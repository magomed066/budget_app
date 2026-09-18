import 'package:budget_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _destinations = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.shopping_bag_outlined, label: 'Budget'),
    (icon: Icons.autorenew_rounded, label: 'Subscriptions'),
    (icon: Icons.show_chart_rounded, label: 'Savings'),
    (icon: Icons.settings_outlined, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Material(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 70,
          child: Row(
            children: List.generate(_destinations.length, (index) {
              final destination = _destinations[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: Semantics(
                  selected: isSelected,
                  button: true,
                  label: destination.label,
                  child: Tooltip(
                    message: destination.label,
                    excludeFromSemantics: true,
                    child: InkWell(
                      onTap: () => onDestinationSelected(index),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.backgroundSecondary
                                : Colors.transparent,
                          ),
                          child: Icon(
                            destination.icon,
                            size: 24,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
