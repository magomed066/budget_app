import 'package:budget_app/shared/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.height, required this.title});

  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      // elevation: 0,
      // scrolledUnderElevation: 0,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 72,
      leading: Center(
        child: IconButton(
          onPressed: () => Navigator.maybePop(context),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          style: IconButton.styleFrom(
            foregroundColor: AppColors.primaryText,
            side: BorderSide(color: AppColors.border),
            shape: CircleBorder(),
          ),
          icon: Icon(Icons.arrow_back_ios_new, size: 16),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
