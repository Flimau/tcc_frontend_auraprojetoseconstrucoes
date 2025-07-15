import 'package:flutter/material.dart';
import 'package:front_application/theme/theme.dart';

class InputCampoMultiline extends StatelessWidget {
  final String label;
  final IconData icone;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;

  const InputCampoMultiline({
    Key? key,
    required this.label,
    required this.icone,
    required this.controller,
    this.maxLines = 4,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          label,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            prefixIcon: Icon(icone, color: AppColors.accent),
            
            hintStyle: AppTextStyles.subtitle,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
