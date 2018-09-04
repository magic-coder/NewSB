package com.qmx.admin.listener;

import com.aliyun.openservices.ons.api.Action;
import com.aliyun.openservices.ons.api.ConsumeContext;
import com.aliyun.openservices.ons.api.Message;
import com.aliyun.openservices.ons.api.MessageListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * @Author liubin
 * @Description 阿里云通知基类
 * @Date Created on 2018/1/10 11:45.
 * @Modified By
 */
@Component
public class AppAdminNotifyListener implements MessageListener {

    private static final Logger logger = LoggerFactory.getLogger(AppAdminNotifyListener.class);

    @Override
    public Action consume(Message message, ConsumeContext consumeContext) {
        logger.info("Receive-start=> msgId:" + message.getMsgID() + ",tag:" + message.getTag() + ",ReconsumeTimes:" + message.getReconsumeTimes());
        long s = System.currentTimeMillis();
        byte[] content = message.getBody();
        String contentStr = null;
        try {
            contentStr = new String(content, "UTF-8");
            logger.info("Receive==> content:" + contentStr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //url通知
        logger.info("Receive-end=> msgId:" + message.getMsgID() + ",tag:" + message.getTag() + ",cost:" + (System.currentTimeMillis()-s)+"ms");
        return Action.CommitMessage;
    }
}
