import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class EmployeesContentWidget extends StatelessWidget {
  const EmployeesContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: UniqueKey(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BlocBuilder<EmployeesCubit, EmployeesState>(
              builder: (context, state) {
            return Column(
              children: [
                Text(
                  'Funcionários',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.regular(18,
                              color: Colors.grey.shade400),
                        ),
                        Text(
                          state.amount.toString(),
                          style: AppTextStyles.bold(32, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Despesa',
                          style: AppTextStyles.regular(18,
                              color: Colors.grey.shade400),
                        ),
                        Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(state.expenses),
                          style: AppTextStyles.bold(32, color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Expanded(
                  child: ListEmployees(),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.newEmployee),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    "Adicionar funcionários",
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ListEmployees extends StatelessWidget {
  const ListEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    var data = context.read<HomeCubit>().state.storage;
    print(data);
    return StreamBuilder(
        stream: context
            .read<EmployeesCubit>()
            .fetchData(data["uid"], data["restaurant"]["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<EmployeesCubit>().convertData(snapshot.data!);
            print("calling again");
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xffE7E7E7),
              ),
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return BlocBuilder<EmployeesCubit, EmployeesState>(
                    builder: (context, state) {
                  var emp = state.employees[index];
                  return Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.4,
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) {},
                            autoClose: true,
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => context
                                      .read<EmployeesCubit>()
                                      .selectToUpdate(emp, context),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xff28B1EC),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => context
                                        .read<EmployeesCubit>()
                                        .deleteEmployee(emp.id!),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xffE20808),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 70,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            emp.name,
                            style:
                                AppTextStyles.semiBold(18, color: Colors.black),
                          ),
                          subtitle: Text(
                            '${emp.ocupation} - ${NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(emp.salary)}',
                            style: AppTextStyles.light(13,
                                color: const Color(0xffB3B3B3)),
                          ),
                          trailing: Transform.scale(
                            scale: 0.75,
                            child: CupertinoSwitch(
                              value: emp.access,
                              activeColor: AppColors.highlight,
                              onChanged: (value) => context
                                  .read<EmployeesCubit>()
                                  .disableEmployee(value, emp.id!),
                            ),
                          ),
                        ),
                      ));
                });
              },
            );
          }
          return const CustomCircularProgress();
        });
  }
}
