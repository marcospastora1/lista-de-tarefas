import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarefas/controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(17, 1, 7, 1),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.toDoController,
                  decoration: const InputDecoration(
                    labelText: 'Nova Tarefa',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: controller.addToDo,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                ),
                child: const Text('ADD'),
              )
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: controller.toDoList.length,
                itemBuilder: controller.buildItem,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
