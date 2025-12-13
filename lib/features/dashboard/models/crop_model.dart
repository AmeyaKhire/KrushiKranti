class CropModel {
  final String id;
  final String name;      // e.g., "Tomato" or displayName
  final String category;  // Crop type name (e.g., "Vegetables", "Fruits")
  final double acres;     // How much land is used
  final DateTime? plantingDate; // Sowing date
  final String? imageUrl; // For the photo
  final String? cropTypeName; // Full crop type name
  final String? cropDisplayName; // Display name from backend

  CropModel({
    required this.id,
    required this.name,
    required this.category,
    required this.acres,
    this.plantingDate,
    this.imageUrl,
    this.cropTypeName,
    this.cropDisplayName,
  });

  // Factory for API
  factory CropModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    return CropModel(
      id: json['id']?.toString() ?? '',
      name: json['cropDisplayName'] ?? json['cropName'] ?? '',
      category: json['cropTypeDisplayName'] ?? json['cropTypeName'] ?? '',
      acres: (json['areaAcres'] ?? 0.0).toDouble(),
      plantingDate: parseDate(json['sowingDate']),
      imageUrl: json['iconUrl'],
      cropTypeName: json['cropTypeName'],
      cropDisplayName: json['cropDisplayName'] ?? json['cropName'],
    );
  }
}