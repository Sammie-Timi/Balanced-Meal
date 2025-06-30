import 'package:balanced_meal/Screens/summary.dart';
import 'package:balanced_meal/Widget/Custom_button.dart';
import 'package:balanced_meal/models/ingredient.dart';
import 'package:balanced_meal/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemBottomSheet extends StatefulWidget {
  final double totalCal;
  final double totalPrice;
  final bool isValid;
  final Map<String, int> selectedItems;
  final List<Ingredient> vegetables;
  final List<Ingredient> meats;
  final List<Ingredient> carbs;
  const ItemBottomSheet({
    super.key,
    required this.totalCal,
    required this.totalPrice,
    required this.isValid,
    required this.selectedItems,
    required this.vegetables,
    required this.meats,
    required this.carbs,
  });

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final dailyCal = UserData().dailyCalories ?? 2000;
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cal',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${widget.totalCal.toInt()} cal out of ${dailyCal.toInt()} cal',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '\$${widget.totalPrice.toInt()} ',
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
              Key('Order Button'),
              text: 'Place Order',
              onTap:
                  widget.isValid
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SummaryOrder(
                                  items: [
                                    ...widget.vegetables,
                                    ...widget.meats,
                                    ...widget.carbs,
                                  ],
                                  quantities: widget.selectedItems,
                                  totalCalories: widget.totalCal,
                                  totalPrice: widget.totalPrice,
                                ),
                          ),
                        );
                      }
                      : () {},

              isDisabled: !widget.isValid,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
