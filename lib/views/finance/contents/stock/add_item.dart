import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class AddStockScreen extends StatelessWidget {
  const AddStockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocProvider.value(
        value: context.read<StockCubit>(),
        child: Column(
          children: [
            Text(
              !(context.read<StockCubit>().state.status == AppStatus.editing)
                  ? 'Novo item'
                  : "Editar item",
              style: AppTextStyles.semiBold(25),
            ),
            const SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 60,
            //   color: Colors.amber,
            // ),
            if (!(context.read<StockCubit>().state.status == AppStatus.editing))
              BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  return FlutterToggleTab(
                      width: 70,
                      borderRadius: 10,
                      unSelectedTextStyle: AppTextStyles.medium(
                        14,
                      ),
                      selectedBackgroundColors: [Colors.black],
                      selectedTextStyle:
                          AppTextStyles.medium(14, color: Colors.white),
                      labels: const ["Kilogramas", "Litros"],
                      selectedIndex: state.unit == "L" ? 1 : 0,
                      marginSelected: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      selectedLabelIndex: (index) => context
                          .read<StockCubit>()
                          .changeUnit(index == 0 ? "Kg" : "L"));
                },
              ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
              onChanged: context.read<StockCubit>().changeTitle,
              textInputAction: TextInputAction.next,
              controller:
                  context.read<StockCubit>().state.status == AppStatus.editing
                      ? TextEditingController(
                          text: context.read<StockCubit>().state.title)
                      : null,
              enabled: !(context.read<StockCubit>().state.status ==
                  AppStatus.editing),
              decoration: InputDecoration(
                fillColor: const Color(0xffF7F8F9),
                filled: true,
                hintStyle: AppTextStyles.medium(16,
                    color: const Color(0xff8391A1).withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                hintText: 'Titulo',
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
            //   // onChanged: context.read<FinanceCubit>().changeExpenseValue,
            //   textInputAction: TextInputAction.next,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     fillColor: const Color(0xffF7F8F9),
            //     filled: true,
            //     hintStyle: AppTextStyles.medium(16,
            //         color: const Color(0xff8391A1).withOpacity(0.5)),
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide:
            //             const BorderSide(color: Color(0xffE8ECF4), width: 1)),
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide:
            //             const BorderSide(color: Color(0xffE8ECF4), width: 1)),
            //     hintText: 'Peso/volume unidade',
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
              onChanged: context.read<StockCubit>().changeVolume,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller:
                  context.read<StockCubit>().state.status == AppStatus.editing
                      ? TextEditingController(
                          text: context.read<StockCubit>().state.volume)
                      : null,
              decoration: InputDecoration(
                fillColor: const Color(0xffF7F8F9),
                filled: true,
                hintStyle: AppTextStyles.medium(16,
                    color: const Color(0xff8391A1).withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                hintText: 'Peso/volume estoque',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomSubmitButton(
                onPressedAction: () {
                  context.read<StockCubit>().save(context
                      .read<HomeCubit>()
                      .state
                      .storage["restaurant"]["id"]);

                  Navigator.pop(context);
                },
                label: "Adicionar"),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: AppTextStyles.medium(14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
