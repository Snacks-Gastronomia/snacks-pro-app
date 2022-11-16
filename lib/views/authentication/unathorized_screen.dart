import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class UnathorizedScreen extends StatelessWidget {
  const UnathorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          // color: Colors.black.withOpacity(.8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color(0xffF6F6F6),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(41, 41)),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 19,
                  )),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 150,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Permissão Negada',
                style: AppTextStyles.semiBold(30, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  'Você não tem permissão de acesso, verifique com o seu '
                  'supervisor sobre seu acesso e tente novamente. ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular(16, color: Colors.white70)),
              const Spacer(),
              SvgPicture.asset(
                AppImages.snacks,
                width: 150,
                color: Colors.white30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
