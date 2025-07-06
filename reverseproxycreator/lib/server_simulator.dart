import 'package:intl/intl.dart';

class LogEntry {
  final String user;
  final String date;
  final String online;

  LogEntry({required this.user, required this.date, required this.online});
}

class ServerSimulator {
  // Kreira samo jednu instancu servera
  static final ServerSimulator _instance = ServerSimulator._internal();

  // Samo jedna instanca servera
  factory ServerSimulator() {
    return _instance;
  }

  ServerSimulator._internal();

  // Inicijalizacija fake db
  final List<LogEntry> _logs = [];
  final Map<String, String> _userConfigs = {};

// Server "API" Metode

// Dohvaća logove
  Future<List<LogEntry>> getLogs() async {
    await Future.delayed(const Duration(milliseconds: 10));
    _logs.sort((a, b) => b.date.compareTo(a.date));
    return List<LogEntry>.from(_logs);
  }
// Dohvaća sve configuracije korisnika
  Future<String> getUserConfig({required String fullName}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (_userConfigs.containsKey(fullName)) {
      return _userConfigs[fullName]!;
    } else {
      return 'Konfiguracija za "$fullName" nije pronađena. Molimo kreirajte je prvo.';
    }
  }
//Briše korisnika i njegovu konfiguraciju
  Future<void> deleteUser({required String fullName}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _userConfigs.remove(fullName);
    _logs.removeWhere((log) => log.user == fullName);
  }

// Povratna informacija o uspješnom kreiranju korisnika
  Future<String> feedbackUser({required String fullName}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (_logs.any((log) => log.user == fullName)) {
      return 'Uspješno ste kreirali korisnika $fullName.';
    } else {
      return 'Došlo je do greške, konfiguracija nije kreirana, pokušajte ponovno ili prijavite problem administratoru.';
    }
  } 
  // Prosljeđuje se ime i prezime korisnika i kreira se nova konfiguracija
  Future<Map<String, String>> createNewVpnUser({required String name, required String surname}) async {
    await Future.delayed(const Duration(seconds: 1));
    final fullName = '$name $surname';
// ToDo: Loganje admina

    final userPrivateKey = 'User_priv_key_${fullName.replaceAll(' ', '_')}';
// Simulacija generiranja javnog ključa
    final userPublicKey = 'User_pub_key_${fullName.replaceAll(' ', '_')}';
    final configContent = '''
          # $fullName
          [Interface]
          PrivateKey = $userPrivateKey
          ListenPort = 51820
          Address = 10.0.0.${_logs.length + 2}/32
          DNS = 195.29.150.3

          [Peer]
          PublicKey = [Server_pub_key]
          Endpoint = ip:51820
          AllowedIPs = 0.0.0.0/0, ::/0
          ''';
    _userConfigs[fullName] = configContent;
    

    final creationDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _logs.add(LogEntry(user: fullName, date: creationDate, online: 'online'));
    
    return {
      'status': 'Uspjeh',
      'message': 'Uspješno kreirana konfiguracija za $fullName.',
    };
  }
}