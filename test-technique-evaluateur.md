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
