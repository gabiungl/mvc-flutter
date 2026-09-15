import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/patrimonio_controller.dart';
import 'services/api_service.dart';
import 'views/home_view.dart';

void main() {
  Get.put(ApiService());
  Get.put(PatrimonioController(Get.find<ApiService>()));
  runApp(const PatrimonioApp());
}

class PatrimonioApp extends StatelessWidget {
  const PatrimonioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Patrimônios SENAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff005b96),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff4f7fa),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const HomeView(),
    );
  }
}
