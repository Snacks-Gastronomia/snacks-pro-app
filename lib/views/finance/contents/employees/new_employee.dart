import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class NewEmployeeScreen extends StatelessWidget {
  NewEmployeeScreen({Key? key}) : super(key: key);
  final toast = AppToast();

  final storage = AppStorage();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<EmployeesCubit>(context),
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  toast.init(context: context);

                  var res = await context.read<EmployeesCubit>().saveEmployee();

                  if (res) {
                    navigator.pop();
                  } else {
                    toast.showToast(
                        content:
                            "Não foi possível salvar o funcionário: verifique o número, ele pode já está cadastrado!",
                        type: ToastType.error);
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.black,
                    fixedSize: const Size(double.maxFinite, 59)),
                child: Text(
                  'Salvar',
                  style: AppTextStyles.regular(16, color: Colors.white),
                ),
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
                        onPressed: () {
                          context.read<EmployeesCubit>().clearSelect();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
            backgroundColor: Colors.white,
            body: Builder(builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<EmployeesCubit, EmployeesState>(
                          builder: (context, state) {
                        return Text(
                          state.updateEmp
                              ? "Editar ${state.newEmployee.name}"
                              : 'Novo Funcionário',
                          style: AppTextStyles.semiBold(30),
                        );
                      }),
                      const SizedBox(
                        height: 50,
                      ),
                      //text 8391A1
                      TextFormField(
                        style: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1)),
                        onChanged:
                            BlocProvider.of<EmployeesCubit>(context).changeName,
                        controller: TextEditingController(
                            text: context
                                .read<EmployeesCubit>()
                                .state
                                .newEmployee
                                .name),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF7F8F9),
                          filled: true,
                          hintStyle: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1).withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          hintText: 'Nome',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1)),
                        onChanged: BlocProvider.of<EmployeesCubit>(context)
                            .changePhoneNumber,
                        controller: TextEditingController(
                            text: context
                                .read<EmployeesCubit>()
                                .state
                                .newEmployee
                                .phone_number),
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '(##) #####-####',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy)
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF7F8F9),
                          filled: true,
                          hintStyle: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1).withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          hintText: 'Telefone',
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1)),
                        onChanged: BlocProvider.of<EmployeesCubit>(context)
                            .changeOcupation,
                        controller: TextEditingController(
                            text: context
                                .read<EmployeesCubit>()
                                .state
                                .newEmployee
                                .ocupation),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF7F8F9),
                          filled: true,
                          hintStyle: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1).withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          hintText: 'Ocupação',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1)),
                        onChanged: BlocProvider.of<EmployeesCubit>(context)
                            .changeSalary,
                        textInputAction: TextInputAction.next,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        controller:
                            context.read<EmployeesCubit>().state.updateEmp ==
                                    true
                                ? TextEditingController(
                                    text: context
                                        .read<EmployeesCubit>()
                                        .state
                                        .newEmployee
                                        .salary
                                        .toInt()
                                        .toString())
                                : null,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF7F8F9),
                          filled: true,
                          hintStyle: AppTextStyles.medium(16,
                              color: const Color(0xff8391A1).withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Color(0xffE8ECF4), width: 1)),
                          hintText: 'Salário',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      FutureBuilder(
                          future: storage.getDataStorage("user"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var user = snapshot.data ?? {};
                              var access_level =
                                  user["access_level"].toString().stringToEnum;
                              if (access_level == AppPermission.sadm) {
                                return BlocBuilder<EmployeesCubit,
                                        EmployeesState>(
                                    builder: (context, snapshot) {
                                  List<String> items = [
                                    AppPermission.waiter.displayEnum,
                                    AppPermission.cashier.displayEnum,
                                    AppPermission.employee.displayEnum,
                                    AppPermission.sadm.displayEnum
                                  ];

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xffF7F8F9),
                                      border: const Border.fromBorderSide(
                                          BorderSide(
                                              color: Color(0xffE8ECF4),
                                              width: 1)),
                                    ),
                                    child: DropdownButton<String>(
                                      value: snapshot
                                              .newEmployee.access_level.isEmpty
                                          ? null
                                          : AppPermission.values
                                              .byName(snapshot
                                                  .newEmployee.access_level)
                                              .displayEnum,
                                      hint: Text(
                                        "Permissão",
                                        style: AppTextStyles.regular(16,
                                            color: Colors.black26),
                                      ),
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: AppTextStyles.medium(16,
                                          color: Colors.black54),
                                      isExpanded: true,
                                      itemHeight: 55,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (String? value) => context
                                          .read<EmployeesCubit>()
                                          .changePermission(value),
                                      borderRadius: BorderRadius.circular(15),
                                      items: items
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                });
                              }
                            }
                            return const SizedBox();
                          }),
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
