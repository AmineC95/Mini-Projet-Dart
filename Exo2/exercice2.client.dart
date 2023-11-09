import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  final socket = await Socket.connect('127.0.0.1', 4040);

  print(
      'Connecté au serveur de chat. Veuillez entrer votre nom d\'utilisateur:');
  String username = stdin.readLineSync() ?? 'Anonyme';
  socket.write(username + '\n');

  socket.listen(
    (data) {
      print(utf8.decode(data).trim());
    },
    onError: (error) {
      print('Erreur: $error');
      socket.destroy();
    },
    onDone: () {
      print('Connexion terminée par le serveur.');
      exit(0);
    },
  );

  stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((String line) {
    if (line == '/quit') {
      socket.destroy();
      exit(0);
    } else {
      socket.write(line + '\n');
    }
  });
}
