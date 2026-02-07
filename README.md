# Test Technique — Evaluation Candidat

Test technique de 20 minutes pour evaluer la capacite d'un developpeur a refactorer du code legacy Java/Spring Boot tout en utilisant l'IA comme outil d'aide.

## Structure du repo

```
├── test-technique-ia/              ← Projet candidat (code legacy + sujet)
│   └── src/.../legacy/
│       └── Application.java       ← Un seul fichier : tout le code legacy
├── test-technique-evaluateur.md    ← Guide de notation (CONFIDENTIEL)
├── test-scenarios.sh               ← Script de non-regression (12 tests)
├── generate-zip-candidat.sh        ← Genere le zip a envoyer au candidat
├── .github/workflows/              ← CI GitHub Actions
└── README.md
```

## Workflow

### 1. Preparer le zip candidat

```bash
./generate-zip-candidat.sh
```

Genere `test-technique-ia.zip` contenant uniquement le code et le sujet. **Pas de guide evaluateur ni de script de test.**

### 2. Envoyer au candidat

Envoyer le fichier `test-technique-ia.zip`. Le candidat doit d'abord mettre en place son environnement de dev et verifier que le projet se lance (`./mvnw spring-boot:run` depuis `test-technique-ia/`). **Le chrono de 20 minutes demarre une fois que le candidat a un environnement operationnel et que le projet tourne sur son poste.**

Pendant ces 20 minutes, le candidat doit :

- Refactorer le code legacy (lisibilite, SOLID, nommage)
- Implementer l'endpoint `GET /api/ord/stats`

### 3. Evaluer le rendu

Recuperer le projet du candidat, le lancer puis executer le script de non-regression :

```bash
./test-scenarios.sh http://localhost:8080
```

Consulter `test-technique-evaluateur.md` pour la grille de notation.

## Ce que le candidat recoit

- Le code source legacy (Java 17 / Spring Boot 3.2) — un seul fichier `Application.java`
- Le fichier `SUJET.md` avec les consignes et les regles fonctionnelles
- Le `README.md` du projet avec les instructions de lancement

## Ce que le candidat ne recoit pas

- Le guide evaluateur et le bareme
- Le script de tests de non-regression
