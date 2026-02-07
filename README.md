# Test Technique — Évaluation Candidat

Test technique de 20 minutes pour évaluer la capacité d'un développeur à refactorer du code legacy Java/Spring Boot tout en utilisant l'IA comme outil d'aide.

## Structure du repo

```
├── test-technique-ia/              ← Projet candidat (code legacy + sujet)
├── test-technique-evaluateur.md    ← Guide de notation (CONFIDENTIEL)
├── test-scenarios.sh               ← Script de non-régression (9 tests)
├── generate-zip-candidat.sh        ← Génère le zip à envoyer au candidat
└── README.md
```

## Workflow

### 1. Préparer le zip candidat

```bash
./generate-zip-candidat.sh
```

Génère `test-technique-ia.zip` contenant uniquement le code et le sujet. **Pas de guide évaluateur ni de script de test.**

### 2. Envoyer au candidat

Envoyer le fichier `test-technique-ia.zip`. Le candidat a 20 minutes pour :

- Refactorer le code legacy (lisibilité, SOLID, nommage)
- Implémenter l'endpoint `GET /api/ord/stats`

### 3. Évaluer le rendu

Récupérer le projet du candidat, le lancer puis exécuter le script de non-régression :

```bash
./test-scenarios.sh http://localhost:8080
```

Consulter `test-technique-evaluateur.md` pour la grille de notation.

## Ce que le candidat reçoit

- Le code source legacy (Java 17 / Spring Boot 3.2)
- Le fichier `SUJET.md` avec les consignes
- Le `README.md` du projet avec les instructions de lancement

## Ce que le candidat ne reçoit pas

- Le guide évaluateur et le barème
- Le script de tests de non-régression
