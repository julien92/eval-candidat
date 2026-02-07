package com.test.legacy;

import jakarta.persistence.*;

@Entity
@Table(name = "orders")
public class OrderEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String t;      // type: std, prm, exp
    private String m;      // email
    private Integer a;     // amount
    private String st;     // status (del = deleted)
    private Boolean pr;    // premium flag

    public OrderEntity() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getT() { return t; }
    public void setT(String t) { this.t = t; }

    public String getM() { return m; }
    public void setM(String m) { this.m = m; }

    public Integer getA() { return a; }
    public void setA(Integer a) { this.a = a; }

    public String getSt() { return st; }
    public void setSt(String st) { this.st = st; }

    public Boolean getPr() { return pr; }
    public void setPr(Boolean pr) { this.pr = pr; }
}
