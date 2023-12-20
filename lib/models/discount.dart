class Discount {
  final int discountId;
  final String discountType;
  final double amount;
  final String name;
  final String code;
  final DateTime startDate;
  final DateTime endDate;
  final int isActive;
  final int quantity;
  final double minimumTotal;
  final DateTime createdOn;

  Discount({
    required this.discountId,
    required this.discountType,
    required this.amount,
    required this.name,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.quantity,
    required this.minimumTotal,
    required this.createdOn,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      discountId: json['discountId'],
      discountType: json['discountType'],
      amount: json['amount'].toDouble(),
      name: json['name'],
      code: json['code'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      quantity: json['quantity'],
      minimumTotal:
          (json['minimumTotal'] != null) ? json['minimumTotal'].toDouble() : 0,
      createdOn: DateTime.parse(json['createdOn']),
    );
  }
}
