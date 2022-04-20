import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

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
        title: 'Webservice Monitriip',
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

// GET TOKEN
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
  String _token= "";
  String _teste = "";
  bool _add = true;

  @override
  void initState() {
    super.initState();
    _add = true;
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
    var xmlResponse = xml.XmlDocument.parse(_response); // DESERIALIZE XML

    setState(() {
      _token = xmlResponse.findAllElements('Token').map((node) => node.text).first;
      _add = true;
      envelope2 = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetRegistrosConsultaViagens xmlns="http://tempuri.org/">
      <token>$_token</token>
      <pagina>1</pagina>
    </GetRegistrosConsultaViagens>
  </soap:Body>
</soap:Envelope>''';
    });
  }

  Future _getTrip() async {
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
    await _parsing(_response);
  }

  Future _parsing(var _response) async {
    var xmlResponse = xml.XmlDocument.parse(_response); // DESERIALIZE XML
    setState(() {
      _teste = xmlResponse.toXmlString(pretty: true, indent: '\t');
      _add = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _add == true
              ? Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Text(_teste,
                        style: const TextStyle(
                          fontSize: 18.0
                        )),
                  ))
              : const CircularProgressIndicator(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _add = false;
              });
              _getTrip();
            },
            child: const Text("Consultar"),
          )
        ],
      )),
    );
  }
}
