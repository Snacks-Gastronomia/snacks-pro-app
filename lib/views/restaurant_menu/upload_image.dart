import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/upload_content_modal.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({
    Key? key,
    required this.buttonAction,
  }) : super(key: key);
  final VoidCallback buttonAction;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          'Adicone uma imagem ao item',
          style: AppTextStyles.medium(18),
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<MenuCubit, MenuState>(builder: (context, snapshot) {
          return Center(
            child: snapshot.item.image_url == null ||
                    snapshot.item.image_url!.isEmpty
                ? DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: const [7, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: ElevatedButton(
                        onPressed: () => AppModal().showModalBottomSheet(
                            context: context,
                            content: const UploadContentModal()),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: const Color(0xff979797),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            fixedSize: const Size(150, 150),
                            elevation: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_rounded,
                              size: 60,
                              color: AppColors.highlight,
                            ),
                            const Text(
                              'Clique aqui para carregar',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  )
                : Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Image.file(File(snapshot.item.image_url!),
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<MenuCubit>().removeImage(),
                        child: Text(
                          "Remover",
                          style: AppTextStyles.regular(16,
                              color: Colors.red.shade600),
                        ),
                      ),
                    ],
                  ),
          );
        }),
        const Spacer(),
        ElevatedButton(
          onPressed: buttonAction,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              primary: Colors.black,
              fixedSize: const Size(double.maxFinite, 59)),
          child: Text(
            'Continuar',
            style: AppTextStyles.regular(16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
