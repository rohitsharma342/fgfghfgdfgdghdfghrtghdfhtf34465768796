import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            side: const BorderSide(color: AppTheme.primaryColor, width: 2),
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 24,
              vertical: isSmall ? 8 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 24,
              vertical: isSmall ? 8 : 16,
            ),
          );

    final child = isLoading
        ? SizedBox(
            height: isSmall ? 16 : 20,
            width: isSmall ? 16 : 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppTheme.primaryColor : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isSmall ? 16 : 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}