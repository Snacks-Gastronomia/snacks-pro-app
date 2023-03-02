import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<FinanceCubit>(context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Text('Horário de funcionamento',
                  style: AppTextStyles.semiBold(22)),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: context.read<FinanceCubit>().fetchSchedule(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // print(snapshot.data!.docs.length);

                        var days = snapshot.data!.docs;

                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 20,
                                ),
                            itemCount: DateFormat().dateSymbols.WEEKDAYS.length,
                            itemBuilder: (context, index) {
                              var day = DateFormat(null, "pt_BR")
                                  .dateSymbols
                                  .SHORTWEEKDAYS[index];
                              DateTime dateTimeStart = DateFormat("HH:mm")
                                  .parse(days[index].data()["start"]);
                              DateTime dateTimeEnd = DateFormat("HH:mm")
                                  .parse(days[index].data()["end"]);

                              return ScheduleDay(
                                active: days[index].data()["active"],
                                day: toBeginningOfSentenceCase(day) ?? "",
                                startHour: days[index].data()["start"],
                                endHour: days[index].data()["end"],
                                changeStatus: (value) => context
                                    .read<FinanceCubit>()
                                    .changeActiveSchedule(
                                        day: index, value: value!),
                                actionStart: () async {
                                  var cubit = context.read<FinanceCubit>();
                                  var time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: dateTimeStart.hour,
                                        minute: dateTimeStart.minute),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    DateTime submitTime = DateFormat("hh:mm a")
                                        .parse(time.format(
                                            context)); // think this will work better for you
// format date

                                    cubit.changeStartTime(
                                        day: index,
                                        value: DateFormat("HH:mm")
                                            .format(submitTime));
                                  }
                                },
                                actionEnd: () async {
                                  var cubit = context.read<FinanceCubit>();

                                  var time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: dateTimeEnd.hour,
                                        minute: dateTimeEnd.minute),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    DateTime submitTime = DateFormat("hh:mm")
                                        .parse(time.format(
                                            context)); // think this will work better for you
// format date

                                    cubit.changeEndTime(
                                        day: index,
                                        value: DateFormat("HH:mm")
                                            .format(submitTime));
                                  }
                                },
                              );
                            });
                      }
                      return const CustomCircularProgress();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleDay extends StatelessWidget {
  const ScheduleDay({
    Key? key,
    required this.active,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.changeStatus,
    required this.actionStart,
    required this.actionEnd,
  }) : super(key: key);
  final bool active;
  final String day;
  final String startHour;
  final String endHour;
  final Function(bool?)? changeStatus;
  final VoidCallback actionStart;
  final VoidCallback actionEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Checkbox(
            value: active,
            onChanged: changeStatus,
            shape: const StadiumBorder(),
            activeColor: const Color(0xff278EFF),
            visualDensity: VisualDensity.comfortable,
            // checkColor: const Color(0xff278EFF),
          ),
        ),
        Text(
          day,
          style: AppTextStyles.regular(20,
              color: Colors.black.withOpacity(active ? 1 : 0.3)),
        ),
        GestureDetector(
          onTap: active ? actionStart : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xff242424).withOpacity(active ? 1 : 0.3),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  startHour,
                  style: AppTextStyles.regular(20, color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.white54,
                  size: 15,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: active ? actionEnd : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xff242424).withOpacity(active ? 1 : 0.3),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  endHour,
                  style: AppTextStyles.regular(20, color: Colors.white),
                ),
                const SizedBox(
                  width: 7,
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.white54,
                  size: 15,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
