import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shawn/features/subscription/model/subscription_model.dart';

class SubscriptionPage extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onCancel;

  const SubscriptionPage({
    super.key,
    required this.subscription,
    required this.onCancel,
  });

  String formatDate(DateTime date) => DateFormat.yMMMMd().format(date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = subscription.isSubActive;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Subscription Details',style: theme.textTheme.titleMedium,),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4A92FE),
                  Color(0xFF3B7DD8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            size: 64,
                            color: isActive ? Colors.green : Colors.redAccent,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isActive ? 'Active Plan' : 'Plan Expired',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _infoTile(
                      context,
                      label: 'Subscription ID',
                      value: subscription.subId,
                      icon: Icons.confirmation_num,
                    ),

                    _infoTile(
                      context,
                      label: 'Start Date',
                      value: formatDate(subscription.startDate),
                      icon: Icons.calendar_today,
                    ),

                    _infoTile(
                      context,
                      label: 'End Date',
                      value: formatDate(subscription.endDate),
                      icon: Icons.calendar_today,
                    ),

                    const Divider(height: 32),

                    _infoTile(
                      context,
                      label: 'Status',
                      value: isActive ? 'Subscribed' : 'Inactive',
                      icon: isActive ? Icons.check : Icons.block,
                      valueColor: isActive ? Colors.green : Colors.redAccent,
                    ),

                    const SizedBox(height: 32),

                    if (isActive)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _showCancelDialog(context),
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Subscription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          'Your subscription has ended.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
        Color? valueColor,
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: valueColor ?? theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content:
        const Text('Are you sure you want to cancel this subscription?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onCancel();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
