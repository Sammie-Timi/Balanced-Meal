import 'package:balanced_meal/Screens/order.dart';
import 'package:balanced_meal/Widget/Custom_button.dart';
import 'package:balanced_meal/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formField = GlobalKey<FormState>();
  final GlobalKey _genderKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? overlayEntry;
  final List<String> gender = ['Male', 'Female'];
  TextEditingController genderC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  double dailyCalories = 0;

  void calculateCalories() {
    final weight = double.tryParse(weightC.text);
    final height = double.tryParse(heightC.text);
    final age = int.tryParse(ageC.text);
    final gender = genderC.text.toLowerCase();

    if (weight != null &&
        height != null &&
        age != null &&
        (gender == 'male' || gender == 'female')) {
      double result;

      if (gender == 'male') {
        result = 10 * weight + 6.25 * height - 5 * age + 5;
      } else {
        result = 10 * weight + 6.25 * height - 5 * age - 161;
      }
      UserData().dailyCalories = result;
      setState(() {
        dailyCalories = result * 1.2; // Assuming sedentary activity level
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Order()),
      );
      debugPrint('Daily Calories: $dailyCalories');
    }
  }

  void showdropdown() {
    overlayEntry = createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
  }

  void hideDropdown() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  OverlayEntry createOverlayEntry() {
    RenderBox renderBox =
        _genderKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            width: size.width,
            top: offset.dy + size.height + 4,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children:
                      gender.map((gender) {
                        final isSelected = genderC.text == gender;
                        return ListTile(
                          title: Text(
                            gender,

                            style: GoogleFonts.poppins(
                              color: Color(0xFF1E1E1E),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? Icon(Icons.check, color: Colors.deepOrange)
                                  : null,
                          tileColor:
                              isSelected
                                  ? Colors.deepOrange.withOpacity(0.1)
                                  : null,
                          onTap: () {
                            setState(() {
                              genderC.text = gender;
                            });
                            hideDropdown();
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    hideDropdown();
    super.dispose();
    genderC.dispose();
    weightC.dispose();
    heightC.dispose();
    ageC.dispose();
    _focusNode.dispose();
  }

  bool get isFormValid =>
      genderC.text.isNotEmpty &&
      weightC.text.isNotEmpty &&
      heightC.text.isNotEmpty &&
      ageC.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Enter your details',
          style: GoogleFonts.poppins(
            color: Color(0xFF1E1E1E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formField,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 31, left: 24, right: 24),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF474747),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: GestureDetector(
                      key: _genderKey,
                      onTap: () {
                        if (overlayEntry == null) {
                          showdropdown();
                        } else {
                          hideDropdown();
                        }
                      },
                      child: AbsorbPointer(
                        child: textField(
                          'Choose your Gender',
                          (value) {
                            setState(() {});
                          },
                          genderC,
                          TextInputType.text,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select Gender';
                            } else {
                              return null;
                            }
                          },
                          null,
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Color(0xFF474747),
                          ),
                          null,
                          _focusNode,
                          true,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Text(
                    'Weight',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF474747),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  textField(
                    'Enter Your Weight',
                    (value) {
                      setState(() {});
                    },
                    weightC,
                    TextInputType.number,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Weight';
                      } else if (double.tryParse(value) == null) {
                        return 'Enter valid weight';
                      } else {
                        return null;
                      }
                    },
                    [FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$'))],
                    null,

                    'Kg',
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Height',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF474747),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  textField(
                    'Enter Your Height',
                    (value) {
                      setState(() {});
                    },
                    heightC,
                    TextInputType.number,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Height';
                      } else if (double.tryParse(value) == null) {
                        return 'Enter a valid height';
                      } else {
                        return null;
                      }
                    },
                    [FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$'))],
                    null,

                    'cm',
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Age',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF474747),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  textField(
                    'Enter Your Age',
                    (value) {
                      setState(() {});
                    },
                    ageC,
                    TextInputType.number,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your age';
                      } else if (value == '0' ||
                          int.tryParse(value) == null ||
                          int.parse(value) < 0) {
                        return 'Enter a valid age';
                      } else {
                        return null;
                      }
                    },
                    [FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$'))],
                  ),
                  SizedBox(height: 169),
                  Center(
                    child: CustomButton(
                      Key('Details Button'),
                      text: 'Next ',
                      isDisabled: !isFormValid,
                      onTap: calculateCalories,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget textField(
  String hintText,
  ValueChanged<String> onChanged, [
  controller,
  keyboardType,
  validator,
  List<TextInputFormatter>? formatters,
  suffixIcon,
  suffixText,
  focusNode,
  bool readOnly = false,
]) {
  return TextFormField(
    onChanged: onChanged,

    focusNode: focusNode,
    readOnly: readOnly,
    textInputAction: TextInputAction.next,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: formatters,
    cursorColor: Color(0xFFF25700),
    cursorErrorColor: Color(0xFFF25700),
    keyboardType: keyboardType ?? TextInputType.text,
    controller: controller,
    validator: validator,
    style: GoogleFonts.roboto(color: Color(0xFF1F1F1F)),
    decoration: InputDecoration(
      focusColor: Color(0xFFEAECF0),
      hintText: hintText,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: GoogleFonts.poppins(
        color: Color(0xFF474747),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.questrial(
        color: Color(0xFF959595),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFF25700), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFEAECF0), width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFEAECF0), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFF25700), width: 1.5),
      ),
    ),
  );
}
