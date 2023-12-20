import 'dart:convert';
import 'dart:typed_data';

class Dish {
  final int dishId;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? name;
  String? description;
  Uint8List? images;
  String? urlSlug;
  double? price;
  double? rating;
  String? tags;
  int? quantityLeft;
  int? requestedQuantity;
  String? dishType;

  Dish({
    required this.dishId,
    this.createdDate,
    this.updatedDate,
    this.name,
    this.description,
    this.images,
    this.urlSlug,
    this.price,
    this.rating,
    this.tags,
    this.quantityLeft,
    this.requestedQuantity,
    this.dishType,
  });

  static Uint8List? _decodeBytes(List<dynamic> bytesList) {
    if (bytesList == null || bytesList.isEmpty) {
      return null;
    }
    List<int> intList = List<int>.from(bytesList.cast<int>());
    return Uint8List.fromList(intList);
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      dishId: json['dishId'],
      createdDate: (json['createdDate'] != null)
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: (json['updatedDate'] != null)
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      description: json['description'],
      images: (json['images'] != null)
          ? _decodeBytes(json['images']['data'])
          : json['images'],
      urlSlug: json['urlSlug'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      tags: json['tags'],
      quantityLeft: json['quantityLeft'],
      requestedQuantity: json['requestedQuantity'],
      dishType: json['dishType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'name': name,
      'description': description,
      'images': _encodeBase64(images),
      'urlSlug': urlSlug,
      'price': price,
      'rating': rating,
      'tags': tags,
      'quantityLeft': quantityLeft,
      'requestedQuantity': requestedQuantity,
      'dishType': dishType?.toString().split('.').last,
    };
  }

  static String? _encodeBase64(Uint8List? uint8List) {
    if (uint8List == null || uint8List.isEmpty) return null;
    return base64.encode(uint8List);
  }
}
