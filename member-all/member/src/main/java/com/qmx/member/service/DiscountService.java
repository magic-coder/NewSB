package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;
import com.qmx.member.api.dto.ConsumptionDto;
import com.qmx.member.api.dto.DiscountDto;
import com.qmx.member.api.enumerate.ProductType;
import com.qmx.member.mapper.DiscountMapper;
import com.qmx.member.model.Associated;
import com.qmx.member.model.Consumption;
import com.qmx.member.model.Discount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@CacheConfig(cacheNames = "discountService")
public class DiscountService extends BaseService<Discount> {

    @Autowired
    private DiscountMapper discountMapper;
    @Autowired
    private AssociatedService associatedService;

    public Discount findByLevelId(Long levelId) {
        return discountMapper.findByLevelId(levelId);
    }

    public Discount saveAll(Discount model, DiscountDto dto) {
        Discount discount = this.save(model);
        savaAssociated(discount.getId(),dto);
        return discount;
    }
    @Transactional
    public Discount updateAll(Discount model, DiscountDto dto) {
        Discount discount = this.update(model);
        associatedService.delByConsumptionId(discount.getId());
        savaAssociated(discount.getId(),dto);
        return discount;
    }
    @Transactional
    public void savaAssociated(Long id,DiscountDto dto){
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
        discountMapper.delByLevenId(id);
    }
}
