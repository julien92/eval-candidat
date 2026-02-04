package com.test.legacy.service;

import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class DscSvc {

    private static final double DISCOUNT_RATE = 0.10; // 10%

    public void aDsc(Map<String, Object> d) {
        if (d.get("a") != null) {
            int amount = Integer.parseInt(d.get("a").toString());
            int discounted = (int) (amount * (1 - DISCOUNT_RATE));
            d.put("a", discounted);
        }
    }
}
