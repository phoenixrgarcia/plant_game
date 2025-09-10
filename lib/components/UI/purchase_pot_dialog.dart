import 'package:flutter/material.dart';

class PurchasePotDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final double cost;

  const PurchasePotDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
    required this.cost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Purchase Pot'),
      content: Text('Do you want to purchase this pot for \$${cost.toStringAsFixed(0)}?'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Purchase'),
        ),
      ],
    );
  }
}