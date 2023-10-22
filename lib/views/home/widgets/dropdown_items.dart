// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';

import 'package:snacks_pro_app/views/finance/state/orders/finance_orders_cubit.dart';

class DropdownItems extends StatelessWidget {
  DropdownItems({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<FinanceOrdersCubit>().getItemsByRestaurantId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          List<String> items = snapshot.data!;
          items.insert(0, "Todos os itens");

          return BlocBuilder<FinanceOrdersCubit, FinanceOrdersState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    hint: const Text("Todos os itens"),
                    value: state.filter.isEmpty ? null : state.filter,
                    onChanged: (option) {
                      context
                          .read<FinanceOrdersCubit>()
                          .filterItems(option.toString());
                    },
                    items: items
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
