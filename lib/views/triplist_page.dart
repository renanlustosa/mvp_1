import 'package:flutter/material.dart';
import 'package:mvp/views/trip_page.dart';

class TriplistApp extends StatelessWidget {
  const TriplistApp({Key? key}) : super(key: key);

// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "lista_de_viagens",
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const ListViewBuilder());
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de viagens")),
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            int id = index + 1;
            return ListTile(
                leading: const Icon(Icons.directions_bus),
                title: Text("Viagem $id"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TripWidget()),
                );
              },
            );
          }),
    );
  }
}
