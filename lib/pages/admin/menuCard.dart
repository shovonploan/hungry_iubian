import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/dish.dart';

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
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      if (state is SessionValue) {
        getDishes();
        return Scaffold(
            appBar: CustomeAppBar(
              userName: state.user.userName,
            ),
            drawer: AdminDrawer(
              username: state.user.userName,
              email: state.user.email as String,
            ),
            body: Center(
              child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (ctx, idx) => foodCard(dishes[idx]),
              ),
            ));
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
                  onPressed: () {},
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
}
