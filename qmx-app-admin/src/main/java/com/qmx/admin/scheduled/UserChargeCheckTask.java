package com.qmx.admin.scheduled;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by liubin on 2018/1/15 12:40.
 */
//@Component
public class UserChargeCheckTask {

    private static final Logger logger = LoggerFactory.getLogger(UserChargeCheckTask.class);
    //暂定一分钟
    private static final long chargeCheckRate = 30 * 1000;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;

    //@Scheduled(fixedRate = chargeCheckRate)
    public void userChargeCheckRateCheck(){

    }
}
