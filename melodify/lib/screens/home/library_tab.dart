import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Library Coming Soon',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
      ),
    );
  }
}