import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_number_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/dropdown_stock.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class NewIngredientModal extends StatefulWidget {
  NewIngredientModal({super.key});

  @override
  State<NewIngredientModal> createState() => _NewIngredientModalState();
}

class _NewIngredientModalState extends State<NewIngredientModal> {
  // final ingredient_id = TextEditingController();
  final amount = TextEditingController();
  final unit = TextEditingController();
  // final medida = TextEditingController();
  var ingredient_id = "";
  var medida = "";

  Map<String, dynamic> ingredient = {"title": null};
  List<dynamic> orderoptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addAllOptions();
  }

  addAllOptions() {
    orderoptions = context
        .read<MenuCubit>()
        .state
        .item
        .options
        .map((e) => e["title"])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<MenuCubit>(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Novo ingrediente',
                style: AppTextStyles.semiBold(25),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Ingrediente do stock",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownIngredients(
                onChange: (op) {
                  setState(
                    () {
                      ingredient = op;
                    },
                  );
                },
                value: ingredient["title"],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: CustomNumberFieldStock(
                      title: 'Quantidade',
                      hint: '100',
                      controller: amount,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownStock(
                      controller: unit,
                      initial: null,
                      // disable: ,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Adicionar para:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // const Text(
                  //   "Adicionar para:",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        addAllOptions();
                      });
                    },
                    child: const Text("Limpar",
                        style: TextStyle(fontWeight: FontWeight.w400)),
                  )
                ],
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: orderoptions.length,
                  itemBuilder: (context, index) {
                    var op = orderoptions[index];

                    return Chip(
                      key: ValueKey(index),
                      label: Text(op,
                          style: AppTextStyles.medium(12, color: Colors.white)),
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 10),
                      deleteIconColor: Colors.white,
                      onDeleted: () => {
                        setState(() {
                          orderoptions.removeWhere((element) => element == op);
                        })
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomSubmitButton(
                  onPressedAction: () {
                    var ing = {
                      "id": ingredient["id"],
                      "name": ingredient["title"],
                      "unit": unit.text,
                      "value": amount.text
                    };
                    context.read<MenuCubit>().addIngredient(ing, orderoptions);
                    Navigator.pop(context);
                  },
                  label: "Feito"),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 45)),
                child: Text(
                  "Cancelar",
                  style: AppTextStyles.medium(14, color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}

// SizedBox(
//               height: 200,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: BlocProvider.of<MenuCubit>(context)
//                     .state
//                     .item
//                     .options
//                     .length,
//                 itemBuilder: (context, index) {
//                   var op = BlocProvider.of<MenuCubit>(context)
//                       .state
//                       .item
//                       .options[index]["title"];

//                   return Text(op);
//                 },
//               ),
//             ),

// ignore_for_file: public_member_api_docs, sort_constructors_first

class DropdownIngredients extends StatelessWidget {
  DropdownIngredients({Key? key, this.onChange, required this.value})
      : super(key: key);

  final onChange;
  final value;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<MenuCubit>().fetchStock(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgress();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          var docs = snapshot.data?.docs ?? [];

          print(docs.length);
          // List<String> items = docs.map((e) => e["title"].toString()).toList();
          // items.insert(0, "Todos os itens");

          // return BlocBuilder<FinanceOrdersCubit, FinanceOrdersState>(
          //   builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                hint: const Text("Selecione um"),
                value: value,
                onChanged: (option) {
                  // onChange(option?.data());
                  // onChange(option);
                  // context
                  //     .read<FinanceOrdersCubit>()
                  //     .filterItems(option.toString());
                },
                items: docs
                    .map(
                      (option) => DropdownMenuItem(
                        value: option["title"],
                        onTap: () => onChange(
                            {"id": option.id, "title": option.data()["title"]}),
                        child: Text(option["title"]),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
          //   },
          // );
        }
      },
    );
  }
}
