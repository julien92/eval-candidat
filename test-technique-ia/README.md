# Test Technique — Legacy Order System

## Lancer le projet

```bash
# Prerequis : Java 17+

# Lancer l'application (Maven Wrapper inclus, pas besoin d'installer Maven)
./mvnw spring-boot:run

# L'API est disponible sur http://localhost:8080
```

## Endpoints disponibles

| Methode | URL | Description |
|---------|-----|-------------|
| POST | /api/ord | Creer une commande |
| GET | /api/ord/{id} | Recuperer une commande |
| DELETE | /api/ord/{id} | Supprimer une commande |

## Format des commandes

```json
{
  "type": "std",
  "email": "email@test.com",
  "amount": 1500
}
```

## Base de donnees

H2 en memoire — console disponible sur http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:testdb`
- User: `sa`
- Password: (vide)
