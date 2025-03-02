import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/todomodel.dart';
import 'package:flutter_application_2/service/todo_database.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  late TextEditingController _controllerText;
  late TextEditingController _controllerDate;
  late TextEditingController _controllerTime;

  @override
  void initState() {
    // TODO: implement initState
    _controllerText = TextEditingController();
    _controllerDate = TextEditingController();
    _controllerTime = TextEditingController();

    //exp DateTime.now() = 2025-03-02 09:59:22.571609
    _controllerDate.text = DateTime.now().toString().substring(0, 10);
    _controllerTime.text = DateTime.now().toString().substring(11, 16);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerText.dispose();
    _controllerDate.dispose();
    _controllerTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo with SQL'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: TextField(
                controller: _controllerText,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Todo',
                ),
                maxLines: 5,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controllerDate,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.date_range)),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onTap: () async {
                  await showDatePicker(
                          context: context,
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                          initialDate: DateTime(
                              int.parse(_controllerDate.text.substring(0, 4)),
                              int.parse(_controllerDate.text.substring(5, 7)),
                              int.parse(_controllerDate.text.substring(8, 10))))
                      .then((onValue) {
                    if (onValue != null) {
                      _controllerDate.text =
                          onValue.toString().substring(0, 10);
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controllerTime,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time',
                    prefixIcon: Icon(Icons.av_timer)),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onTap: () async {
                  await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: int.parse(_controllerTime.text
                                  .toString()
                                  .substring(0, 2)),
                              minute: int.parse(_controllerTime.text
                                  .toString()
                                  .substring(3, 5))))
                      .then((onValue) {
                    if (onValue != null) {
                      _controllerTime.text = onValue.format(context).toString();
                    }
                  });
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FilledButton(
                    onPressed: () async {
                      //save to SQL
                      final todo = Todomodel(
                          text: _controllerText.text,
                          datetime:
                              '${_controllerDate.text} ${_controllerTime.text}',
                          done: false);
                      await TodoDatabase.instance.create(todo).then((onValue) {
                        print('id = $onValue');
                        Navigator.pop(context, true);
                      });
                    },
                    child: const Text('Save Todo')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
