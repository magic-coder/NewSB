package com.qmx;

import com.qmx.base.core.utils.HttpClientUtils;
import com.qmx.tickets.api.externalapi.ctrip.request.*;
import com.qmx.tickets.api.support.XmlUtil;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.junit.Test;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CtripTest {

    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private final SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final String ak = "AAF196DC49349AC6";
    private final String sk = "FBA700933A47456C1056D0A9DD7E32E3";
    private final String ENCODING = "UTF-8";
    private final String URL = "http://127.0.0.1:8082/open/ctrip/v1/invoke";

    @Test
    public void VerifyOrder() {
        try {
            VerifyCtripOrderRequest req = new VerifyCtripOrderRequest();
            CtripRequestHeader header = new CtripRequestHeader();
            String requestTime = sdf2.format(new Date());
            String serviceName = "VerifyOrder";
            String version = "v2.0";
            header.setAccountId(ak);
            header.setRequestTime(requestTime);
            header.setServiceName(serviceName);
            header.setVersion(version);

            VerifyCtripOrderRequestBody body2 = new VerifyCtripOrderRequestBody();
            List<CtripPassengerInfo> visitPersons = new ArrayList<CtripPassengerInfo>();
            CtripPassengerInfo ctripPassengerInfo = new CtripPassengerInfo();
            ctripPassengerInfo.setName("");
            visitPersons.add(ctripPassengerInfo);
            body2.setProductId("832ec5a4-40ca-4347-b1a8-35f69cd83017_911879");
            body2.setUseDate(sdf.format(new Date()));
            //body2.setContactEmail(contactEmail);
            body2.setUseEndDate(sdf.format(new Date()));
            body2.setPrice("20");
            body2.setContactMobile("18900002222");
            body2.setCount("2");
            body2.setContactName("携程测试");
            body2.setPassengerInfos(visitPersons);

            req.setBody(body2);
            String xmlStr = XmlUtil.toXML(req);
            String body = xmlStr.substring(xmlStr.indexOf("<body>"), xmlStr.indexOf("</body>") + 7);
            System.out.println("body:" + body);

            String data = Base64.encodeBase64String(body.getBytes(ENCODING));
            String str = ak + serviceName + requestTime + data + version + sk;
            String mySign = DigestUtils.md5Hex(str);
            header.setSign(mySign);
            req.setHeader(header);
            String xml2 = XmlUtil.toXML(req);
            System.out.println("xml2:" + xml2);

            String xml = HttpClientUtils.post(HttpClientUtils.getClient(), URL, xml2, null);
            System.out.println("result:" + xml);
        } catch (Exception e) {

        }
    }

    @Test
    public void CreateOrder() {
        try {
            CreateOrderByCtripRequest req = new CreateOrderByCtripRequest();
            CtripRequestHeader header = new CtripRequestHeader();
            String requestTime = sdf2.format(new Date());
            String serviceName = "CreateOrder";
            String version = "v2.0";
            header.setAccountId(ak);
            header.setRequestTime(requestTime);
            header.setServiceName(serviceName);
            header.setVersion(version);

            CreateOrderByCtripRequestBody body2 = new CreateOrderByCtripRequestBody();

            body2.setOtaOrderId("ctrip-cs0007");
            body2.setProductId("832ec5a4-40ca-4347-b1a8-35f69cd83017_911879");
            body2.setUseDate(sdf.format(new Date()));
            body2.setUseEndDate(sdf.format(new Date()));
            body2.setPrice("20");
            body2.setContactMobile("15196644874");
            body2.setCount("2");
            body2.setContactName("测试");


            req.setBody(body2);
            String xmlStr = XmlUtil.toXML(req);
            String body = xmlStr.substring(xmlStr.indexOf("<body>"), xmlStr.indexOf("</body>") + 7);
            System.out.println("body:" + body);

            String data = Base64.encodeBase64String(body.getBytes(ENCODING));
            String str = ak + serviceName + requestTime + data + version + sk;
            String mySign = DigestUtils.md5Hex(str);
            header.setSign(mySign);
            req.setHeader(header);
            String xml2 = XmlUtil.toXML(req);
            System.out.println("xml2:" + xml2);

            String xml = HttpClientUtils.post(HttpClientUtils.getClient(), URL, xml2, null);
            System.out.println("result:" + xml);
        } catch (Exception e) {

        }
    }

    @Test
    public void CancelOrder() {
        try {
            RefundOrderByCtripRequest req = new RefundOrderByCtripRequest();
            CtripRequestHeader header = new CtripRequestHeader();
            String requestTime = sdf2.format(new Date());
            String serviceName = "CancelOrder";
            String version = "v2.0";
            header.setAccountId(ak);
            header.setRequestTime(requestTime);
            header.setServiceName(serviceName);
            header.setVersion(version);

            RefundOrderByCtripRequestBody body2 = new RefundOrderByCtripRequestBody();
            body2.setOtaOrderId("ctrip-cs0007");
            body2.setVendorOrderId("999559608819322882");
            body2.setSequenceId("999559608819322882");
            body2.setCancelCount("2");

            req.setBody(body2);
            String xmlStr = XmlUtil.toXML(req);
            String body = xmlStr.substring(xmlStr.indexOf("<body>"), xmlStr.indexOf("</body>") + 7);
            System.out.println("body:" + body);

            String data = Base64.encodeBase64String(body.getBytes(ENCODING));
            String str = ak + serviceName + requestTime + data + version + sk;
            String mySign = DigestUtils.md5Hex(str);
            header.setSign(mySign);
            req.setHeader(header);
            String xml2 = XmlUtil.toXML(req);
            System.out.println("xml2:" + xml2);

            String xml = HttpClientUtils.post(HttpClientUtils.getClient(), URL, xml2, null);
            System.out.println("result:" + xml);
        } catch (Exception e) {

        }
    }

    @Test
    public void QueryOrder() {
        try {
            GetOrderByCtripRequest req = new GetOrderByCtripRequest();
            CtripRequestHeader header = new CtripRequestHeader();
            String requestTime = sdf2.format(new Date());
            String serviceName = "QueryOrder";
            String version = "v2.0";
            header.setAccountId(ak);
            header.setRequestTime(requestTime);
            header.setServiceName(serviceName);
            header.setVersion(version);

            GetOrderByCtripRequestBody body2 = new GetOrderByCtripRequestBody();
            body2.setOtaOrderId("ctrip-cs0007");
            body2.setVendorOrderId("999559608819322882");

            req.setBody(body2);
            String xmlStr = XmlUtil.toXML(req);
            String body = xmlStr.substring(xmlStr.indexOf("<body>"), xmlStr.indexOf("</body>") + 7);
            System.out.println("body:" + body);

            String data = Base64.encodeBase64String(body.getBytes(ENCODING));
            String str = ak + serviceName + requestTime + data + version + sk;
            String mySign = DigestUtils.md5Hex(str);
            header.setSign(mySign);
            req.setHeader(header);
            String xml2 = XmlUtil.toXML(req);
            System.out.println("xml2:" + xml2);

            String xml = HttpClientUtils.post(HttpClientUtils.getClient(), URL, xml2, null);
            System.out.println("result:" + xml);
        } catch (Exception e) {

        }
    }

    public static void main(String[] args) throws IOException {

		/*CtripRequest req = new CtripRequest();

		CtripRequestHeader header= new CtripRequestHeader();
		header.setAccountId("xxxxxxxx");
		header.setRequestTime("xxxx");
		header.setSign("哈哈");
		req.setHeader(header);
		VerifyCtripOrderRequestBody body = new VerifyCtripOrderRequestBody();
		body.setProductId("");
		body.setExtendInfo(null);
		req.setBody(body);
		//XStream xStream = new XStream();
		XStream xStream = new XStream(new DomDriver());//dom解析xml
		xStream.autodetectAnnotations(true);
		//XStream xStream = new XStream(new StaxDriver());//stax解析xml
		//xStream.alias("request", VerifyCtripOrderRequest.class);
		//NullConverter v = new NullConverter();
		//v.regAttribute(VerifyCtripOrderRequest.class, "unittype");
		//xStream.registerConverter(v);
		long s = System.currentTimeMillis();
		//String xml = xStream.toXML(req);
		String xml = XmlUtil.toXML(req);
		
		
		Document document = null;
		try {
			document = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		Element root = document.getRootElement(); 
	    Element body2 = root.element("body");
		System.out.println(body2.asXML());
		//xStream.fromXML(xml);
		//String x = JSONObject.toJSONString(xStream.fromXML(xml));
		//System.out.println(x);
		//String xml2 = xml.substring(xml.indexOf("<body>"),xml.indexOf("</body>")+7);
		String xml2 = xml.substring(xml.indexOf("<accountId>")+11,xml.indexOf("</accountId>"));
		System.out.println((System.currentTimeMillis()-s)+"ms");
		System.out.println(xml);
		System.out.println(xml2);
		
		//VerifyCtripOrderRequest obj = CtripXmlUtil.fromXML(xml, VerifyCtripOrderRequest.class);
		CtripRequest obj2 = XmlUtil.fromXML(xml, CtripRequest.class);
		String x = JSONObject.toJSONString(obj2);
		System.out.println(x);
		String xx = TestBase64.encodeToString("<body><otaOrderId>123456</otaOrderId><productId>1</productId><otaProductName><![CDATA[测试产品]]></otaProductName><price>100</price><count>1</count><contactName>test</contactName><contactMobile>13011111111</contactMobile><contactIdCardType>1</contactIdCardType><passengerInfos></passengerInfos><useDate>2017-04-28</useDate><useEndDate>2017-05-01</useEndDate><payMode>0</payMode><extendInfo><deposit>500</deposit><depositMode>0</depositMode><disAmount>10</disAmount><deliveryType>1</deliveryType><returnAddress></returnAddress></extendInfo></body>");
		try {
			String xxx = Base64.encodeBase64String("<body><otaOrderId>123456</otaOrderId><productId>1</productId><otaProductName><![CDATA[测试产品]]></otaProductName><price>100</price><count>1</count><contactName>test</contactName><contactMobile>13011111111</contactMobile><contactIdCardType>1</contactIdCardType><passengerInfos></passengerInfos><useDate>2017-04-28</useDate><useEndDate>2017-05-01</useEndDate><payMode>0</payMode><extendInfo><deposit>500</deposit><depositMode>0</depositMode><disAmount>10</disAmount><deliveryType>1</deliveryType><returnAddress></returnAddress></extendInfo></body>".getBytes("UTF-8"));
			System.out.println("xx1:"+xxx);
			//String data = Base64.encodeBase64String("<body><otaOrderId>123456</otaOrderId><productId>1</productId><otaProductName><![CDATA[测试产品]]></otaProductName><price>100</price><count>1</count><contactName>test</contactName><contactMobile>13011111111</contactMobile><contactIdCardType>1</contactIdCardType><passengerInfos></passengerInfos><useDate>2017-04-28</useDate><useEndDate>2017-05-01</useEndDate><payMode>0</payMode><extendInfo><deposit>500</deposit><depositMode>0</depositMode><disAmount>10</disAmount><deliveryType>1</deliveryType><returnAddress></returnAddress></extendInfo></body>".getBytes("utf-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		//xx = "PGJvZHk+PG90YU9yZGVySWQ+MTIzNDU2NzgtMjQ8L290YU9yZGVySWQ+PHByb2R1Y3RJZD4yOGY4ZWJjNS0yNmZkLTQxNTctYjJjYy00ZDFjMTk3ZDI3MDY8L3Byb2R1Y3RJZD48b3RhUHJvZHVjdE5hbWU+PCFbQ0RBVEFb5rWL6K+V5Lqn5ZOBXV0+PC9vdGFQcm9kdWN0TmFtZT48Y291bnQ+MjwvY291bnQ+PGNvbnRhY3ROYW1lPnRlc3Q8L2NvbnRhY3ROYW1lPjxjb250YWN0TW9iaWxlPjEzMDExMTExMTExPC9jb250YWN0TW9iaWxlPjxwYXNzZW5nZXJJbmZvcz48L3Bhc3NlbmdlckluZm9zPjx1c2VEYXRlPjIwMTctMDQtMjg8L3VzZURhdGU+PHVzZUVuZERhdGU+MjAxNy0wNC0yODwvdXNlRW5kRGF0ZT48cGF5TW9kZT4xPC9wYXlNb2RlPjxleHRlbmRJbmZvPjwvZXh0ZW5kSW5mbz48L2JvZHk+";
		String xx2 = TestBase64.decodeToString(xx);
		System.out.println("xx2:"+xx+" xx2:"+xx2);
		System.out.println(DigestUtils.md5Hex("FF936A9B860C3291CreateOrder2017-04-27 15:05:05PGJvZHk+PG90YU9yZGVySWQ+MTIzNDU2PC9vdGFPcmRlcklkPjxwcm9kdWN0SWQ+MTwvcHJvZHVjdElkPjxvdGFQcm9kdWN0TmFtZT48IVtDREFUQVvmtYvor5Xkuqflk4FdXT48L290YVByb2R1Y3ROYW1lPjxwcmljZT4xMDA8L3ByaWNlPjxjb3VudD4xPC9jb3VudD48Y29udGFjdE5hbWU+dGVzdDwvY29udGFjdE5hbWU+PGNvbnRhY3RNb2JpbGU+MTMwMTExMTExMTE8L2NvbnRhY3RNb2JpbGU+PGNvbnRhY3RJZENhcmRUeXBlPjE8L2NvbnRhY3RJZENhcmRUeXBlPjxwYXNzZW5nZXJJbmZvcy8+PHVzZURhdGU+MjAxNy0wNC0yODwvdXNlRGF0ZT48dXNlRW5kRGF0ZT4yMDE3LTA1LTAxPC91c2VFbmREYXRlPjxwYXlNb2RlPjA8L3BheU1vZGU+PGV4dGVuZEluZm8+PGRlcG9zaXQ+NTAwPC9kZXBvc2l0PjxkZXBvc2l0TW9kZT4wPC9kZXBvc2l0TW9kZT48ZGlzQW1vdW50PjEwPC9kaXNBbW91bnQ+PGRlbGl2ZXJ5VHlwZT4xPC9kZWxpdmVyeVR5cGU+PHJldHVybkFkZHJlc3MvPjwvZXh0ZW5kSW5mbz48L2JvZHk+2.0C615F304D696B1A0D4F8E333977A6502"));
		
		
		*/

		/*String strs = "<request><header><accountId>FF936A9B860C3291</accountId><serviceName>CreateOrder</serviceName><requestTime>2017-04-27 16:12:27</requestTime><version>2.0</version><sign>4fe15be44a65262648f504e5a44cfd2d</sign></header><body><otaOrderId>123456</otaOrderId><productId>1</productId><otaProductName><![CDATA[测试产品]]></otaProductName><price>100</price><count>1</count><contactName>test</contactName><contactMobile>13011111111</contactMobile><contactIdCardType>1</contactIdCardType><passengerInfos></passengerInfos><useDate>2017-04-28</useDate><useEndDate>2017-05-01</useEndDate><payMode>0</payMode><extendInfo><deposit>500</deposit><depositMode>0</depositMode><disAmount>10</disAmount><deliveryType>1</deliveryType><returnAddress></returnAddress></extendInfo></body></request>";

		long s = System.currentTimeMillis();
		CreateOrderByCtripRequest reqxx = XmlUtil.fromXML(strs, CreateOrderByCtripRequest.class);
		
		//System.out.println(JSONObject.toJSONString(reqxx));
		
		String xs = XmlUtil.toXML(reqxx);
		
		System.out.println(xs);
		long e = System.currentTimeMillis();
		//DomDriver dm = new DomDriver();
		//XStream xStream = new XStream(dm);//dom解析xml
		System.out.println("xx"+(e-s));*/


        //String accountId = "";


    }
}
