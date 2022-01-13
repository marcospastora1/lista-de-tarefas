import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarefas/bindings.dart';
import 'package:tarefas/home.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/home',
      title: 'Lista de Tarefas',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
      ],
    ),
  );
}
