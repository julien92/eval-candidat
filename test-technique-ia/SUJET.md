# Test Technique Développeur — Édition IA 2026

## 🚀 Lancer le projet

```bash
# Prérequis : Java 17+, Maven
mvn spring-boot:run

# L'API est disponible sur http://localhost:8080
```

---

## 📋 Contexte

Tu rejoins une équipe qui maintient un système de gestion de commandes legacy. Le code fonctionne en production depuis 5 ans, mais personne n'ose y toucher.

Ta mission : refactorer ce code ET ajouter une nouvelle fonctionnalité.

---

## ⏱️ Règles

- **Durée** : 20 minutes
- **Outils autorisés** : IA de ton choix (ChatGPT, Claude, Copilot, etc.)
- **Contrainte absolue** : Zéro régression — le comportement existant doit être préservé
- **Livrable** : Code refactoré + nouvelle feature + tests

---

## 💀 Le Code Legacy

```java
@RestController
@RequestMapping("/api")
public class OrdCtrl {

    @Autowired
    private OrdDao dao;

    @Autowired
    private DscSvc dscSvc;

    @PostMapping("/ord")
    public ResponseEntity prcOrd(@RequestBody Map<String, Object> d) {
        if(d.get("t").equals("std")){
            dao.s(d);
            try{dao.n(d.get("m"),d);}catch(Exception e){/**/}
            if(d.get("a")!=null&&Integer.parseInt(d.get("a").toString())>1000){
                dao.s(d);dscSvc.aDsc(d);
            }
        }
        if(d.get("t").equals("prm")){
            d.put("pr",true);dao.s(d);
            try{dao.n(d.get("m"),d);}catch(Exception e){/**/}
            if(d.get("a")!=null){dscSvc.aDsc(d);dscSvc.aDsc(d);}
            dao.s(d);
        }
        if(d.get("t").equals("exp")){
            dao.sExp(d);
            try{dao.nExp(d.get("m"),d);}catch(Exception e){System.out.println("err");}
        }
        return ResponseEntity.ok(d);
    }

    @GetMapping("/ord/{id}")
    public ResponseEntity gtOrd(@PathVariable String id) {
        Map<String, Object> o = dao.g(id);
        if(o==null){return ResponseEntity.notFound().build();}
        if(o.get("st")!=null&&o.get("st").equals("del")){return ResponseEntity.notFound().build();}
        return ResponseEntity.ok(o);
    }

    @DeleteMapping("/ord/{id}")
    public ResponseEntity dlOrd(@PathVariable String id) {
        Map<String, Object> o = dao.g(id);
        if(o!=null){o.put("st","del");dao.s(o);}
        return ResponseEntity.ok().build();
    }
}
```

### Classes annexes (fournies, non modifiables)

```java
@Repository
public class OrdDao {
    public void s(Map<String, Object> d) { /* save */ }
    public void sExp(Map<String, Object> d) { /* save express */ }
    public Map<String, Object> g(String id) { /* get by id */ }
    public List<Map<String, Object>> getAll() { /* get all orders */ }
    public void n(Object email, Map<String, Object> d) { /* notify */ }
    public void nExp(Object email, Map<String, Object> d) { /* notify express */ }
}

@Service
public class DscSvc {
    public void aDsc(Map<String, Object> d) { /* apply discount */ }
}
```

---

## 🆕 Nouvelle Feature à Implémenter

**Fonctionnalité** : Ajouter un endpoint `GET /api/ord/stats` qui retourne les statistiques suivantes :

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
- Utiliser le `OrdDao` existant
- Les commandes supprimées ne doivent PAS être comptées
- Le code doit suivre les mêmes standards de qualité que ton refactoring

---

## 📝 Ce qu'on attend

1. **Refactoring** du code existant (lisibilité, maintenabilité, bonnes pratiques)
2. **Implémentation** de la nouvelle feature

**Rappel** : Le comportement existant doit être préservé. À toi de garantir qu'il n'y a pas de régression.

---

Bonne chance ! ⏱️
