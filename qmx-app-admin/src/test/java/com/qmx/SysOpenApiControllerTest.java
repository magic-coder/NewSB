package com.qmx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
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
import java.util.List;

public class SysOpenApiControllerTest {
    private String API_URL = "http://localhost:9999/open/openapi/";
    private String APPKEY = "eihgaQOyXCuoHoRUKRbvfOMTdcuoYAZp";
    private String SECRETKEY = "vduSModXLONrTrlQZsXholvqfliomKho";

    @Test
    public void getProductList() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            //指定ID查询
            object.put("method", "list");
            JSONArray snList = new JSONArray();
            snList.add("911879");
            object.put("snList", snList);
            /*//分页查询
            object.put("method", "page");
            object.put("pageIndex", 1);
            object.put("pageSize", 10);*/

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "getProductList");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void getProductPriceList() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("productId", "911879");
            object.put("startTime", "2018-05-22");
            object.put("endTime", "2018-06-22");


            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "getProductPriceList");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void getSightList() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            //指定ID查询
            object.put("method", "list");
            JSONArray snList = new JSONArray();
            snList.add(998760205955309570L);
            object.put("sightIdList", snList);
            /*//分页查询
            object.put("method", "page");
            object.put("pageIndex", 1);
            object.put("pageSize", 10);*/

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "getSightList");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void verify() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("outSn", "cs0001");
            object.put("contactName", "测试");
            object.put("contactMobile", "15196644874");
            object.put("productSn", "911879");
            object.put("quantity", "2");

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "verify");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void create() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("outSn", "cs0001");
            object.put("contactName", "测试");
            object.put("contactMobile", "15196644874");
            object.put("productSn", "911879");
            object.put("quantity", "2");
            object.put("salePrice", "10");

            object.put("useDate", "2018-05-25");

            JSONArray passengerList = new JSONArray();
            JSONObject passenger = new JSONObject();
            passenger.put("name", "name");
            passenger.put("mobile", "mobile");
            passenger.put("credentialsType", "credentialsType");
            passenger.put("credentials", "credentials");
            passengerList.add(passenger);
            object.put("passengerList", passengerList);

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "create");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void payment() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("orderId", "999219479000932354");
            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "payment");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void getOrderInfo() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("orderId", "999219479000932354");
            object.put("queryEticket", "true");

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "getOrderInfo");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void refund() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("orderId", "999219479000932354");
            object.put("refundId", "999219479000932354");
            object.put("refundQuantity", "1");

            JSONArray refundList = new JSONArray();
            refundList.add("324642168414");
            refundList.add("101194727002");
            object.put("refundList", refundList);


            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "refund");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void notifyRefund() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());

            JSONObject object = new JSONObject();
            object.put("orderId", "999149944743055361");
            object.put("refundId", "99914994474305536");
            object.put("refundQuantity", "2");

            JSONArray refundList = new JSONArray();
            refundList.add("324642168414");
            refundList.add("101194727002");
            object.put("refundList", refundList);

            String str = APPKEY + object.toString() + SECRETKEY + timestamp;
            System.out.println("需要加密的数据>>>" + str);
            String sign = DigestUtils.md5Hex(str);

            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "notifyRefund");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("appkey", APPKEY));
            params.add(new BasicNameValuePair("sign", sign));
            params.add(new BasicNameValuePair("timestamp", timestamp));
            params.add(new BasicNameValuePair("body", object.toString()));
            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println(">>>:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println(">>>:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
