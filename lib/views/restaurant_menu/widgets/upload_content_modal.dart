import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class UploadContentModal extends StatelessWidget {
  const UploadContentModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    compressImage(File file) async {
      final filePath = file.absolute.path;

      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
      );
      if (result != null) {
        return result.path;
      } else {
        return ("Compress image is not possible");
      }
    }

    _getFromGallery() async {
      Navigator.pop(context);

      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        return compressImage(File(pickedFile.path));
      }
    }

    _getFromCamera() async {
      Navigator.pop(context);
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        return compressImage(File(pickedFile.path));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CardUpload(
              action: () async {
                var cubit = BlocProvider.of<MenuCubit>(context);
                final path = await _getFromGallery();
                cubit.changeImage(path);
              },
              icon: Icons.image_rounded,
              title: "Galeria",
              description: "Carregue uma imagem"),
          CardUpload(
              action: () async {
                var cubit = BlocProvider.of<MenuCubit>(context);
                final path = await _getFromCamera();
                cubit.changeImage(path);
              },
              icon: Icons.photo_camera,
              title: "Camera",
              description: "Capture uma foto")
        ],
      ),
    );
  }
}

class CardUpload extends StatelessWidget {
  const CardUpload({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: const Border.fromBorderSide(
                BorderSide(width: 1, color: Colors.black87))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: AppTextStyles.medium(22),
            ),
            Text(
              description,
              style: AppTextStyles.medium(13, color: Colors.black38),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
