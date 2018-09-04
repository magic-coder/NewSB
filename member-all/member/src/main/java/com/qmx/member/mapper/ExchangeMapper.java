package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Discount;
import com.qmx.member.model.Exchange;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ExchangeMapper extends IBaseMapper<Exchange> {

    void updateState();
}
