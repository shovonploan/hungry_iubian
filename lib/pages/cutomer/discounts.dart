import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/discount.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DiscountsPage extends StatefulWidget {
  const DiscountsPage({Key? key}) : super(key: key);

  @override
  State<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends State<DiscountsPage> {
  List<Map<String, dynamic>> discounts = [];

  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController minimumTotalController = TextEditingController();

  final List<String> discountTypes = [
    'Flat',
    'Percentage',
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? discountType;
  bool isActive = false;

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = isStart
        // ignore: use_build_context_synchronously
        ? await showDatePicker(
            context: context,
            initialDate:
                startDate.isAfter(DateTime(2000)) ? startDate : DateTime(2000),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          )
        // ignore: use_build_context_synchronously
        : await showDatePicker(
            context: context,
            initialDate:
                endDate.isAfter(DateTime(2000)) ? endDate : DateTime(2000),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          );
    if (isStart) {
      if (picked != null && picked != startDate) {
        setState(() {
          startDate = picked;
          startDateController.text = formattedDate(startDate).toString();
        });
      }
    } else {
      if (picked != null && picked != endDate) {
        setState(() {
          endDate = picked;
          endDateController.text = formattedDate(endDate).toString();
        });
      }
    }
  }

  void setFields(Discount discount) {
    setState(() {
      amountController.text = discount.amount.toString();
      nameController.text = discount.name;
      codeController.text = discount.code;
      startDateController.text = formattedDate(discount.startDate).toString();
      endDateController.text = formattedDate(discount.endDate).toString();
      quantityController.text = discount.quantity.toString();
      minimumTotalController.text = discount.minimumTotal.toString();
      isActive = discount.isActive == 1;
      discountType = discount.discountType;
    });
  }

  void resetFields() {
    setState(() {
      amountController.text = '';
      nameController.text = '';
      codeController.text = '';
      startDateController.text = '';
      endDateController.text = '';
      quantityController.text = '';
      minimumTotalController.text = '';
      isActive = false;
      discountType = 'Flat';
    });
  }

  void getDiscounts() async {
    try {
      final response = await Dio().get('http://localhost:3000/discounts');
      discounts = List<Map<String, dynamic>>.from(response.data);
      setState(() {});
    } catch (error) {
      print('Dio error: $error');
    }
  }

  void updateDiscount(int discountId) async {
    try {
      await Dio().put(
        'http://localhost:3000/updateDiscount',
        queryParameters: {
          'discountId': discountId,
          'amount': amountController.text,
          'name': nameController.text,
          'code': codeController.text,
          'startDate': startDateController.text,
          'endDate': endDateController.text,
          'quantity': quantityController.text,
          'isActive': isActive ? 1 : 0,
          'discountType': discountType,
          'minimumTotal': minimumTotalController.text,
        },
      );
      setState(() {
        resetFields();
        getDiscounts();
      });
    } catch (error) {
      print('Dio error: $error');
    }
  }

  void createDiscount() async {
    try {
      await Dio().post(
        'http://localhost:3000/createDiscount',
        data: {
          'amount': amountController.text,
          'name': nameController.text,
          'code': codeController.text,
          'startDate': startDateController.text,
          'endDate': endDateController.text,
          'quantity': quantityController.text,
          'isActive': isActive ? 1 : 0,
          'discountType': discountType,
          'minimumTotal': minimumTotalController.text,
        },
      );
      setState(() {
        resetFields();
        getDiscounts();
      });
    } catch (error) {
      print('Dio error: $error');
    }
  }

  void deleteDiscount(int discountId) async {
    try {
      await Dio().post(
        'http://localhost:3000/deleteDiscount',
        data: {
          'discountId': discountId,
        },
      );
      setState(() {
        getDiscounts();
      });
    } catch (error) {
      print('Dio error: $error');
    }
  }

  bool validateFields() {
    if (amountController.text.isEmpty ||
        (amountController.text == '') ||
        nameController.text.isEmpty ||
        (nameController.text == '') ||
        codeController.text.isEmpty ||
        (codeController.text == '') ||
        startDateController.text.isEmpty ||
        (startDateController.text == '') ||
        endDateController.text.isEmpty ||
        (endDateController.text == '') ||
        quantityController.text.isEmpty ||
        (quantityController.text == '') ||
        minimumTotalController.text.isEmpty ||
        (minimumTotalController.text == '') ||
        discountType!.isEmpty ||
        (discountType == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "All fields need to be filled",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    getDiscounts();
  }

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    codeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    quantityController.dispose();
    minimumTotalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return ResponsiveBuilder(builder: (context, sizingInformation) {
            return DashboardSkeleton(
              body: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columns: [
                        const DataColumn(label: Text('Discount Type')),
                        const DataColumn(label: Text('Amount')),
                        const DataColumn(label: Text('Name')),
                        const DataColumn(label: Text('Code')),
                        const DataColumn(label: Text('Start Date')),
                        const DataColumn(label: Text('End Date')),
                        if (state.user.userType == 'admin')
                          const DataColumn(label: Text('Is Active')),
                        const DataColumn(label: Text('Quantity')),
                        const DataColumn(label: Text('Minimum Total')),
                        if (state.user.userType == 'admin')
                          const DataColumn(label: Text('Created On')),
                        if (state.user.userType == 'admin')
                          const DataColumn(label: Text('Edit')),
                        if (state.user.userType == 'admin')
                          const DataColumn(label: Text('Delete')),
                      ],
                      rows: discounts
                          .map(
                            (discount) => DataRow(
                              cells: [
                                DataCell(Text(discount['discountType'])),
                                DataCell(Text(discount['amount'].toString())),
                                DataCell(Text(discount['name'])),
                                DataCell(Text(discount['code'])),
                                DataCell(Text(formattedDate(
                                    DateTime.parse(discount['startDate'])))),
                                DataCell(Text(formattedDate(
                                    DateTime.parse(discount['endDate'])))),
                                if (state.user.userType == 'admin')
                                  DataCell(
                                      Text(discount['isActive'].toString())),
                                DataCell(Text(discount['quantity'].toString())),
                                DataCell(
                                    Text(discount['minimumTotal'].toString())),
                                if (state.user.userType == 'admin')
                                  DataCell(Text(formattedDate(
                                      DateTime.parse(discount['createdOn'])))),
                                if (state.user.userType == 'admin')
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        Discount dis =
                                            Discount.fromJson(discount);
                                        setFields(dis);
                                        showDishInfo(
                                          context,
                                          sizingInformation,
                                          discountId: dis.discountId,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                if (state.user.userType == 'admin')
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        Discount dis =
                                            Discount.fromJson(discount);
                                        deleteDiscount(dis.discountId);
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              user: state.user,
              floatingActionButton: (state.user.userType == 'admin')
                  ? FloatingActionButton(
                      onPressed: () {
                        resetFields();
                        showDishInfo(
                          context,
                          sizingInformation,
                        );
                      },
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            );
          });
        } else if (state is SessionValue) {
          Navigator.pushNamed(context, "/");
        }
        return const Scaffold();
      },
    );
  }

  void showDishInfo(BuildContext context, SizingInformation sizingInformation,
      {int discountId = 0}) {
    const double spaceRatio = 0.01;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(amountController.text);
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Dish Information'),
            content: SizedBox(
              width: sizingInformation.screenSize.width * 0.8,
              height: sizingInformation.screenSize.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: amountController,
                      decoration: textFieldDecoration(
                        'Amount',
                        'Please enter Amount',
                        Icons.monetization_on_outlined,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: nameController,
                      decoration: textFieldDecoration(
                        'Name',
                        'Please enter name',
                        Icons.people,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: codeController,
                      decoration: textFieldDecoration(
                        'Code',
                        'Please enter code',
                        Icons.one_x_mobiledata,
                      ),
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: startDateController,
                      decoration: calederFieldDecoration(
                        'Start Date',
                        'Please enter date',
                        Icons.calendar_month,
                        IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              selectDate(context, true);
                            }),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: endDateController,
                      decoration: calederFieldDecoration(
                        'End Date',
                        'Please enter date',
                        Icons.calendar_month,
                        IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              selectDate(context, false);
                            }),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Is Active',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 16),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: quantityController,
                      decoration: textFieldDecoration(
                        'Quantity',
                        'Please enter quantity',
                        Icons.numbers,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    TextField(
                      controller: minimumTotalController,
                      decoration: textFieldDecoration(
                        'Minimum total',
                        'Please enter total',
                        Icons.numbers,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                        height:
                            sizingInformation.screenSize.height * spaceRatio),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select discount type',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: discountTypes
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
                            value: discountType,
                            onChanged: (value) {
                              setState(() {
                                discountType = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: sizingInformation.screenSize.width * 0.8,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
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
                              width: sizingInformation.screenSize.height * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.grey[200],
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (validateFields()) {
                    if (discountId != 0) {
                      updateDiscount(discountId);
                    } else {
                      createDiscount();
                    }
                    Navigator.pop(context);
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

  InputDecoration textFieldDecoration(
      String label, String hintText, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  InputDecoration calederFieldDecoration(
      String label, String hintText, IconData icon, Widget? suffixWidget) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffix: suffixWidget,
    );
  }
}
