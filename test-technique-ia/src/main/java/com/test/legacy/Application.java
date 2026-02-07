package com.test.legacy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import java.util.*;

@SpringBootApplication
@RestController
@RequestMapping("/api")
@Transactional
public class Application {

    @PersistenceContext
    private EntityManager em;

    private static final double DSC = 0.10;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @PostMapping("/ord")
    public ResponseEntity prcOrd(@RequestBody Map<String, Object> d) {
        if(d.get("type").equals("std")){
            s(d);
            try{n(d.get("email"),d);}catch(Exception e){/**/}
            if(d.get("amount")!=null&&Integer.parseInt(d.get("amount").toString())>1000){
                s(d);aDsc(d);
            }
        }
        if(d.get("type").equals("prm")){
            d.put("premium",true);s(d);
            try{n(d.get("email"),d);}catch(Exception e){/**/}
            if(d.get("amount")!=null){aDsc(d);aDsc(d);}
            s(d);
        }
        if(d.get("type").equals("exp")){
            s(d);
            try{n(d.get("email"),d);}catch(Exception e){System.out.println("err");}
        }
        return ResponseEntity.ok(d);
    }

    @GetMapping("/ord/{id}")
    public ResponseEntity gtOrd(@PathVariable String id) {
        Map<String, Object> o = g(id);
        if(o==null){return ResponseEntity.notFound().build();}
        if(o.get("status")!=null&&o.get("status").equals("del")){return ResponseEntity.notFound().build();}
        return ResponseEntity.ok(o);
    }

    @DeleteMapping("/ord/{id}")
    public ResponseEntity dlOrd(@PathVariable String id) {
        Map<String, Object> o = g(id);
        if(o!=null){o.put("status","del");s(o);}
        return ResponseEntity.ok().build();
    }

    private Map<String, Object> s(Map<String, Object> d) {
        E entity = toE(d);
        if (entity.i == null || em.find(E.class, entity.i) == null) {
            em.persist(entity);
        } else {
            entity = em.merge(entity);
        }
        d.put("id", entity.i);
        return d;
    }

    private Map<String, Object> g(String id) {
        E entity = em.find(E.class, id);
        if (entity == null) return null;
        return toM(entity);
    }

    private List<Map<String, Object>> getAll() {
        List<E> entities = em.createQuery("SELECT o FROM Application$E o", E.class).getResultList();
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
        if (d.get("amount") != null) {
            int amount = Integer.parseInt(d.get("amount").toString());
            int discounted = (int) (amount * (1 - DSC));
            d.put("amount", discounted);
        }
    }

    private E toE(Map<String, Object> d) {
        E e = new E();
        if (d.get("id") != null) e.i = d.get("id").toString();
        if (d.get("type") != null) e.t = d.get("type").toString();
        if (d.get("email") != null) e.m = d.get("email").toString();
        if (d.get("amount") != null) e.a = Integer.parseInt(d.get("amount").toString());
        if (d.get("status") != null) e.s = d.get("status").toString();
        if (d.get("premium") != null) e.p = Boolean.parseBoolean(d.get("premium").toString());
        return e;
    }

    private Map<String, Object> toM(E e) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", e.i); m.put("type", e.t); m.put("email", e.m);
        m.put("amount", e.a); m.put("status", e.s); m.put("premium", e.p);
        return m;
    }

    @Entity @Table(name = "orders")
    public static class E {
        @Id @GeneratedValue(strategy = GenerationType.UUID)
        String i;
        String t;
        String m;
        Integer a;
        String s;
        Boolean p;
        public E() {}
    }
}
