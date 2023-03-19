import 'package:flutter/material.dart';

import 'package:snacks_pro_app/core/app.text.dart';

class TabarBar extends StatelessWidget {
  TabarBar({
    Key? key,
    required this.page1,
    required this.page2,
    required this.tab1_text,
    required this.tab2_text,
    required this.new_items_page1,
    required this.new_items_page2,
    required this.onChange,
  }) : super(key: key);

  final Widget page1;
  final Widget page2;
  final String tab1_text;
  final String tab2_text;
  final int new_items_page1;
  final int new_items_page2;
  final Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: TabBar(
                onTap: onChange,

                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tab1_text),
                        const SizedBox(width: 5),
                        if (new_items_page1 != 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              new_items_page1.toString(),
                              style:
                                  AppTextStyles.medium(11, color: Colors.white),
                            ),
                          )
                      ],
                    ),
                  ),
                  Tab(
                    // text: 'Local',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tab2_text),
                        const SizedBox(width: 5),
                        if (new_items_page2 != 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              new_items_page2.toString(),
                              style:
                                  AppTextStyles.medium(11, color: Colors.white),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // first tab bar view widget
                  page1,
                  page2
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
