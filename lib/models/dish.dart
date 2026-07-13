class CustomizationOption {
  final String id;
  final String title;
  final String? subtitle;
  final double extraPrice;

  const CustomizationOption({
    required this.id,
    required this.title,
    this.subtitle,
    this.extraPrice = 0,
  });

  factory CustomizationOption.fromMap(Map<String, dynamic> map) {
    return CustomizationOption(
      id: map['id'].toString(),
      title: map['title'],
      subtitle: map['extra_price'] > 0 ? '+ \$${map['extra_price']}' : null,
      extraPrice: (map['extra_price'] as num).toDouble(),
    );
  }
}

class Dish {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final String weight;
  final int calories;
  final double rating;
  final int preparationMinutes;
  final List<CustomizationOption> customizations;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.weight,
    required this.calories,
    required this.rating,
    required this.preparationMinutes,
    this.customizations = const [],
  });

  factory Dish.fromMap(Map<String, dynamic> map) {
    var customizationsList = <CustomizationOption>[];
    if (map['dish_customizations'] != null) {
      customizationsList = (map['dish_customizations'] as List)
          .map((c) => CustomizationOption.fromMap(c))
          .toList();
    }

    return Dish(
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'] ?? '',
      category: map['category'] ?? 'Общее',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] ?? '',
      weight: map['weight'] ?? '',
      calories: map['calories'] ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      preparationMinutes: map['prep_minutes'] ?? 0,
      customizations: customizationsList,
    );
  }
}
