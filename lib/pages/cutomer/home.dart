import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/orderInfo.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => CustomerHomeState();
}

class CustomerHomeState extends State<CustomerHome> {
  List<List<OrderInfo>> orders = [];
  List<List<OrderInfo>> rateOrders = [];

  Future<void> getOrder(int userId) async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/customerOrderInfo',
        queryParameters: {'userId': userId},
      );
      List<OrderInfo> newOrders = [];
      for (var res in response.data) {
        newOrders.add(OrderInfo.fromJson(res));
      }
      setState(() {
        getGroupedOrder(newOrders);
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void getGroupedOrder(List<OrderInfo> newOrders) {
    Map<int, List<OrderInfo>> groupedByOrderId =
        groupBy(newOrders, (OrderInfo order) => order.orderId);

    List<OrderInfo> filteredOrders = newOrders
        .where((order) => order.isReadyToServe == 1 && order.isReviewed == 0)
        .toList();

    // Group the filtered orders by orderId
    Map<int, List<OrderInfo>> groupedByRatedOrder =
        groupBy(filteredOrders, (OrderInfo order) => order.orderId);

    orders = groupedByOrderId.values.toList();
    rateOrders = groupedByRatedOrder.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      if (state is SessionValue) {
        getOrder(state.user.userId as int);
        return Scaffold(
          appBar: CustomeAppBar(
            userName: state.user.userName,
          ),
          drawer: CustomerDrawer(
            username: state.user.userName,
            email: state.user.email as String,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(6.0),
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
                    child: Column(children: [
                      Text(
                        "Discount Offers",
                        style: headingStyle(),
                      ),
                      const noItems()
                    ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 231, 231),
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
                    child: Column(children: [
                      Text(
                        "Recent Orders",
                        style: headingStyle(),
                      ),
                      orders.isEmpty
                          ? const noItems()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  return foodCard(orders[index]);
                                },
                              ),
                            )
                    ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(6.0),
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
                    child: Column(children: [
                      Text(
                        "Order To Rate",
                        style: headingStyle(),
                      ),
                      rateOrders.isEmpty
                          ? const noItems()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListView.builder(
                                itemCount: rateOrders.length,
                                itemBuilder: (context, index) {
                                  return foodCard(rateOrders[index]);
                                },
                              ),
                            )
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.15,
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
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/credit.jpg',
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'User Credit Balance',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${state.user.credit} Taka',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }

  TextStyle headingStyle() => const TextStyle(
      color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20);
  Widget foodCard(List<OrderInfo> order) {
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
                      // Iterate through each order and display order details
                      for (OrderInfo orderItem in order)
                        Text(
                          'Name: ${orderItem.name}\nQuantity: ${orderItem.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Placeholder total amount (replace with actual logic)
                Text(
                  'Total: ${calculateTotal(order)} Taka', // Placeholder total amount
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Placeholder status (replace with actual logic)
                Text(
                  'Status: ${calculateStatus(order)}', // Placeholder status
                  style: const TextStyle(
                    color: Colors.green, // Example color for success status
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Placeholder function to calculate total amount
  double calculateTotal(List<OrderInfo> order) {
    // Replace this with your actual logic to calculate the total amount
    return order
        .map((orderItem) => orderItem.price * orderItem.quantity)
        .reduce((a, b) => a + b);
  }

  String calculateStatus(List<OrderInfo> order) {
    if (order[0].isReadyToCollect == 0) return 'Need to serve';
    return 'Delivered';
  }
}

class noItems extends StatelessWidget {
  const noItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "No Items",
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }
}
