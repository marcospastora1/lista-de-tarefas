import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  final toDoController = TextEditingController();

  var toDoList = [].obs;
  var lastRemoved = {}.obs;
  int? lastRemovedPos;

  @override
  void onInit() {
    super.onInit();

    readData().then((data) {
      toDoList.value = json.decode(data!);
    });
  }

  void addToDo() {
    if (toDoController.text.isNotEmpty) {
      final newToDo = {}.obs;
      newToDo["title"] = toDoController.text;
      toDoController.text = '';
      newToDo["ok"] = false;
      toDoList.add(newToDo);
    }
    saveData();
  }

  @override
  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    toDoList.sort((a, b) {
      if (a['ok'] && !b['ok']) {
        return 1;
      } else if (!a['ok'] && b['ok']) {
        return -1;
      } else {
        return 0;
      }
    });
    saveData();
  }

  Widget buildItem(BuildContext context, int index) {
    return Obx(
      () => Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: CheckboxListTile(
          title: Text(toDoList[index]['title']),
          value: toDoList[index]['ok'],
          secondary: CircleAvatar(
            child: Icon(toDoList[index]['ok'] ? Icons.check : Icons.error),
          ),
          onChanged: (c) {
            toDoList[index]['ok'] = c;
            saveData();
          },
        ),
        onDismissed: (direction) {
          lastRemoved.value = Map.from(toDoList[index]);
          lastRemovedPos = index;
          toDoList.removeAt(index);

          saveData();

          Get.snackbar('Tarefa "${lastRemoved['title']}" removida', '',
              margin: const EdgeInsets.only(left: 0, right: 0),
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              borderRadius: 0,
              backgroundColor: Colors.black87,
              mainButton: TextButton(
                onPressed: () {
                  toDoList.insert(lastRemovedPos!, lastRemoved);
                  saveData();
                },
                child: const Text('Desfazer'),
              ));
        },
      ),
    );
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    //pegou o local onde armazena os documentos ainda nao sabe o local por isso é um dado futuro
    return File("${directory.path}/data.json");
    //retorna um arquivo junta o arquivo data.json
  }

  Future<File> saveData() async {
    String data = json.encode(toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String?> readData() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (err) {
      return null;
    }
  }
}
