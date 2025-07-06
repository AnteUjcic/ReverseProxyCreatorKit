import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reverseproxycreator/server_simulator.dart'; 
class DataReceivePage extends StatefulWidget {

  final String userName;
  final String userLastName;

  const DataReceivePage(
    {super.key, 
    required this.userName,
    required this.userLastName,
    });
// Kombiniramo ime i prezime u jedno polje za lakše korištenje
    String get fullName=>'$userName $userLastName';

  @override
  State<DataReceivePage> createState() => _DataReceivePageState();
}

class _DataReceivePageState extends State<DataReceivePage> {
  final _server = ServerSimulator();
  late Future<String> _configFuture;


  @override
  // Pokreće dohvat konfiguracije korisnika odmah nakon što se stranica učita
  void initState() {
    super.initState();
// Dobavljamo konfiguraciju za korisnika kada se stranica učita
    _configFuture = _server.getUserConfig(fullName: widget.fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config za ${widget.fullName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: _configFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)
                ),
              );
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Vaša WireGuard konfiguracija:"),
                    const SizedBox(height: 15),
                    Text(snapshot.data!),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: snapshot.data!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Konfiguracija kopirana'))
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Kopiraj konfiguraciju'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("Nema konfiguracije"));
          },
        ),
      ),
    );
  }
}