import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class RatingsContent extends StatelessWidget {
  RatingsContent({super.key});
  final List<String> questions = [
    "Você indicaria o Snacks para um amigo? 0-10",
    "O que você achou da usabilidade do nosso aplicativo? 5-10",
    "O quanto você está satisfeito, em termos gerais, com a nossa empresa?"
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: UniqueKey(),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text(
                  'Feedbacks',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Expanded(
                  child: ListRatings(),
                ),
                Column(children: [
                  SizedBox(
                    height: 100,
                    child: PageView(
                      controller: PageController(
                        initialPage: 0,
                      ),
                      onPageChanged: (value) {
                        context.read<FinanceCubit>().changeCarouselIndex(value);
                      },
                      children: questions
                          .map<Widget>((e) => Center(
                                child: Text(
                                  e,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.medium(16),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: BlocBuilder<FinanceCubit, FinanceHomeState>(
                        builder: (context, state) {
                      return Center(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 5,
                                ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return state.questions_carousel_index != index
                                  ? Icon(
                                      Icons.brightness_1,
                                      color: Colors.grey.shade300,
                                      size: 10,
                                    )
                                  : Container(
                                      // height: 10,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: getColor(index + 1),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    );
                            },
                            itemCount: questions.length),
                      );
                    }),
                  )
                ])
              ],
            )),
      ),
    );
  }

  Color getColor(int value) {
    switch (value) {
      case 1:
        return Colors.black;
      case 2:
        return const Color(0xff278EFF);
      case 3:
        return const Color(0xffF46363);
      default:
        return Colors.black;
    }
  }
}

class ListRatings extends StatelessWidget {
  const ListRatings({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<FinanceCubit>().fetchFeedbacks(),
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
                  return CardRate(
                    title: "",
                    description: item.data()["observations"],
                    questions: item.data()["questions"],
                  );
                });
          }
          return const CustomCircularProgress();
        });
  }
}

class CardRate extends StatelessWidget {
  const CardRate({
    Key? key,
    required this.title,
    required this.description,
    required this.questions,
    this.icon = Icons.business_outlined,
  }) : super(key: key);
  final String title;
  final String description;
  final List questions;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF0F6F5).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.semiBold(16),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              description.isEmpty ? "Não deixou comentários" : description,
              style: AppTextStyles.light(14,
                  color: description.isEmpty
                      ? Colors.grey.shade400
                      : Colors.black),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < questions.length; i++)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: getColor(i + 1)),
                  child: Text(
                    questions[i]["rate"],
                    style: AppTextStyles.medium(14, color: Colors.white),
                  ),
                )
              // getIconFeedback(i + 1, questions[i]["rate"]),
            ],
          )
        ],
      ),
    );
    // );
  }

  // Widget getIconFeedback(question, value) {
  //   switch (value) {
  //     case 0:
  //       return Column(
  //         children: [
  //           Icon(
  //             Icons.sentiment_dissatisfied_rounded,
  //             color: getColor(question),
  //             size: 45,
  //           ),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           Text(
  //             "Insastisfeito",
  //             style: AppTextStyles.light(10),
  //           )
  //         ],
  //       );
  //     case 1:
  //       return Column(
  //         children: [
  //           Icon(
  //             Icons.sentiment_neutral_rounded,
  //             color: getColor(question),
  //             size: 40,
  //           ),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           Text("Suficiente", style: AppTextStyles.light(10))
  //         ],
  //       );
  //     case 2:
  //       return Column(
  //         children: [
  //           Icon(
  //             Icons.sentiment_satisfied_rounded,
  //             size: 40,
  //             color: getColor(question),
  //           ),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           Text("Satisfeito", style: AppTextStyles.light(10))
  //         ],
  //       );

  //     default:
  //       return Column(
  //         children: [
  //           Icon(
  //             Icons.sentiment_very_satisfied_rounded,
  //             color: getColor(question),
  //             size: 40,
  //           ),
  //           const SizedBox(
  //             height: 5,
  //           ),
  //           Text("Muito Satisfeito", style: AppTextStyles.light(10))
  //         ],
  //       );
  //   }
  // }

  Color getColor(int value) {
    switch (value) {
      case 1:
        return Colors.black;
      case 2:
        return const Color(0xff278EFF);
      case 3:
        return const Color(0xffF46363);
      default:
        return Colors.black;
    }
  }
}
