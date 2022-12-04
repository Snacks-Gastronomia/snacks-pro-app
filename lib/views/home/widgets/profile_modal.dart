import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class ProfileModal extends StatelessWidget {
  ProfileModal(
      {Key? key,
      required this.name,
      required this.phone,
      required this.ocupation})
      : super(key: key);
  final String name;
  final String phone;
  final String ocupation;

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.black, Colors.black54])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppImages.snacks_logo,
                height: 30,
                width: 30,
                color: Colors.white30,
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            name,
            style: AppTextStyles.bold(32, color: Colors.white),
          ),
          Text(
            phone,
            style: AppTextStyles.regular(16, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                ocupation,
                style: AppTextStyles.light(17, color: Colors.white),
              ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //   ],
            // ),
          ),
          // const Center(
          //   child: Icon(
          //     Icons.f,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white12,
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async =>
                  context.read<AuthCubit>().appSingOut(context),
              icon: const Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
              ),
              label: Text(
                "Sair",
                style: AppTextStyles.light(18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
