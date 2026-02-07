# Test Technique Developpeur — Edition IA 2026

## Lancer le projet

```bash
# Prerequis : Java 17+, Maven
mvn spring-boot:run

# L'API est disponible sur http://localhost:8080
```

---

## Contexte

Tu rejoins une equipe qui maintient un systeme de gestion de commandes legacy. Le code fonctionne en production depuis 5 ans, mais personne n'ose y toucher.

Ta mission : refactorer ce code ET ajouter une nouvelle fonctionnalite.

---

## Regles

- **Duree** : 20 minutes
- **Outils autorises** : IA de ton choix (ChatGPT, Claude, Copilot, etc.)
- **Contrainte absolue** : Zero regression — le comportement existant doit etre preserve
- **Livrable** : Code refactore + nouvelle feature

---

## Regles fonctionnelles du systeme

### Commandes Standard (`type: "std"`)

- La creation d'une commande standard retourne un code HTTP 200
- La commande est sauvegardee en base a la creation
- Une notification est envoyee par email apres la sauvegarde
- Si le montant (`amount`) depasse 1000, une remise de 10% est appliquee (la commande est re-sauvegardee apres la remise)
- Si le montant est inferieur ou egal a 1000, aucune remise n'est appliquee

### Commandes Premium (`type: "prm"`)

- La creation d'une commande premium retourne un code HTTP 200
- Le flag premium (`premium: true`) est positionne sur la commande
- La commande est sauvegardee une premiere fois a la creation
- Une notification est envoyee par email apres la premiere sauvegarde
- Une double remise de 10% est appliquee sur le montant quel que soit le montant (ex : 1000 * 0.9 * 0.9 = 810)
- La commande est re-sauvegardee apres l'application des remises

### Commandes Express (`type: "exp"`)

- La creation d'une commande express retourne un code HTTP 200
- La commande est sauvegardee en base
- Une notification est envoyee par email apres la sauvegarde

### Notifications

- L'echec d'envoi d'un email (email vide ou absent) ne doit jamais bloquer la creation d'une commande
- La commande doit etre creee avec succes meme si la notification echoue

### Consultation

- La recuperation d'une commande existante par son ID retourne un code HTTP 200 avec les donnees de la commande
- La recuperation d'une commande inexistante retourne un code HTTP 404

### Suppression

- La suppression est logique (soft delete) : le statut de la commande passe a `"del"`
- Une commande supprimee n'est plus accessible en consultation (retourne HTTP 404)

---

## Nouvelle Feature a Implementer

**Fonctionnalite** : Ajouter un endpoint `GET /api/ord/stats` qui retourne les statistiques suivantes :

```json
{
  "totalOrders": 150,
  "ordersByType": {
    "standard": 80,
    "premium": 50,
    "express": 20
  },
  "totalRevenue": 125000,
  "averageOrderAmount": 833.33
}
```

**Contraintes** :
- Les commandes supprimees ne doivent PAS etre comptees
- Le code doit suivre les memes standards de qualite que ton refactoring

---

## Ce qu'on attend

1. **Refactoring** du code existant (lisibilite, maintenabilite, bonnes pratiques)
2. **Implementation** de la nouvelle feature

**Rappel** : Le comportement existant doit etre preserve. A toi de garantir qu'il n'y a pas de regression.

---

Bonne chance !
