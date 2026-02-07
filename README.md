# Test Technique — Evaluation Candidat

Test technique de 20 minutes pour evaluer la capacite d'un developpeur a refactorer du code legacy Java/Spring Boot tout en utilisant l'IA comme outil d'aide.

## Structure du repo

```
├── test-technique-ia/              ← Projet candidat (code legacy + sujet)
│   └── src/.../legacy/
│       └── Application.java       ← Un seul fichier : tout le code legacy
├── test-technique-evaluateur.md    ← Guide de notation (CONFIDENTIEL)
├── resultats/                      ← Dossier des resultats d'evaluation
│   ├── prompt-evaluation.md       ← Prompt IA unique (analyse code + debrief)
│   ├── resultats-template.md      ← Template de reference (alternative manuelle)
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

A la fin des 20 minutes, 3 etapes — **1 script + 1 conversation IA = 1 fichier resultat complet** :

- [ ] **Lancer les tests** : `./test-scenarios.sh http://localhost:8080`
- [ ] **Ouvrir une IA** : copier `resultats/prompt-evaluation.md`, coller le code candidat a la suite
  - L'IA analyse le code et genere `resultats-XX-DDMMYYYY.md` (scores code + non-regression)
  - Reporter les resultats du script dans la section "Confirmation par test-scenarios.sh"
  - Dire **"on passe au debrief"** → l'IA guide le debrief question par question
  - A la fin, l'IA renvoie le fichier complet et mis a jour
- [ ] **Sauvegarder** le fichier dans `resultats/`, cocher la recommandation finale

> **Alternative manuelle** : copier `resultats/resultats-template.md` et le remplir a la main.
> Voir `resultats/resultats-JD-15012026.md` pour un exemple complet.

## Ce que le candidat recoit

- Le code source legacy (Java 17 / Spring Boot 3.2) — un seul fichier `Application.java`
- Le fichier `SUJET.md` avec les consignes et les regles fonctionnelles
- Le `README.md` du projet avec les instructions de lancement

## Ce que le candidat ne recoit pas

- Le guide evaluateur et le bareme
- Le script de tests de non-regression
