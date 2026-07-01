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
    this.customizations = const [],
  });
}
