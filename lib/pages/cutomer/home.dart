import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/orderInfo.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
        return DashboardSkeleton(
          body: Center(
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      responsiveContainer(
                        context,
                        "Discount Offers",
                        headingStyle(context),
                        const noItems(),
                        sizingInformation,
                      ),
                      responsiveContainer(
                        context,
                        "Recent Orders",
                        headingStyle(context),
                        orders.isEmpty
                            ? const noItems()
                            : SizedBox(
                                height:
                                    sizingInformation.screenSize.height * 0.4,
                                width: sizingInformation.screenSize.width * 0.8,
                                child: ListView.builder(
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return foodCard(context, orders[index]);
                                  },
                                ),
                              ),
                        sizingInformation,
                      ),
                      responsiveContainer(
                        context,
                        "Order To Rate",
                        headingStyle(context),
                        rateOrders.isEmpty
                            ? const noItems()
                            : SizedBox(
                                height:
                                    sizingInformation.screenSize.height * 0.4,
                                width: sizingInformation.screenSize.width * 0.4,
                                child: ListView.builder(
                                  itemCount: rateOrders.length,
                                  itemBuilder: (context, index) {
                                    return foodCard(context, rateOrders[index]);
                                  },
                                ),
                              ),
                        sizingInformation,
                      ),
                      responsiveCreditContainer(
                        context,
                        state.user.credit as double,
                        sizingInformation,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          user: state.user,
        );
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }

  Widget responsiveContainer(
      BuildContext context,
      String title,
      TextStyle textStyle,
      Widget content,
      SizingInformation sizingInformation) {
    return Container(
      width: sizingInformation.screenSize.width * 0.8,
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
      child: Column(
        children: [
          Text(
            title,
            style: textStyle,
          ),
          content,
        ],
      ),
    );
  }

  Widget responsiveCreditContainer(BuildContext context, double credit,
      SizingInformation sizingInformation) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: isDesktop(sizingInformation)
          ? sizingInformation.screenSize.width * 0.15
          : sizingInformation.screenSize.width * 0.5,
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
                  '$credit Taka',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle headingStyle(BuildContext context) {
    return TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 20,
    );
  }

  Widget foodCard(BuildContext context, List<OrderInfo> order) {
    return Container(
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width < 600 ? double.infinity : 300.0,
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
                      for (OrderInfo orderItem in order)
                        Text(
                          'Name: ${orderItem.discountName} Quantity: ${orderItem.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 12
                                : 16,
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
                Text(
                  'Total: ${calculateTotal(order)} Taka',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Status: ${calculateStatus(order)}', // Placeholder status
                  style: TextStyle(
                    color: Colors.green, // Example color for success status
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotal(List<OrderInfo> order) {
    return order
        .map((orderItem) => orderItem.dishPrice * (orderItem.quantity as int))
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
