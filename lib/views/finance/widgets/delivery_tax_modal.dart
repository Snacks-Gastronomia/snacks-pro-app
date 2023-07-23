import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final controller = TextEditingController();
  String doc = "";
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<FinanceCubit>().fetchFeatureByName('delivery'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data?.docs[0];
            setState(() {
              active = data?.data()["active"];
              doc = data?.id ?? "";
              controller.setText((data?.data()["value"]).toString());
              //value = ;
            });
            return Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery',
                        style: AppTextStyles.medium(18),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: active,
                          activeColor: AppColors.highlight,
                          onChanged: (value) {
                            setState(() {
                              active = !active;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: AppTextStyles.semiBold(60, color: Colors.black),
                    controller: controller,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      //fillColor: const Color(0xffF7F8F9),
                      filled: false,
                      hintStyle: AppTextStyles.semiBold(60,
                          color: const Color(0xff8391A1).withOpacity(0.5)),
                      enabledBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xffE8ECF4), width: 1)),
                      hintText: 'Ex.: R\$ 7,00',
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<FinanceCubit, FinanceHomeState>(
                    builder: (context, state) {
                      return CustomSubmitButton(
                          onPressedAction: () async {
                            final navigator = Navigator.of(context);
                            await context.read<FinanceCubit>().updateFeature(
                                doc,
                                {"active": active, "value": controller.text});

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
          }
          return const CustomCircularProgress();
        });
  }
}
