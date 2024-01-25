import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';

class AddDataToStock extends StatelessWidget {
  const AddDataToStock({
    Key? key,
    required this.typeModal,
    this.unit,
    this.lastEntrance,
  }) : super(key: key);

  final StockModalOptions typeModal;
  final String? unit;
  final String? lastEntrance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: typeModal == StockModalOptions.loss
              ? StockLoss(unit: unit)
              : NewStockItem(
                  isNew: typeModal == StockModalOptions.isNew,
                  lastEntrance: lastEntrance,
                )),
    );
  }
}

class StockLoss extends StatelessWidget {
  const StockLoss({
    Key? key,
    this.unit,
  }) : super(key: key);
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                child: CustomFieldText(
              title: "Quantidade",
              hintText: "Ex: 200",
              suffix: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  unit ?? "",
                  style: AppTextStyles.medium(16),
                ),
              ),
              isNumberType: true,
              onChangeValue: (value) =>
                  context.read<StockCubit>().onChangeState(volume: value),
            )),
          ],
        ),
        BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            return Row(
              children: [
                Flexible(
                  child: CustomFieldText(
                      title: "Data de entrada",
                      hintText: state.date,
                      readOnly: true,
                      onChangeValue: (p0) {},
                      suffix: GestureDetector(
                        onTap: () async {
                          var value = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.input,
                            // initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                          );

                          if (value != null) {
                            context.read<StockCubit>().onChangeState(
                                date: value.toString().split(" ")[0]);
                          }
                        },
                        child: const Icon(Icons.calendar_month),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: CustomFieldText(
                  title: "Hora de entrada",
                  hintText: state.time,
                  readOnly: true,
                  onChangeValue: (p0) {},
                  suffix: GestureDetector(
                      onTap: () async {
                        var selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (selectedTime != null) {
                          context.read<StockCubit>().onChangeState(
                              time: selectedTime.format(context));
                        }
                      },
                      child: const Icon(Icons.access_time_rounded)),
                )),
              ],
            );
          },
        ),
        CustomFieldText(
          title: "Descrição do ocorrido",
          hintText: "",
          onChangeValue: (value) =>
              context.read<StockCubit>().onChangeState(description: value),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomSubmitButton(
            onPressedAction: () => context
                .read<StockCubit>()
                .saveLoss()
                .then((value) => Navigator.pop(context)),
            label: "Adicionar")
      ],
    );
  }
}

class NewStockItem extends StatelessWidget {
  const NewStockItem({
    Key? key,
    required this.isNew,
    this.lastEntrance,
  }) : super(key: key);

  final bool isNew;
  final String? lastEntrance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Adicionar estoque",
          style: AppTextStyles.bold(22),
        ),
        const SizedBox(
          height: 15,
        ),
        if (isNew)
          CustomFieldText(
            title: "Titulo",
            hintText: "Ex.: Batatas",
            onChangeValue: (value) =>
                context.read<StockCubit>().onChangeState(title: value),
          ),
        CustomFieldText(
          title: "Número do documento(opcional)",
          hintText: "",
          isNumberType: true,
          onChangeValue: (value) =>
              context.read<StockCubit>().onChangeState(document: value),
        ),
        Row(
          children: [
            Flexible(
                child: CustomFieldText(
              title: "Quantidade",
              hintText: "Ex: 200",
              isNumberType: true,
              onChangeValue: (value) =>
                  context.read<StockCubit>().onChangeState(volume: value),
            )),
            const SizedBox(
              width: 10,
            ),
            BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                return Flexible(
                    child: CustomFieldDropdown(
                  title: "Medida",
                  readOnly: !isNew,
                  selectedValue: state.unit == "" ? null : state.unit,
                  onChangeValue: (value) =>
                      context.read<StockCubit>().onChangeState(unit: value),
                ));
              },
            ),
          ],
        ),
        BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            return Row(
              children: [
                Flexible(
                  child: CustomFieldText(
                      title: "Data de entrada",
                      hintText: state.date,
                      readOnly: true,
                      onChangeValue: (p0) {},
                      suffix: GestureDetector(
                        onTap: () async {
                          print("object");
                          var value = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.input,
                            // initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                          );

                          if (value != null) {
                            context.read<StockCubit>().onChangeState(
                                date: value.toString().split(" ")[0]);
                          }
                        },
                        child: const Icon(Icons.calendar_month),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: GestureDetector(
                  onTap: () async {
                    var selectedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    if (selectedTime != null) {
                      print(selectedTime);
                    }
                  },
                  child: CustomFieldText(
                    title: "Hora de entrada",
                    hintText: state.time,
                    readOnly: true,
                    onChangeValue: (p0) {},
                    suffix: GestureDetector(
                        onTap: () async {
                          var selectedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (selectedTime != null) {
                            context.read<StockCubit>().onChangeState(
                                time: selectedTime.format(context));
                          }
                        },
                        child: const Icon(Icons.access_time_rounded)),
                  ),
                )),
              ],
            );
          },
        ),
        CustomFieldText(
          title: "Valor",
          hintText: "",
          isNumberType: true,
          onChangeValue: (value) =>
              context.read<StockCubit>().onChangeState(value: value),
        ),
        CustomFieldText(
          title: "Descrição",
          hintText: "",
          onChangeValue: (value) =>
              context.read<StockCubit>().onChangeState(description: value),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomSubmitButton(
            onPressedAction: () => context
                .read<StockCubit>()
                .save(isNew, lastEntranceId: lastEntrance)
                .then((value) => Navigator.pop(context)),
            label: "Adicionar")
      ],
    );
  }
}

class CustomFieldText extends StatelessWidget {
  const CustomFieldText(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.onChangeValue,
      this.readOnly = false,
      this.isNumberType = false,
      this.suffix})
      : super(key: key);

  final String title;
  final Widget? suffix;
  final String hintText;
  final bool readOnly;
  final bool isNumberType;
  final Function(String?) onChangeValue;
  // final
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          title,
          style: AppTextStyles.semiBold(14),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          style: AppTextStyles.light(16, color: const Color(0xff8391A1)),
          autofocus: false,
          readOnly: readOnly,
          onChanged: onChangeValue,
          keyboardType:
              isNumberType ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            fillColor: Colors.black.withOpacity(0.033),
            suffixIcon: suffix,
            filled: true,
            hintStyle:
                AppTextStyles.light(16, color: Colors.black.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.only(left: 17, top: 15, bottom: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}

class CustomFieldDropdown extends StatelessWidget {
  const CustomFieldDropdown(
      {Key? key,
      required this.title,
      required this.selectedValue,
      required this.onChangeValue,
      this.readOnly = false,
      this.suffix})
      : super(key: key);

  final String title;
  final Widget? suffix;
  final String? selectedValue;
  final bool readOnly;
  final Function(String?) onChangeValue;
  // final
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          title,
          style: AppTextStyles.semiBold(14),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.033),
            borderRadius: BorderRadius.circular(10),
          ),
          // padding: const EdgeInsets.only(left: 17, top: 15, bottom: 15),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          child: DropdownButton<String>(
              isExpanded: true,
              focusColor: Colors.grey[100],
              hint: const Text("Selecione"),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: const Color(0xffF7F8F9),
              value: selectedValue,
              underline: Container(),
              items: <String>['L', 'kg', 'g', 'un'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChangeValue),
        ),
      ],
    );
  }
}
