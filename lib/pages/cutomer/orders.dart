import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/orderInfo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  List<List<OrderInfo>> orders = [];

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

    orders = groupedByOrderId.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return DashboardSkeleton(
              body: ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (ctx, idx) => foodCard(orders[idx]));
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
                          'Name: ${orderItem.dishName}\nQuantity: ${orderItem.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Call a function to show the rating dialog
                showRatingDialog(context);
              },
              child: const Text('Rate Order'),
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
        .map((orderItem) => orderItem.dishPrice * (orderItem.quantity as int))
        .reduce((a, b) => a + b);
  }

  String calculateStatus(List<OrderInfo> order) {
    if (order[0].isReadyToCollect == 0) return 'Need to serve';
    return 'Delivered';
  }

  void showRatingDialog(BuildContext context) {
    double rating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate Order'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                const Text('Please rate your order:'),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40.0, // Set the height of each star
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    // Update the rating when the user interacts with the stars
                    rating = value;
                  },
                ),
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
