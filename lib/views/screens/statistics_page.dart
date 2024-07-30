import 'package:flutter/material.dart';
import 'package:todo/controllers/note_controller.dart';
import 'package:todo/controllers/todo_controllers.dart';
import 'package:todo/models/todo_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  TodoControllers todoControllers = TodoControllers();
  NoteController noteController = NoteController();
  Future<List<List<dynamic>>> todoandnote() async {
    final todo = await todoControllers.getTodos();
    final note = await noteController.getNotes();
    return [todo, note];
  }

  Widget countTodo(List todos) {
    int isComplate = 0;
    int isNotComplate = 0;
    for (Todo i in todos) {
      if (i.isComplate) {
        isComplate++;
      } else {
        isNotComplate++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Bajarilgan ishlar soni : $isComplate"),
        Text("Bajarilmagan ishlar soni : $isNotComplate"),
        Text("Jami todolar soni : ${todos.length}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(AppLocalizations.of(context)!.statisticpage),
          centerTitle: true,
        ),
        Expanded(
          child: FutureBuilder(
              future: todoandnote(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  const Center(
                    child: Text("Malumot yo'q"),
                  );
                }
                if (snapshot.hasError) {
                  const Center(
                    child: Text("Malumot olishda hatolik bor"),
                  );
                }
                return Row(
                  children: [
                    Card(
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2 - 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: countTodo(snapshot.data![0]),
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 2 - 10,
                        child: Center(
                          child: Text("Jami notelar soni ${snapshot.data![1].length}"),
                        ),
                      ),
                    )
                  ],
                );
              }),
        )
      ],
    );
  }
}
