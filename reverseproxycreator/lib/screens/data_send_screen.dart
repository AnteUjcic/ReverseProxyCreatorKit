import 'package:flutter/material.dart';
import 'package:reverseproxycreator/server_simulator.dart'; 
import 'data_receive_screen.dart';
import 'utils/logout_util.dart';

class DataSendPage extends StatefulWidget {
  const DataSendPage({super.key});

  @override
  State<DataSendPage> createState() => _DataSendScreenState();
}

class _DataSendScreenState extends State<DataSendPage> {
  final _imeController = TextEditingController();
  final _prezimeController = TextEditingController();
  final _server = ServerSimulator();
  bool _isLoading = false;

  Future<void> _kreirajKorisnikaINavigiraj() async {
    final String ime = _imeController.text.trim();
    final String prezime = _prezimeController.text.trim();

    if (ime.isEmpty || prezime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unesite ime i prezime.')),
      );
      return;
    }
    setState(() => _isLoading = true);


    try {
      // Pozivamo server da kreira novog korisnika i čekamo da završi.
      await _server.createNewVpnUser(name: ime, surname: prezime);

      // Pokažemo poruku o uspjehu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(await _server.feedbackUser(fullName: '$ime $prezime'))),
      );

      // Provjeravamo je li widget aktivan i prosljeđujemo ime i prezime
      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DataReceivePage(
              userName: ime,
              userLastName: prezime,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kreiraj novog korisnika'),
        actions: [
          LogoutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _imeController, decoration: const InputDecoration(labelText: 'Ime')),
            const SizedBox(height: 16),
            TextField(controller: _prezimeController, decoration: const InputDecoration(labelText: 'Prezime')),

            // ToDo: osmislit način za uid bez "mucenja(razgovor)" musterija
            // Mayb adresa + jos nes ili neki dolibarr user ID
            const SizedBox(height: 32),
            if (_isLoading) const CircularProgressIndicator() 
            else ElevatedButton(
                    onPressed: _kreirajKorisnikaINavigiraj,
                    child: const Text('Kreiraj i prikaži konfiguraciju'),
                  ),
          ],
        ),
      ),
    );
  }
}

