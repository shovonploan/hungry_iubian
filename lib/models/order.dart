class Order {
  final int orderId;
  final int userId;
  final DateTime createdDate;
  final DateTime? deliveryTime;
  final bool isPreOrder;
  final bool isReviewed;
  final bool isReadyToServe;
  final DateTime? receivedTime;
  final int tokenId;
  final bool isReadyToCollect;
  final int total;

  Order({
    required this.orderId,
    required this.userId,
    required this.createdDate,
    required this.deliveryTime,
    required this.isPreOrder,
    required this.isReviewed,
    required this.isReadyToServe,
    required this.receivedTime,
    required this.tokenId,
    required this.isReadyToCollect,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      createdDate: DateTime.parse(json['createdDate']),
      deliveryTime: json['deliveryTime'] != null
          ? DateTime.parse(json['deliveryTime'])
          : null,
      isPreOrder: json['isPreOrder'],
      isReviewed: json['isReviewed'],
      isReadyToServe: json['isReadyToServe'],
      receivedTime: json['receivedTime'] != null
          ? DateTime.parse(json['receivedTime'])
          : null,
      tokenId: json['tokenId'],
      isReadyToCollect: json['isReadyToCollect'],
      total: json['total'],
    );
  }
}
