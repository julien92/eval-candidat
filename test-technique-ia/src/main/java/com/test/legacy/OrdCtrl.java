package com.test.legacy;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import java.util.*;

@RestController
@RequestMapping("/api")
@Transactional
public class OrdCtrl {

    @PersistenceContext
    private EntityManager em;

    private static final double DSC = 0.10;

    @PostMapping("/ord")
    public ResponseEntity prcOrd(@RequestBody Map<String, Object> d) {
        if(d.get("t").equals("std")){
            s(d);
            try{n(d.get("m"),d);}catch(Exception e){/**/}
            if(d.get("a")!=null&&Integer.parseInt(d.get("a").toString())>1000){
                s(d);aDsc(d);
            }
        }
        if(d.get("t").equals("prm")){
            d.put("pr",true);s(d);
            try{n(d.get("m"),d);}catch(Exception e){/**/}
            if(d.get("a")!=null){aDsc(d);aDsc(d);}
            s(d);
        }
        if(d.get("t").equals("exp")){
            s(d);
            try{n(d.get("m"),d);}catch(Exception e){System.out.println("err");}
        }
        return ResponseEntity.ok(d);
    }

    @GetMapping("/ord/{id}")
    public ResponseEntity gtOrd(@PathVariable String id) {
        Map<String, Object> o = g(id);
        if(o==null){return ResponseEntity.notFound().build();}
        if(o.get("st")!=null&&o.get("st").equals("del")){return ResponseEntity.notFound().build();}
        return ResponseEntity.ok(o);
    }

    @DeleteMapping("/ord/{id}")
    public ResponseEntity dlOrd(@PathVariable String id) {
        Map<String, Object> o = g(id);
        if(o!=null){o.put("st","del");s(o);}
        return ResponseEntity.ok().build();
    }

    private Map<String, Object> s(Map<String, Object> d) {
        E entity = toE(d);
        if (entity.id == null || em.find(E.class, entity.id) == null) {
            em.persist(entity);
        } else {
            entity = em.merge(entity);
        }
        d.put("id", entity.id);
        return d;
    }

    private Map<String, Object> g(String id) {
        E entity = em.find(E.class, id);
        if (entity == null) return null;
        return toM(entity);
    }

    private List<Map<String, Object>> getAll() {
        List<E> entities = em.createQuery("SELECT o FROM OrdCtrl$E o", E.class).getResultList();
        List<Map<String, Object>> result = new ArrayList<>();
        for (E e : entities) { result.add(toM(e)); }
        return result;
    }

    private void n(Object email, Map<String, Object> d) {
        if (email == null || email.toString().isEmpty()) {
            throw new RuntimeException("Email invalide");
        }
    }

    private void aDsc(Map<String, Object> d) {
        if (d.get("a") != null) {
            int amount = Integer.parseInt(d.get("a").toString());
            int discounted = (int) (amount * (1 - DSC));
            d.put("a", discounted);
        }
    }

    private E toE(Map<String, Object> d) {
        E e = new E();
        if (d.get("id") != null) e.id = d.get("id").toString();
        if (d.get("t") != null) e.t = d.get("t").toString();
        if (d.get("m") != null) e.m = d.get("m").toString();
        if (d.get("a") != null) e.a = Integer.parseInt(d.get("a").toString());
        if (d.get("st") != null) e.st = d.get("st").toString();
        if (d.get("pr") != null) e.pr = Boolean.parseBoolean(d.get("pr").toString());
        return e;
    }

    private Map<String, Object> toM(E e) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", e.id); m.put("t", e.t); m.put("m", e.m);
        m.put("a", e.a); m.put("st", e.st); m.put("pr", e.pr);
        return m;
    }

    @Entity @Table(name = "orders")
    public static class E {
        @Id @GeneratedValue(strategy = GenerationType.UUID)
        String id;
        String t;
        String m;
        Integer a;
        String st;
        Boolean pr;
        public E() {}
    }
}
