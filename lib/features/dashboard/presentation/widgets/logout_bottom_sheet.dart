import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shawn/core/theme/app_color.dart';

void showLogoutBottomSheet({required BuildContext context, required VoidCallback onLogout, required ThemeData theme}) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      // final theme= Theme.of(_);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Heading Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Lottie.asset(
                'assets/animations/logout.json',
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Confirmation Text
            Text(
              'Ready to log out?',
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            Text(
              'You will need to log in again to access your account.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
