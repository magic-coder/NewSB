package com.qmx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.base.core.utils.Base64Util;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.*;

public class MeituanUtil {

    private static final Logger log = LoggerFactory.getLogger(MeituanUtil.class);

    private String clientId = "";
    private String clientSecret = "3ldxh2gd";
    private String partnerId = "832ec5a4-40ca-4347-b1a8-35f69cd83017";
    private String url = "http://127.0.0.1:8082/open/newmeituan";

    @Test
    public void queryLvProductPriceList() {
        String partnerDealId = "911879";
        String startTime = "2018-05-22";
        String endTime = "2018-06-22";

        String queryLvProductPriceList = url + "/queryLvProductPriceList.do";
        System.out.println("==========获取产品价格库存============");
        String queryLvProductPriceListparam = "{\"partnerId\":1007,\"body\":{\"partnerDealId\":\"" + partnerDealId + "\",\"partnerPoiId\":\"" + "" + "\",\"startTime\":\"" + startTime + "\",\"endTime\":\"" + endTime + "\"}}";
        String queryLvProductPriceListresult = invokePost(queryLvProductPriceList, queryLvProductPriceListparam, clientId, clientSecret, partnerId);
        System.out.println(">>>" + queryLvProductPriceListresult);
    }

    @Test
    public void createLvOrder() {
        String orderId = "cs0004";
        String partnerDealId = "911879";
        String sellPrice = "2";
        String visitDate = "2018-05-27";

        String createLvOrder = url + "/createLvOrder.do";
        System.out.println("==========创建订单============");
        String createLvOrderparam = "{\"partnerId\":1007,\"body\":{\"orderId\":\"" + orderId + "\",\"partnerDealId\":\"" + partnerDealId + "\",\"sellPrice\":" + sellPrice + ",\"quantity\":1,\"visitDate\":\"" + visitDate + "\",\"contactPerson\":{\"name\":\"测试\",\"pinyin\":\"\",\"mobile\":\"15196644874\",\"address\":\"\",\"postCode\":\"\",\"email\":\"\",\"credentials\":\"\",\"credentialsType\":0},\"otherVisitor\":[]}}";
        String createLvOrderresult = invokePost(createLvOrder, createLvOrderparam, clientId, clientSecret, partnerId);
        System.out.println("result=" + createLvOrderresult);
    }

    @Test
    public void payLvOrder() {
        String orderId = "cs0003";
        String partnerOrderId = "999203850336374786";

        String payLvOrder = url + "/payLvOrder.do";
        System.out.println("==========订单支付============");
        String payLvOrderparam = "{\"partnerId\":0,\"body\":{\"orderId\":\"" + orderId + "\",\"partnerOrderId\":\"" + partnerOrderId + "\"}}";
        String payLvOrderresult = invokePost(payLvOrder, payLvOrderparam, clientId, clientSecret, partnerId);
        System.out.println("result=" + payLvOrderresult);
    }

    @Test
    public void queryLvOrder() {
        String orderId = "cs0004";
        String partnerOrderId = "999219479000932354";

        String queryLvOrder = url + "/queryLvOrder.do";
        System.out.println("==========查询订单============");
        String queryLvOrderparam = "{\"partnerId\":1007,\"body\":{\"orderId\":\"" + orderId + "\",\"partnerOrderId\":\"" + partnerOrderId + "\"}}";
        String queryLvOrderresult = invokePost(queryLvOrder, queryLvOrderparam, clientId, clientSecret, partnerId);
        System.out.println("result=" + queryLvOrderresult);
    }

    @Test
    public void refundLvOrder() {
        JSONObject params = new JSONObject();
        JSONObject body = new JSONObject();
        body.put("orderId", "cs0004");
        body.put("partnerOrderId", "999219479000932354");
        body.put("refundId", "999219479000932354_2");
        body.put("partnerDealId", "911879");
        JSONArray voucherList = new JSONArray();
        voucherList.add("404059649321");
        body.put("voucherList", voucherList);
        body.put("refundQuantity", 1);
        params.put("body", body);

        String refundLvOrder = url + "/refundLvOrder.do";
        System.out.println("==========订单退款============");
        String refundLvOrderparam = params.toString();
        String refundLvOrderresult = invokePost(refundLvOrder, refundLvOrderparam, clientId, clientSecret, partnerId);
        System.out.println("result=" + refundLvOrderresult);
    }

    /*======================================================*/
    public static String invokePost(String url, String param, String clientId, String clientSecret, String partnerId) {
        return invokePost(url, param, "UTF-8", 15000, 15000, clientId, clientSecret, partnerId);
    }

    private static void getHeadersInfo(HttpServletRequest request) {

        Map<String, String> map = new HashMap<String, String>();
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();
            String value = request.getHeader(key);
            map.put(key, value);
        }
    }

    /**
     * 请求头处理
     *
     * @param request
     * @param client:美团分配的id
     * @param secret:美团分配的密钥
     */
    public static void generateHttpHeader(HttpRequestBase request, String client, String secret, String partnerId) {
        Date sysdate = new Date();
        SimpleDateFormat df = new SimpleDateFormat("EEE', 'dd' 'MMM' 'yyyy' 'HH:mm:ss' 'z", Locale.US);
        //SimpleDateFormat df = new SimpleDateFormat("EEE','dd''MMM''yyyy''HH:mm:ss''z", Locale.US);
        df.setTimeZone(TimeZone.getTimeZone("GMT"));
        String date = df.format(sysdate);
        String stringToSign = request.getMethod().toUpperCase() + " " + request.getURI().getPath() + "\n" + date;
        log.info(stringToSign);
        String encoding;
        try {
            encoding = getSignature(stringToSign.getBytes(), secret.getBytes());
        } catch (Exception e) {
            return;
        }
        String authorization = "MWS" + " " + client + ":" + encoding;
        request.addHeader("Authorization", authorization);
        request.addHeader("Date", date);
        request.addHeader("PartnerId", partnerId);
    }


    /**
     * 签名生成方法
     *
     * @param data
     * @param key
     * @return
     */
    public static String getSignature(byte[] data, byte[] key) throws Exception {
        String ALGORITHM_HMAC_SHA1 = "HmacSHA1";
        SecretKeySpec signingKey = new SecretKeySpec(key, ALGORITHM_HMAC_SHA1);
        Mac mac = Mac.getInstance(ALGORITHM_HMAC_SHA1);
        mac.init(signingKey);
        byte[] rawHmac = mac.doFinal(data);
        return new String(Base64Util.encodeToString(rawHmac));
    }

    public static String invokePost(String requestUrl, String param, String encode, int connectTimeout, int readTimeout, String clientId, String clientSecret, String partnerId) {
        String responseString = null;
        HttpPost httpPost = new HttpPost(requestUrl);
        RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(readTimeout).setConnectTimeout(connectTimeout).setConnectionRequestTimeout(connectTimeout).build();
        try {
            httpPost.setConfig(requestConfig);
            StringEntity stringEntity = new StringEntity(param, encode);
            httpPost.setEntity(stringEntity);
            httpPost.setHeader("Content-Type", "application/json;charset=utf-8");
            generateHttpHeader(httpPost, clientId, clientSecret, partnerId);
            responseString = doRequest(httpPost, encode);
        } finally {
            log.info("param=" + param + ",requestConfig=" + requestConfig + ",httpPost=" + httpPost + ",clientId=" + clientId + ",clientSecret=" + clientSecret + ",partnerId=" + partnerId + ",result=" + responseString);
        }
        return responseString;
    }


    private static String doRequest(HttpRequestBase httpRequestBase, String encode) {
        HttpClientBuilder httpClientBuilder = HttpClientBuilder.create();
        CloseableHttpClient httpClient = httpClientBuilder.build();
        String responseString = null;
        try {
            CloseableHttpResponse response = httpClient.execute(httpRequestBase);
            try {
                HttpEntity entity = response.getEntity();
                try {
                    if (entity != null) {
                        responseString = EntityUtils.toString(entity, encode);
                    }
                } finally {
                    if (entity != null) {
                        entity.getContent().close();
                    }
                }
            } catch (Exception e) {
                log.error("", e);
                responseString = "";
            } finally {
                if (response != null) {
                    response.close();
                }
            }
        } catch (SocketTimeoutException e) {
            log.error("", e);
            responseString = "";
        } catch (Exception e) {
            log.error("", e);
            responseString = "";
        } finally {
            httpRequestBase.releaseConnection();
        }
        return responseString;
    }

    /**
     * 获取request中的json数据
     *
     * @param request
     * @return
     */
    public static String readJSONString(HttpServletRequest request) {
        String str = "";
        try {

            getHeadersInfo(request);//获取头部信息

            BufferedReader br = request.getReader();
            String inputLine;
            while ((inputLine = br.readLine()) != null) {
                str += inputLine;
            }
            br.close();
            System.out.println("================" + str);
            return str;
        } catch (IOException e) {
            System.out.println("IOException: " + e);
        }
        return str;
    }

}
