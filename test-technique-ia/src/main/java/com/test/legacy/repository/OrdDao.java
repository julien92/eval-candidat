package com.test.legacy.repository;

import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.*;

@Repository
@Transactional
public class OrdDao {

    @PersistenceContext
    private EntityManager em;

    public Map<String, Object> s(Map<String, Object> d) {
        OrderEntity entity = toEntity(d);
        if (entity.getId() == null || em.find(OrderEntity.class, entity.getId()) == null) {
            em.persist(entity);
        } else {
            entity = em.merge(entity);
        }
        d.put("id", entity.getId());
        return d;
    }

    public Map<String, Object> sExp(Map<String, Object> d) {
        // Express save - même logique mais pourrait être différent
        return s(d);
    }

    public Map<String, Object> g(String id) {
        OrderEntity entity = em.find(OrderEntity.class, id);
        if (entity == null) return null;
        return toMap(entity);
    }

    public List<Map<String, Object>> getAll() {
        List<OrderEntity> entities = em.createQuery("SELECT o FROM OrderEntity o", OrderEntity.class).getResultList();
        List<Map<String, Object>> result = new ArrayList<>();
        for (OrderEntity e : entities) {
            result.add(toMap(e));
        }
        return result;
    }

    public void n(Object email, Map<String, Object> d) {
        // Notification - peut échouer
        if (email == null || email.toString().isEmpty()) {
            throw new RuntimeException("Email invalide");
        }
        // Simule l'envoi d'email
    }

    public void nExp(Object email, Map<String, Object> d) {
        // Notification express
        n(email, d);
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
