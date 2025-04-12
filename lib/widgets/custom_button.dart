import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final double? width;
  final IconData? leadingIcon;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
    this.leadingIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            minimumSize: width != null ? Size(width!, 52) : null,
            padding: padding,
            side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          )
        : ElevatedButton.styleFrom(
            minimumSize: width != null ? Size(width!, 52) : null,
            padding: padding,
            elevation: 0,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
          );

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppTheme.primaryColor : Colors.white,
              ),
            ),
          )
        else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isOutlined || isLoading
            ? null
            : [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonContent,
            ),
    );
  }
} 