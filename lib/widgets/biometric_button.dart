import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BiometricButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const BiometricButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Ink(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      ),
                    ),
                  )
                : Icon(
                    Icons.fingerprint,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
          ),
        ),
      ),
    );
  }
} 