import 'dart:io';

void main() async {
  var server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 4040);
  print(
      'Serveur de chat en écoute sur ${server.address.address}:${server.port}');

  Map<Socket, String> clients = {};

  await for (Socket client in server) {
    print(
        'Nouveau client connecté : ${client.remoteAddress.address}:${client.remotePort}');

    client.listen((data) {
      String message = String.fromCharCodes(data).trim();
      String? username = clients[client];

      if (username == null && message.isNotEmpty) {
        clients[client] = message;
        client.write('Bienvenue $message! Vous êtes maintenant connecté.\n');
        print('$message s\'est connecté.');
      } else if (username != null) {
        print('$username dit: $message');
        for (var otherClient in clients.keys) {
          if (otherClient != client) {
            otherClient.write('$username: $message\n');
          }
        }
      }
    }, onDone: () {
      String? username = clients[client];
      clients.remove(client);
      print('$username s\'est déconnecté.');
      client.close();
    }, onError: (error) {
      print('Erreur: $error');
      client.close();
    });
  }
}
