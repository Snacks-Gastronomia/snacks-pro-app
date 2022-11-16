import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/core/app.routes.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class BankNoInfoModal extends StatelessWidget {
  const BankNoInfoModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Dados bancários',
                  style: AppTextStyles.semiBold(28),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Você ainda não cadastrou seus dados para depósito!',
                style: AppTextStyles.light(14),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.pushNamed(context, AppRoutes.addBankAccount);
                },
                child: Container(
                  height: 135,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withOpacity(.05),
                      border: const Border.fromBorderSide(
                          BorderSide(width: 2, color: Color(0xff28B1EC)))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Color(0xff28B1EC),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Cadastrar dados',
                          style: AppTextStyles.medium(16,
                              color: const Color(0xff28B1EC)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.black,
                    fixedSize: const Size(double.maxFinite, 59)),
                child: Text(
                  'Fechar',
                  style: AppTextStyles.regular(16, color: Colors.white),
                ),
              )
            ],
          ));
    });
  }
}
