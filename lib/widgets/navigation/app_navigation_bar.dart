import 'package:budget_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const destinations = <_NavigationDestination>[
    _NavigationDestination(label: "Home", icon: Icons.home_rounded),
    _NavigationDestination(
      label: "Budget",
      icon: Icons.pie_chart_outline_rounded,
    ),
    _NavigationDestination(label: "Savings", icon: Icons.savings_outlined),
    _NavigationDestination(
      label: "Profile",
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: renderDestinations()),
          ),
        ),
      ),
    );
  }

  List<Widget> renderDestinations() {
    return List.generate(destinations.length, (index) {
      return Expanded(
        child: _NavigationItem(
          destination: destinations[index],
          isSelected: currentIndex == index,
          onTap: () => onDestinationSelected(index),
        ),
      );
    });
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final _NavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.dark;

    return Semantics(
      selected: isSelected,
      button: true,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(destination.icon, color: color, size: 27),
              const SizedBox(height: 4),
              Text(
                destination.label,
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination {
  const _NavigationDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
