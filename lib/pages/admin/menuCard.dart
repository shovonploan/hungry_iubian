import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/dish.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminMenucard extends StatefulWidget {
  const AdminMenucard({super.key});

  @override
  State<AdminMenucard> createState() => _AdminMenucardState();
}

class _AdminMenucardState extends State<AdminMenucard> {
  List<Dish> dishes = [];

  Future<void> getDishes() async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/dishes',
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

  Future<void> updateDish(
      int request, int qty, double price, int dishId) async {
    try {
      final _ = await Dio()
          .put('http://localhost:3000/updateDishV1', queryParameters: {
        'request': request,
        'quantity': qty,
        'price': price,
        'dishId': dishId,
      });
      getDishes();
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getDishes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return DashboardSkeleton(
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return Center(
                  child: ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (ctx, idx) => AdminFoodCard(
                      dish: dishes[idx],
                      updateDish: updateDish,
                      sizingInformation: sizingInformation,
                      getDishes: getDishes,
                    ),
                  ),
                );
              },
            ),
            user: state.user,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                getDishes();
              },
            ),
          );
        } else if (state is SessionValue) {
          Navigator.pushNamed(context, "/");
        }
        return const Scaffold();
      },
    );
  }
}

class AdminFoodCard extends StatefulWidget {
  const AdminFoodCard({
    Key? key,
    required this.dish,
    required this.updateDish,
    required this.sizingInformation,
    required this.getDishes,
  }) : super(key: key);

  final Dish dish;
  final Function(int, int, double, int) updateDish;
  final SizingInformation sizingInformation;
  final Function() getDishes;

  @override
  State<AdminFoodCard> createState() => _AdminFoodCardState();
}

class _AdminFoodCardState extends State<AdminFoodCard> {
  final TextEditingController _availableQuantityController =
      TextEditingController();
  final TextEditingController _requestQuantityControler =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> items = ['Breakfast', 'Lunch', 'Snack', 'Beverage'];
  String? selectedValue;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _availableQuantityController.text = widget.dish.quantityLeft.toString();
    _priceController.text = widget.dish.price.toString();
    _requestQuantityControler.text = widget.dish.requestedQuantity.toString();
  }

  @override
  void dispose() {
    _availableQuantityController.dispose();
    _priceController.dispose();
    _requestQuantityControler.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, Dish dish) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.single.path!);

        Uint8List imageData = await fileToUint8List(file);

        setState(() {
          _nameController.text = widget.dish.name as String;
          _descriptionController.text = widget.dish.description as String;
          selectedValue = widget.dish.dishType as String;
          _imageData = imageData;
        });
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
          showDishInfo(context, dish);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<Uint8List> fileToUint8List(File file) async {
    List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  void updateDish() async {
    final dio = Dio();
    try {
      var data = {
        'dishId': widget.dish.dishId,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'dishType': selectedValue as String,
        'images': (_imageData != null) ? base64.encode(_imageData!) : 'Null',
      };

      await dio.post(
        'http://localhost:3000/updateDishV2',
        data: data,
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = widget.sizingInformation.screenSize.width * 0.8;
    double imageWidth = cardWidth * 0.08;
    double inputWidth = cardWidth * 0.05;

    return Container(
      constraints: BoxConstraints(
        maxWidth: cardWidth,
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
                  (widget.dish.images != null)
                      ? Image.memory(
                          widget.dish.images!,
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
                        widget.dish.name as String,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      isDesktop(widget.sizingInformation)
                          ? Text(
                              widget.dish.description as String,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 10),
                      if (widget.dish.rating != null && widget.dish.rating != 0)
                        Row(
                          children: [
                            Text(
                              "${widget.dish.rating}",
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
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _availableQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Available'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _requestQuantityControler,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Request'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: inputWidth,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.updateDish(
                        int.parse(_requestQuantityControler.text),
                        int.parse(_availableQuantityController.text),
                        double.parse(_priceController.text),
                        widget.dish.dishId);
                  },
                  style: buttonStyle(),
                  child: isDesktop(widget.sizingInformation)
                      ? Text(
                          'Save',
                          style: buttonText(),
                        )
                      : const Icon(Icons.check),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nameController.text = widget.dish.name as String;
                      _descriptionController.text =
                          widget.dish.description as String;
                      selectedValue = widget.dish.dishType as String;
                      _imageData = (widget.dish.images != null &&
                              widget.dish.images.runtimeType == Uint8List)
                          ? widget.dish.images
                          : null;
                    });
                    showDishInfo(context, widget.dish);
                  },
                  style: buttonStyle(),
                  child: isDesktop(widget.sizingInformation)
                      ? Text(
                          'Edit',
                          style: buttonText(),
                        )
                      : const Icon(Icons.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDishInfo(BuildContext context, Dish dish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dish Information'),
          content: SizedBox(
            width: widget.sizingInformation.screenSize.width * 0.6,
            height: widget.sizingInformation.screenSize.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: Colors.grey[200],
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey[200],
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(context, dish).then((_) {});
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all(Size(
                          widget.sizingInformation.screenSize.width,
                          widget.sizingInformation.screenSize.height * 0.01)),
                    ),
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(height: 10),
                  if (_imageData != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.memory(
                          _imageData!,
                          height: 200,
                          width: 200,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateDish();
                widget.getDishes();
                Navigator.pop(context);
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
      },
    );
  }

  TextStyle buttonText() {
    return TextStyle(
        fontSize: widget.sizingInformation.screenSize.width * 0.01);
  }

  ButtonStyle buttonStyle() => ElevatedButton.styleFrom(
        fixedSize: Size(
            isDesktop(widget.sizingInformation)
                ? widget.sizingInformation.screenSize.width * 0.05
                : widget.sizingInformation.screenSize.width * 0.01,
            isDesktop(widget.sizingInformation)
                ? widget.sizingInformation.screenSize.height * 0.03
                : widget.sizingInformation.screenSize.height * 0.01),
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      );
}
