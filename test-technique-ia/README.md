# Test Technique — Legacy Order System

## 🚀 Lancer le projet

```bash
# Prérequis : Java 17+, Maven

# Lancer l'application
mvn spring-boot:run

# L'API est disponible sur http://localhost:8080
```

## 📡 Endpoints disponibles

| Méthode | URL | Description |
|---------|-----|-------------|
| POST | /api/ord | Créer une commande |
| GET | /api/ord/{id} | Récupérer une commande |
| DELETE | /api/ord/{id} | Supprimer une commande |

## 📦 Format des commandes

```json
{
  "t": "std",           // Type: std, prm, exp
  "m": "email@test.com", // Email client
  "a": 1500             // Montant
}
```

## 🗄️ Base de données

H2 en mémoire — console disponible sur http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:testdb`
- User: `sa`
- Password: (vide)
