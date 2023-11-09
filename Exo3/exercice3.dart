//Exercice 3

import 'dart:io';
import 'dart:convert';

class Task {
  String description;
  bool isDone;

  Task({required this.description, this.isDone = false});

  Map<String, dynamic> toJson() => {
        'description': description,
        'isDone': isDone,
      };

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      description: json['description'],
      isDone: json['isDone'],
    );
  }

  @override
  String toString() => '${isDone ? "[x]" : "[ ]"} $description';
}

class TaskManager {
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    try {
      File file = File('tasks.json');
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<dynamic> jsonTasks = jsonDecode(contents);
        tasks = jsonTasks.map((json) => Task.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erreur lors du chargement des tâches: $e');
    }
  }

  Future<void> saveTasks() async {
    try {
      File file = File('tasks.json');
      String json = jsonEncode(tasks);
      await file.writeAsString(json);
    } catch (e) {
      print('Erreur lors de la sauvegarde des tâches: $e');
    }
  }

  void addTask(String description) {
    tasks.add(Task(description: description));
    saveTasks();
  }

  void viewTasks() {
    for (var task in tasks) {
      print(task);
    }
  }

  void toggleTaskDone(int index) {
    if (index < 0 || index >= tasks.length) {
      print('Index invalide');
      return;
    }
    tasks[index].isDone = !tasks[index].isDone;
    saveTasks();
  }

  void removeTask(int index) {
    if (index < 0 || index >= tasks.length) {
      print('Index invalide');
      return;
    }
    tasks.removeAt(index);
    saveTasks();
  }
}

void main() async {
  TaskManager manager = TaskManager();

  await manager.loadTasks();

  print('Bienvenue dans votre application de liste de tâches!');
  String command;

  do {
    stdout.write(
        'Que souhaitez-vous faire? (ajouter, voir, supprimer, isDone, quitter): ');
    command = stdin.readLineSync() ?? '';

    switch (command) {
      case 'ajouter':
        stdout.write('Entrez la description de la tâche: ');
        String description = stdin.readLineSync() ?? '';
        manager.addTask(description);
        break;
      case 'voir':
        manager.viewTasks();
        break;
      case 'isDone':
        stdout.write(
            'Entrez l\'index de la tâche dont vous voulez changer l\'état: ');
        int index = int.parse(stdin.readLineSync() ?? '0');
        manager.toggleTaskDone(index);
        break;
      case 'supprimer':
        stdout.write('Entrez l\'index de la tâche à supprimer: ');
        int index = int.parse(stdin.readLineSync() ?? '0');
        manager.removeTask(index);
        break;
    }
  } while (command != 'quitter');

  print('Merci d\'avoir utilisé l\'application de liste de tâches!');
}
