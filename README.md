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
├── resultats-template.md           ← Template de reference (alternative manuelle)
├── resultats/                      ← Dossier des resultats d'evaluation
│   └── resultats-JD-15012026.md   ← Exemple de resultat complet
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

**a) Evaluation du code** — Deux actions a realiser :

1. **Lancer le script de non-regression** (l'application du candidat doit tourner sur `localhost:8080`) :

```bash
./test-scenarios.sh http://localhost:8080
```

2. **Analyser le code par IA** — Copier le prompt de `prompt-evaluation-code.md` dans une IA et coller le code du candidat a la suite. L'IA **genere directement le fichier `resultats-XX-DDMMYYYY.md`** (ex : `resultats-JD-15012026.md`) avec :
   - Les tests de non-regression (analyse statique des 12 scenarios PASS/FAIL)
   - Le scoring qualite du code et feature
   - Les sections debrief laissees vides pour l'etape suivante

Sauvegarder le fichier genere dans le dossier `resultats/`. Reporter les resultats du script dans la section "Confirmation par test-scenarios.sh".

> **Alternative manuelle** : copier `resultats-template.md` dans `resultats/resultats-XX-DDMMYYYY.md` et le remplir a la main.

**b) Debrief avec le candidat (5 min)** — Copier le prompt de `prompt-evaluation-debrief.md` dans une IA et coller le fichier `resultats-XX-DDMMYYYY.md` genere a l'etape a). L'IA accompagne le recruteur question par question :
- Observations pendant le test (signaux positifs, alertes, gestion du temps)
- Questions de debrief une par une (le recruteur donne les reponses du candidat)
- Scoring Methodologie (/40) et Utilisation IA (/25) — l'IA propose, le recruteur valide

A la fin, l'IA renvoie le fichier `resultats-XX-DDMMYYYY.md` complet et mis a jour.

**c) Recommandation finale** — Cocher la recommandation (Hire / Hire avec mentoring / Second entretien / No hire) et ajouter un commentaire si necessaire. Le fichier `resultats-XX-DDMMYYYY.md` constitue le livrable de l'evaluation.

> Voir `resultats/resultats-JD-15012026.md` pour un exemple complet.

## Ce que le candidat recoit

- Le code source legacy (Java 17 / Spring Boot 3.2) — un seul fichier `Application.java`
- Le fichier `SUJET.md` avec les consignes et les regles fonctionnelles
- Le `README.md` du projet avec les instructions de lancement

## Ce que le candidat ne recoit pas

- Le guide evaluateur et le bareme
- Le script de tests de non-regression
