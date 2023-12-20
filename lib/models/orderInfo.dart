import 'dart:typed_data';

class OrderInfo {
  final int userId;
  final int orderId;
  final int dishId;
  final int? discountId;
  final int? isPreOrder;
  final int? isReviewed;
  final int? isReadyToServe;
  final String? receivedTime;
  final int? tokenId;
  final int? orderTotal;
  final int? isReadyToCollect;
  final String? deliveryTime;
  final int? quantity;
  final int? pickUpTime;
  final String dishName;
  final String? dishDescription;
  final Uint8List? dishImages;
  final String? dishUrlSlug;
  final double dishPrice;
  final double dishRating;
  final String? dishTags;
  final String? dishType;
  final String userUsername;
  final String userUserType;
  final String userPhone;
  final String userEmail;
  final String? discountType;
  final String? discountName;
  final double? discountAmount;

  OrderInfo({
    required this.userId,
    required this.orderId,
    required this.dishId,
    required this.discountId,
    required this.isPreOrder,
    required this.isReviewed,
    required this.isReadyToServe,
    required this.receivedTime,
    required this.tokenId,
    required this.orderTotal,
    required this.isReadyToCollect,
    required this.deliveryTime,
    required this.quantity,
    required this.pickUpTime,
    required this.dishName,
    this.dishDescription,
    this.dishImages,
    this.dishUrlSlug,
    required this.dishPrice,
    required this.dishRating,
    this.dishTags,
    this.dishType,
    required this.userUsername,
    required this.userUserType,
    required this.userPhone,
    required this.userEmail,
    this.discountType,
    this.discountName,
    this.discountAmount,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      userId: json['userId'],
      orderId: json['orderId'],
      dishId: json['dishId'],
      discountId: json['discountId'],
      isPreOrder: json['isPreOrder'],
      isReviewed: json['isReviewed'],
      isReadyToServe: json['isReadyToServe'],
      receivedTime: json['receivedTime'],
      tokenId: json['tokenId'],
      orderTotal: json['total'],
      isReadyToCollect: json['isReadyToCollect'],
      deliveryTime: json['deliveryTime'],
      quantity: json['quantity'],
      pickUpTime: json['pickUpTime'],
      dishName: json['dishName'],
      dishDescription: json['description'],
      dishImages: (json['images'] != null)
          ? _decodeBytes(json['images']['data'])
          : json['images'],
      dishUrlSlug: json['urlSlug'],
      dishPrice: json['price'],
      dishRating: json['rating'],
      dishTags: json['tags'],
      dishType: json['dishType'],
      userUsername: json['username'],
      userUserType: json['userType'],
      userPhone: json['phone'],
      userEmail: json['email'],
      discountType: json['discountType'],
      discountName: json['discountName'],
      discountAmount: json['amount'],
    );
  }
  static Uint8List? _decodeBytes(List<dynamic> bytesList) {
    if (bytesList.isEmpty) {
      return null;
    }
    List<int> intList = List<int>.from(bytesList.cast<int>());
    return Uint8List.fromList(intList);
  }
}
