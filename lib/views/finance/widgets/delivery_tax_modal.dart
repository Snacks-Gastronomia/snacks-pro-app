import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pinput/pinput.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class DeliveryTax extends StatefulWidget {
  DeliveryTax({
    Key? key,
  }) : super(key: key);

  @override
  State<DeliveryTax> createState() => _DeliveryTaxState();
}

class _DeliveryTaxState extends State<DeliveryTax> {
  final controller = MoneyMaskedTextController(leftSymbol: r'R$ ');
  String doc = "";
  bool active = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FinanceCubit>().fetchFeatureByName('delivery').then((value) {
      var data = value.docs[0];

      setState(() {
        active = data.data()["active"];
        doc = data.id;
      });
      controller.setText(
          ((double.tryParse((data.data()["value"]).toString()) ?? 0) * 10)
              .toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery',
                  style: AppTextStyles.semiBold(20),
                ),
                Transform.scale(
                  scale: 0.75,
                  child: CupertinoSwitch(
                    value: active,
                    activeColor: AppColors.highlight,
                    onChanged: (value) {
                      setState(() {
                        active = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 100,
              child: TextField(
                textInputAction: TextInputAction.done,
                style: AppTextStyles.semiBold(50, color: Colors.black),
                decoration: InputDecoration(
                  filled: false,
                  hintStyle: AppTextStyles.semiBold(50, color: Colors.black26),
                  hintText: r'R$ 0,00',
                  border: InputBorder.none,
                  counterText: "",
                  contentPadding: EdgeInsets.zero,
                ),
                textAlign: TextAlign.center,
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                maxLength: 30,
                controller: controller,
                maxLines: 6,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<FinanceCubit, FinanceHomeState>(
              builder: (context, state) {
                return CustomSubmitButton(
                    onPressedAction: () async {
                      final navigator = Navigator.of(context);
                      await context.read<FinanceCubit>().updateFeature(doc, {
                        "active": active,
                        "value": double.tryParse(controller.text
                            .split(" ")[1]
                            .split(",")[0]
                            .toString())
                      });

                      navigator.pop();
                    },
                    loading: state.status == AppStatus.loading,
                    loading_label: "Salvando",
                    label: "Salvar");
              },
            )
          ],
        ),
      );
    });
  }
}
