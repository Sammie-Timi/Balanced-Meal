import 'package:balanced_meal/Widget/bottom_sheet.dart';
import 'package:balanced_meal/Widget/food_card.dart';
import 'package:balanced_meal/models/ingredient.dart';
import 'package:balanced_meal/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Map<String, int> selectedQuantities = {};
  double totalCalories = 0;
  double totalPrice = 0;
  void updateSelection(
    String name,
    double calories,
    double price,
    int quantity,
  ) {
    setState(() {
      selectedQuantities[name] = quantity;
      _recalculateTotals();
    });
  }

  void _recalculateTotals() {
    totalCalories = 0;
    totalPrice = 0;
    selectedQuantities.forEach((name, qty) {
      final allItems = [...vegetables, ...meats, ...carbs];
      final matched = allItems.firstWhere((item) => item.name == name);
      totalCalories += matched.calories * qty;
      totalPrice += matched.price * qty;
    });
  }

  List<Ingredient> vegetables = [];
  List<Ingredient> meats = [];
  List<Ingredient> carbs = [];

  Future<void> fetchIngredients() async {

    final vegSnap =
        await FirebaseFirestore.instance.collection('vegetable').get();
    final meatSnap = await FirebaseFirestore.instance.collection('meat').get();
    final carbSnap = await FirebaseFirestore.instance.collection('Carb').get();

    setState(() {
      vegetables =
          vegSnap.docs
              .map((doc) => Ingredient.fromFirestore(doc.data()))
              .toList();
      meats =
          meatSnap.docs
              .map((doc) => Ingredient.fromFirestore(doc.data()))
              .toList();
      carbs =
          carbSnap.docs
              .map((doc) => Ingredient.fromFirestore(doc.data()))
              .toList();
      if (vegetables.isEmpty) {
        vegetables = [
          Ingredient(name: 'Carrot', calories: 30, price: 1.0, image_url: ''),
          Ingredient(name: 'Broccoli', calories: 40, price: 1.5, image_url: ''),
        ];
      }
      // if (meats.isEmpty) {
      //   meats = [
      //     Ingredient(name: 'Chicken', calories: 200, price: 5.0, image_url: ''),
      //     Ingredient(name: 'Beef', calories: 250, price: 6.0, image_url: ''),
      //   ];
      // }
      // if (carbs.isEmpty) {
      //   carbs = [
      //     Ingredient(name: 'Rice', calories: 150, price: 2.0, image_url: ''),
      //     Ingredient(name: 'Pasta', calories: 180, price: 2.5, image_url: ''),
      //   ];
      // }
      if (kDebugMode) {
        print('Vegetables raw: ${vegSnap.docs.map((d) => d.data())}');
      }
      if (kDebugMode) {
        print('Vegetables: $vegetables');
      }
      print('Meats: $meats');
      if (kDebugMode) {
        print('Carbs: $carbs');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  Widget _buildCategory(String title, List<Ingredient> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 248,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final quantity = selectedQuantities[item.name] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FoodCard(
                  name: item.name,
                  calories: item.calories.toInt(),
                  price: item.price,
                  imageUrl: item.image_url,
                  quantity: quantity,
                  onQuantityChanged: (qty) {
                    updateSelection(
                      item.name,
                      item.calories.toDouble(),
                      item.price,
                      qty,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyCal = UserData().dailyCalories ?? 2000;
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Create your order',
          style: GoogleFonts.poppins(
            color: Color(0xFF1E1E1E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      bottomSheet: ItemBottomSheet(
        totalCal: totalCalories,
        totalPrice: totalPrice,
        isValid:
            totalCalories >= dailyCal * 0.9 && totalCalories <= dailyCal * 1.1,
        selectedItems: selectedQuantities,
        vegetables: vegetables,
  meats: meats,
  carbs: carbs,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 31, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategory('Vegetables', vegetables),
              SizedBox(height: 24),
              _buildCategory('Meats', meats),
              SizedBox(height: 24),
              _buildCategory('Carbs', carbs),
              SizedBox(height: 230),
            ],
          ),
        ),
      ),
    );
  }
}
