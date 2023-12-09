import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/cart.dart';
import 'package:hungry_iubian/cubits/menu.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/dish.dart';

class CustomerMenuCard extends StatefulWidget {
  const CustomerMenuCard({super.key});

  @override
  State<CustomerMenuCard> createState() => _CustomerMenuCardState();
}

class _CustomerMenuCardState extends State<CustomerMenuCard> {
  final TextEditingController _dropdownController = TextEditingController();

  double getTotal(List<DishQuantity> dishes) {
    double total = 0;
    for (var element in dishes) {
      total += element.dish.price!.toInt() * element.quantity;
    }
    return total;
  }

  Future<void> createOrder(
    int userId,
    bool isPreOrder,
    List<DishQuantity> dishQuantities,
  ) async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/createOrder',
        data: {
          'userId': userId,
          'isPreOrder': isPreOrder,
          'dishQuantities': dishQuantities.map((dq) => dq.toJson()).toList(),
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
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      context.read<MenuCubit>().loadMenues();
      if (state is SessionValue) {
        return Scaffold(
            appBar: CustomeAppBar(
              userName: state.user.userName,
            ),
            drawer: CustomerDrawer(
              username: state.user.userName,
              email: state.user.email as String,
            ),
            body: BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
              return Center(
                child: ListView.builder(
                  itemCount: state.dishes.length,
                  itemBuilder: (ctx, idx) => foodCard(state.dishes[idx]),
                ),
              );
            }),
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
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DropdownButton<String>(
                                        value:
                                            _dropdownController.text.isNotEmpty
                                                ? _dropdownController.text
                                                : null,
                                        onChanged: (String? newValue) {
                                          _dropdownController.text =
                                              newValue ?? '';
                                        },
                                        items: <String>['Now', 'Pre-Order']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            var isPreOrder = false;
                                            if (_dropdownController
                                                    .text.isNotEmpty &&
                                                _dropdownController.text ==
                                                    'Pre-Order') {
                                              isPreOrder = true;
                                            }
                                            if (cartState.dishes.isNotEmpty) {
                                              createOrder(
                                                  state.user.userId as int,
                                                  isPreOrder,
                                                  cartState.dishes);
                                              context
                                                  .read<CartCubit>()
                                                  .resetCart();

                                              context
                                                  .read<MenuCubit>()
                                                  .loadMenues();
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.blueAccent),
                                          ),
                                          child: const Text(
                                            "Place Order",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
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
                                            "${getTotal(cartState.dishes)} Taka",
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
                                        itemBuilder: (ctx, idx) =>
                                            cartCard(cartState.dishes[idx])),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.shopping_bag),
                  ),
                ),
              );
            }));
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }

  Widget foodCard(Dish dish) {
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
                  Image.asset(
                    'assets/images/burger.jpg',
                    width: 50.0,
                    height: 50.0,
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

  Widget cartCard(DishQuantity dishQuantity) {
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
                  Image.asset(
                    'assets/images/burger.jpg',
                    width: 50.0,
                    height: 50.0,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
