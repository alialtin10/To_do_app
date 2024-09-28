import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:easy_localization/easy_localization.dart';



final locator = GetIt.instance;

void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive()async{
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  // ignore: non_constant_identifier_names
  var TaskBox = await Hive.openBox<Task>('Tasks');
  for (var task in TaskBox.values) {
    if(task.createdAt.month != DateTime.now().month){
      TaskBox.delete(task.id);
    }
  }
}

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setupHive();
  setup();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: const  Locale('en', 'US'),
      child: const  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
