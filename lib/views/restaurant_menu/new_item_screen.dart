import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/restaurant_menu/add_item_widget.dart';
import 'package:snacks_pro_app/views/restaurant_menu/extras_widget.dart';
import 'package:snacks_pro_app/views/restaurant_menu/item_details_widget.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/stock_control_widget.dart';
import 'package:snacks_pro_app/views/restaurant_menu/upload_image.dart';

class NewItemScreen extends StatelessWidget {
  NewItemScreen({Key? key}) : super(key: key);
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<MenuCubit>().clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xffF6F6F6),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(41, 41)),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 19,
                    )),
                const SizedBox(
                  width: 15,
                  // height: 41,
                ),
                Text(
                  'Adicionar item',
                  style: AppTextStyles.medium(20),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: true,
          allowImplicitScrolling: false,
          scrollDirection: Axis.vertical,
          controller: pageController,

          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: UploadImageWidget(
                  buttonAction: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AddItemWidget(
                  buttonAction: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut),
                  backAction: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut)),
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ItemDetailsWidget(
                    buttonAction: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                    backAction: () => pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ExtraWidget(
                  buttonAction: () =>
                      context.read<MenuCubit>().saveItem(context),
                  backAction: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut)),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: StockControlWidget(
            //       buttonAction: () =>
            //           BlocProvider.of<MenuCubit>(context).createItem()),
            // )
          ],

          // Padding(padding: const EdgeInsets.all(25), child: AddItemWidget()
          // ItemDetailsWidget()
          // StockControlWidget()
          // ),
        ),
      ),
    );
  }
}
