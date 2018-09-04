package com.qmx.admin.api.wx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxMembershipRecordRemoteService;
import com.qmx.admin.remoteapi.wx.WxMembershipRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import com.qmx.wxbasics.api.dto.WxMembershipDto;
import com.qmx.wxbasics.api.dto.WxMembershipRecordDto;
import com.qmx.wxbasics.api.enumerate.MembershipRecordType;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController("/api/wxMembership")
@RequestMapping("/api/wxMembership")
public class WxMembershipController extends BaseController {
    private static final String APPKEY = "APPKEY";
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxMembershipRemoteService wxMembershipRemoteService;
    @Autowired
    private WxMembershipRecordRemoteService wxMembershipRecordRemoteService;

    public WxAuthorizationDto getUser(HttpServletRequest request) {
        String outappkey = request.getHeader(APPKEY);
        WxAuthorizationDto authorizer = wxAuthorizationRemoteService.findByOutappkey(outappkey).getData();
        if (authorizer != null) {
            return authorizer;
        }
        return null;
    }

    private String getRequestData(HttpServletRequest request) {
        String base64Data = RequestUtils.getString(request, "data", null);
        String data = null;
        try {
            System.out.println("base64Data:" + base64Data);
            data = new String(Base64.decodeBase64(base64Data), "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            data = new String(Base64.decodeBase64(base64Data));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.out.println("deBase64Data:" + data);
        }
        return data;
    }

    private JSONObject verifyAppKeyAndBody(String data) throws Exception {
        if (StringUtils.isEmpty(data)) {
            throw new Exception("没接收到json数据");
        }
        JSONObject jsonObject = JSONObject.parseObject(data);
        if (StringUtils.isEmpty(jsonObject.getString("appKey"))) {
            throw new Exception("数据格式错误：未找到appKey");
        }
        Object body = jsonObject.get("body");
        if (body == null) {
            throw new Exception("数据格式错误：未找到body");
        }
        return jsonObject;
    }

    /**
     * 线下同步会员列表
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getHykList")
    public Object getHykList(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            String method = reqbody.getString("method");

            if (StringUtils.isEmpty(method)) {
                method = "ALL";
            }
            JSONObject body = new JSONObject();
            JSONArray hyks = new JSONArray();
            if ("query".equals(method)) {
                String cardNum = reqbody.getString("cardNum");
                WxMembershipDto wxMembership = wxMembershipRemoteService.findByCardNum(aid, cardNum).getData();
                if (wxMembership != null) {
                    JSONObject hyk = new JSONObject();
                    hyk.put("cardNum", wxMembership.getCardNum());//会员卡号
                    hyk.put("phone", wxMembership.getPhone());//手机号码
                    hyk.put("userName", wxMembership.getUserName());//姓名
                    hyk.put("balance", wxMembership.getBalance());//余额
                    hyk.put("integral", wxMembership.getIntegral());//积分
                    hyk.put("carType", wxMembership.getCarType());//会员等级
                    hyks.add(hyk);
                }
                body.put("hyks", hyks);
                resultJson.put("body", body);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                return resultJson;
            } else {
                List<WxMembershipDto> wxMemberships = wxMembershipRemoteService.findBySynState(aid, Boolean.FALSE).getData();
                for (WxMembershipDto wxMembership : wxMemberships) {
                    JSONObject hyk = new JSONObject();
                    hyk.put("cardNum", wxMembership.getCardNum());//会员卡号
                    hyk.put("phone", wxMembership.getPhone());//手机号码
                    hyk.put("userName", wxMembership.getUserName());//姓名
                    hyk.put("balance", wxMembership.getBalance());//余额
                    hyk.put("integral", wxMembership.getIntegral());//积分
                    hyk.put("carType", wxMembership.getCarType());//会员等级
                    hyks.add(hyk);
                }
                body.put("hyks", hyks);
                resultJson.put("body", body);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                return resultJson;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    /**
     * 更改会员卡同步状态
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/updateHyk")
    public Object updateHyk(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            List<WxMembershipDto> memberships = new ArrayList<WxMembershipDto>();
            JSONArray cardNums = reqbody.getJSONArray("cardNums");
            WxMembershipDto membership = null;
            for (Object object : cardNums) {
                String cardNum = object.toString();
                membership = wxMembershipRemoteService.findByCardNum(aid, cardNum).getData();
                if (membership == null) {
                    resultJson.put("rspCode", 500);
                    resultJson.put("rspDesc", "不存在的会员卡号:" + cardNum);
                    return resultJson;
                }
                membership.setSynState(Boolean.TRUE);
                memberships.add(membership);
            }
            wxMembershipRemoteService.createMembership(getAccessToken(), membership);
            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }


    /**
     * 线下同步会员卡充值记录
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getRecordList")
    public Object getRecordList(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            String method = reqbody.getString("method");

            if (StringUtils.isEmpty(method)) {
                method = "ALL";
            }
            JSONObject body = new JSONObject();
            JSONArray records = new JSONArray();
            if ("query".equals(method)) {
                String cardNum = reqbody.getString("cardNum");
                WxMembershipRecordDto recordDto1 = new WxMembershipRecordDto();
                recordDto1.setAuthorizer(aid);
                recordDto1.setSynState(Boolean.FALSE);
                recordDto1.setType(MembershipRecordType.recharge);
                recordDto1.setEnable(Boolean.TRUE);
                recordDto1.setCarNum(cardNum);
                WxMembershipRecordDto wxRecord = wxMembershipRecordRemoteService.findByCardNum(recordDto1).getData().get(0);
                if (wxRecord != null) {
                    JSONObject record = new JSONObject();
                    record.put("cardNum", wxRecord.getCarNum());//会员卡号
                    record.put("money", wxRecord.getMoney().doubleValue());//充值金额
                    record.put("outTradeNo", wxRecord.getOutTradeNo());//充值订单号
                    record.put("integral", wxRecord.getIntegral());//积分
                    records.add(record);
                }
                body.put("records", records);
                resultJson.put("body", body);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                return resultJson;
            } else {
                WxMembershipRecordDto recordDto2 = new WxMembershipRecordDto();
                recordDto2.setAuthorizer(aid);
                recordDto2.setSynState(Boolean.FALSE);
                recordDto2.setType(MembershipRecordType.recharge);
                recordDto2.setEnable(Boolean.TRUE);
                List<WxMembershipRecordDto> wxRecords = wxMembershipRecordRemoteService.findByCardNum(recordDto2).getData();
                for (WxMembershipRecordDto wxRecord : wxRecords) {
                    JSONObject record = new JSONObject();
                    record.put("cardNum", wxRecord.getCarNum());//会员卡号
                    record.put("money", wxRecord.getMoney().doubleValue());//充值金额
                    record.put("outTradeNo", wxRecord.getOutTradeNo());//充值订单号
                    record.put("integral", wxRecord.getIntegral());//积分
                    records.add(record);
                }
                body.put("records", records);
                resultJson.put("body", body);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                return resultJson;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    /**
     * 更改会员卡充值状态
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/updateRecord")
    public Object updateRecord(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            JSONArray outTradeNos = reqbody.getJSONArray("outTradeNos");
            for (Object object : outTradeNos) {
                String outTradeNo = object.toString();
                WxMembershipRecordDto wxRecord = wxMembershipRecordRemoteService.findByOutTradeNo(outTradeNo).getData();
                if (wxRecord == null) {
                    resultJson.put("rspCode", 500);
                    resultJson.put("rspDesc", "不存在的充值订单号:" + outTradeNo);
                    return resultJson;
                }
                wxRecord.setSynState(Boolean.TRUE);
                wxMembershipRecordRemoteService.createMembershipRecord(getAccessToken(), wxRecord);
            }

            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    /**
     * 同步会员卡余额
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/synHykMoney")
    public Object synHykMoney(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            String cardNum = reqbody.getString("cardNum");
            WxMembershipDto membership = wxMembershipRemoteService.findByCardNum(aid, cardNum).getData();
            if (membership == null) {
                resultJson.put("rspCode", 500);
                resultJson.put("rspDesc", "不存在的会员卡号:" + cardNum);
                return resultJson;
            }
            BigDecimal money = reqbody.getBigDecimal("money");
            String integral = reqbody.getString("integral");
            membership.setBalance(money);
            if (StringUtils.isNotEmpty(integral)) {
                membership.setIntegral(Long.parseLong(integral));
            }
            String ICnum = reqbody.getString("ICnum");
            if (StringUtils.isNotEmpty(ICnum)) {
                membership.setIcnum(ICnum);
            }
            wxMembershipRemoteService.updateMembership(getAccessToken(), membership);

            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    /**
     * 线下同步会员卡消费记录
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getConsumptionRecord")
    public Object getConsumptionRecord(HttpServletRequest request, HttpServletResponse response) {
        JSONObject resultJson = new JSONObject();
        SysUserDto userDto = getCurrentUser();
        Long aid = wxAuthorizationRemoteService.findByMId(userDto.getId()).getData().getId();
        WxAuthorizationDto account = wxAuthorizationRemoteService.findById(aid).getData();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject reqbody = jsonObject.getJSONObject("body");

            String cardNum = reqbody.getString("cardNum");
            String time = reqbody.getString("time");
            BigDecimal money = reqbody.getBigDecimal("money");
            String integral = reqbody.getString("integral");
            BigDecimal givemoney = reqbody.getBigDecimal("givemoney");
            String goods = reqbody.getString("goods");

            WxMembershipDto membership = wxMembershipRemoteService.findByCardNum(aid, cardNum).getData();
            if (membership == null) {
                resultJson.put("rspCode", 500);
                resultJson.put("rspDesc", "不存在的会员卡号:" + cardNum);
                return resultJson;
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date d = sdf.parse(time);
            StringBuilder str = new StringBuilder();
            String random = wxMembershipRecordRemoteService.getRandomSecurityCode(8, "Simple", true).getData();
            str.append(random);

            WxMembershipRecordDto record = new WxMembershipRecordDto();
            record.setAuthorizer(aid);
            record.setMembership(membership.getId());
            record.setTime(d);
            record.setEnable(Boolean.TRUE);
            record.setType(MembershipRecordType.consumption);
            record.setCarNum(membership.getCardNum());
            if (StringUtils.isNotEmpty(integral)) {
                record.setIntegral(Long.parseLong(integral));
            }
            record.setOutTradeNo(str.toString());
            record.setSynState(true);
            if (StringUtils.isNotEmpty(goods)) {
                record.setGoods(goods);
            }
            record.setMoney(money);
            if (givemoney != null) {
                record.setGivemoney(givemoney);
            }

            wxMembershipRecordRemoteService.createMembershipRecord(getAccessToken(), record);
            str.append(String.format("%06d", record.getId()));
            record.setOutTradeNo(str.toString());
            wxMembershipRecordRemoteService.updateMembershipRecord(getAccessToken(), record);

            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            resultJson.put("appKey", account.getOutappkey());
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }


}
