package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.mapper.ExchangeOrderMapper;
import com.qmx.member.model.ExchangeOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@CacheConfig(cacheNames = "exchangeService")
public class ExchangeOrderService extends BaseService<ExchangeOrder> {

    @Autowired
    private ExchangeOrderMapper exchangeOrderMapper;

    @Transactional
    public Boolean updateStateType(Long id) {
        try {
            exchangeOrderMapper.updateStateType(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
