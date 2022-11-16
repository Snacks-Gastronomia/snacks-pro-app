import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/authentication/state/auth_cubit.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomSubmitButton(
                  dark_theme: true,
                  onPressedAction: () async =>
                      context.read<AuthCubit>().authenticateUser(context),
                  label: state.firstAccess ? "Salvar" : "Entrar",
                  loading_label: "Salvando dados..",
                  loading: state.status == AppStatus.loading);
            },
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        // primary: Colors.white,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(41, 41)),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 19,
                    )),
                SvgPicture.asset(
                  "assets/icons/snacks_logo.svg",
                  height: 30,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Senha de segurança',
                  style: AppTextStyles.semiBold(30, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Digite e confirme uma senha para autenticação, contendo no mínimo 6 caracteres.',
                  style: AppTextStyles.regular(16, color: Colors.white70),
                ),
                const SizedBox(
                  height: 40,
                ),
                //text 8391A1
                Column(
                  children: [
                    InputPassword(
                        hint: "Senha",
                        validator: (value) =>
                            context.read<AuthCubit>().validatePassLength(value),
                        onChange:
                            BlocProvider.of<AuthCubit>(context).changePassword),
                    const SizedBox(height: 20),
                    if (context.read<AuthCubit>().state.firstAccess)
                      InputPassword(
                          hint: "Confirme a senha",
                          validator: (value) => context
                              .read<AuthCubit>()
                              .validatePassEquals(value),
                          buttonAction: TextInputAction.done,
                          onChange: BlocProvider.of<AuthCubit>(context)
                              .changeCofirmPassword)
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({
    Key? key,
    this.errorText,
    required this.hint,
    this.buttonAction,
    this.onChange,
    required this.validator,
  }) : super(key: key);

  final String? errorText;
  final String hint;
  final TextInputAction? buttonAction;
  final Function(String)? onChange;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: onChange,
          obscureText: state.obscure_pass,
          textInputAction: buttonAction ?? TextInputAction.next,
          style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            fillColor: Colors.white12,
            filled: true,
            hintStyle: AppTextStyles.medium(16,
                color: const Color(0xff8391A1).withOpacity(0.3)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30, width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 1)),
            suffixIcon: GestureDetector(
              onTap: () => context.read<AuthCubit>().changeObscurePassword(),
              child: Icon(
                state.obscure_pass
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                // color: Colors.grey,
              ),
            ),
            hintText: hint,
          ),
        );
      },
    );
  }
}
