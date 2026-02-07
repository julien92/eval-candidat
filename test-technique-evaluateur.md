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

> **Mode d'emploi** : copie le prompt, puis colle l'intégralité du code rendu par le candidat à la suite.

````
Tu es un évaluateur technique senior. Analyse le code ci-dessous, rendu par un candidat lors d'un test technique de 20 minutes. Le candidat devait refactorer un code legacy Java/Spring Boot (gestion de commandes) et implémenter une nouvelle feature.

## Code original (avant refactoring)

Le code de départ était un "god class" unique (Application.java) contenant tout : Spring Boot main, REST controller, JPA entity (classe interne statique `E`), persistence via EntityManager, business logic, notifications et discount. Variables et méthodes en noms abrégés (d, o, E, prcOrd, gtOrd, dlOrd, aDsc, toE, toM). Pas de tests. Map<String, Object> partout.

## Règles métier à préserver (non-régression)

1. Commandes standard (type "std") : sauvegardées 1 fois. Si amount > 1000, remise de 10% puis re-sauvegardées (2 saves au total).
2. Commandes premium (type "prm") : flag premium=true positionné, sauvegardées 1 fois, puis double remise 10%+10% = 19% (amount * 0.9 * 0.9), puis re-sauvegardées (2 saves au total).
3. Commandes express (type "exp") : sauvegardées et notifiées comme les standard, sans remise.
4. Les échecs de notification (email vide/absent) ne bloquent JAMAIS la création — le catch silencieux est intentionnel.
5. La suppression est un soft delete (status="del"), jamais physique. GET sur une commande supprimée retourne 404.

## Nouvelle feature demandée

GET /api/ord/stats retournant : totalOrders, ordersByType (avec mapping std→standard, prm→premium, exp→express), totalRevenue, averageOrderAmount. Exclure les commandes soft-deleted.

## Bonus (optionnel)

Validation des champs en entrée sur POST /api/ord avec retour HTTP 400. Le candidat choisissait lui-même quels contrôles ajouter.

## Grille d'évaluation (note chaque critère sur le barème indiqué)

### 1. Méthodologie (40 pts)
- Tests écrits AVANT le refactoring ? (/10)
- Bon type de tests choisi (intégration HTTP, pas unitaire sur le legacy) ? (/10)
- Cas nominaux ET edge cases couverts ? (/10)
- Règles fonctionnelles couvertes par les tests ? (/10)

### 2. Qualité du Code (20 pts)
- Nommage clair (variables, méthodes, classes) (/5)
- Séparation des responsabilités (controller/service/repository) (/5)
- Gestion des erreurs appropriée (/5)
- Utilisation de DTOs vs Map<String, Object> (/5)

### 3. Feature stats (15 pts)
- Feature fonctionnelle (/5)
- Feature testée (/5)
- Code cohérent avec le refactoring (/5)

### 4. Bonus — Validation des entrées (10 pts, uniquement si traité)
- Contrôles pertinents et cohérents (/4)
- Retour HTTP 400 avec message explicite (/3)
- Tests sur les cas de validation (/3)

## Format de réponse attendu

Pour chaque section :
1. Score attribué avec justification courte
2. Points positifs observés
3. Points d'amélioration

Termine par :
- Score total sur 100 (+ bonus /10 si applicable)
- 3 points forts principaux du candidat
- 3 axes d'amélioration prioritaires
- Recommandation : Hire / Hire avec mentoring / Second entretien / No hire

## Code du candidat à analyser :
````

---

## 📝 Notes de l'Entretien

**Candidat** : _________________________

**Date** : _________________________

**Évaluateur** : _________________________

### Points forts :



### Points d'amélioration :



### Questions posées par le candidat :



### Comportement face à la pression du temps :



### Recommandation finale :



---

*Guide créé pour évaluer les développeurs dans un contexte réaliste d'utilisation de l'IA — 2026*
