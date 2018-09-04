package com.qmx.admin.controller.tickets;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.tickets.EticketRemoteService;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.qrcode.QRCodeUtil;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.tickets.api.dto.SysEticketDTO;
import com.qmx.tickets.api.dto.SysOrderDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
public class QRController extends BaseController {
	
	@Autowired
	private EticketRemoteService eticketRemoteService;

	@RequestMapping(value = "/0/{sn}", method = RequestMethod.GET)
	public String qr0(@PathVariable String sn, HttpServletRequest request) {
		RestResponse<SysEticketDTO> restResponse = eticketRemoteService.findEticketsWithOrderByEticketSn(sn,null);
		return qr(sn, request,restResponse);
	}

	@RequestMapping(value = "/1/{sn}", method = RequestMethod.GET)
	public String qr1(@PathVariable String sn, HttpServletRequest request) {
		RestResponse<SysEticketDTO> restResponse = eticketRemoteService.findEticketsWithOrderByEticketSn(null,sn);
		return qr(sn, request,restResponse);
	}


	public String qr(String sn, HttpServletRequest request,RestResponse<SysEticketDTO> restResponse) {
		try {
			if(!restResponse.success()){
				request.setAttribute("msg", "二维码地址异常或票号不存在");
			}else{
				SysEticketDTO eticketDTO = restResponse.getData();
				SysOrderDTO orderDTO = eticketDTO.getOrderDTO();

				List<String> list = new ArrayList<String>();
				ByteArrayOutputStream out = new ByteArrayOutputStream();
				QRCodeUtil.encode(sn, 320, 320, out);
				byte[] tempbyte = out.toByteArray();

				String pngbase64String = org.apache.commons.codec.binary.Base64.encodeBase64String(tempbyte);
				list.add("data:image/png;base64," + pngbase64String);
				request.setAttribute("url", list);

				//二维码说明信息
				Boolean limitUseTimeRange = orderDTO.getLimitUseTimeRange() == null  ? false : orderDTO.getLimitUseTimeRange();
				if(limitUseTimeRange){
					request.setAttribute("useTimeRangeStart", orderDTO.getUseTimeRangeStart());
					request.setAttribute("useTimeRangeEnd", orderDTO.getUseTimeRangeEnd());
				}

				String status = "NORMAL";
				Date date = new Date();
				Date date1 = DateUtil.parseDateTime(orderDTO.getVsdate()+" 00:00:00", "yyyy-MM-dd HH:mm:ss");
				Date date2 = DateUtil.parseDateTime(orderDTO.getVedate()+" 23:59:59", "yyyy-MM-dd HH:mm:ss");
				if(date1.compareTo(orderDTO.getCanUseDate()) <= 0){
					date1 = orderDTO.getCanUseDate();
				}
				if(date.compareTo(date1) < 0){
					status = "NOTVALID";
				}else if(date.compareTo(date2) > 0){
					status = "EXPIRYDATE";
				}

				request.setAttribute("limitUseTimeRange", limitUseTimeRange);
				request.setAttribute("ticketName", orderDTO.getProductName());
				request.setAttribute("contactName", orderDTO.getContactName());
				request.setAttribute("contactMobile", orderDTO.getContactMobile());
				request.setAttribute("orderSource", orderDTO.getOrderSourceName());
				request.setAttribute("status", status);//可使用状态
				request.setAttribute("quantity", orderDTO.getQuantity());
				request.setAttribute("consumeQuantity", orderDTO.getConsumeQuantity());
				request.setAttribute("refundQuantity", (orderDTO.getReturnQuantity()+orderDTO.getReturningQuantity()));
				request.setAttribute("createDate", orderDTO.getCreateTime());
				request.setAttribute("canUseDate", date1);//在此时间之后才可使用
				request.setAttribute("date", orderDTO.getVsdate());
				request.setAttribute("edate", orderDTO.getVedate());
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("msg", "系统错误");
		}
		return "/tickets/qr/main";
	}
	
}
