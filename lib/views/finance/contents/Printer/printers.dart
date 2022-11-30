import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/Printer/new_printer.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class PrinterContent extends StatelessWidget {
  const PrinterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        // stream: null,
        value: BlocProvider.of<FinanceCubit>(context),
        child: SafeArea(
          child: Scaffold(
            key: UniqueKey(),
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
              child: CustomSubmitButton(
                  onPressedAction: () => AppModal().showModalBottomSheet(
                      withPadding: false,
                      context: context,
                      content: const NewPrinterContent()),
                  label: "Adicionar impressora"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Impressoras',
                      style: AppTextStyles.semiBold(22),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Expanded(
                      child: ListPrinters(),
                    ),
                    // Column(children: [
                    //   SizedBox(
                    //     height: 100,
                    //     child: PageView(
                    //       controller: PageController(
                    //         initialPage: 0,
                    //       ),
                    //       onPageChanged: (value) {
                    //         context.read<FinanceCubit>().changeCarouselIndex(value);
                    //       },
                    //       children: questions
                    //           .map<Widget>((e) => Center(
                    //                 child: Text(
                    //                   e,
                    //                   textAlign: TextAlign.center,
                    //                   style: AppTextStyles.medium(16),
                    //                 ),
                    //               ))
                    //           .toList(),
                    //     ),
                    //   ),
                    //   SizedBox(
                    //     height: 10,
                    //     child: BlocBuilder<FinanceCubit, FinanceHomeState>(
                    //         builder: (context, state) {
                    //       return Center(
                    //         child: ListView.separated(
                    //             scrollDirection: Axis.horizontal,
                    //             separatorBuilder: (context, index) =>
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //             shrinkWrap: true,
                    //             itemBuilder: (context, index) {
                    //               return state.questions_carousel_index != index
                    //                   ? Icon(
                    //                       Icons.brightness_1,
                    //                       color: Colors.grey.shade300,
                    //                       size: 10,
                    //                     )
                    //                   : Container(
                    //                       // height: 10,
                    //                       width: 30,
                    //                       decoration: BoxDecoration(
                    //                           color: getColor(index + 1),
                    //                           borderRadius:
                    //                               BorderRadius.circular(15)),
                    //                     );
                    //             },
                    //             itemCount: questions.length),
                    //       );
                    //     }),
                    //   )
                    // ])
                  ],
                )),
          ),
        ));
  }
}

class ListPrinters extends StatelessWidget {
  const ListPrinters({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FinanceCubit>().fetchPrinters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  print(snapshot.data!.docs[index].data());
                  return CardPrinter(
                    title: '${item.get("name")} - ${item.get("goal")}',
                    onDelete: () =>
                        context.read<FinanceCubit>().deletePrinter(item.id),
                    onEdit: () {
                      context
                          .read<FinanceCubit>()
                          .updatePrinter(null, item.id, item.data());
                      AppModal().showModalBottomSheet(
                          withPadding: false,
                          context: context,
                          content: const NewPrinterContent());
                    },
                    subtitle: item.get("ip"),
                  );
                });
          }
          return const CustomCircularProgress();
        });
  }
}

class CardPrinter extends StatelessWidget {
  const CardPrinter({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          CustomSlidableAction(
            onPressed: (context) {},
            autoClose: true,
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //     onPressed: null,
                //     icon: Icon(
                //       Icons.delete,
                //       color: Color(0xffE20808),
                //     ))

                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    "Excluir",
                    style: AppTextStyles.light(14, color: Color(0xffE20808)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffF0F6F5).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.print_outlined,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.semiBold(18),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.light(14),
                      ),
                    ],
                  )
                ],
              ),
              IconButton(onPressed: onEdit, icon: const Icon(Icons.settings))
            ],
          )),
    );
    // );
  }
}
