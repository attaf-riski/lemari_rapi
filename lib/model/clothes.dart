// mapping
class Clothes {
  final bool? isWashed, isAtWardrobe, isIroned;
  final String? clotheName, description, clotheId, clotheImageURL;

  Clothes(
      {this.isWashed,
      this.isAtWardrobe,
      this.isIroned,
      this.clotheName,
      this.description,
      this.clotheImageURL,
      this.clotheId});

  static Clothes fromJson({required Map<dynamic, dynamic> json}) {
    return Clothes(
        isWashed: json['isWashed'],
        isAtWardrobe: json['isAtWardrobe'],
        isIroned: json['isIroned'],
        clotheId: json['clotheId'],
        clotheName: json['clotheName'],
        description: json['description']);
  }
}
