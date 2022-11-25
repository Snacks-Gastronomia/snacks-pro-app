import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class RatingsContent extends StatelessWidget {
  const RatingsContent({super.key});

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
                  'Avaliações',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Expanded(
                  child: ListRatings(),
                ),
                Container(
                  height: 200,
                  color: Colors.black,
                )
              ],
            )),
      ),
    );
  }
}

class ListRatings extends StatelessWidget {
  const ListRatings({super.key});

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: null,
    //     builder: (context, snapshot) {
    // if (snapshot.hasData) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
              color: Color(0xffE7E7E7),
            ),
        itemCount: 5,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return const CardRate(title: "title", owner: "teste");
        });
    // }
    // return Center(
    //   child: const SizedBox(
    //       height: 70, width: 70, child: CircularProgressIndicator()),
    // );
    // });
  }
}

class CardRate extends StatelessWidget {
  const CardRate({
    Key? key,
    required this.title,
    required this.owner,
    this.icon = Icons.business_outlined,
  }) : super(key: key);
  final String title;
  final String owner;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            'text',
            style: AppTextStyles.semiBold(16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'text',
            style: AppTextStyles.light(12),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Icon(Icons.fa)
            ],
          )
        ],
      ),
    );
    // );
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
