import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/services/beerpass_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/item_screen.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/card_item.dart';
import 'package:snacks_pro_app/views/home/widgets/skeletons.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late ScrollController controller;
  final storage = AppStorage();
  @override
  void initState() {
    controller = ScrollController();
    context.read<HomeCubit>().fetchItems();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller.addListener(
      () {
        // if (controller.position.maxScrollExtent == controller.offset &&
        //     context.read<HomeCubit>().state.status == AppStatus.loaded) {
        //   context.read<HomeCubit>().fetchItems();
        // }
      },
    );
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  late NavigatorState _navigator;

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    // final access_level = context
    //     .read<HomeCubit>()
    //     .state
    //     .storage["access_level"]
    //     .toString()
    //     .stringToEnum;
    var getStorage = storage.getDataStorage("user");

    return FutureBuilder(
        future: getStorage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data ?? {};
            var access_level = user["access_level"].toString().stringToEnum;
            return Scaffold(
              floatingActionButton: (access_level == AppPermission.radm ||
                      access_level == AppPermission.employee)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.newItem),
                        child: const Icon(Icons.plus_one),
                      ),
                    )
                  : null,
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  // color: Colors.black.withOpacity(.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(
                        AppImages.snacks,
                        width: 140,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
                child: SingleChildScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const TopWidget(),
                      const SizedBox(
                        height: 45,
                      ),
                      TextFormField(
                        style: AppTextStyles.light(16,
                            color: const Color(0xff8391A1)),
                        autofocus: false,
                        onChanged: context.read<HomeCubit>().fetchQuery,
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(0.033),
                          filled: true,
                          hintStyle: AppTextStyles.light(16,
                              color: Colors.black.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.only(
                              left: 17, top: 15, bottom: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          suffixIcon: const Icon(Icons.search),
                          hintText: 'Pesquise um item',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // PopularItemsWidget(ns: _navigator),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      Text(
                        'Cardápio',
                        style: AppTextStyles.medium(18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AllItemsWidget(
                        ns: _navigator,
                        access_level: access_level,
                        // controller: controller,
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return const CustomCircularProgress();
        });
  }
}

class AllItemsWidget extends StatelessWidget {
  AllItemsWidget({
    Key? key,
    required this.access_level,
    required this.ns,
  }) : super(key: key);
  final AppPermission access_level;
  final NavigatorState ns;
  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return StreamBuilder<QuerySnapshot>(
        stream: state.menu,
        builder: (context, snapshot) {
          if (snapshot.hasData && (snapshot.data?.docs ?? []).isNotEmpty) {
            final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: isTablet ? 230 : 160),
                shrinkWrap: true,
                cacheExtent: 100,
                addAutomaticKeepAlives: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length +
                    (!context.watch<HomeCubit>().state.listIsLastPage &&
                            context.watch<HomeCubit>().state.status ==
                                AppStatus.loading
                        ? 4
                        : 0),
                itemBuilder: (BuildContext ctx, index) {
                  return BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                    // }
                    var data = state.menu;

                    if (docs.isNotEmpty && index < docs.length) {
                      var item = Item.fromJson(jsonEncode(docs[index].data()));
                      var id = docs[index].id;
                      item = item.copyWith(id: id);
                      return GestureDetector(
                          onTap: () => modal.showIOSModalBottomSheet(
                              context: context,
                              content: ItemScreen(
                                  permission: access_level,
                                  order: OrderModel(
                                      item: item,
                                      observations: "",
                                      option_selected: {}))),
                          child: CardItemWidget(
                            // ns: ns,
                            permission: access_level,
                            item: item,
                          ));
                    }

                    return const ListSkeletons(direction: Axis.horizontal);
                  });
                });
          }
          return const Center(child: Text("Cardapio vazio"));
        },
      );
    });
  }
}

// class AllItemsWidget extends StatelessWidget {
//   AllItemsWidget({
//     Key? key,
//     required this.access_level,
//     required this.ns,
//   }) : super(key: key);
//   final AppPermission access_level;
//   final NavigatorState ns;
//   final modal = AppModal();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (context, state) {
//         // if (state.status == AppStatus.loading) {
//         //   return const ListSkeletons(direction: Axis.vertical);
//         // }
//         var data = state.menu;

//         if (data.isNotEmpty) {
//           if (state.status == AppStatus.loading) {
//             return const ListSkeletons(direction: Axis.horizontal);
//           } else {
//             return GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     mainAxisExtent: 160),
//                 shrinkWrap: true,
//                 cacheExtent: 100,
//                 addAutomaticKeepAlives: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: data.length,
//                 // itemCount: data.length,
//                 // controller: controller,
//                 itemBuilder: (BuildContext ctx, index) {
//                   // if (data.length <= index && state.listIsLastPage) {
//                   //   return Transform.scale(
//                   //       scale: 0.9, child: const CardSkeleton());
//                   // } else {
//                   // if (ctx.) print("loading more");

//                   var item = Item.fromMap(data[index]);
//                   var id = data[index]["id"];
//                   item = item.copyWith(id: id);
//                   return GestureDetector(
//                       onTap: () => modal.showIOSModalBottomSheet(
//                           context: context,
//                           content: ItemScreen(
//                               permission: access_level,
//                               order: OrderModel(item: item, observations: ""))),
//                       child: CardItemWidget(
//                         // ns: ns,
//                         permission: access_level,
//                         item: item,
//                       ));

//                   // }
//                 });
//           }
//         }
//         return const Center(
//           child: Text("Cardapio vazio"),
//         );
//       },
//     );
//   }
// }

// class PopularItemsWidget extends StatelessWidget {
//   const PopularItemsWidget({
//     Key? key,
//     required this.ns,
//   }) : super(key: key);
//   final NavigatorState ns;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
//       if (snapshot.status == AppStatus.loading) {
//         return const ListSkeletons(direction: Axis.horizontal);
//       }
//       if (snapshot.popular.isNotEmpty) {
//         return Column(
//           children: [
//             Text(
//               'Itens populares',
//               style: AppTextStyles.medium(18),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             SizedBox(
//               height: 155,
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 separatorBuilder: (context, index) => const SizedBox(
//                   width: 10,
//                 ),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: snapshot.popular.length, //alterado sem teste
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   var item = snapshot.popular[index];
//                   return SizedBox(
//                       width: 165,
//                       child: GestureDetector(
//                           onTap: () => AppModal().showIOSModalBottomSheet(
//                               context: context,
//                               expand: true,
//                               content: ItemScreen(
//                                   order: OrderModel(
//                                       item: item, observations: ""))),
//                           child: CardItemWidget(
//                             // ns: ns,
//                             item: item,
//                           )));
//                 },
//               ),
//             ),
//           ],
//         );
//       }
//       return const SizedBox();
//     });
//   }
// }

class TopWidget extends StatelessWidget {
  const TopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.rotate(
              angle: -90 * pi / 180,

              // decoration: BoxDecoration(
              //     color: Colors.amber, borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.asset(
                AppImages.snacks_logo,
                color: Colors.grey.shade400,
                height: 35,
                width: 35,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            FutureBuilder(
                future:
                    context.read<HomeCubit>().storage.getDataStorage("user"),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return SizedBox(
                      width: 140,
                      child: Text(
                        snap.data!["restaurant"]["name"],
                        style: AppTextStyles.medium(22),
                        maxLines: 2,
                      ),
                    );
                  }
                  return const SizedBox();
                }),
          ],
        ),

        IconButton(onPressed: () {}, icon: Icon(Icons.info_rounded))
        // GestureDetector(
        //   onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
        //   child: Stack(
        //     children: [
        //       SvgPicture.asset(
        //         AppImages.shopping_bag,
        //         // width: 30,
        //         height: 35,
        //         color: AppColors.highlight,
        //       ),
        //       BlocBuilder<CartCubit, CartState>(
        //         builder: (context, state) {
        //           return Positioned(
        //             top: 3,
        //             right: 0,
        //             child: Container(
        //               // padding: const EdgeInsets.all(5),
        //               height: 20,
        //               width: 20,
        //               decoration: BoxDecoration(
        //                   color: AppColors.highlight,
        //                   border: const Border.fromBorderSide(
        //                       BorderSide(color: Colors.white, width: 1)),
        //                   shape: BoxShape.circle),
        //               child: Center(
        //                 child: Text(
        //                   context
        //                       .read<CartCubit>()
        //                       .state
        //                       .cart
        //                       .length
        //                       .toString(),
        //                   style: AppTextStyles.medium(12, color: Colors.white),
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}
