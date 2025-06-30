import 'dart:convert';
import 'package:balanced_meal/models/ingredient.dart';
import 'package:balanced_meal/Widget/Custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SummaryOrder extends StatefulWidget {
  final List<Ingredient> items;
  final Map<String, int> quantities;
  final double totalCalories;
  final double totalPrice;

  const SummaryOrder({
    super.key,
    required this.items,
    required this.quantities,
    required this.totalCalories,
    required this.totalPrice,
  });

  @override
  State<SummaryOrder> createState() => _SummaryOrderState();
}

class _SummaryOrderState extends State<SummaryOrder> {
  bool isLoading = false;
  bool isSuccess = false;

  Future<void> _confirmOrder() async {
    setState(() => isLoading = true);

    final orderItems =
        widget.items
            .where((item) => (widget.quantities[item.name] ?? 0) > 0)
            .map(
              (item) => {
                "name": item.name,
                "total_price":
                    (item.price * (widget.quantities[item.name] ?? 0)).toInt(),
                "quantity": widget.quantities[item.name] ?? 0,
              },
            )
            .toList();

    final response = await http.post(
      Uri.parse('https://uz8if7.buildship.run/placeOrder'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"items": orderItems}),
    );

    setState(() => isLoading = false);

    if (response.statusCode != 200 || !response.body.contains('true')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order failed. Please try again.')),
      );
    } else {
      setState(() => isSuccess = true);
      // Go back to home after a short delay
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryItems =
        widget.items
            .where((item) => (widget.quantities[item.name] ?? 0) > 0)
            .toList();

    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Order summary',
          style: GoogleFonts.poppins(
            color: Color(0xFF1E1E1E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...summaryItems.map((item) {
                final qty = widget.quantities[item.name] ?? 0;
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            item.image_url.isNotEmpty
                                ? Image.network(
                                  item.image_url,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 32,
                                  ),
                                ),
                      ),
                      SizedBox(width: 12),
                      // Name, Calories
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                // Price
                                Text(
                                  '\$${item.price.toInt()}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.calories} Cal',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF25700),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '$qty',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF25700),

                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cals',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${widget.totalCalories.toInt()} Cal out of 1200 Cal',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '\$ ${widget.totalPrice.toInt()}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              CustomButton(
                Key('Confirm Button'),
                text: isLoading ? 'Placing Order...' : 'Confirm',
                isDisabled: isLoading,
                onTap: isLoading ? () {} : _confirmOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
