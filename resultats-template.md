# Résultats — Test Technique IA

> Copier ce fichier dans le dossier `resultats/` et le renommer `resultats-XX-DDMMYYYY.md` (initiales du candidat + date, ex : `resultats-JD-15012026.md` pour Jean Dupont testé le 15/01/2026).
>
> **Alternative** : utiliser le prompt `prompt-evaluation-code.md` pour générer ce fichier automatiquement via l'IA.

**Candidat** : _________________________
**Date** : _________________________
**Évaluateur** : _________________________

---

## 1. Tests de non-régression

### Analyse statique par IA

> Coller ici la sortie du prompt `prompt-evaluation-code.md` (section tests de non-régression).

| # | Scénario | Résultat | Commentaire |
|---|----------|----------|-------------|
| 1 | Commande std, amount=500 | | |
| 2 | Commande prm, amount=800 | | |
| 3 | Commande prm, amount=1000 | | |
| 4 | Commande exp | | |
| 5 | Email vide | | |
| 6 | Email absent | | |
| 7 | GET existante | | |
| 8 | GET inexistante | | |
| 9 | Soft delete | | |
| 10 | DELETE inexistante | | |
| 11 | Stats endpoint | | |
| 12 | Commande std, amount=2000 | | |

**Résultat IA** : ___/12 PASS

### Confirmation par test-scenarios.sh

- Résultat script : ___/12 PASS
- Écarts avec l'analyse IA :


---

## 2. Scores

### Qualité du Code (20 pts)

> Coller ici la sortie du prompt `prompt-evaluation-code.md` (section qualité).

| Critère | Score | Justification |
|---------|-------|---------------|
| Nommage clair | /5 | |
| Séparation des responsabilités | /5 | |
| Gestion des erreurs | /5 | |
| Utilisation de DTOs | /5 | |

**Sous-total** : ___/20

### Feature stats (15 pts)

> Coller ici la sortie du prompt `prompt-evaluation-code.md` (section feature).

| Critère | Score | Justification |
|---------|-------|---------------|
| Feature fonctionnelle | /5 | |
| Feature testée | /5 | |
| Code cohérent avec le refactoring | /5 | |

**Sous-total** : ___/15

### Méthodologie (40 pts)

> Coller ici la sortie du prompt `prompt-evaluation-debrief.md` (section méthodologie).

| Critère | Score | Justification |
|---------|-------|---------------|
| Tests écrits AVANT le refactoring | /10 | |
| Bon type de tests (intégration HTTP) | /10 | |
| Cas nominaux et edge cases couverts | /10 | |
| Règles fonctionnelles couvertes | /10 | |

**Sous-total** : ___/40

### Utilisation de l'IA (25 pts)

> Coller ici la sortie du prompt `prompt-evaluation-debrief.md` (section utilisation IA).

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
