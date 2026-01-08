# GAINZ – Flutter Fitness App

GAINZ est une application mobile développée avec Flutter, permettant aux utilisateurs de rester motivés, organiser leurs entraînements et suivre leur progression sportive.  


---

##  Objectifs du projet

- Mettre en pratique Flutter (UI, navigation, widgets)
- Implémenter une authentification utilisateur
- Gérer l’état de l’application proprement
- Persister les données utilisateur dans le cloud
- Travailler avec une architecture claire et maintenable

---

##  Fonctionnalités

###  Authentification (Firebase)
- Inscription utilisateur
- Connexion sécurisée
- Gestion des sessions avec Firebase Authentication

###  Motivation
- Affichage de citations motivationnelles
- Appel API externe
- Bouton pour charger une nouvelle citation

###  Programme d’entraînement
- Page dédiée aux programmes
- Base prête pour l’ajout d’exercices

###  Timer d’exercices
- Timer simple pour accompagner les séances
- Gestion de l’état avec StatefulWidget

###  Suivi du poids
- Ajout du poids utilisateur
- Historique stocké dans Firestore
- Données liées à l’utilisateur connecté

---

##  Architecture du projet

Le projet est structuré selon une séparation claire des responsabilités :


lib/
 ├─ components/    # Widgets réutilisables (FeatureWidget, Quote, etc.)
 ├─ pages/         # Écrans principaux (Home, Login, Programme, Timer, Poids)
 ├─ services/      # Accès API et Firebase
 ├─ providers/     # Gestion d’état avec Provider
 └─ main.dart      # Point d’entrée, routes et initialisation Firebase
