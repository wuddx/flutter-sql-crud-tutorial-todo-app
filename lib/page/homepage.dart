import 'package:flutter/material.dart';
import 'package:flutter_application_2/page/create_todo.dart';
import 'package:flutter_application_2/page/edit_todo.dart';
import 'package:flutter_application_2/service/todo_database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo with SQL'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          bottom: const TabBar(unselectedLabelColor: Colors.grey, tabs: [
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Done',
            )
          ]),
        ),
        body: TabBarView(children: [

          //tab Todo Active -------
          FutureBuilder(
              future: TodoDatabase.instance.readAllTodo(false),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              leading: IconButton(
                                  onPressed: () async {
                                    data.done = true;
                                    await TodoDatabase.instance
                                        .update(data)
                                        .then((onValue) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.check_box_outline_blank_rounded)),
                              title: Text(data.text),
                              subtitle: Text(data.datetime),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditTodo(
                                                      todo: data,
                                                    )));
                                        print(
                                            'data return from edit page = $result');
                                        if (result == true) {
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.edit_outlined)), // icon-1
                                  IconButton(
                                      onPressed: () async {
                                        await TodoDatabase.instance
                                            .delete(data.id!)
                                            .then((onValue) {
                                          setState(() {});
                                        });
                                      },
                                      icon: const Icon(Icons
                                          .delete_outline_outlined)), // icon-2
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),

          // tab Todo Done -----------------
          FutureBuilder(
              future: TodoDatabase.instance.readAllTodo(true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              leading: IconButton(
                                  onPressed: () async {
                                    data.done = false;
                                    await TodoDatabase.instance
                                        .update(data)
                                        .then((onValue) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.check_box)),
                              title: Text(
                                data.text,
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough),
                              ),
                              subtitle: Text(data.datetime,
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough)),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await TodoDatabase.instance
                                        .delete(data.id!)
                                        .then((onValue) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // go to create_todo page.
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateTodo()));
            print('data return from create page = $result');
            if (result == true) {
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
