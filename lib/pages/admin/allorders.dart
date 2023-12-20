import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/orderInfo.dart';
import 'package:intl/intl.dart';

class AllOrdes extends StatefulWidget {
  const AllOrdes({super.key});

  @override
  State<AllOrdes> createState() => _AllOrdesState();
}

class _AllOrdesState extends State<AllOrdes> {
  List<List<OrderInfo>> orders = [];
  Future<void> getOrder() async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/orderInfos',
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
    orders = [];
    Map<int, List<OrderInfo>> groupedByOrderId =
        groupBy(newOrders, (OrderInfo order) => order.orderId);

    orders = groupedByOrderId.values.toList();
  }

  String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      if (state is SessionValue) {
        getOrder();
        return Scaffold(
          appBar: CustomeAppBar(
            userName: state.user.userName,
          ),
          drawer: AdminDrawer(
            username: state.user.userName,
            email: state.user.email as String,
          ),
          body: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, idx) => foodCard(orders[idx])),
        );
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }

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
                  (order[0].dishImages != null)
                      ? Image.memory(
                          order[0].dishImages!,
                          width: 50,
                          height: 50,
                        )
                      : Image.asset(
                          'assets/images/burger.jpg',
                          width: 50,
                          height: 50,
                        ),
                  const SizedBox(width: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customeText('OrderId', order[0].orderId.toString()),
                      const SizedBox(height: 5),
                      customeText('Order By', order[0].userUsername),
                      const SizedBox(height: 5),
                      if (order[0].isPreOrder == 1 && order[0].deliveryTime != null)
                        statusText(
                            "Pre Order : ${formatDateTime(DateTime.parse(order[0].deliveryTime as String))}"),
                      if (order[0].isReviewed == 1) statusText("Reviewed"),
                      if (order[0].isReadyToServe == 1 && order[0].pickUpTime != null)
                        statusText(
                            "Ready To Serve ${formatDateTime(DateTime.parse(order[0].pickUpTime as String))}"),
                      if (order[0].discountId != null)
                        statusText(
                            "Discount add: ${order[0].discountName}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height:
                                MediaQuery.of(context).size.width * 0.01 * 0.05,
                            decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      for (OrderInfo orderItem in order)
                        Text(
                          'Name: ${orderItem.dishName} |  ${orderItem.dishPrice * (orderItem.quantity as int).toDouble()} Taka | ${orderItem.quantity} portion',
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
                Text(
                  'Total: ${order[0].orderTotal} Taka',
                  style: const TextStyle(
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

  Text statusText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.greenAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  RichText customeText(String heading, String value) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      text: TextSpan(
        text: '$heading ',
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
              text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void showOrderInfo(BuildContext context) {
    double rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate Order'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Column(
              children: [
                Text('Please rate your order:'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform actions when the user submits the rating
                print('Rating submitted: $rating');
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                // Perform actions when the user cancels the rating
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
