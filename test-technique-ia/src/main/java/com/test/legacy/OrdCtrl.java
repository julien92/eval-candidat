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
        OrderEntity entity = toEntity(d);
        if (entity.getId() == null || em.find(OrderEntity.class, entity.getId()) == null) {
            em.persist(entity);
        } else {
            entity = em.merge(entity);
        }
        d.put("id", entity.getId());
        return d;
    }

    private Map<String, Object> g(String id) {
        OrderEntity entity = em.find(OrderEntity.class, id);
        if (entity == null) return null;
        return toMap(entity);
    }

    private List<Map<String, Object>> getAll() {
        List<OrderEntity> entities = em.createQuery("SELECT o FROM OrderEntity o", OrderEntity.class).getResultList();
        List<Map<String, Object>> result = new ArrayList<>();
        for (OrderEntity e : entities) {
            result.add(toMap(e));
        }
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

    private OrderEntity toEntity(Map<String, Object> d) {
        OrderEntity e = new OrderEntity();
        if (d.get("id") != null) e.setId(d.get("id").toString());
        if (d.get("t") != null) e.setT(d.get("t").toString());
        if (d.get("m") != null) e.setM(d.get("m").toString());
        if (d.get("a") != null) e.setA(Integer.parseInt(d.get("a").toString()));
        if (d.get("st") != null) e.setSt(d.get("st").toString());
        if (d.get("pr") != null) e.setPr(Boolean.parseBoolean(d.get("pr").toString()));
        return e;
    }

    private Map<String, Object> toMap(OrderEntity e) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", e.getId());
        m.put("t", e.getT());
        m.put("m", e.getM());
        m.put("a", e.getA());
        m.put("st", e.getSt());
        m.put("pr", e.getPr());
        return m;
    }
}
