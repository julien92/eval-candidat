# Guide Évaluateur — Test Technique IA 2026

> ⚠️ **CONFIDENTIEL** — Ne pas partager avec le candidat

---

## 🚀 Lancer les Tests de Non-Régression

À la fin des 20 minutes, lance le script sur le code du candidat :

```bash
chmod +x test-scenarios.sh
./test-scenarios.sh http://localhost:8080
```

Le script vérifie automatiquement tous les comportements métier et affiche un score PASS/FAIL.

---

## 🎯 Objectif du Test

Évaluer la capacité d'un développeur à :
1. Travailler avec du code legacy en conditions réelles
2. Utiliser l'IA comme accélérateur (pas comme béquille)
3. Avoir le réflexe de sécuriser avant de modifier
4. Livrer sous contrainte de temps

---

## 📋 Comportements Métier (fournis au candidat)

Toutes les règles fonctionnelles sont documentées dans `SUJET.md` et fournies au candidat. Il n'y a pas de comportement caché. Le candidat doit s'appuyer sur ces règles pour écrire ses tests de non-régression.

| # | Comportement | Détail technique dans le code |
|---|--------------|-------------------------------|
| 1 | **Double save pour premium** | Le premier `save` avant le discount crée l'état "commande reçue", le second après crée "commande finalisée". |
| 2 | **Double discount pour premium** | `aDsc()` est appelé deux fois : 10% + 10% = 19% (pas 20%). Ex : 1000 → 810. |
| 3 | **Catch silencieux sur notify** | Les notifications email ne bloquent JAMAIS une commande. |
| 4 | **Soft delete uniquement** | La suppression est logique (`status = "del"`), jamais physique. |
| 5 | **Threshold 1000€ pour standard uniquement** | Le discount standard s'applique seulement au-dessus de 1000€. Le discount premium s'applique toujours. |
| 6 | **Flag "premium" pour premium** | `d.put("premium", true)` marque la commande comme premium avant le save. |

---

## 👀 Ce qu'il faut Observer

### Signaux Positifs ✅

- [ ] Commence par lire et comprendre le code
- [ ] Écrit des tests d'intégration HTTP AVANT de refactorer (teste le comportement, pas l'implémentation)
- [ ] Demande à l'IA d'expliquer le code avant de le modifier
- [ ] Pose des questions de clarification
- [ ] Relit et challenge les suggestions de l'IA
- [ ] Lance les tests entre chaque modification
- [ ] Gère son temps (regarde l'horloge)

### Signaux d'Alerte 🚩

- [ ] Fonce directement dans le refacto sans tests
- [ ] Écrit des tests unitaires sur le code legacy AVANT de refactorer (ils casseront au refacto → perte de temps)
- [ ] Copie-colle le code dans l'IA et applique sans relire
- [ ] Accepte le premier output de l'IA aveuglément
- [ ] Ne pose aucune question
- [ ] Panique et fait du copier-coller en boucle
- [ ] "L'IA m'a dit que..." comme justification

---

## 📊 Grille d'Évaluation

### 1. Méthodologie (40 points)

| Critère | Points | Score | Notes |
|---------|--------|-------|-------|
| Écrit des tests AVANT de refactorer | /10 | | |
| Choisit le bon type de tests (intégration HTTP, pas unitaire sur le legacy) | /10 | | |
| Tests couvrent les cas nominaux et edge cases | /10 | | |
| Tests couvrent les règles fonctionnelles fournies | /10 | | |

**Sous-total méthodologie** : ___/40

---

### 2. Utilisation de l'IA (25 points)

| Critère | Points | Score | Notes |
|---------|--------|-------|-------|
| Prompts clairs et structurés | /10 | | |
| Itère intelligemment (pas de copier-coller en boucle) | /5 | | |
| Challenge les suggestions de l'IA | /5 | | |
| Sait quand NE PAS utiliser l'IA | /5 | | |

**Sous-total IA** : ___/25

---

### 3. Qualité du Code (20 points)

| Critère | Points | Score | Notes |
|---------|--------|-------|-------|
| Nommage clair (variables, méthodes, classes) | /5 | | |
| Séparation des responsabilités | /5 | | |
| Gestion des erreurs appropriée | /5 | | |
| Utilisation de DTOs vs Map<String, Object> | /5 | | |

**Sous-total qualité** : ___/20

---

### 4. Livraison de la Feature (15 points)

| Critère | Points | Score | Notes |
|---------|--------|-------|-------|
| Feature fonctionnelle | /5 | | |
| Feature testée | /5 | | |
| Code cohérent avec le refactoring | /5 | | |

**Sous-total feature** : ___/15

---

### 5. Bonus — Validation des Entrées (10 points)

> Uniquement si le candidat a traité le bonus. Ne pénalise pas s'il n'a pas eu le temps.

| Critère | Points | Score | Notes |
|---------|--------|-------|-------|
| Validation fonctionnelle (type obligatoire et valide, amount positif) | /4 | | |
| Retour HTTP 400 avec message explicite | /3 | | |
| Tests sur les cas de validation | /3 | | |

**Sous-total bonus** : ___/10

---

## 🏆 Score Total

| Section | Score |
|---------|-------|
| Méthodologie | /40 |
| Utilisation IA | /25 |
| Qualité code | /20 |
| Feature | /15 |
| **TOTAL** | **/100** |
| Bonus (validation entrées) | /10 |
| **TOTAL AVEC BONUS** | **/110** |

---

## 📈 Interprétation

| Score | Niveau | Décision |
|-------|--------|----------|
| 80-100 | Excellent | ✅ Hire |
| 65-79 | Bon | ✅ Hire (avec mentoring) |
| 50-64 | Moyen | ⚠️ Second entretien recommandé |
| < 50 | Insuffisant | ❌ No hire |

---

## 🎤 Questions de Débrief (5 min après le test)

À poser systématiquement :

1. "Pourquoi as-tu commencé par [ce qu'il a fait en premier] ?"
2. "Pourquoi as-tu choisi ce type de tests ? Qu'est-ce qui t'a guidé dans ce choix ?"
3. "Qu'est-ce que tu n'as pas eu le temps de faire ?"
4. "Y a-t-il des comportements dans le code original qui t'ont surpris ?"
5. "Comment aurais-tu fait différemment avec plus de temps ?"
6. "Qu'est-ce que l'IA a bien fait ? Mal fait ?"

Si le candidat a traité le bonus (validation des entrées) :

7. "Pourquoi as-tu choisi de faire la validation à cet endroit du code (controller / service / autre) ?"
8. "Quels champs as-tu choisi de valider et pourquoi ceux-là en priorité ?"

---

## 🤖 Prompt d'Aide à l'Évaluation

Après avoir récupéré le code du candidat, colle le prompt ci-dessous dans ton IA (ChatGPT, Claude, etc.) pour obtenir une pré-évaluation structurée. **Ce n'est qu'une aide** : l'évaluateur garde le dernier mot sur les scores.

> **Mode d'emploi** : copie le prompt, puis colle l'intégralité du code rendu par le candidat (tous les fichiers) à la suite.

> **Périmètre** : le prompt évalue le code (qualité, feature, tests de non-régression, bonus). Les sections **Méthodologie** et **Utilisation de l'IA** sont à remplir par l'évaluateur lors du débrief.

````
Tu es un évaluateur technique senior. Analyse le code ci-dessous, rendu par un candidat lors d'un test technique de 20 minutes. Le candidat devait refactorer un code legacy Java/Spring Boot (gestion de commandes) et implémenter une nouvelle feature.

## Code original (avant refactoring)

Le code de départ était un "god class" unique (Application.java) contenant tout : Spring Boot main, REST controller, JPA entity (classe interne statique `E`), persistence via EntityManager, business logic, notifications et discount. Variables et méthodes en noms abrégés (d, o, E, prcOrd, gtOrd, dlOrd, aDsc, toE, toM). Pas de tests. Map<String, Object> partout.

## Ta mission

1. **Vérifier les tests de non-régression** : analyse statiquement le code et détermine si chacun des 12 scénarios ci-dessous passerait ou échouerait.
2. **Évaluer la qualité du code** et la feature stats.
3. **Évaluer le bonus** (validation des entrées) si le candidat l'a traité.
4. **Remplir les sections correspondantes** du template `resultats.md` fourni en bas.

## Scénarios de non-régression à vérifier

Pour chaque scénario, indique PASS ou FAIL avec une justification courte si FAIL.

| # | Scénario | Vérification attendue |
|---|----------|----------------------|
| 1 | POST std, amount=500 | HTTP 200, amount reste 500 (pas de remise <= 1000) |
| 2 | POST prm, amount=800 | premium=true, amount=648 (800 * 0.9 * 0.9) |
| 3 | POST prm, amount=1000 | amount=810 (1000 * 0.9 * 0.9) |
| 4 | POST exp, amount=200 | HTTP 200 |
| 5 | POST std, email="" | HTTP 200 (email vide ne bloque pas) |
| 6 | POST std, sans champ email | HTTP 200 (email absent ne bloque pas) |
| 7 | GET commande existante | HTTP 200, body contient type, amount, email |
| 8 | GET commande inexistante | HTTP 404 |
| 9 | DELETE puis GET | DELETE retourne 200, GET retourne 404 |
| 10 | DELETE commande inexistante | HTTP 200 |
| 11 | GET /api/ord/stats | Contient totalOrders, ordersByType (standard/premium/express), totalRevenue, averageOrderAmount. Exclut les commandes supprimées. |
| 12 | POST std, amount=2000 | amount=1800 (2000 * 0.9, remise 10% car > 1000) |

IMPORTANT pour les scénarios 5 et 6 : si le candidat a ajouté une validation sur l'email qui retourne 400, c'est une RÉGRESSION. L'email vide/absent doit être accepté (le catch silencieux est intentionnel).

## Grille d'évaluation

### 1. Tests de non-régression (analyse statique)

Remplis le tableau PASS/FAIL pour les 12 scénarios ci-dessus. Compte le nombre total de PASS.

### 2. Qualité du Code (20 pts)

| Critère | Barème |
|---------|--------|
| Nommage clair (variables, méthodes, classes) | /5 |
| Séparation des responsabilités (controller/service/repository) | /5 |
| Gestion des erreurs appropriée | /5 |
| Utilisation de DTOs vs Map<String, Object> | /5 |

### 3. Feature stats (15 pts)

| Critère | Barème |
|---------|--------|
| Feature fonctionnelle (totalOrders, ordersByType avec mapping std→standard/prm→premium/exp→express, totalRevenue, averageOrderAmount, exclut soft-deleted) | /5 |
| Feature testée | /5 |
| Code cohérent avec le refactoring | /5 |

### 4. Bonus — Validation des entrées (10 pts, uniquement si traité)

| Critère | Barème |
|---------|--------|
| Contrôles pertinents et cohérents | /4 |
| Retour HTTP 400 avec message explicite | /3 |
| Tests sur les cas de validation | /3 |

## Format de réponse attendu

Réponds directement au format `resultats.md` suivant (remplis uniquement les sections indiquées, laisse les autres vides pour l'évaluateur) :

```markdown
## 1. Tests de non-régression (analyse statique)

| # | Scénario | Résultat | Commentaire |
|---|----------|----------|-------------|
| 1 | Commande std, amount=500 | PASS/FAIL | |
| 2 | Commande prm, amount=800 | PASS/FAIL | |
| 3 | Commande prm, amount=1000 | PASS/FAIL | |
| 4 | Commande exp | PASS/FAIL | |
| 5 | Email vide | PASS/FAIL | |
| 6 | Email absent | PASS/FAIL | |
| 7 | GET existante | PASS/FAIL | |
| 8 | GET inexistante | PASS/FAIL | |
| 9 | Soft delete | PASS/FAIL | |
| 10 | DELETE inexistante | PASS/FAIL | |
| 11 | Stats endpoint | PASS/FAIL | |
| 12 | Commande std, amount=2000 | PASS/FAIL | |

**Résultat** : ___/12 PASS

## 2. Qualité du Code (20 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Nommage clair | /5 | |
| Séparation des responsabilités | /5 | |
| Gestion des erreurs | /5 | |
| Utilisation de DTOs | /5 | |

**Sous-total** : ___/20

## 3. Feature stats (15 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Feature fonctionnelle | /5 | |
| Feature testée | /5 | |
| Code cohérent avec le refactoring | /5 | |

**Sous-total** : ___/15

## 4. Bonus — Validation des entrées (10 pts)

> Laisser vide si le candidat n'a pas traité le bonus.

| Critère | Score | Justification |
|---------|-------|---------------|
| Contrôles pertinents et cohérents | /4 | |
| Retour HTTP 400 avec message explicite | /3 | |
| Tests sur les cas de validation | /3 | |

**Sous-total** : ___/10

## Synthèse IA

- **Score code + feature** : ___/35 (+ bonus ___/10)
- **Tests de non-régression** : ___/12 PASS
- **3 points forts** :
- **3 axes d'amélioration** :
- **Régressions détectées** : (lister les scénarios FAIL et l'impact)
```

## Code du candidat à analyser :
````

---

## 📝 Template `resultats.md`

A la fin de l'évaluation, copie le template ci-dessous dans un fichier `resultats.md` et remplis-le. Ce fichier constitue le livrable de l'évaluation.

````markdown
# Résultats — Test Technique IA

**Candidat** : _________________________
**Date** : _________________________
**Évaluateur** : _________________________

---

## 1. Tests automatiques (test-scenarios.sh)

- Résultat global : ___/12 PASS
- Scénarios en échec :


---

## 2. Scores

### Méthodologie (40 pts)

| Critère | Score | Notes |
|---------|-------|-------|
| Tests écrits AVANT le refactoring | /10 | |
| Bon type de tests (intégration HTTP) | /10 | |
| Cas nominaux et edge cases couverts | /10 | |
| Règles fonctionnelles couvertes | /10 | |

**Sous-total** : ___/40

### Utilisation de l'IA (25 pts)

| Critère | Score | Notes |
|---------|-------|-------|
| Prompts clairs et structurés | /10 | |
| Itère intelligemment | /5 | |
| Challenge les suggestions de l'IA | /5 | |
| Sait quand NE PAS utiliser l'IA | /5 | |

**Sous-total** : ___/25

### Qualité du Code (20 pts)

| Critère | Score | Notes |
|---------|-------|-------|
| Nommage clair | /5 | |
| Séparation des responsabilités | /5 | |
| Gestion des erreurs | /5 | |
| Utilisation de DTOs | /5 | |

**Sous-total** : ___/20

### Feature stats (15 pts)

| Critère | Score | Notes |
|---------|-------|-------|
| Feature fonctionnelle | /5 | |
| Feature testée | /5 | |
| Code cohérent avec le refactoring | /5 | |

**Sous-total** : ___/15

### Bonus — Validation des entrées (10 pts)

> Laisser vide si le candidat n'a pas traité le bonus.

| Critère | Score | Notes |
|---------|-------|-------|
| Contrôles pertinents et cohérents | /4 | |
| Retour HTTP 400 avec message explicite | /3 | |
| Tests sur les cas de validation | /3 | |

**Sous-total** : ___/10

---

## 3. Débrief candidat

**"Pourquoi as-tu commencé par [ce qu'il a fait en premier] ?"**


**"Pourquoi as-tu choisi ce type de tests ?"**


**"Qu'est-ce que tu n'as pas eu le temps de faire ?"**


**"Y a-t-il des comportements dans le code qui t'ont surpris ?"**


**"Comment aurais-tu fait différemment avec plus de temps ?"**


**"Qu'est-ce que l'IA a bien fait ? Mal fait ?"**


**Si bonus traité — "Pourquoi la validation à cet endroit du code ?"**


**Si bonus traité — "Quels champs validés et pourquoi ceux-là en priorité ?"**


---

## 4. Observations pendant le test

### Signaux positifs observés :


### Signaux d'alerte observés :


### Comportement face à la pression du temps :


---

## 5. Synthèse

| Section | Score |
|---------|-------|
| Méthodologie | /40 |
| Utilisation IA | /25 |
| Qualité code | /20 |
| Feature | /15 |
| **TOTAL** | **/100** |
| Bonus | /10 |
| **TOTAL AVEC BONUS** | **/110** |

### Points forts :


### Axes d'amélioration :


### Recommandation finale :

- [ ] Hire
- [ ] Hire (avec mentoring)
- [ ] Second entretien recommandé
- [ ] No hire

**Commentaire** :

````

---

*Guide créé pour évaluer les développeurs dans un contexte réaliste d'utilisation de l'IA — 2026*
