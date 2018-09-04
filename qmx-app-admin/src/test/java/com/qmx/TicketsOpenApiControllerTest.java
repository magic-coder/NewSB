package com.qmx;
import com.alibaba.fastjson.JSONObject;
import com.qmx.tickets.api.enumerate.ConsumeTypeEnum;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.junit.Test;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class TicketsOpenApiControllerTest {

    private String API_URL = "http://10.1.3.135";
    //private String API_URL = "http://test.qmx028.com";
    private String APPKEY = "YStwldxRJHJpXfcLLAlHbZYnOBSAMJkX";
    private String SECRETKEY = "imYdIyktljgJTHvWbTXRYVTJlEFxIXvP";
    //private String APPKEY = "NFWEEZtzPLpsDddsHPEPUputhUTzPjmJ";
    //private String SECRETKEY = "nXBxWoiRKJrbnyhMjNkQiNTTBRYnfRPp";


    private String sendHttp(String url,String body){
        String result = null;
        long s = System.currentTimeMillis();
        try{
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(url);
            List<NameValuePair> params = new ArrayList<>();
            String timestamp = String.valueOf(System.currentTimeMillis());
            String str = APPKEY + body + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("body", body));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("sign", sign));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            result = EntityUtils.toString(response.getEntity());
            System.out.println("result:" + result);
            response.close();
            httpClient.close();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            System.out.println("call:"+url+",cost:"+(System.currentTimeMillis()-s)+"ms");
        }
        return result;
    }

    @Test
    public void getOrderList() {
        try {
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);
            JSONObject data = new JSONObject();
            data.put("startTime","2018-05-01");
            data.put("endTime","2018-05-20");
            data.put("maxRow","100");
            object.put("data", data);
            String result = sendHttp(API_URL+"/open/tickets/offline/v1/orderList",object.toJSONString());
            System.out.println("返回内容:"+result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void updateSyncStatus() {
        try {
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);
            List<Long> ids = new ArrayList<>();
            ids.add(994830574218698754L);
            object.put("data", ids);
            String result = sendHttp(API_URL+"/open/tickets/offline/v1/updateOfflineSyncStatus",object.toJSONString());
            System.out.println("返回内容:"+result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void consumeEticket() {
        try {
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);
            List<String> ids = new ArrayList<>();
            ids.add("603143873363");
            object.put("data", ids);
            object.put("consumeType", ConsumeTypeEnum.OFFLINE.name());
            String result = sendHttp(API_URL+"/open/tickets/offline/v1/consumeEticket",object.toJSONString());
            System.out.println("返回内容:"+result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}
