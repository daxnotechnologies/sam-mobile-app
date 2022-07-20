import 'package:flutter/material.dart';

class CustomTextFormFieldWithPrefix extends StatefulWidget {
  final String? hintText;
  final int? minLines;
  final String? label;
  final Widget prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextFormFieldWithPrefix({
    Key? key,
    this.hintText,
    this.label,
    required this.prefixIcon,
    this.minLines,
    this.controller,
    this.validator,
  }) : super(key: key);
  @override
  State<CustomTextFormFieldWithPrefix> createState() =>
      _CustomTextFormFieldWithPrefixState();
}

class _CustomTextFormFieldWithPrefixState
    extends State<CustomTextFormFieldWithPrefix> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: textFeildHeight,
      child: TextFormField(
        scrollPadding: const EdgeInsets.only(left: 10, right: 10),
        // textAlign: TextAlign.center,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Theme.of(context).primaryColor),
          ),
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          label: widget.label != null ? Text(widget.label!) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(0),

        ),
        validator: widget.validator ??
                (String? value) {
              if (value!.isEmpty) {

                return "Please fill out this feild";
              }else if (!value.contains("@")) {
                return "Please enter valid email";
              }
              return null;
            },
      ),
    );
  }
}

class CustomPasswordFormFieldWithPrefix extends StatefulWidget {
  final String? hintText;
  final int? minLines;
  final String? label;
  final Widget prefixIcon;
  final TextEditingController? controller;
  // final bool? obscureText;
  final String? Function(String?)? validator;
  final Color? borderColor;
  const CustomPasswordFormFieldWithPrefix({
    Key? key,
    this.hintText,
    this.label,
    required this.prefixIcon,
    this.minLines,
    this.controller,
    // this.obscureText,
    this.validator,
    this.borderColor,
  }) : super(key: key);

  @override
  State<CustomPasswordFormFieldWithPrefix> createState() =>
      _CustomPasswordFormFieldWithPrefixState();
}

class _CustomPasswordFormFieldWithPrefixState
    extends State<CustomPasswordFormFieldWithPrefix> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      // height: textFeildHeight,
      child: TextFormField(
        scrollPadding: const EdgeInsets.only(left: 10, right: 10),
        // textAlign: TextAlign.center,
        controller: widget.controller,
        obscureText: isVisible,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          label: widget.label != null ? Text(widget.label!) : null,
          contentPadding: const EdgeInsets.all(0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            splashRadius: 15,
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
            iconSize: 20,
          ),
        ),

        validator: widget.validator ??
                (String? value) {
              if (value!.isEmpty) {
                return "Please fill out this feild";
              }else if(value.length<8){
                return "Password Must Contain 8 characters";
              }
              return null;
            },
      ),
    );
  }
}
