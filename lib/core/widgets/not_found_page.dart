import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'section_heading.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w800,
                  color: AppColors.flutterBlue,
                  height: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const SectionHeading(title: 'Page Not Found'),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'The page you are looking for does not exist or has been moved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.neutralGrey),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
