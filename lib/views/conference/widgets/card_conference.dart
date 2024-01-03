import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class CardConference extends StatelessWidget {
  const CardConference(
      {super.key, this.title, required this.total, this.onTap});
  final String? title;
  final double total;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              title ?? '',
              style: AppTextStyles.semiBold(22),
            ),
            subtitle: Text(
              total == 0 ? 'Valor não adicionado' : 'Total: R\$ $total',
              style: const TextStyle(height: 2),
            ),
            trailing: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
