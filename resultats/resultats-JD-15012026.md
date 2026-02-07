# Résultats — Test Technique IA

**Candidat** : Jean Dupont
**Date** : 15/01/2026
**Évaluateur** : Marie Martin

---

## 1. Tests de non-régression

### Analyse statique par IA

| # | Scénario | Résultat | Commentaire |
|---|----------|----------|-------------|
| 1 | Commande std, amount=500 | PASS | Amount inchangé, pas de remise appliquée |
| 2 | Commande prm, amount=800 | PASS | premium=true, amount=648 (double discount correct) |
| 3 | Commande prm, amount=1000 | PASS | amount=810 (1000 * 0.9 * 0.9) |
| 4 | Commande exp | PASS | Création OK |
| 5 | Email vide | PASS | Pas de validation bloquante sur l'email |
| 6 | Email absent | PASS | Pas de validation bloquante sur l'email |
| 7 | GET existante | PASS | Retourne type, amount, email |
| 8 | GET inexistante | PASS | HTTP 404 |
| 9 | Soft delete | PASS | DELETE 200 puis GET 404 |
| 10 | DELETE inexistante | PASS | HTTP 200 |
| 11 | Stats endpoint | PASS | Tous les champs présents, exclut les supprimées |
| 12 | Commande std, amount=2000 | FAIL | Retourne 2000 au lieu de 1800 — le candidat a supprimé le discount standard par erreur lors du refactoring |

**Résultat IA** : 11/12 PASS

### Confirmation par test-scenarios.sh

- Résultat script : 11/12 PASS
- Écarts avec l'analyse IA : Aucun écart, l'analyse IA est confirmée.

---

## 2. Scores

### Qualité du Code (20 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Nommage clair | 4/5 | Bon renommage des classes et méthodes. Quelques variables locales encore abrégées. |
| Séparation des responsabilités | 4/5 | Controller/Service/Repository bien séparés. La logique de notification reste dans le service. |
| Gestion des erreurs | 3/5 | 404 géré correctement. Pas de gestion des erreurs de persistence. |
| Utilisation de DTOs | 4/5 | DTO pour la requête et la réponse. Map supprimé. |

**Sous-total** : 15/20

### Feature stats (15 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Feature fonctionnelle | 5/5 | Tous les champs présents, mapping des types correct, exclut les soft-deleted. |
| Feature testée | 3/5 | Test d'intégration présent mais ne vérifie que le cas nominal. |
| Code cohérent avec le refactoring | 5/5 | Utilise le repository et le service, cohérent avec l'architecture. |

**Sous-total** : 13/15

### Méthodologie (40 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Tests écrits AVANT le refactoring | 8/10 | A écrit les tests d'intégration rapidement mais a commencé à renommer quelques variables avant. |
| Bon type de tests (intégration HTTP) | 10/10 | Tests d'intégration HTTP avec MockMvc dès le départ. Pas de tests unitaires sur le legacy. |
| Cas nominaux et edge cases couverts | 6/10 | Cas nominaux bien couverts. Manque les edge cases : email vide, discount standard > 1000. |
| Règles fonctionnelles couvertes | 5/10 | Double discount premium testé. Manque le seuil 1000€ standard (d'où la régression). Soft delete non testé. |

**Sous-total** : 29/40

### Utilisation de l'IA (25 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Prompts clairs et structurés | 7/10 | Bons prompts avec contexte. Aurait pu préciser les contraintes de non-régression. |
| Itère intelligemment | 4/5 | Ajuste ses prompts quand le résultat ne convient pas. Une seule boucle de copier-coller. |
| Challenge les suggestions de l'IA | 3/5 | Relit le code généré mais n'a pas détecté la suppression du discount standard. |
| Sait quand NE PAS utiliser l'IA | 4/5 | A réfléchi seul à l'architecture avant de demander à l'IA de générer le code. |

**Sous-total** : 18/25

### Bonus — Validation des entrées (10 pts)

| Critère | Score | Justification |
|---------|-------|---------------|
| Contrôles pertinents et cohérents | 3/4 | Valide type (obligatoire, valeurs autorisées) et amount (positif). Ne valide pas les types inconnus. |
| Retour HTTP 400 avec message explicite | 3/3 | Messages clairs : "Le type est obligatoire", "Le montant doit être positif". |
| Tests sur les cas de validation | 2/3 | Tests sur type manquant et amount négatif. Manque le test sur un type invalide. |

**Sous-total** : 8/10

---

## 3. Débrief candidat

**"Pourquoi as-tu commencé par [ce qu'il a fait en premier] ?"**

"J'ai commencé par lire le code pour comprendre la logique métier, puis j'ai écrit des tests d'intégration HTTP pour sécuriser le comportement avant de refactorer. J'ai renommé quelques variables d'abord pour mieux comprendre, puis j'ai écrit les tests."

**"Pourquoi as-tu choisi ce type de tests ?"**

"Des tests d'intégration HTTP parce que je voulais tester le comportement de l'API sans dépendre de l'implémentation interne. Comme ça, je pouvais refactorer librement sans casser mes tests."

**"Qu'est-ce que tu n'as pas eu le temps de faire ?"**

"J'aurais voulu ajouter plus de tests edge cases, notamment sur le soft delete et les discounts. Et aussi mieux structurer la gestion des erreurs."

**"Y a-t-il des comportements dans le code qui t'ont surpris ?"**

"Le double discount pour premium m'a surpris — 0.9 * 0.9 au lieu de 0.8. Et le catch silencieux sur les notifications, j'ai failli le supprimer avant de comprendre que c'était voulu."

**"Comment aurais-tu fait différemment avec plus de temps ?"**

"Plus de tests, une meilleure couverture des règles métier, et j'aurais ajouté de la validation sur les entrées dès le départ."

**"Qu'est-ce que l'IA a bien fait ? Mal fait ?"**

"L'IA m'a bien aidé à structurer le refactoring et générer les tests. Par contre, elle a simplifié le discount standard en supprimant le seuil des 1000€, et je ne l'ai pas vu."

**Si bonus traité — "Pourquoi la validation à cet endroit du code ?"**

"J'ai mis la validation dans le controller parce que c'est la porte d'entrée de l'API. Les erreurs de format doivent être détectées avant d'atteindre la logique métier."

**Si bonus traité — "Quels champs validés et pourquoi ceux-là en priorité ?"**

"Le type et le montant, parce que ce sont les champs critiques pour la logique métier. Sans type valide, on ne sait pas quel traitement appliquer. Sans montant positif, la commande n'a pas de sens."

---

## 4. Observations pendant le test

### Signaux positifs observés :

- A lu le code attentivement avant de commencer (3-4 min)
- A demandé à l'IA d'expliquer le code legacy avant de le modifier
- A écrit des tests d'intégration HTTP (bon réflexe)
- A relancé les tests après chaque étape de refactoring
- Gardait un oeil sur le temps

### Signaux d'alerte observés :

- N'a pas détecté que l'IA avait supprimé le seuil 1000€ pour le discount standard
- A accepté le refactoring du service sans vérifier chaque règle métier

### Comportement face à la pression du temps :

- Calme et méthodique. A priorisé le refactoring et les tests avant la feature stats. A traité le bonus dans les 3 dernières minutes — peut-être un peu précipité mais le résultat est correct.

---

## 5. Synthèse

| Section | Score |
|---------|-------|
| Méthodologie | 29/40 |
| Utilisation IA | 18/25 |
| Qualité code | 15/20 |
| Feature | 13/15 |
| **TOTAL** | **75/100** |
| Bonus | 8/10 |
| **TOTAL AVEC BONUS** | **83/110** |

### Points forts :

1. Bonne approche méthodologique : tests d'intégration HTTP avant refactoring
2. Code bien structuré après refactoring (séparation controller/service/repository, DTOs)
3. Feature stats complète et fonctionnelle, cohérente avec l'architecture

### Axes d'amélioration :

1. Couverture de tests insuffisante sur les edge cases (discount standard > 1000€, soft delete)
2. Relecture insuffisante du code généré par l'IA — la régression sur le discount standard aurait pu être évitée
3. Aurait dû tester chaque règle fonctionnelle du SUJET.md systématiquement

### Régressions détectées :

- **Scénario 12 (FAIL)** : Le discount standard pour les commandes > 1000€ a été supprimé lors du refactoring. Une commande de 2000€ retourne 2000 au lieu de 1800. Impact : perte de la logique de remise pour les gros montants standard.

### Recommandation finale :

> Exemple — en conditions réelles, à remplir par l'évaluateur.

- [ ] Hire
- [x] Hire (avec mentoring)
- [ ] Second entretien recommandé
- [ ] No hire

**Commentaire** : Bon profil avec les bons réflexes (test-first, intégration HTTP, lecture du code avant modification). La régression sur le discount standard montre un manque de rigueur dans la relecture du code IA, mais le candidat en est conscient et l'a identifié lui-même au débrief. Avec un accompagnement sur la discipline de vérification systématique, c'est un profil qui peut rapidement monter en compétence.
