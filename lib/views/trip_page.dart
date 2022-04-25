import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/Trip.dart';
import 'package:mvp/views/trip_info_page.dart';
import 'package:xml/xml.dart';

List<Trip> trips = [];
late int selectedIndex;

class TripWidget extends StatefulWidget {
  const TripWidget({Key? key}) : super(key: key);
  @override
  State<TripWidget> createState() => _AppState();
}

class _AppState extends State<TripWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TripPage(
        title: 'Lista de viagens',
        key: null,
      ),
    );
  }
}

class TripPage extends StatefulWidget {
  const TripPage({required Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _TripPage createState() => _TripPage();
}

class _TripPage extends State<TripPage> {
  var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetTokenConsultaViagens xmlns="http://tempuri.org/">
      <dataHoraInicio>2022-04-10T15:00:00</dataHoraInicio>
      <dataHoraFim>2022-04-10T17:00:00</dataHoraFim>
      <arrayEmpresas></arrayEmpresas>
      <arrayTiposLinha></arrayTiposLinha>
      <arrayTiposServico></arrayTiposServico>
      <arrayRegionais></arrayRegionais>
      <arrayNops></arrayNops>
      <flgComMotorista>84</flgComMotorista>
      <flgLiberado>84</flgLiberado>
    </GetTokenConsultaViagens>
  </soap:Body>
</soap:Envelope>''';
  var envelope2;
  String _token = "";

  @override
  void initState() {
    super.initState();
  }

  Future _getToken() async {
    http.Response response = await http.post(
        Uri.parse(
            'http://sigla.guanabaraholding.com.br:8090/MoniTriipServices.asmx'),
        headers: {
          "Authorization": "Basic c2lnbGE6JCQwYmcxbXQyZnMzJCQ=",
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/GetTokenConsultaViagens",
          "Host": "sigla.guanabaraholding.com.br",
          "Access-Control-Allow-Origin": "*",
        },
        body: envelope);
    var _response = response.body; // RESPONSE XML IS HERE
    var xmlResponse = XmlDocument.parse(_response); // DESERIALIZE XML

    _token =
        xmlResponse.findAllElements('Token').map((node) => node.text).first;
    envelope2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetRegistrosConsultaViagens xmlns="http://tempuri.org/">
      <token>$_token</token>
      <pagina>1</pagina>
    </GetRegistrosConsultaViagens>
  </soap:Body>
</soap:Envelope>''';
  }

  Future getTripsFromXML(BuildContext context) async {
    await _getToken();
    http.Response response = await http.post(
        Uri.parse(
            'http://sigla.guanabaraholding.com.br:8090/MoniTriipServices.asmx'),
        headers: {
          "Authorization": "Basic c2lnbGE6JCQwYmcxbXQyZnMzJCQ=",
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/GetRegistrosConsultaViagens",
          "Host": "sigla.guanabaraholding.com.br",
          "Access-Control-Allow-Origin": "*",
        },
        body: envelope2);
    var _response = response.body; // RESPONSE XML IS HERE
    var xmlResponse = XmlDocument.parse(_response); // DESERIALIZE XML

    var elements = xmlResponse.findAllElements("Registro");
    return elements.map((element) {
      return Trip(
        element.findElements("Servico").first.text,
        element.findElements("CodigoLinha").first.text,
        element.findAllElements("PartidaPrev").first.text,
        element.findAllElements("ChegadaPrev").first.text,
        element.findAllElements("PlacaVeiculo").first.text,
        element.findAllElements("Nome").first.text,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: getTripsFromXML(context),
              builder: (context, data) {
                if (data.hasData) {
                  trips = data.data as List<Trip>;
                  return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        int indice = index + 1;
                        return ListTile(
                          title: Text("Viagem $indice"),
                          subtitle: Text("Serviço: " + trips[index].servico),
                          leading: const Icon(Icons.directions_bus),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TripInfoPage()),
                            );
                          },
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
