package com.qmx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
//import com.qmx.admin.remoteapi.travelagency.OpenApiRemoteService;
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
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;

public class TaOpenApiControllerTest {
    /*private String API_URL = "http://127.0.0.1:9999/open/travelagency/";
    private String APPKEY = "QjFmLKNyUHrrFEtDafMhszvflJKUpVbN";
    private String SECRETKEY = "HJAdhpaFNPczdkphMquiZwYOxsIMVeJq";*/

    private String API_URL = "http://qmx028.com//open/travelagency/";
    private String APPKEY = "EOAcHeMhUoCTmbEXZovRJiknCGuhvmLa";
    private String SECRETKEY = "KuNCNAYedOnMNVEfnodZJgtZSoEFeqge";


    @Autowired
//    private OpenApiRemoteService openApiRemoteService;

    @Test
    public void getOrderList() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "getOrderList");
            List<NameValuePair> params = new ArrayList<>();
            String timestamp = String.valueOf(System.currentTimeMillis());
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);

            JSONArray data = new JSONArray();
            object.put("data", data);

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("body", object.toString()));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("sign", sign));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            System.out.println(API_URL + "getOrderList?appkey=" + APPKEY + "&body=" + object.toString() + "&timestamp=" + timestamp + "&sign=" + sign);
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void updateStatus() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "updateStatus");
            List<NameValuePair> params = new ArrayList<>();
            String timestamp = String.valueOf(System.currentTimeMillis());
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);

            JSONObject data = new JSONObject();
            data.put("type", "sync");
            JSONArray ids = new JSONArray();
            ids.add(984689998214602754L);
            ids.add(984627038398095362L);

            data.put("ids", ids);
            object.put("data", data);

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("body", object.toString()));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("sign", sign));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            System.out.println(API_URL + "updateStatus?appkey=" + APPKEY + "&body=" + object.toString() + "&timestamp=" + timestamp + "&sign=" + sign);
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void orderConsume() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "orderConsume");
            List<NameValuePair> params = new ArrayList<>();
            String timestamp = String.valueOf(System.currentTimeMillis());
            JSONObject object = new JSONObject();
            object.put("appkey", APPKEY);

            JSONObject data = new JSONObject();
            data.put("infoid", 984689998214602754L);
            data.put("quantity", 2);
            object.put("data", data);

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("body", object.toString()));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("sign", sign));

            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");

            System.out.println(API_URL + "orderConsume?appkey=" + APPKEY + "&body=" + object.toString() + "&timestamp=" + timestamp + "&sign=" + sign);

            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
