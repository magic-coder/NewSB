package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.member.mapper.AssociatedMapper;
import com.qmx.member.model.Associated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = "associatedService")
public class AssociatedService extends BaseService<Associated> {

    @Autowired
    private AssociatedMapper associatedMapper ;

    public List<Associated> findByConsumptionId(Long id, ProductType type) {
        return associatedMapper.findByConsumptionId(id,type);
    }

    public void delByConsumptionId(Long id) {
        associatedMapper.delByConsumptionId(id);
    }

}
