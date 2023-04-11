import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/recharge_card/modal_payment.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_report.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';
import 'package:snacks_pro_app/views/recharge_card/widgets/recharge_success.dart';
import 'package:snacks_pro_app/views/splash/loading_screen.dart';

class RechargeCardScreen extends StatefulWidget {
  const RechargeCardScreen({Key? key}) : super(key: key);

  @override
  State<RechargeCardScreen> createState() => _RechargeCardScreenState();
}

class _RechargeCardScreenState extends State<RechargeCardScreen> {
  final modal = AppModal();
  final fieldFocus = FocusNode();
  late PageController controller;
  final toast = AppToast();
  @override
  void initState() {
    // TODO: implement initState
    controller =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
    toast.init(context: context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  List<String> fields = ["NOME", "CPF", "VALOR"];
  List<FocusNode> focus = [FocusNode(), FocusNode(), FocusNode()];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RechargeCubit, RechargeState>(builder: (context, state) {
      return LoadingPage(
        text: "Recarregando cartão",
        loading: state.status == AppStatus.loading,
        backgroundPage: SafeArea(
          child: Scaffold(
            floatingActionButton: BlocBuilder<RechargeCubit, RechargeState>(
                builder: (context, state) {
              if (state.card_code.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      // mini: true,

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tooltip: "Fechar cartão",
                      onPressed: () =>
                          context.read<RechargeCubit>().closeCard(controller),
                      elevation: 4,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.credit_card_off_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndDocked,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ElevatedButton(
                    //     onPressed: () {},
                    //     style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12)),
                    //         backgroundColor: const Color(0xffF6F6F6),
                    //         padding: EdgeInsets.zero,
                    //         minimumSize: const Size(41, 41)),
                    //     child: const Icon(
                    //       Icons.arrow_back_ios_rounded,
                    //       color: Colors.black,
                    //       size: 19,
                    //     )),
                    Text(
                      'Recharge card',
                      style: AppTextStyles.medium(20),
                    ),
                    IconButton(
                        onPressed: () => modal.showIOSModalBottomSheet(
                              context: context,
                              content: const RechargeReportContent(),
                            ),
                        icon: const Icon(Icons.line_weight))
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        SnacksCardPresentation(
                          controller: controller,
                          toast: toast,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          child: PageView.builder(
                            controller: controller,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fields.length,
                            itemBuilder: (context, index) => TextField(
                                textAlign: TextAlign.center,
                                style: AppTextStyles.medium(30,
                                    color: Colors.black),
                                maxLength:
                                    index == 1 ? 11 : TextField.noMaxLength,
                                keyboardType: index != 0
                                    ? TextInputType.numberWithOptions(
                                        signed: true)
                                    : TextInputType.name,
                                // keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  switch (index) {
                                    case 0:
                                      BlocProvider.of<RechargeCubit>(context)
                                          .changeName(value);
                                      break;
                                    case 1:
                                      BlocProvider.of<RechargeCubit>(context)
                                          .changeCpf(value);
                                      break;
                                    case 2:
                                      BlocProvider.of<RechargeCubit>(context)
                                          .changeValue(value);
                                      break;
                                    default:
                                  }
                                },
                                focusNode: focus[index],
                                decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fields[index],
                                          style: AppTextStyles.medium(30,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      var page = controller.page!.toInt();
                      if (page == 0 &&
                          context.read<RechargeCubit>().state.name.isEmpty) {
                      } else if (page == 1 &&
                          context.read<RechargeCubit>().state.cpf.isEmpty) {
                      } else if (page == 2 &&
                          context.read<RechargeCubit>().state.value == 0) {
                      } else {
                        if (page < fields.length - 1) {
                          focus[page + 1].requestFocus();
                          await controller.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut);
                        } else {
                          AppModal().showModalBottomSheet(
                              withPadding: false,
                              context: context,
                              content: ModalPaymentMethod(
                                next: () async {
                                  Navigator.pop(context);
                                  var cubit = context.read<RechargeCubit>();
                                  var card_code = await Navigator.pushNamed(
                                      context, AppRoutes.scanCard);

                                  if (card_code != null) {
                                    cubit.changeCode(card_code.toString());

                                    if (!mounted) {
                                      return;
                                    }
                                    print(card_code);
                                    if (cubit.state.recharge_id.isEmpty) {
                                      print("create order and recharge");
                                      await cubit
                                          .createOrderAndRecharge(context);
                                    } else {
                                      print("just recharge");
                                      await cubit.rechargeCard();
                                    }
                                    await modal.showModalBottomSheet(
                                        context: context,
                                        content: const RechargeSuccess());
                                    cubit.clear(controller);

                                    focus[page].unfocus();
                                  } else {
                                    toast.showToast(
                                        context: context,
                                        content: "Cartão snacks inválido",
                                        type: ToastType.error);
                                  }
                                },
                              ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // <-- Radius
                      ),
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text(
                      "Proximo",
                      style: AppTextStyles.regular(16, color: Colors.white),
                    )),
                const SizedBox(
                  height: 5,
                )
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: CustomSubmitButton(
                //       onPressedAction: () async => await controller.nextPage(
                //           duration: const Duration(milliseconds: 600),
                //           curve: Curves.easeInOut),
                //       label: "Próximo",
                //       loading_label: "",
                //       loading: false),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class SnacksCardPresentation extends StatelessWidget {
  const SnacksCardPresentation(
      {Key? key, required this.controller, required this.toast})
      : super(key: key);
  final PageController controller;
  final AppToast toast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var cubit = context.read<RechargeCubit>();
        var card_code = await Navigator.pushNamed(context, AppRoutes.scanCard);

        if (card_code != null) {
          await cubit.readCard(card_code.toString(), controller, context);
        }
      },
      onLongPress: () => context.read<RechargeCubit>().clear(controller),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 220,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  AppImages.snacks_logo,
                  height: 60,
                  color: Colors.white,
                ),
              ],
            ),
            BlocBuilder<RechargeCubit, RechargeState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      state.name,
                      style: AppTextStyles.regular(20, color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (state.value != 0)
                      Text(
                        NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                            .format(state.value),
                        style: AppTextStyles.light(18, color: Colors.white70),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
