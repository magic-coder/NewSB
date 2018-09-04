package com.qmx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.codec.binary.Base64;
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

public class WxWristbandControllerTest {
    private String API_URL = "http://qmx028.com/api/wxWristband/";
    private String APPKEY = "TuozYUTmKormxApSbEoCewcgJncccqoz";
    private String SECRETKEY = "kBMGBNXTfrYomsnkUwCpPQbjCkkCWBIC";

    @Test
    public void wristBandInfo() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "wristBandInfo");

            JSONObject json = new JSONObject();
            JSONObject body = new JSONObject();
            body.put("barCode", "H7901821Q1AMLKFS");
            body.put("wdType", "成人票");
            body.put("vStart", "2017-01-01");
            body.put("vEnd", "2018-12-31");
            body.put("balance", 0);
            body.put("remarks", "腕带单人");
            body.put("guId", "H7901821Q1AMLKFS");
            body.put("status", "1");
            body.put("name", "name");
            body.put("phone", "phone");
            body.put("idcard", "idcard");
            json.put("appKey", APPKEY);
            json.put("body", body);
            String param = json.toString();

            String ts = String.valueOf(System.currentTimeMillis());
            String sign = DigestUtils.md5Hex(APPKEY + param + ts + SECRETKEY).toUpperCase();
            post.addHeader("TIMESTAMP", ts);
            post.addHeader("APPKEY", APPKEY);
            post.addHeader("SIGN", sign);

            String data = Base64.encodeBase64String(param.getBytes("UTF-8"));
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("data", data));

            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {

        }
    }

    @Test
    public void wdRechargeT() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "wdRechargeT");

            JSONObject json = new JSONObject();
            JSONObject body = new JSONObject();
            body.put("barCode", "");

            json.put("appKey", APPKEY);
            json.put("body", body);
            String param = json.toString();
            System.out.println(param.toString());

            String ts = String.valueOf(System.currentTimeMillis());
            String sign = DigestUtils.md5Hex(APPKEY + param + ts + SECRETKEY).toUpperCase();
            post.addHeader("TIMESTAMP", ts);
            post.addHeader("APPKEY", APPKEY);
            post.addHeader("SIGN", sign);

            String data = Base64.encodeBase64String(param.getBytes("UTF-8"));
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("data", data));

            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {

        }
    }

    @Test
    public void wdSetTStatus() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "wdSetTStatus");

            JSONObject json = new JSONObject();
            JSONObject body = new JSONObject();
            JSONArray ids = new JSONArray();
            ids.add("999615656982761474");
            body.put("ids", ids);
            json.put("appKey", APPKEY);
            json.put("body", body);
            String param = json.toString();
            System.out.println(param.toString());

            String ts = String.valueOf(System.currentTimeMillis());
            String sign = DigestUtils.md5Hex(APPKEY + param + ts + SECRETKEY).toUpperCase();
            post.addHeader("TIMESTAMP", ts);
            post.addHeader("APPKEY", APPKEY);
            post.addHeader("SIGN", sign);

            String data = Base64.encodeBase64String(param.getBytes("UTF-8"));
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("data", data));

            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {

        }
    }

    @Test
    public void setWdInfo() {
        try {
            CloseableHttpClient httpClient = HttpClients.createDefault();
            HttpPost post = new HttpPost(API_URL + "setWdInfo");

            JSONObject json = new JSONObject();
            JSONObject body = new JSONObject();

            JSONArray guids = new JSONArray();
            guids.add("D00498924ORR74QN");
            body.put("guids", guids);
            json.put("appKey", APPKEY);
            json.put("body", body);
            String param = json.toString();
            System.out.println(param);

            String ts = String.valueOf(System.currentTimeMillis());
            String sign = DigestUtils.md5Hex(APPKEY + param + ts + SECRETKEY).toUpperCase();
            post.addHeader("TIMESTAMP", ts);
            post.addHeader("APPKEY", APPKEY);
            post.addHeader("SIGN", sign);

            String data = Base64.encodeBase64String(param.getBytes("UTF-8"));
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("data", data));

            StringEntity entity = new UrlEncodedFormEntity(params, "utf-8");
            post.setEntity(entity);
            CloseableHttpResponse response = httpClient.execute(post);
            int statusCode = response.getStatusLine().getStatusCode();
            System.out.println("statusCode:" + statusCode);
            String string = EntityUtils.toString(response.getEntity());
            System.out.println("string:" + string);
            response.close();
            httpClient.close();
        } catch (Exception e) {

        }
    }
}
