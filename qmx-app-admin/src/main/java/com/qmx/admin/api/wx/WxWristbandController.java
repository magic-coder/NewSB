package com.qmx.admin.api.wx;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.controller.common.BaseApiController;
import com.qmx.admin.remoteapi.core.SysUserApiRemoteService;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.wx.WxAuthorizationRemoteService;
import com.qmx.admin.remoteapi.wx.WxWristbandRechargeRemoteService;
import com.qmx.admin.remoteapi.wx.WxWristbandRemoteService;
import com.qmx.admin.utils.RequestUtils;
import com.qmx.base.core.constants.Constants;
import com.qmx.base.core.service.UserTokenService;
import com.qmx.coreservice.api.user.dto.SysUserApiDTO;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.wxbasics.api.dto.WxAuthorizationDto;
import com.qmx.wxbasics.api.dto.WxWristbandDto;
import com.qmx.wxbasics.api.dto.WxWristbandRechargeDto;
import com.qmx.wxbasics.api.enumerate.WristbandRechargeType;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;

@RestController("/api/wxWristband")
@RequestMapping("/api/wxWristband")
public class WxWristbandController extends BaseApiController {

    private static final String APPKEY = "APPKEY";
    private static final String USERAPIDTO = "userApiDTO";
    private static final String SYSUSERDTO = "sysUserDto";
    private static final String AUTHORIZER = "authorizer";
    @Autowired
    private WxAuthorizationRemoteService wxAuthorizationRemoteService;
    @Autowired
    private WxWristbandRemoteService wxWristbandRemoteService;
    @Autowired
    private WxWristbandRechargeRemoteService wxWristbandRechargeRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private SysUserApiRemoteService sysUserApiRemoteService;
    @Autowired
    private UserTokenService userTokenService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response) {
        String appkey = request.getHeader(APPKEY);
        SysUserApiDTO userApiDTO = sysUserApiRemoteService.findByAppkey(appkey).getData();
        if (userApiDTO == null) {
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("msg", "不存在的appkey");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
        SysUserDto sysUserDto = sysUserRemoteService.findById(userApiDTO.getUserId()).getData();
        if (sysUserDto == null) {
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("msg", "appkey未绑定用户");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
        WxAuthorizationDto authorizer = wxAuthorizationRemoteService.findByMId(sysUserDto.getId()).getData();
        if (authorizer == null) {
            JSONObject object = new JSONObject();
            object.put("code", "200");
            object.put("msg", "账号未和微信公众号绑定");
            request.setAttribute(Constants.API_LOG_RESP_CONTENT_ATTRIBUTE_NAME, object.toString());
            return false;
        }
        request.setAttribute(USERAPIDTO, userApiDTO);
        request.setAttribute(SYSUSERDTO, sysUserDto);
        request.setAttribute(AUTHORIZER, authorizer);
        return true;
    }

    @Override
    public String getAppKey(HttpServletRequest request) {
        return null;
    }

    @Override
    public String getApiName(HttpServletRequest request) {
        return null;
    }

    @Override
    public String getRequestStr(HttpServletRequest request) {
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
     * 录入腕带信息
     *
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/wristBandInfo")
    public Object wristBandInfo(HttpServletRequest request,
                                HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        Long aid = authorizer.getId();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");

            Long aId = null;
            if (authorizer != null) {
                aId = authorizer.getId();
            }

            String barCode = body.getString("barCode");
            String wdType = body.getString("wdType");
            String vStart = body.getString("vStart");
            String vEnd = body.getString("vEnd");
            String guId = body.getString("guId");
            double balance = body.getDoubleValue("balance");
            String remarks = body.getString("remarks");
            String number = body.getString("number");//腕带柜号
            Integer status = body.getInteger("status");
            String name = body.getString("name");
            String phone = body.getString("phone");
            String idcard = body.getString("idcard");

            WxWristbandDto WristBand = wxWristbandRemoteService.findByGuidAid(aid, guId).getData();
            if (WristBand == null) {
                WristBand = new WxWristbandDto();
                if (authorizer != null) {
                    WristBand.setAuthorizer(aid);
                }
                WristBand.setBarCode(barCode);
                WristBand.setWdType(wdType);
                WristBand.setvEnd(vEnd);
                WristBand.setvStart(vStart);
                WristBand.setBalance(balance);
                WristBand.setRemarks(remarks);
                WristBand.setGuId(guId);
                WristBand.setNumber(number);
                if (status == 1) {
                    WristBand.setEnable(Boolean.TRUE);
                } else {
                    WristBand.setEnable(Boolean.FALSE);
                }
                if (name != null) {
                    WristBand.setName(name);
                }
                if (phone != null) {
                    WristBand.setPhone(phone);
                }
                if (idcard != null) {
                    WristBand.setIdcard(idcard);
                }
                wxWristbandRemoteService.createWristband(userTokenService.getAccessToken(sysUserDto.getId(), sysUserDto.getAccount()), WristBand);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "新增成功");
            } else {
                WristBand.setUpdateTime(new Date());
                if (authorizer != null) {
                    WristBand.setAuthorizer(aid);
                }
                WristBand.setBarCode(barCode);
                WristBand.setWdType(wdType);
                WristBand.setvEnd(vEnd);
                WristBand.setvStart(vStart);
                WristBand.setBalance(balance);
                WristBand.setRemarks(remarks);
                WristBand.setGuId(guId);
                WristBand.setNumber(number);
                if (status == 1) {
                    WristBand.setEnable(Boolean.TRUE);
                } else {
                    WristBand.setEnable(Boolean.FALSE);
                }
                if (StringUtils.isNotEmpty(name)) {
                    WristBand.setName(name);
                }
                if (StringUtils.isNotEmpty(phone)) {
                    WristBand.setPhone(phone);
                }
                if (StringUtils.isNotEmpty(idcard)) {
                    WristBand.setIdcard(idcard);
                }
                wxWristbandRemoteService.updateWristband(userTokenService.getAccessToken(sysUserDto.getId(), sysUserDto.getAccount()), WristBand);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "更新成功");
            }
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/wdSetTStatus")
    public Object wdSetTStatus(HttpServletRequest request,
                               HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject;
            jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");
            JSONArray rids = body.getJSONArray("ids");
            for (Object object : rids) {
                Long rid = Long.parseLong(object.toString());
                WxWristbandRechargeDto recharge = wxWristbandRechargeRemoteService.findById(rid).getData();
                if (recharge == null) {
                    throw new Exception("未找到id为[" + rid + "]的记录!");
                }
                recharge.settStatus(1);
                wxWristbandRechargeRemoteService.updateWristbandRecharge(userTokenService.getAccessToken(sysUserDto.getId(), sysUserDto.getAccount()), recharge);
            }
            resultJson.put("body", body);
            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/wdRechargeT")
    public Object wdRechargeT(HttpServletRequest request,
                              HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        Long aid = authorizer.getId();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject;
            jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");
            String barCode = body.getString("barCode");
            WxWristbandDto wristBand = wxWristbandRemoteService.findByBarCode(barCode, aid).getData();
            if (wristBand != null) {
                Long rId = wristBand.getId();
                List<WxWristbandRechargeDto> recharges = wxWristbandRechargeRemoteService.findByWidAid(rId, aid, 1, "recharge", 0).getData();
                JSONArray json = new JSONArray();
                for (int i = 0; i < recharges.size(); i++) {
                    JSONObject body1 = new JSONObject();
                    body1.put("id", recharges.get(i).getId() + "");
                    body1.put("barCode", barCode);
                    body1.put("rMoney", recharges.get(i).getrMoney());
                    body1.put("rDate", recharges.get(i).getrDate());
                    body1.put("rStatus", recharges.get(i).getrStatus());
                    body1.put("tStatus", recharges.get(i).gettStatus());
                    body1.put("remarks", recharges.get(i).getRemarks());
                    body1.put("sn", recharges.get(i).getOutSn());
                    json.add(body1);
                }
                resultJson.put("body", json);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                if (recharges.size() == 0) {
                    resultJson.put("rspDesc", "没有充值信息");
                }
                System.out.println("========" + json.toString());
                return resultJson;
            } else {
                List<WxWristbandRechargeDto> recharges = wxWristbandRechargeRemoteService.findByWidAid(0L, aid, 1, "recharge", 0).getData();
                JSONArray json = new JSONArray();
                for (int i = 0; i < recharges.size(); i++) {
                    JSONObject body1 = new JSONObject();
                    body1.put("id", recharges.get(i).getId() + "");
                    body1.put("barCode", recharges.get(i).getBarCode());
                    body1.put("rMoney", recharges.get(i).getrMoney());
                    body1.put("rDate", recharges.get(i).getrDate());
                    body1.put("rStatus", recharges.get(i).getrStatus());
                    body1.put("tStatus", recharges.get(i).gettStatus());
                    body1.put("remarks", recharges.get(i).getRemarks());
                    body1.put("sn", recharges.get(i).getOutSn());
                    json.add(body1);
                }
                resultJson.put("body", json);
                resultJson.put("rspCode", 200);
                resultJson.put("rspDesc", "执行成功");
                if (recharges.size() == 0) {
                    resultJson.put("rspDesc", "没有充值信息");
                }
                System.out.println("========" + json.toString());
                return resultJson;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/consumption")
    public Object consumption(HttpServletRequest request,
                              HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        Long aid = authorizer.getId();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");

            JSONArray lists = body.getJSONArray("lists");
            for (Object object : lists) {
                JSONObject list = (JSONObject) object;
                String guId = list.getString("guId");
                double rMoney = list.getDouble("rMoney");
                String remarks = list.getString("remarks");
                String sn = list.getString("sn");

                WxWristbandDto WristBand = wxWristbandRemoteService.findByGuidAid(aid, guId).getData();
                WxWristbandRechargeDto recharge = new WxWristbandRechargeDto();
                recharge.setAuthorizer(aid);
                recharge.setWristBand(WristBand.getId());
                recharge.setBarCode(WristBand.getBarCode());
                recharge.setrDate(new Date());
                recharge.setrMoney(rMoney);
                recharge.setType(WristbandRechargeType.consumption);
                recharge.setrStatus(1);
                recharge.settStatus(1);
                recharge.setRemarks(remarks);
                recharge.setSn(sn);
                recharge.setEnable(Boolean.TRUE);
                wxWristbandRechargeRemoteService.createWristbandRecharge(userTokenService.getAccessToken(sysUserDto.getId(), sysUserDto.getAccount()), recharge);
            }
            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/getWdInfo")
    public Object getWdInfo(HttpServletRequest request,
                            HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        Long aid = authorizer.getId();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");

            JSONArray array = new JSONArray();
            List<WxWristbandDto> bands = wxWristbandRemoteService.findByTStatus(aid, 0).getData();
            for (WxWristbandDto band : bands) {
                JSONObject object = new JSONObject();
                object.put("guId", band.getGuId());
                object.put("barCode", band.getBarCode());
                object.put("phone", band.getPhone());
                object.put("name", band.getName());
                object.put("idcard", band.getIdcard());
                array.add(object);
            }
            resultJson.put("body", array.toString());
            resultJson.put("rspCode", 200);
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/setWdInfo")
    public Object setWdInfo(HttpServletRequest request,
                            HttpServletResponse response) {
        SysUserApiDTO userApiDTO = (SysUserApiDTO) request.getAttribute(USERAPIDTO);
        SysUserDto sysUserDto = (SysUserDto) request.getAttribute(SYSUSERDTO);
        WxAuthorizationDto authorizer = (WxAuthorizationDto) request.getAttribute(AUTHORIZER);

        JSONObject resultJson = new JSONObject();
        Long aid = authorizer.getId();
        try {
            String data = getRequestData(request);
            JSONObject jsonObject;
            jsonObject = verifyAppKeyAndBody(data);
            JSONObject body = jsonObject.getJSONObject("body");
            JSONArray guids = body.getJSONArray("guids");
            for (Object guid : guids) {
                WxWristbandDto wristBand = wxWristbandRemoteService.findByGuidAid(aid, guid.toString()).getData();
                if (wristBand == null) {
                    throw new Exception("未找到guid为[" + guid + "]的记录!");
                }
                wristBand.settStatus(1);
                wxWristbandRemoteService.updateWristband(userTokenService.getAccessToken(sysUserDto.getId(), sysUserDto.getAccount()), wristBand);
            }
            resultJson.put("body", body);
            resultJson.put("rspCode", 200);
            resultJson.put("rspDesc", "执行成功");
            return resultJson;
        } catch (Exception e) {
            e.printStackTrace();
            resultJson.put("rspCode", 500);
            if (e instanceof Exception) {
                resultJson.put("rspDesc", e.getMessage());
            } else {
                resultJson.put("rspDesc", "接口出现异常!");
            }
            return resultJson;
        }
    }

}
