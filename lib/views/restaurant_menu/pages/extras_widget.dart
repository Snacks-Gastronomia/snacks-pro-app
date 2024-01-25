import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/limit_options.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/new_extra.dart';

class ExtraWidget extends StatefulWidget {
  const ExtraWidget({
    Key? key,
    required this.backAction,
    required this.buttonAction,
  }) : super(key: key);
  final VoidCallback backAction;
  final VoidCallback buttonAction;

  @override
  State<ExtraWidget> createState() => _ExtraWidgetState();
}

class _ExtraWidgetState extends State<ExtraWidget> {
  bool checkLimit = false;
  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:
              BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
            return CustomSubmitButton(
              onPressedAction: () {
                if (checkLimit) {
                  context
                      .read<MenuCubit>()
                      .changeLimitOptions(state.item.options.length);

                  modal.showModalBottomSheet(
                      withPadding: false,
                      context: context,
                      content: LimitOptionsModal(
                        submit: () {
                          widget.buttonAction();
                        },
                      ));
                } else {
                  widget.buttonAction();
                }
              },
              label: state.status == AppStatus.editing
                  ? "Salvar alterações"
                  : "Salvar",
              loading: state.status == AppStatus.loading,
              loading_label: "Salvando...",
            );
          }),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Extras',
                style: AppTextStyles.medium(18),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
                if (state.item.extras.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "Itens extras ou opcionais não adicionados.",
                        style: AppTextStyles.regular(14),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.item.extras.length,
                      itemBuilder: (context, index) => CardExtra(
                          title: state.item.extras[index]["title"],
                          value:
                              double.parse(state.item.extras[index]["value"]),
                          onDelete: () {
                            context.read<MenuCubit>().removeExtraItem(
                                state.item.extras[index]["id"]);
                          }),
                    ),
                  );
                }
              }),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SizedBox(
                  height: 42,
                  child: DottedBorder(
                      color: const Color(0xff278EFF),
                      strokeWidth: 1.5,
                      dashPattern: const [7, 4],
                      borderType: BorderType.RRect,
                      padding: EdgeInsets.zero,
                      radius: const Radius.circular(10),
                      child: TextButton(
                          onPressed: () => modal.showModalBottomSheet(
                              withPadding: false,
                              context: context,
                              content: NewExtraModal()),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(250, 45)),
                          child: Text(
                            "Novo item extra",
                            style: AppTextStyles.medium(14,
                                color: const Color(0xff278EFF)),
                          ))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CheckboxListTile(
                value: checkLimit,
                contentPadding: EdgeInsets.zero,
                checkboxShape: const StadiumBorder(),
                onChanged: (value) {
                  setState(() {
                    checkLimit = value!;
                  });
                },
                checkColor: Colors.white,
                activeColor: Colors.black,
                title: Text(
                  'Limitar número de opções',
                  style: AppTextStyles.regular(15),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}

class CardExtra extends StatelessWidget {
  const CardExtra({
    Key? key,
    required this.title,
    required this.value,
    required this.onDelete,
  }) : super(key: key);

  final String title;
  final double value;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(.05)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  title,
                  style: AppTextStyles.semiBold(16),
                ),
              ),
              Text(
                NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                    .format(value),
                style: AppTextStyles.regular(13),
              ),
            ],
          ),
          IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
