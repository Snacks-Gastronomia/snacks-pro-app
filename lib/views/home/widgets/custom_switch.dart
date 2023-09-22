import "package:flutter/material.dart";

import '../../../core/app.colors.dart';
import '../../../core/app.text.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    Key? key,
    required this.decrementAction,
    required this.incrementAction,
    required this.value,
  }) : super(key: key);
  final Function decrementAction;
  final Function incrementAction;
  final int value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 120,
      child: Stack(children: [
        Center(
          child: Container(
            width: 90,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffF6F6F6),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 45,
                width: 45,
                child: ElevatedButton(
                  onPressed: decrementAction(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,

                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.white, width: 2)),
                    primary: Color(0xffF6F6F6),
                    shadowColor: Colors.grey.shade200,
                    fixedSize: const Size(45, 45),
                    // elevation: 0
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: AppTextStyles.medium(18),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: ElevatedButton(
                    onPressed: incrementAction(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        shape: const CircleBorder(
                            side: BorderSide(color: Colors.white, width: 2)),
                        primary: Color(0xffF6F6F6),
                        // elevation: 0,
                        shadowColor: Colors.grey.shade200,
                        fixedSize: const Size(45, 45)),
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.highlight,
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
