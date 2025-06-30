import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodCard extends StatefulWidget {
  final String name;
  final int calories;
  final double price;
  final String? imageUrl;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  const FoodCard({
    super.key,
    required this.name,
    required this.calories,
    required this.price,
    this.imageUrl,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void incrementQ() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(quantity);
  }

  void decrementQ() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
    widget.onQuantityChanged(quantity);
  }

  void addFood() {
    setState(() {
      quantity = 1;
    });
    widget.onQuantityChanged(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(widget.imageUrl!, fit: BoxFit.cover),
                    )
                    : Icon(Icons.image, size: 40, color: Colors.grey.shade400),
          ),
          SizedBox(height: 12),
          // Name and Calories
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8),

              Text(
                ' ${widget.calories} cal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Price
          Row(
            children: [
              Text(
                '\$ ${widget.price.toInt()}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 8),
              quantity == 0
                  ? Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: addFood,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: decrementQ,
                          child: IconButton(
                            iconSize: 20,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: decrementQ,
                            icon: Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$quantity',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: incrementQ,
                          child: IconButton(
                            iconSize: 20,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: incrementQ,
                            icon: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
