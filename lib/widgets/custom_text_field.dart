import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isPassword = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _hasFocus = false;

  late final FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }
  
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }
  
  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasFocus 
              ? AppTheme.primaryColor 
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: _hasFocus 
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ] 
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null 
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: _hasFocus ? AppTheme.primaryColor : AppTheme.darkGreyColor,
                    size: 22,
                  ),
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
} 