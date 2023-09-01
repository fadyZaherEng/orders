// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/bloc_observer/firebase_options.dart';
import 'package:orders/bloc_observer/observer.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/splash/splash_screen.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:orders/shared/styles/themes.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  await SharedHelper.init();
  if (SharedHelper.get(key: 'theme') == null) {
    SharedHelper.save(value: 'Light Theme', key: 'theme');
  }
  if (SharedHelper.get(key: 'lang') == null) {
    SharedHelper.save(value: 'arabic', key: 'lang');
  }
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales:const  [ Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOffline = true;
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      }
      if (event == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      }
      if (event == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersHomeCubit()..getOrders()..getCategories()..getAdminsProfile(),
      child: BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Sizer(
            builder: (a, b, c) => Phoenix(
              child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
                debugShowCheckedModeBanner: false,
                darkTheme: darkTheme(),
                theme: lightTheme(),
                themeMode: SharedHelper.get(key: 'theme') == 'Light Theme'
                    ? ThemeMode.light
                    : ThemeMode.dark,
                home: !isOffline
                    ? startScreen()
                    : Scaffold(
                        backgroundColor:
                            SharedHelper.get(key: 'theme') == 'Light Theme'
                                ? Colors.white
                                : Theme.of(context).scaffoldBackgroundColor,
                        appBar: AppBar(
                          title: const Text('No Internet'),
                          centerTitle: true,
                        ),
                        body: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget startScreen() {
    String? signIn = SharedHelper.get(key: 'uid');
    if (signIn != null) {
      return SplashScreen('home');
    }
    return SplashScreen('logIn');
  }
}
