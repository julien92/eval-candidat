package com.test.legacy.controller;

import com.test.legacy.repository.OrdDao;
import com.test.legacy.service.DscSvc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

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
