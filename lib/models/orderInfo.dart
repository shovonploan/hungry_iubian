class OrderInfo {
  final int userId;
  final int orderId;
  final int dishId;
  final int isPreOrder;
  final int isReviewed;
  final int isReadyToServe;
  final DateTime? receivedTime;
  final int tokenId;
  final int isReadyToCollect;
  final int quantity;
  final DateTime pickUpTime;
  final int discountId;
  final String name;
  final String description;
  final String images;
  final String urlSlug;
  final double price;
  final double rating;
  final String tags;
  final int dishTypeId;

  OrderInfo({
    required this.userId,
    required this.orderId,
    required this.dishId,
    required this.isPreOrder,
    required this.isReviewed,
    required this.isReadyToServe,
    required this.receivedTime,
    required this.tokenId,
    required this.isReadyToCollect,
    required this.quantity,
    required this.pickUpTime,
    required this.discountId,
    required this.name,
    required this.description,
    required this.images,
    required this.urlSlug,
    required this.price,
    required this.rating,
    required this.tags,
    required this.dishTypeId,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      userId: json['userId'] ??
          0, // Provide a default value (0 in this case) for null
      orderId: json['orderId'] ?? 0,
      dishId: json['dishId'] ?? 0,
      isPreOrder: json['isPreOrder'] ?? 0,
      isReviewed: json['isReviewed'] ?? 0,
      isReadyToServe: json['isReadyToServe'] ?? 0,
      receivedTime: json['receivedTime'] != null
          ? DateTime.parse(json['receivedTime'])
          : null,
      tokenId: json['tokenId'] ?? 0,
      isReadyToCollect: json['isReadyToCollect'] ?? 0,
      quantity: json['quantity'] ?? 0,
      pickUpTime: json['pickUpTime'] != null
          ? DateTime.parse(json['pickUpTime'])
          : DateTime(1970),
      discountId: json['discountId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] ?? '',
      urlSlug: json['urlSlug'] ?? '',
      price: (json['price'] as num?)?.toDouble() ??
          0.0, // Convert to double and provide a default value
      rating: (json['rating'] as num?)?.toDouble() ??
          0.0, // Convert to double and provide a default value
      tags: json['tags'] ?? '',
      dishTypeId: json['dishTypeId'] ?? 0,
    );
  }
}
