class Ingredient {
  final String name;
  final int calories;
  final double price;
  final String image_url;

  Ingredient({
    required this.name,
    required this.calories,
    required this.price,
    required this.image_url,
  });

  factory Ingredient.fromFirestore(Map<String, dynamic> data) {
    return Ingredient(
      name: data['food_name'] ?? data['name'] ?? '',
      calories: data['calories'],
      price: data['price'].toDouble(),
      image_url: data['image_url'],
    );
  }
}
