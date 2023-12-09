class Dish {
  int? dishId;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? name;
  String? description;
  String? images;
  String? urlSlug;
  double? price;
  double? rating;
  String? tags;
  int? quantityLeft;
  int? requestedQuantity;
  int? dishTypeId;

  Dish({
    this.dishId,
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
    this.dishTypeId,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      dishId: json['dishId'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
      name: json['name'],
      description: json['description'],
      images: json['images'],
      urlSlug: json['urlSlug'],
      price: json['price']?.toDouble(),
      rating: json['rating']?.toDouble(),
      tags: json['tags'],
      quantityLeft: json['quantityLeft'],
      requestedQuantity: json['requestedQuantity'],
      dishTypeId: json['dishTypeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'name': name,
      'description': description,
      'images': images,
      'urlSlug': urlSlug,
      'price': price,
      'rating': rating,
      'tags': tags,
      'quantityLeft': quantityLeft,
      'requestedQuantity': requestedQuantity,
      'dishTypeId': dishTypeId,
    };
  }
}
