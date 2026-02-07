# Prompt IA — Évaluation du Code

> **Mode d'emploi** : copie le prompt ci-dessous dans ton IA (ChatGPT, Claude, etc.), puis colle l'intégralité du code rendu par le candidat (tous les fichiers) à la suite.
>
> **Résultat** : l'IA génère directement un fichier `resultats-XX.md` complet. Les sections code sont remplies, les sections débrief sont laissées vides pour l'étape suivante.

---

````
Tu es un évaluateur technique senior. Analyse le code ci-dessous, rendu par un candidat lors d'un test technique de 20 minutes. Le candidat devait refactorer un code legacy Java/Spring Boot (gestion de commandes) et implémenter une nouvelle feature.

## Étape préalable

Avant toute analyse, demande le **prénom et nom du candidat** (pour nommer le fichier `resultats-XX.md` avec les initiales, ex : Jean Dupont → `resultats-JD.md`).

## Code original (avant refactoring)

Le code de départ était un "god class" unique (Application.java) contenant tout : Spring Boot main, REST controller, JPA entity (classe interne statique `E`), persistence via EntityManager, business logic, notifications et discount. Variables et méthodes en noms abrégés (d, o, E, prcOrd, gtOrd, dlOrd, aDsc, toE, toM). Pas de tests. Map<String, Object> partout.

## Ta mission

1. **Vérifier les tests de non-régression** : analyse statiquement le code et détermine si chacun des 12 scénarios ci-dessous passerait ou échouerait.
2. **Évaluer la qualité du code** et la feature stats.
3. **Évaluer le bonus** (validation des entrées) si le candidat l'a traité.
4. **Générer le fichier `resultats-XX.md` complet** avec les sections code remplies et les sections débrief vides.

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

### Qualité du Code (20 pts)

| Critère | Barème |
|---------|--------|
| Nommage clair (variables, méthodes, classes) | /5 |
| Séparation des responsabilités (controller/service/repository) | /5 |
| Gestion des erreurs appropriée | /5 |
| Utilisation de DTOs vs Map<String, Object> | /5 |

### Feature stats (15 pts)

| Critère | Barème |
|---------|--------|
| Feature fonctionnelle (totalOrders, ordersByType avec mapping std→standard/prm→premium/exp→express, totalRevenue, averageOrderAmount, exclut soft-deleted) | /5 |
| Feature testée | /5 |
| Code cohérent avec le refactoring | /5 |

### Bonus — Validation des entrées (10 pts, uniquement si traité)

| Critère | Barème |
|---------|--------|
| Contrôles pertinents et cohérents | /4 |
| Retour HTTP 400 avec message explicite | /3 |
| Tests sur les cas de validation | /3 |

## Format de réponse attendu

Génère directement le fichier `resultats-XX.md` complet ci-dessous. Remplis les sections code (non-régression, qualité, feature, bonus, synthèse IA). Laisse les sections débrief (méthodologie, utilisation IA, questions, observations) avec les placeholders vides — elles seront remplies à l'étape suivante.

```markdown
# Résultats — Test Technique IA

**Candidat** : [Prénom Nom]
**Date** : _________________________
**Évaluateur** : _________________________

---

## 1. Tests de non-régression

### Analyse statique par IA

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

**Résultat IA** : ___/12 PASS

### Confirmation par test-scenarios.sh

> À remplir après exécution du script.

- Résultat script : ___/12 PASS
- Écarts avec l'analyse IA :

---

## 2. Scores

### Qualité du Code (20 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Nommage clair | /5 | |
| Séparation des responsabilités | /5 | |
| Gestion des erreurs | /5 | |
| Utilisation de DTOs | /5 | |

**Sous-total** : ___/20

### Feature stats (15 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Feature fonctionnelle | /5 | |
| Feature testée | /5 | |
| Code cohérent avec le refactoring | /5 | |

**Sous-total** : ___/15

### Méthodologie (40 pts)

> À remplir via le prompt débrief (`prompt-evaluation-debrief.md`).

| Critère | Score | Justification |
|---------|-------|---------------|
| Tests écrits AVANT le refactoring | /10 | |
| Bon type de tests (intégration HTTP) | /10 | |
| Cas nominaux et edge cases couverts | /10 | |
| Règles fonctionnelles couvertes | /10 | |

**Sous-total** : ___/40

### Utilisation de l'IA (25 pts)

> À remplir via le prompt débrief (`prompt-evaluation-debrief.md`).

| Critère | Score | Justification |
|---------|-------|---------------|
| Prompts clairs et structurés | /10 | |
| Itère intelligemment | /5 | |
| Challenge les suggestions de l'IA | /5 | |
| Sait quand NE PAS utiliser l'IA | /5 | |

**Sous-total** : ___/25

### Bonus — Validation des entrées (10 pts)

> Laisser vide si le candidat n'a pas traité le bonus.

| Critère | Score | Justification |
|---------|-------|---------------|
| Contrôles pertinents et cohérents | /4 | |
| Retour HTTP 400 avec message explicite | /3 | |
| Tests sur les cas de validation | /3 | |

**Sous-total** : ___/10

---

## 3. Débrief candidat

> À remplir pendant le débrief.

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

> À remplir par l'évaluateur.

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

[Rempli par l'IA — 3 points forts identifiés dans le code]

### Axes d'amélioration :

[Rempli par l'IA — 3 axes d'amélioration identifiés dans le code]

### Régressions détectées :

[Rempli par l'IA — lister les scénarios FAIL et leur impact]

### Recommandation finale :

> À remplir par l'évaluateur après le débrief.

- [ ] Hire
- [ ] Hire (avec mentoring)
- [ ] Second entretien recommandé
- [ ] No hire

**Commentaire** :
```

## Code du candidat à analyser :
````
