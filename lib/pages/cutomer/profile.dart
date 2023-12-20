import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/user.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});
  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _passportNo = TextEditingController();
  final _fatherName = TextEditingController();
  final _motherName = TextEditingController();
  final _dateOfBirth = TextEditingController();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
    _dateOfBirth.dispose();
    _email.dispose();
    _phone.dispose();
    _passportNo.dispose();
    _fatherName.dispose();
    _motherName.dispose();

    super.dispose();
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void reset(User user) {
    if (_email.text.isEmpty) {
      _email.text = user.email as String;
    }

    if (_phone.text.isEmpty) {
      _phone.text = user.phone as String;
    }

    if (_passportNo.text.isEmpty) {
      _passportNo.text = user.passportNo as String;
    }

    if (_fatherName.text.isEmpty) {
      _fatherName.text = user.fatherName as String;
    }

    if (_motherName.text.isEmpty) {
      _motherName.text = user.motherName as String;
    }
  }

  void submit(
    BuildContext context,
    int userId,
  ) async {
    try {
      final response = await Dio().put(
        'http://localhost:3000/userEdit',
        queryParameters: {
          'userId': userId,
          'userName': _userName.text,
          'email': _email.text,
          'phone': _phone.text,
          'passportNo': _passportNo.text,
          'fatherName': _fatherName.text,
          'motherName': _motherName.text,
          'dateOfBirth': _dateOfBirth.text
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      User user = User.fromJson(response.data[0]);
      context.read<SessionCubit>().login(user);
    } catch (error) {
      print('Dio error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.isAfter(DateTime(2000))
            ? selectedDate
            : DateTime(2000),
        firstDate: DateTime(1800),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          _dateOfBirth.text = formattedDate(selectedDate);
        });
      }
    }

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
                                  "Personal Details",
                                  style: sectionTitleStyle(),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    textFieldWithControl(
                                        _userName,
                                        state.user.userName,
                                        "User Name",
                                        Icons.emoji_people,
                                        !_isEdit,
                                        TextInputType.name),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(
                                        _email,
                                        state.user.email as String,
                                        "Email",
                                        Icons.email,
                                        !_isEdit,
                                        TextInputType.name)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    textFieldWithControl(
                                        _phone,
                                        state.user.phone as String,
                                        "Phone",
                                        Icons.phone,
                                        !_isEdit,
                                        TextInputType.phone),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(
                                        _passportNo,
                                        state.user.passportNo as String,
                                        "Passport No",
                                        Icons.document_scanner_sharp,
                                        !_isEdit,
                                        TextInputType.text)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    textField(
                                        state.user.userType as String,
                                        "User type",
                                        Icons.people,
                                        true,
                                        TextInputType.text),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textField(
                                        "${state.user.credit} Taka",
                                        "Credit",
                                        Icons.money_sharp,
                                        true,
                                        TextInputType.text)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    textFieldWithControl(
                                        _fatherName,
                                        state.user.fatherName as String,
                                        "Father Name",
                                        Icons.supervised_user_circle,
                                        !_isEdit,
                                        TextInputType.phone),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    textFieldWithControl(
                                        _motherName,
                                        state.user.motherName as String,
                                        "Mother Name",
                                        Icons.supervised_user_circle,
                                        !_isEdit,
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
                                          readOnly: !_isEdit,
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
                                                onPressed: !_isEdit
                                                    ? null
                                                    : () {
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
                                    TextButton(
                                        onPressed: () {
                                          reset(state.user);
                                          _isEdit
                                              ? setState(() {
                                                  _isEdit = !_isEdit;
                                                })
                                              : setState(() {
                                                  _isEdit = !_isEdit;
                                                  submit(context,
                                                      state.user.userId as int);
                                                });
                                        },
                                        child: Text(_isEdit ? "Save" : "Edit"))
                                  ],
                                ),
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

  Widget textFieldWithControl(
      TextEditingController controller,
      String initial,
      String label,
      IconData prefixIcon,
      bool readOnly,
      TextInputType inputType) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
        readOnly: readOnly,
        keyboardType: inputType,
        initialValue: initial,
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
      ),
    );
  }

  Widget textField(String initialValue, String label, IconData prefixIcon,
      bool readOnly, TextInputType inputType) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
          readOnly: readOnly,
          initialValue: initialValue,
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
          }),
    );
  }

  TextStyle sectionTitleStyle() => const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue);
}
