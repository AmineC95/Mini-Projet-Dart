// Exercice 1

import 'dart:io';
import 'dart:math';

void main() {
  print("Jeu de devinettes !");
  print("Devine le nombre aléatoire entre 1 et 100.");
  print("Choisis un niveau de difficulté (1, 2 ou 3) :");
  print("Niveau 1 : jusqu'a 10");
  print("Niveau 2 : jusqu'a 50");
  print("Niveau 3 : jusqu'a 100");

  String? niveau = stdin.readLineSync();

  int maxNombre;
  if (niveau == "1") {
    maxNombre = 10;
  } else if (niveau == "2") {
    maxNombre = 50;
  } else {
    maxNombre = 100;
  }

  var rng = Random();
  int nombreAleatoire = rng.nextInt(maxNombre) + 1;

  int nombreEssais = 10;
  int? essaiNombre;

  for (int i = 0; i < nombreEssais; i++) {
    print("Devinez le nombre :");
    String? essai = stdin.readLineSync();
    essaiNombre = int.tryParse(essai!) ?? 0;

    if (essaiNombre < nombreAleatoire) {
      print("Plus !");
    } else if (essaiNombre > nombreAleatoire) {
      print("Moins !");
    } else {
      print("Bravo, vous avez trouvé le bon nombre $nombreAleatoire !");
      break;
    }
  }

  if (essaiNombre != nombreAleatoire) {
    print("Désolé, vous avez perdu le bon nombre est : $nombreAleatoire");
  }
}
