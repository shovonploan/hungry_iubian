import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/cart.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/discount.dart';
import 'package:hungry_iubian/models/dish.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomerMenuCard extends StatefulWidget {
  const CustomerMenuCard({super.key});

  @override
  State<CustomerMenuCard> createState() => _CustomerMenuCardState();
}

class _CustomerMenuCardState extends State<CustomerMenuCard> {
  List<Dish> dishes = [];
  bool isPreOrder = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> getDishes() async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/userDishes',
      );
      dishes = [];
      for (var res in response.data) {
        dishes.add(Dish.fromJson(res));
      }
      setState(() {});
    } catch (error) {
      print('Error: $error');
    }
  }

  String formatDateTime() {
    DateTime combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
  }

  @override
  void initState() {
    super.initState();
    getDishes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double getTotal(List<DishQuantity> dishes, Discount? discount) {
    double total = 0;
    for (var element in dishes) {
      total += element.dish.price!.toInt() * element.quantity;
    }
    if (discount != null) {
      if (discount.discountType == 'Percentage') {
        total = total - (discount.amount / 100);
      } else if (discount.discountType == 'Flat') {
        total = total - discount.amount;
      }
    }
    return total;
  }

  Future<void> createOrder(
    int userId,
    List<DishQuantity> dishQuantities,
    Discount? discount,
  ) async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/createOrder',
        data: {
          'userId': userId,
          'isPreOrder': isPreOrder,
          'dishQuantities': dishQuantities.map((dq) => dq.toJson()).toList(),
          'deliveryTime': formatDateTime(),
          'total': getTotal(dishQuantities, discount),
        },
      );

      if (response.statusCode == 201) {
        print('Order created successfully');
      } else {
        print('Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return ResponsiveBuilder(builder: (context, sizingInformation) {
            return DashboardSkeleton(
              body: Center(
                child: ListView.builder(
                  itemCount: dishes.length,
                  itemBuilder: (ctx, idx) =>
                      foodCard(sizingInformation, dishes[idx]),
                ),
              ),
              user: state.user,
              floatingActionButton: BlocBuilder<CartCubit, CartState>(
                  builder: (context, cartState) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: badges.Badge(
                    badgeContent: (cartState.dishes.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              "${cartState.dishes.length}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    badgeStyle: badges.BadgeStyle(
                        badgeColor: (cartState.dishes.isNotEmpty)
                            ? Colors.redAccent
                            : Colors.transparent,
                        elevation: 10),
                    badgeAnimation: const badges.BadgeAnimation.slide(
                      animationDuration: Duration(seconds: 1),
                      colorChangeAnimationDuration: Duration(seconds: 1),
                      loopAnimation: false,
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 106, 149, 223),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              const Text("Now"),
                                              const SizedBox(width: 5),
                                              Switch(
                                                value: isPreOrder,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isPreOrder = value;
                                                    if (isPreOrder) {
                                                      _selectDate(context);
                                                    }
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              const Text("Pre-Order"),
                                            ],
                                          ),
                                          (cartState.discount == null)
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    getDiscountPopup(
                                                        sizingInformation,
                                                        context);
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blueAccent),
                                                  ),
                                                  child: const Text(
                                                    "Discount",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    Text(cartState
                                                        .discount!.code),
                                                    IconButton(
                                                        onPressed: () {
                                                          context
                                                              .read<CartCubit>()
                                                              .removeDiscount();
                                                        },
                                                        icon: Icon(Icons.close,
                                                            color: Colors.red))
                                                  ],
                                                ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (cartState.dishes.isNotEmpty) {
                                                createOrder(
                                                  state.user.userId as int,
                                                  cartState.dishes,
                                                  cartState.discount,
                                                )
                                                    .then((value) => context
                                                        .read<CartCubit>()
                                                        .resetCart())
                                                    .then(
                                                        (value) => getDishes())
                                                    .then((value) =>
                                                        Navigator.pop(context));
                                              }
                                            },
                                            style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blueAccent),
                                            ),
                                            child: const Text(
                                              "Place Order",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Total ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "${getTotal(cartState.dishes, cartState.discount)} Taka",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blueGrey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 5),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: cartState.dishes.length,
                                            itemBuilder: (ctx, idx) => cartCard(
                                                sizingInformation,
                                                cartState.dishes[idx])),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: const Icon(Icons.shopping_bag),
                    ),
                  ),
                );
              }),
            );
          });
        } else if (state is SessionValue) {
          Navigator.pushNamed(context, "/");
        }
        return const Scaffold();
      },
    );
  }

  void getDiscountPopup(
      SizingInformation sizingInformation, BuildContext context) {
    String code = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add discount'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Discount Code',
                      hintText: "Discount Code",
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      code = value;
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (code.isNotEmpty && code != '') {
                    context.read<CartCubit>().addDiscount(code);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Enter Dicount Code'),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: Colors.blue)
                .copyWith(secondary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _selectTime(context);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Widget foodCard(SizingInformation sizingInformation, Dish dish) {
    double cardWidth = sizingInformation.screenSize.width * 0.8;
    double imageWidth = cardWidth * 0.08;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  (dish.images != null)
                      ? Image.memory(
                          dish.images!,
                          width: imageWidth,
                          height: imageWidth,
                        )
                      : Image.asset(
                          'assets/images/burger.jpg',
                          width: imageWidth,
                          height: imageWidth,
                        ),
                  const SizedBox(width: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name as String,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        dish.description as String,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (dish.rating != null && dish.rating != 0)
                        Row(
                          children: [
                            Text(
                              "${dish.rating}",
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            )
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${dish.quantityLeft} available",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${dish.price} Taka",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<CartCubit>().addToCart(dish);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[500],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cartCard(
      SizingInformation sizingInformation, DishQuantity dishQuantity) {
    double cardWidth = sizingInformation.screenSize.width * 0.8;
    double imageWidth = cardWidth * 0.08;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  (dishQuantity.dish.images != null)
                      ? Image.memory(
                          dishQuantity.dish.images!,
                          width: imageWidth,
                          height: imageWidth,
                        )
                      : Image.asset(
                          'assets/images/burger.jpg',
                          width: imageWidth,
                          height: imageWidth,
                        ),
                  const SizedBox(width: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dishQuantity.dish.name as String,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        dishQuantity.dish.description as String,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${dishQuantity.quantity}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<CartCubit>()
                          .removeFromCart(dishQuantity.dish);
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
