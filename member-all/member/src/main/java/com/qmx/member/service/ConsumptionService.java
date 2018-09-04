package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.api.dto.ConsumptionDto;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.member.mapper.ConsumptionMapper;
import com.qmx.member.model.Associated;
import com.qmx.member.model.Consumption;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Random;

@Service
@CacheConfig(cacheNames = "consumptionService")
public class ConsumptionService extends BaseService<Consumption> {

    @Autowired
    private ConsumptionMapper consumptionMapper;
    @Autowired
    private AssociatedService associatedService;

    public Consumption findByLevelId(Long levelId) {
        return consumptionMapper.findByLevelId(levelId);
    }

    @Transactional
    public Consumption saveAll(Consumption model, ConsumptionDto dto) {
        Consumption consumption = this.save(model);
        savaAssociated(consumption.getId(),dto);
        return consumption;
    }
    @Transactional
    public Consumption updateAll(Consumption model, ConsumptionDto dto) {
        Consumption consumption = this.update(model);
        associatedService.delByConsumptionId(consumption.getId());
        savaAssociated(consumption.getId(),dto);
        return consumption;
    }
    @Transactional
    public void savaAssociated(Long id,ConsumptionDto dto){
        List<String> ids = dto.getIds();
        Associated associated = new Associated();
        if (ids != null && ids.size() != 0) {
            for (String s : ids) {
                String[] split = s.split("&");
                associated.setAssociatedId(id);
                associated.setProductId(Long.valueOf(split[0].trim()));
                associated.setProductName(split[1].trim());
                for (ProductType type : ProductType.values()) {
                    if (type.name().equals(split[2].trim()))
                        associated.setProductType(type);
                }
                associatedService.save(associated);
            }
        }

    }

    public void delByLevenId(Long id) {
        consumptionMapper.delByLevenId(id);
    }
}
