import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color bgColor;
  final Color disabledColor;
  final Color textColor;
  const CustomButton(
    Key? key, {
    required this.text,
    required this.onTap,
    this.isDisabled = false,
    this.bgColor = const Color(0xFFF25700),
    this.disabledColor = const Color(0xFFEAECF0),
    this.textColor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDisabled ? disabledColor : bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.abhayaLibre(
            color: isDisabled ? Colors.grey : textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
