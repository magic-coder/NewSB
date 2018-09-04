package com.qmx.member.service;

import com.qmx.base.core.base.BaseService;

import com.qmx.member.mapper.SignMapper;
import com.qmx.member.model.Sign;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@CacheConfig(cacheNames = "signService")
public class SignService extends BaseService<Sign> {

    @Autowired
    private SignMapper signMapper;

    /**
     * 查询今天有没有签到
     * false(没有)true(签到)
     * @param id
     * @return
     */
    public Boolean findByMemberId(Long id) {
        Sign sign = signMapper.findByMemberId(id);
        return sign == null ? false : true;
    }

    /**
     * 查询昨天没有签到,获取记录的连续签到次数
     * @return
     * @param id
     */
    public Integer isContinuousSign(Long id) {
        Sign sign = signMapper.isContinuousSign(id);
        Integer ContinuousSign;
        if (sign == null) {
            ContinuousSign = 0;
            return ContinuousSign;
        }
        String day = new SimpleDateFormat("MM").format(new Date());
        String time = new SimpleDateFormat("MM").format(sign.getTime());
        if (!day.equals(time)) {
            ContinuousSign = 0;
            return ContinuousSign;
        }
        ContinuousSign = sign.getContinuousSign();
        return ContinuousSign;
    }
}
