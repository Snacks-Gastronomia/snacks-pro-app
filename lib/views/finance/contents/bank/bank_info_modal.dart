import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/core/app.routes.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/bank_model.dart';

class BankInfoModal extends StatelessWidget {
  const BankInfoModal({
    Key? key,
    required this.data,
  }) : super(key: key);

  final BankModel data;

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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text('Titular', style: AppTextStyles.regular(17)),
                  Text(data.owner,
                      style: AppTextStyles.regular(16,
                          color: Colors.grey.shade400)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Banco', style: AppTextStyles.regular(17)),
                  Text(data.bank,
                      style: AppTextStyles.regular(16,
                          color: Colors.grey.shade400)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Conta corrente', style: AppTextStyles.regular(17)),
                      Text(data.account,
                          style: AppTextStyles.regular(16,
                              color: Colors.grey.shade400)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agência', style: AppTextStyles.regular(17)),
                      Text(data.agency.toString(),
                          style: AppTextStyles.regular(16,
                              color: Colors.grey.shade400)),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  TextButton.icon(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xff28B1EC),
                      size: 16,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.addBankAccount);
                    },
                    label: Text("Editar",
                        style: AppTextStyles.regular(16,
                            color: Color(0xff28B1EC))),
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
                  ),
                ],
              )
            ],
          ));
    });
  }
}
