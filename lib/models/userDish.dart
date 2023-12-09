class UserDish {
  final int userDishId;
  final int orderId;
  final int dishId;
  final int quantity;
  final DateTime pickUpTime;
  final int discountId;

  UserDish({
    required this.userDishId,
    required this.orderId,
    required this.dishId,
    required this.quantity,
    required this.pickUpTime,
    required this.discountId,
  });

  factory UserDish.fromJson(Map<String, dynamic> json) {
    return UserDish(
      userDishId: json['userDishId'],
      orderId: json['orderId'],
      dishId: json['dishId'],
      quantity: json['quantity'],
      pickUpTime: DateTime.parse(json['pickUpTime']),
      discountId: json['discountId'],
    );
  }
}
