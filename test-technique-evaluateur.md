# Guide Évaluateur — Test Technique IA 2026

> ⚠️ **CONFIDENTIEL** — Ne pas partager avec le candidat

---

## 🚀 Lancer les Tests de Non-Régression

À la fin des 20 minutes, lance le script sur le code du candidat :

```bash
chmod +x test-scenarios.sh
./test-scenarios.sh http://localhost:8080
```

Le script vérifie automatiquement tous les comportements métier cachés et affiche un score PASS/FAIL.

---

## 🎯 Objectif du Test

Évaluer la capacité d'un développeur à :
1. Travailler avec du code legacy en conditions réelles
2. Utiliser l'IA comme accélérateur (pas comme béquille)
3. Avoir le réflexe de sécuriser avant de modifier
4. Livrer sous contrainte de temps

---

## 🚫 Comportements Métier Cachés

Ces comportements doivent être découverts par le candidat via ses tests. **Ne jamais les révéler.**

| # | Comportement | Explication métier |
|---|--------------|-------------------|
| 1 | **Double save pour premium** | Le premier `save` avant le discount crée l'état "commande reçue", le second après crée "commande finalisée". Nécessaire pour l'audit comptable. |
| 2 | **Double discount pour premium** | `aDsc()` est appelé deux fois. Les clients premium reçoivent 10% + 10% = 19% (pas 20%). Bug devenu feature, les clients s'y sont habitués. |
| 3 | **Catch silencieux sur notify** | Les notifications email ne doivent JAMAIS bloquer une commande. Un serveur mail down ne doit pas faire perdre des ventes. |
| 4 | **Soft delete uniquement** | La suppression est logique (`st = "del"`), jamais physique. Obligatoire pour la comptabilité et les audits. |
| 5 | **Threshold 1000€ pour standard uniquement** | Le discount standard s'applique seulement au-dessus de 1000€. Le discount premium s'applique toujours, quel que soit le montant. |
| 6 | **Flag "pr" pour premium** | `d.put("pr", true)` marque la commande comme premium avant le save. Utilisé par d'autres systèmes en aval. |

---

## 👀 Ce qu'il faut Observer

### Signaux Positifs ✅

- [ ] Commence par lire et comprendre le code
- [ ] Écrit (ou fait écrire) des tests AVANT de toucher au code
- [ ] Demande à l'IA d'expliquer le code avant de le modifier
- [ ] Pose des questions de clarification
- [ ] Relit et challenge les suggestions de l'IA
- [ ] Lance les tests entre chaque modification
- [ ] Gère son temps (regarde l'horloge)

### Signaux d'Alerte 🚩

- [ ] Fonce directement dans le refacto sans tests
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
| Écrit des tests AVANT de refactorer | /15 | | |
| Tests couvrent les cas nominaux | /10 | | |
| Tests couvrent les edge cases | /10 | | |
| Tests détectent les comportements métier cachés | /5 | | |

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

## 🏆 Score Total

| Section | Score |
|---------|-------|
| Méthodologie | /40 |
| Utilisation IA | /25 |
| Qualité code | /20 |
| Feature | /15 |
| **TOTAL** | **/100** |

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
2. "Qu'est-ce que tu n'as pas eu le temps de faire ?"
3. "Y a-t-il des comportements dans le code original qui t'ont surpris ?"
4. "Comment aurais-tu fait différemment avec plus de temps ?"
5. "Qu'est-ce que l'IA a bien fait ? Mal fait ?"

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
