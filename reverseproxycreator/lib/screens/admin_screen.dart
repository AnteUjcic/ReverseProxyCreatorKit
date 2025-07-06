import 'package:flutter/material.dart';
import 'package:reverseproxycreator/server_simulator.dart'; 
import 'utils/logout_util.dart';
import 'utils/delete_user_button.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _server = ServerSimulator();
  late Future<List<LogEntry>> _logsFuture;
  
  List<LogEntry> _allLogs = [];
  List<LogEntry> _filteredLogs = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _logsFuture = _server.getLogs();
    _searchController.addListener(_filterLogs);
  }

// Filtrira logove prema unosu pretraživača
  void _filterLogs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLogs = _allLogs.where((log) {
        return log.user.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Log'),
        actions: [
          LogoutButton(),
        ],
      ),
  
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pretraži po korisniku',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LogEntry>>(
              future: _logsFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No logs found.'));
                }
                
                _allLogs = snapshot.data!;
                if (_searchController.text.isEmpty) {
                   _filteredLogs = _allLogs;
                }
                
                return ListView.builder(
                  itemCount: _filteredLogs.length,
                
                  itemBuilder: (context, index) {
                    final log = _filteredLogs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: ExpansionTile(
                        title: Text(log.user),
                        subtitle: Text('Zadnje: ${log.online} ${log.date}'),
                        children: [
                          FutureBuilder<String>(
                            future: _server.getUserConfig(fullName: log.user),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Dok se konfiguracija dohvaća, prikaži indikator učitavanja
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Ako je došlo do greške prilikom dohvaćanja konfiguracije
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                // Ako je konfiguracija uspješno dohvaćena, prikaži je
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        "WireGuard Config:",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data!,),
                                      // Gumb za brisanje korisnika
                                      DeleteUserButton(
                                        userFullName: log.user,
                                        onDelete: (userFullName) => _server.deleteUser(fullName: userFullName),
                                        onDeleted: () {
                                          setState(() {
                                            _logsFuture = _server.getLogs();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}