import 'package:flutter/material.dart';
import 'trip_page.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Informação sobre a viagem")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Serviço: ' + trips[selectedIndex].servico, style: const TextStyle(fontSize: 16)),
              Text('Código Linha: ' + trips[selectedIndex].codigolinha, style: const TextStyle(fontSize: 16)),
              Text('Partida Prev: ' + trips[selectedIndex].partidaprev, style: const TextStyle(fontSize: 16)),
              Text('Chegada Prev: ' + trips[selectedIndex].chegadaprev, style: const TextStyle(fontSize: 16)),
              Text('Placa Veículo: ' + trips[selectedIndex].placaveiculo, style: const TextStyle(fontSize: 16)),
              Text('Nome Motorista: ' + trips[selectedIndex].nome, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ));
  }
}
