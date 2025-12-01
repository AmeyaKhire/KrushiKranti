class CropModel {
  final String id;
  final String name;      // e.g., "Tomato" [cite: 47]
  final String category;  // "Vegetable", "Fruit", "Grain" [cite: 46, 61, 71]
  final double acres;     // How much land is used
  final DateTime plantingDate;
  final String? imageUrl; // For the photo

  CropModel({
    required this.id,
    required this.name,
    required this.category,
    required this.acres,
    required this.plantingDate,
    this.imageUrl,
  });

  // Factory for API
  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      acres: json['acres']?.toDouble() ?? 0.0,
      plantingDate: DateTime.parse(json['plantingDate']),
      imageUrl: json['imageUrl'],
    );
  }
}