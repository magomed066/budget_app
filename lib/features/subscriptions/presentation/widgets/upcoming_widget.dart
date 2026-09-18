import 'package:budget_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UpcomingWidget extends StatelessWidget {
  const UpcomingWidget({super.key});

  static const _subscriptions = [
    _UpcomingSubscription(
      name: 'Spotify',
      amount: '\$5.99',
      daysLeft: '2 days left',
      icon: Icons.music_note_rounded,
      iconColor: Color(0xFF1D1D1B),
    ),
    _UpcomingSubscription(
      name: 'Notion',
      amount: '\$12.00',
      daysLeft: '4 days left',
      icon: Icons.description_outlined,
      iconColor: Color(0xFF262626),
    ),
    _UpcomingSubscription(
      name: 'Figma',
      amount: '\$15.00',
      daysLeft: '6 days left',
      icon: Icons.grid_view_rounded,
      iconColor: Color(0xFF5A3DCC),
    ),
    _UpcomingSubscription(
      name: 'Figma',
      amount: '\$15.00',
      daysLeft: '6 days left',
      icon: Icons.grid_view_rounded,
      iconColor: Color(0xFF5A3DCC),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: _subscriptions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _UpcomingCard(subscription: _subscriptions[index]),
          ),
        ),
      ],
    );
  }
}

class _UpcomingSubscription {
  const _UpcomingSubscription({
    required this.name,
    required this.amount,
    required this.daysLeft,
    required this.icon,
    required this.iconColor,
  });

  final String name;
  final String amount;
  final String daysLeft;
  final IconData icon;
  final Color iconColor;
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.subscription});

  final _UpcomingSubscription subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      padding: const EdgeInsets.fromLTRB(11, 10, 8, 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.dark, width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4CC),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: subscription.iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      subscription.icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.amount,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subscription.daysLeft,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            subscription.name,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
