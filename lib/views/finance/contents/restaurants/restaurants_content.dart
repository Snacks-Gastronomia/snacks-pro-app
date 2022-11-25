import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class RestaurantsContent extends StatelessWidget {
  const RestaurantsContent({super.key});

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
                  'Restaurantes',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Expanded(
                  child: ListRestaurants(),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.newRestaurant),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    "Adicionar restaurante",
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ListRestaurants extends StatelessWidget {
  const ListRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FinanceCubit>().fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      color: Color(0xffE7E7E7),
                    ),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  return CardRestaurant(
                      editAction: () => context
                          .read<FinanceCubit>()
                          .updateRestaurant(item.id, item.data(), context),
                      removeAction: () => context
                          .read<FinanceCubit>()
                          .deleteRestaurant(item.id),
                      title: item.get("name"),
                      owner: item.get("owner")["name"]);
                });
          }
          return const CustomCircularProgress();
        });
  }
}

class CardRestaurant extends StatelessWidget {
  const CardRestaurant({
    Key? key,
    required this.title,
    required this.owner,
    this.icon = Icons.business_outlined,
    required this.editAction,
    required this.removeAction,
  }) : super(key: key);
  final String title;
  final String owner;
  final IconData? icon;
  final VoidCallback editAction;
  final VoidCallback removeAction;
  @override
  Widget build(BuildContext context) {
    return
        // Slidable(
        //   key: const ValueKey(0),
        //   endActionPane: ActionPane(
        //     motion: const ScrollMotion(),
        //     extentRatio: 0.4,
        //     children: [
        //       CustomSlidableAction(
        //         onPressed: (context) {},
        //         autoClose: true,
        //         flex: 2,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             IconButton(
        //               onPressed: null,
        //               icon: const Icon(
        //                 Icons.edit,
        //                 color: Color(0xff28B1EC),
        //               ),
        //             ),
        //             IconButton(
        //                 onPressed: null,
        //                 icon: const Icon(
        //                   Icons.delete,
        //                   color: Color(0xffE20808),
        //                 ))
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        //   child:

        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color(0xffF0F6F5),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.medium(16),
                ),
                Text(
                  owner,
                  style: AppTextStyles.light(12),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: editAction,
              icon: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: removeAction,
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Color(0xffE20808),
                ))
          ],
        )
      ],
    );
    // );
  }
}
