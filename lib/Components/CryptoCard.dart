import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';

class CryptoCard extends StatelessWidget {
  final String img;
  final String name;
  final String stack;
  final String balance;
  final String rate;
  final bool dateStatus;
  final String date;

  const CryptoCard({
    super.key,
    required this.img,
    required this.name,
    required this.stack,
    required this.balance,
    required this.rate,
    required this.dateStatus,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double rateValue = double.parse(rate);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      width: screenWidth * 0.6,
      decoration: BoxDecoration(
        // gradient: MyColors.primaryGradient,
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(width: 50, img),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        color: MyColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "\$ ${rateValue.toStringAsFixed(4)}",
                    style: const TextStyle(
                        color: MyColors.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),

                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Staking",
                style: TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
              ),

              Text(
                double.parse(stack).toStringAsFixed(8),
                style: const TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Balance",
                style: TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
              Text(
                double.parse(balance).toStringAsFixed(8),
                style: const TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              )
            ],
          ),
          dateStatus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Unblock Date",
                      style: TextStyle(
                          color: MyColors.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                          color: MyColors.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
