import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';

import 'package:snacks_pro_app/views/authentication/otp_screen.dart';
import 'package:snacks_pro_app/views/authentication/password_screen.dart';
import 'package:snacks_pro_app/views/authentication/phone_screen.dart';
import 'package:snacks_pro_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_pro_app/views/authentication/unathorized_screen.dart';
import 'package:snacks_pro_app/views/finance/contents/restaurants/new_restaurant.dart';
import 'package:snacks_pro_app/views/finance/home_finance.dart';
import 'package:snacks_pro_app/views/finance/contents/bank/add_bank_account.dart';
import 'package:snacks_pro_app/views/finance/contents/employees/new_employee.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/orders/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/home_screen.dart';
import 'package:snacks_pro_app/views/home/orders_screen.dart';
import 'package:snacks_pro_app/views/home/scan_card_screen.dart';
import 'package:snacks_pro_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_card_screen.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/new_item_screen.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;
  final storage = AppStorage();
  @override
  Widget build(BuildContext context) {
    Future<String> getRouter() async {
      await initializeDateFormatting("pt_BR");
      // Intl.defaultLocale = "pt_BR";
      var user = await storage.getDataStorage("user");
      var acc = user["access_level"];

      return auth.currentUser != null && user.isNotEmpty
          ? acc == AppPermission.sadm.name
              ? AppRoutes.finance
              : AppRoutes.home
          : AppRoutes.restaurantAuth;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<ItemScreenCubit>(
          create: (context) => ItemScreenCubit(),
        ),
        BlocProvider<MenuCubit>(
          create: (context) => MenuCubit(),
        ),
        BlocProvider<RechargeCubit>(
          create: (context) => RechargeCubit(),
        ),
        BlocProvider<FinanceCubit>(
          create: (context) => FinanceCubit(),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(),
        ),
        BlocProvider<EmployeesCubit>(
          create: (context) => EmployeesCubit(),
        ),
      ],
      key: UniqueKey(),
      child: FutureBuilder<String>(
          future: getRouter(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    // primaryColor: AppColors.main,
                    backgroundColor: Colors.white,
                    textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme)),
                title: "Snacks Pro",
                initialRoute: snapshot.data,
                // AppRoutes.home,

                routes: {
                  // AppRoutes.start: (context) => const StartScreen(),
                  AppRoutes.otp: (context) => OtpScreen(),
                  AppRoutes.passwordScreen: (context) => const PasswordScreen(),
                  AppRoutes.rechargeCard: (context) => RechargeCardScreen(),
                  AppRoutes.scanCard: (context) => const ScanCardScreen(),
                  AppRoutes.newItem: (context) => NewItemScreen(),
                  AppRoutes.orders: (context) => const OrdersScreen(),
                  AppRoutes.home: (context) => HomeScreen(),
                  AppRoutes.finance: (context) => FinanceScreen(),
                  AppRoutes.newEmployee: (context) => const NewEmployeeScreen(),
                  AppRoutes.newRestaurant: (context) =>
                      const NewRestaurantScreen(),
                  AppRoutes.addBankAccount: (context) =>
                      const AddBankAccountScreen(),
                  AppRoutes.restaurantAuth: (context) =>
                      const RestaurantAuthenticationScreen(),
                  AppRoutes.unathorizedAuth: (context) =>
                      const UnathorizedScreen(),
                },
              );
            }
            return const SizedBox();
          }),
    );
  }
}
