import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/printer/new_printer.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class FeaturesContent extends StatelessWidget {
  const FeaturesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        // stream: null,
        value: BlocProvider.of<FinanceCubit>(context),
        child: SafeArea(
          child: Scaffold(
            key: UniqueKey(),
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Funcionalidades',
                      style: AppTextStyles.semiBold(22),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Expanded(
                      child: ListFeatures(),
                    ),
                  ],
                )),
          ),
        ));
  }
}

class ListFeatures extends StatelessWidget {
  const ListFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FinanceCubit>().fetchFeatures(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];

                  bool active = item.data()["active"];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.data()["title"],
                        style: AppTextStyles.semiBold(16),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: active,
                          activeColor: AppColors.highlight,
                          onChanged: (value) => context
                              .read<FinanceCubit>()
                              .changeFeatureValue(item.id, !active),
                        ),
                      ),
                    ],
                  );
                });
          }
          return const CustomCircularProgress();
        });
  }
}
