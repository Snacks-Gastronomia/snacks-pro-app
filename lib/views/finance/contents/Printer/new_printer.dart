import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class NewPrinterContent extends StatelessWidget {
  const NewPrinterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<FinanceCubit>(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<FinanceCubit, FinanceHomeState>(
                  builder: (context, state) {
                return Text(
                  state.status == AppStatus.editing
                      ? "Editar impressora ${state.printerAUX.name}"
                      : 'Adicionar impressora',
                  style: AppTextStyles.semiBold(25),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changePrinterName,
                textInputAction: TextInputAction.next,
                controller: TextEditingController(
                    text: context.read<FinanceCubit>().state.printerAUX.name ??
                        ""),
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
                  hintText: 'Nome',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // TextFormField(
              //   style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
              //   onChanged: context.read<FinanceCubit>().changePrinterGoal,
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
              //     hintText: 'Finalidade',
              //   ),
              // ),
              BlocBuilder<FinanceCubit, FinanceHomeState>(
                  builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: const Border.fromBorderSide(
                        BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  ),
                  child: DropdownButton<String>(
                    value: snapshot.printerAUX.goal,
                    hint: Text(
                      "Finalidade",
                      style: AppTextStyles.regular(16, color: Colors.black26),
                    ),
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: AppTextStyles.medium(16, color: Colors.black54),
                    isExpanded: true,
                    itemHeight: 55,
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? value) =>
                        context.read<FinanceCubit>().changePrinterGoal(value),
                    borderRadius: BorderRadius.circular(15),
                    items: ["Pedidos", "Caixa", "Outros"]
                        .map((String value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changePrinterIP,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                // inputFormatters: [
                //   MaskTextInputFormatter(
                //       filter: {"#": RegExp(r'[0-9]')},
                //       type: MaskAutoCompletionType.lazy)
                // ],
                controller: TextEditingController(
                    text: context.read<FinanceCubit>().state.printerAUX?.ip ??
                        ""),
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
                  hintText: 'Endereço IP',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<FinanceCubit, FinanceHomeState>(
                  builder: (context, state) {
                return CustomSubmitButton(
                  onPressedAction: () =>
                      context.read<FinanceCubit>().state.status ==
                              AppStatus.editing
                          ? context
                              .read<FinanceCubit>()
                              .updatePrinter(context, null, null)
                          : context.read<FinanceCubit>().insertPrinter(context),
                  label: state.status == AppStatus.editing
                      ? "Atualizar"
                      : "Adicionar",
                  loading_label: "Adicionando...",
                  loading: state.status == AppStatus.loading,
                );
              }),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  context.read<FinanceCubit>().clearAUX();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancelar",
                  style: AppTextStyles.medium(16, color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
