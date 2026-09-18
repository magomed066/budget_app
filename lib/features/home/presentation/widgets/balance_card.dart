import 'package:budget_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({super.key});

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  bool isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 196, 176),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  isBalanceVisible ? r"$500" : '••••••',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              changeIsBalanceVisible();
            },
            icon: Icon(
              isBalanceVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Color(0xFFF3F3F3),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            label: Text(isBalanceVisible ? "Hide" : "Show"),
          ),
        ],
      ),
    );
  }

  void changeIsBalanceVisible() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }
}
