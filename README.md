# Test Technique — Evaluation Candidat

Test technique de 20 minutes pour evaluer la capacite d'un developpeur a refactorer du code legacy Java/Spring Boot tout en utilisant l'IA comme outil d'aide.

## Structure du repo

```
├── test-technique-ia/              ← Projet candidat (code legacy + sujet)
│   └── src/.../legacy/
│       └── Application.java       ← Un seul fichier : tout le code legacy
├── test-technique-evaluateur.md    ← Guide de notation (CONFIDENTIEL)
├── prompt-evaluation-code.md       ← Prompt IA : analyse du code + non-regression
├── prompt-evaluation-debrief.md    ← Prompt IA : scoring methodologie + usage IA
├── resultats-template.md           ← Template de reference (le fichier est genere par l'IA)
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

Envoyer le fichier `test-technique-ia.zip` au candidat.

**Deroulement en 2 temps :**

1. **Installation (5 min)** — Le candidat dezippe le projet, ouvre son IDE et verifie que l'application se lance (`./mvnw spring-boot:run` depuis `test-technique-ia/`). Ce temps n'est pas evalue.
2. **Test (20 min)** — Le chrono demarre une fois que le projet tourne sur le poste du candidat. Pendant ces 20 minutes, le candidat doit :
   - Refactorer le code legacy (lisibilite, SOLID, nommage)
   - Implementer l'endpoint `GET /api/ord/stats`

### 3. Evaluer le rendu

A la fin des 20 minutes, suivre ces etapes dans l'ordre :

**a) Analyse du code par IA** — Copier le prompt de `prompt-evaluation-code.md` dans une IA et coller le code du candidat a la suite. L'IA **genere directement le fichier `resultats-XX.md`** (initiales du candidat, ex : `resultats-JD.md`) avec :
- Les tests de non-regression (analyse statique des 12 scenarios PASS/FAIL)
- Le scoring qualite du code et feature
- Les sections debrief laissees vides pour l'etape suivante

Sauvegarder le fichier genere tel quel.

**b) Tests automatiques (verification)** — Lancer le script pour confirmer les resultats de l'IA :

```bash
./test-scenarios.sh http://localhost:8080
```

Reporter les resultats du script dans la section "Confirmation par test-scenarios.sh" du fichier `resultats-XX.md`.

**c) Debrief avec le candidat (5 min)** — Poser les questions listees dans `test-technique-evaluateur.md`. Noter les reponses et les observations (approche, comportement, interaction avec l'IA).

**d) Scoring du debrief par IA** — Copier le prompt de `prompt-evaluation-debrief.md` dans une IA et coller a la suite : (1) le contenu du fichier `resultats-XX.md` genere a l'etape a), (2) les observations pendant le test, (3) les reponses du candidat. L'IA **renvoie le fichier `resultats-XX.md` complet et mis a jour** avec :
- Les scores Methodologie (/40) et Utilisation IA (/25)
- Les reponses du candidat au debrief
- Les observations pendant le test
- La synthese finale (total, points forts, axes d'amelioration)

Sauvegarder le fichier mis a jour. Il ne reste qu'a cocher la recommandation finale.

**e) Recommandation finale** — Cocher la recommandation (Hire / Hire avec mentoring / Second entretien / No hire) et ajouter un commentaire si necessaire. Le fichier `resultats-XX.md` constitue le livrable de l'evaluation.

## Ce que le candidat recoit

- Le code source legacy (Java 17 / Spring Boot 3.2) — un seul fichier `Application.java`
- Le fichier `SUJET.md` avec les consignes et les regles fonctionnelles
- Le `README.md` du projet avec les instructions de lancement

## Ce que le candidat ne recoit pas

- Le guide evaluateur et le bareme
- Le script de tests de non-regression
