import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _passportNo = TextEditingController();
  final _fatherName = TextEditingController();
  final _motherName = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _password = TextEditingController();
  final List<String> items = [
    'admin',
    'customer',
  ];
  DateTime selectedDate = DateTime.now();
  String? selectedValue;

  @override
  void initState() {
    _dateOfBirth.text = formattedDate(selectedDate).toString();
    super.initState();
  }

  @override
  void dispose() {
    _dateOfBirth.dispose();
    _password.dispose();
    _userName.dispose();
    _email.dispose();
    _phone.dispose();
    _passportNo.dispose();
    _fatherName.dispose();
    _motherName.dispose();

    super.dispose();
  }

  void save(DateTime selectDate) async {
    try {
      final _ = await Dio().post(
        'http://localhost:3000/createUser',
        data: {
          'userName': _userName.text,
          'email': _email.text,
          'phone': _phone.text,
          'passportNo': _passportNo.text,
          'fatherName': _fatherName.text,
          'motherName': _motherName.text,
          'dateOfBirth': _dateOfBirth.text,
          'password': _password.text,
          'userType': selectedValue as String,
          'credit': 0,
        },
      );
      Navigator.pop(context);
    } catch (error) {
      print('Error: $error');
    }
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate.isAfter(DateTime(2000)) ? selectedDate : DateTime(2000),
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateOfBirth.text = formattedDate(selectedDate).toString();
      });
    }
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
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create New User",
                                  style: sectionTitleStyle(),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    textFieldWithControl(_userName, "User Name",
                                        Icons.emoji_people, TextInputType.name),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(_email, "Email",
                                        Icons.email, TextInputType.name)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    textFieldWithControl(_phone, "Phone",
                                        Icons.phone, TextInputType.phone),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(
                                        _passportNo,
                                        "Passport No",
                                        Icons.document_scanner_sharp,
                                        TextInputType.text)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    textFieldWithControl(
                                        _fatherName,
                                        "Father Name",
                                        Icons.supervised_user_circle,
                                        TextInputType.phone),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(
                                        _motherName,
                                        "Mother Name",
                                        Icons.supervised_user_circle,
                                        TextInputType.text)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextFormField(
                                          controller: _dateOfBirth,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: "Date of Birth",
                                            labelStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            prefixIcon: const Icon(
                                              Icons.calendar_month,
                                              color: Colors.blue,
                                            ),
                                            suffixIcon: IconButton(
                                                icon: const Icon(
                                                    Icons.calendar_today),
                                                onPressed: () {
                                                  selectDate(context);
                                                }),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          }),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
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
                                            .map((String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.grey[200],
                                          ),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                          padding: EdgeInsets.only(
                                              left: 14, right: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              _password.text = value;
                                            });
                                          },
                                          obscureText: true,
                                          keyboardType: TextInputType.none,
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                            labelStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          }),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            (selectedValue!.isNotEmpty ||
                                                selectedValue != null)) {
                                          save(selectedDate);
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            vertical: 25),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text("Save"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              user: state.user);
        } else if (state is SessionValue) {
          Navigator.pushNamed(context, "/");
        }
        return const Scaffold();
      },
    );
  }

  Widget textFieldWithControl(TextEditingController controller, String label,
      IconData prefixIcon, TextInputType inputType) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.blue,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.blue,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }

  TextStyle sectionTitleStyle() => const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue);
}
