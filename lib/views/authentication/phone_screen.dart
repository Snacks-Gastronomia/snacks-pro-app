import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import './state/auth_cubit.dart';

class RestaurantAuthenticationScreen extends StatelessWidget {
  RestaurantAuthenticationScreen({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomSubmitButton(
                  dark_theme: true,
                  onPressedAction: () async {
                    await auth.signInAnonymously();
                    await context.read<AuthCubit>().sendPhoneCodeOtp(context);
                  },
                  label: "Enviar",
                  loading_label: "Validando...",
                  loading: state.status == AppStatus.loading);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              const Spacer(),
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: SvgPicture.asset("assets/icons/snacks_shadown_dark.svg"),
              ),

              const Spacer(),

              Text('Restaurante?',
                  style: AppTextStyles.semiBold(24, color: Colors.white)),
              const SizedBox(
                height: 5,
              ),
              Text('Digite seu telefone',
                  style: AppTextStyles.regular(14, color: Colors.white70)),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                style: AppTextStyles.regular(16, color: Colors.white),
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                onChanged: BlocProvider.of<AuthCubit>(context).changePhone,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '(##) #####-####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)
                ],
                decoration: InputDecoration(
                  fillColor: Colors.white12,
                  filled: true,
                  hintStyle: AppTextStyles.medium(16,
                      color: const Color(0xff8391A1).withOpacity(0.3)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.white30, width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1)),
                  hintText: '(xx) xxxxx-xxxx',
                ),
              ),
              const Spacer(),

              // SizedBox(
              //   height: 300,
              //   // width: 300,
              //   child: PageView(children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(25.0),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('Digite a senha de segurança',
              //               style: AppTextStyles.semiBold(24,
              //                   color: Colors.white)),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           // Text('Digite o codigo de acesso',
              //           //     style: AppTextStyles.regular(14,
              //           //         color: Colors.white70)),
              //           const SizedBox(
              //             height: 20,
              //           ),
              //           TextFormField(
              //             style: AppTextStyles.medium(16,
              //                 color: Color(0xff8391A1)),
              //             decoration: InputDecoration(
              //               fillColor: Colors.white30,
              //               filled: true,
              //               hintStyle: AppTextStyles.medium(16,
              //                   color: Color(0xff8391A1).withOpacity(0.5)),
              //               enabledBorder: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                   borderSide: const BorderSide(
              //                       color: Colors.white30, width: 1)),
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                   borderSide: const BorderSide(
              //                       color: Colors.white, width: 1)),
              //               hintText: 'xxxxxxx',
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 20,
              //           ),
              //           ElevatedButton(
              //             onPressed: () {},
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(15)),
              //                 primary: Colors.white,
              //                 fixedSize: const Size(double.maxFinite, 59)),
              //             child: Text(
              //               'Entrar',
              //               style: AppTextStyles.regular(16,
              //                   color: Colors.black),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ]),
              // ),
              // PageView(controller: PageController(initialPage: 0), children: [
            ],
          ),
        ),
      ),
    );
  }
}
