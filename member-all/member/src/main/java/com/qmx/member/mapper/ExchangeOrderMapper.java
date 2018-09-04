package com.qmx.member.mapper;

import com.qmx.base.core.base.IBaseMapper;
import com.qmx.member.model.Exchange;
import com.qmx.member.model.ExchangeOrder;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ExchangeOrderMapper extends IBaseMapper<ExchangeOrder> {

    void updateStateType(@Param("id") Long id);
}
