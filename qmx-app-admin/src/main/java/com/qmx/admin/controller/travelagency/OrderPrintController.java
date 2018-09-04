package com.qmx.admin.controller.travelagency;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.qmx.admin.controller.common.BaseController;
import com.qmx.admin.remoteapi.core.SysUserRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderPrintRemoteService;
import com.qmx.admin.remoteapi.travelagency.OrderRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyPrintRelationRemoteService;
import com.qmx.admin.remoteapi.travelagency.TravelAgencyRemoteService;
import com.qmx.base.core.utils.DateUtil;
import com.qmx.coreservice.api.user.dto.SysUserDto;
import com.qmx.travelagency.api.dto.*;
import com.qmx.travelagency.api.enumerate.GuideType;
import com.qmx.travelagency.api.enumerate.TaOfflinePayType;
import com.qmx.travelagency.api.enumerate.TaOnlinePayType;
import org.apache.commons.lang.enums.EnumUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.List;

@Controller("/taOrderPrint")
@RequestMapping("/taOrderPrint")
public class OrderPrintController extends BaseController {
    @Autowired
    private OrderPrintRemoteService orderPrintRemoteService;
    @Autowired
    private OrderRemoteService orderRemoteService;
    @Autowired
    private TravelAgencyRemoteService travelAgencyRemoteService;
    @Autowired
    private SysUserRemoteService sysUserRemoteService;
    @Autowired
    private TravelAgencyPrintRelationRemoteService travelAgencyPrintRelationRemoteService;


    @RequestMapping(value = "/print")
    public void list(Long id, HttpServletResponse response) {
        try {

            OrderDto orderDto = orderRemoteService.findById(id).getData();
            if (orderDto == null) {
                throw new Exception("订单不存在");
            }
            TravelAgencyDto travelAgencyDto = travelAgencyRemoteService.findByMenberId(orderDto.getDistributorId()).getData();
            //根据旅行社id查询打印规则
            //TravelagencyPrintRelationDto relationDto = travelAgencyPrintRelationRemoteService.findByTravelagencyId(travelAgencyDto.getUserId()).getData();
            /*if (relationDto == null) {
                throw new Exception("该订单所属的旅行社未进行打印设置!");
            }*/
            //根据用户id查询打印设置
            OrderPrintSetDto printSetDto = orderPrintRemoteService.findBySupplierId(orderDto.getSupplierId()).getData();
            SysUserDto sysUserDto = sysUserRemoteService.findById(orderDto.getMemberId()).getData();
            SysUserDto operatorDto = sysUserRemoteService.findById(orderDto.getOperatorId()).getData();
            SysUserDto managerDto = sysUserRemoteService.findById(travelAgencyDto.getManager()).getData();

            response.setContentType("application/pdf");
            //不在网页中打开，而是直接下载该文件，并设置下载文件名
            response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("旅行社团队订单-" + orderDto.getSn(), "UTF-8") + ".pdf");

            // 新建一个文档，默认是A4纸的大小，4个边框为36
            Document document = new Document();
            document.setPageSize(PageSize.A4);

            // 将文档输出，我们写到输出流里面
            PdfWriter.getInstance(document, response.getOutputStream());

            // 打开文档
            document.open();

            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100);

            //表头样式
            BaseFont titleBaseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
            Font titleFont = new Font(titleBaseFont, 14, Font.BOLD, BaseColor.BLACK);

            //正文样式
            BaseFont cellbaseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
            Font cellfont = new Font(cellbaseFont, 10, Font.BOLD, BaseColor.WHITE);

            BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);// 设置中文字体
            Font font = new Font(baseFont, 10, Font.NORMAL, BaseColor.BLACK);

            //设置表头
            PdfPCell cell = new PdfPCell(new Phrase("旅行社团队订单", titleFont));
            cell.setColspan(3);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);

            //添加内容
            //客户信息
            cell = new PdfPCell(new Phrase("客户信息", cellfont));
            cell.setColspan(3);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setBackgroundColor(BaseColor.BLACK);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("旅行社名称:" + travelAgencyDto.getName(), font));
            cell.setColspan(2);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("所属账号:" + sysUserDto.getUsername() + "(" + sysUserDto.getAccount() + ")", font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            //订单信息
            cell = new PdfPCell(new Phrase("订单信息", cellfont));
            cell.setColspan(3);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setBackgroundColor(BaseColor.BLACK);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("订单号:\n" + orderDto.getSn(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("联系人:\n" + travelAgencyDto.getContactsName(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("联系电话:\n" + travelAgencyDto.getContactsMobile(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("下单人:\n" + operatorDto.getUsername() + "(" + operatorDto.getAccount() + ")", font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("下单时间:\n" + DateUtil.toDateTimeString(orderDto.getCreateTime()), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("客户经理:\n" + managerDto.getUsername() + "(" + managerDto.getAccount() + ")", font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("使用日期:\n" + orderDto.getDate(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            StringBuffer guideStr = new StringBuffer();
            if (printSetDto.getOrderGuide() != null && printSetDto.getOrderGuide()) {
                List<OrderGuideDto> guideDtos = orderDto.getGuideDtos();
                if (guideDtos != null && guideDtos.size() > 0) {
                    guideStr.append("领队/导游:\n");
                }
                for (OrderGuideDto guideDto : guideDtos) {
                    guideStr.append("姓名:" + guideDto.getGuideName() + "\n");
                    guideStr.append("电话:" + guideDto.getGuide().getMobile() + "\n");
                    if (guideDto.getGuide().getType() == GuideType.guide) {
                        guideStr.append("导游证号:" + guideDto.getGuide().getGuideNumber() + "\n");
                    }
                }
            }
            cell = new PdfPCell(new Phrase(guideStr.toString(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            StringBuffer carAndDriverStr = new StringBuffer();
            if ((printSetDto.getOrderCar() != null && printSetDto.getOrderCar()) || (printSetDto.getOrderDriver() != null && printSetDto.getOrderDriver())) {
                guideStr.append("车辆/司机:\n");

                List<OrderCarDto> carDtos = orderDto.getCarDtos();
                for (OrderCarDto carDto : carDtos) {
                    carAndDriverStr.append(carDto.getCar().getCarNumber() + "   ");
                }

                List<OrderDriverDto> driverDtos = orderDto.getDriverDtos();
                for (OrderDriverDto driverDto : driverDtos) {
                    carAndDriverStr.append(driverDto.getDriver().getName() + "\n");
                }
            }
            cell = new PdfPCell(new Phrase(carAndDriverStr.toString(), font));
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);


            //消费内容
            cell = new PdfPCell(new Phrase("消费内容", cellfont));
            cell.setColspan(3);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setBackgroundColor(BaseColor.BLACK);
            table.addCell(cell);

            List<OrderInfoDto> infoDtos = orderDto.getInfoDtos();
            Boolean ok = Boolean.TRUE;
            for (OrderInfoDto infoDto : infoDtos) {
                cell = new PdfPCell(new Phrase(infoDto.getProductName(), font));
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                table.addCell(cell);

                String price = "";
                if (printSetDto.getOrderInfoPrice() != null && printSetDto.getOrderInfoPrice()) {
                    price = "\n合计:" + infoDto.getPrice().multiply(new BigDecimal(infoDto.getQuantity())).setScale(2).toString();
                }

                cell = new PdfPCell(new Phrase("数量:" + infoDto.getQuantity() + price, font));
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                table.addCell(cell);

                if (ok) {
                    ok = Boolean.FALSE;
                    //在生成一个表格用于显示图片下面加入文字
                    PdfPTable table1 = new PdfPTable(1);
                    table1.setHorizontalAlignment(Element.ALIGN_CENTER); //垂直居中
                    table1.getDefaultCell().setBorderWidth(0); //不显示边框
                    if (printSetDto.getProductCode() != null && printSetDto.getProductCode()) {
                        BarcodeQRCode qr = new BarcodeQRCode(orderDto.getSn(), 150, 150, null);//此处是用于生成的二维码，因此扫描出来的信息也是密文
                        Image image = qr.getImage();
                        cell = new PdfPCell();
                        cell.setImage(image);
                        cell.setFixedHeight(80f);
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table1.addCell(cell);

                        cell = new PdfPCell();
                        cell.setPhrase(new Phrase("辅助码:" + orderDto.getSn(), font));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table1.addCell(cell);
                    }
                    cell = new PdfPCell(table1);
                    cell.setRowspan(infoDtos.size());
                    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(cell);
                }

            }

            //增值产品
            List<OrderIncreaseInfoDto> increaseInfoDtos = orderDto.getIncreaseInfoDtos();
            if (!increaseInfoDtos.isEmpty()) {
                cell = new PdfPCell(new Phrase("增值产品", cellfont));
                cell.setColspan(3);
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                cell.setBackgroundColor(BaseColor.BLACK);
                table.addCell(cell);
                ok = Boolean.TRUE;
                for (OrderIncreaseInfoDto increaseInfoDto : increaseInfoDtos) {
                    cell = new PdfPCell(new Phrase(increaseInfoDto.getProductName(), font));
                    cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                    table.addCell(cell);

                    String price = "";
                    if (printSetDto.getOrderInfoPrice() != null && printSetDto.getOrderInfoPrice()) {
                        price = "\n合计:" + increaseInfoDto.getPrice().multiply(new BigDecimal(increaseInfoDto.getQuantity())).setScale(2).toString();
                    }

                    cell = new PdfPCell(new Phrase("数量:" + increaseInfoDto.getQuantity() + price, font));
                    cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                    table.addCell(cell);

                    if (ok) {
                        ok = Boolean.FALSE;
                        //在生成一个表格用于显示图片下面加入文字
                        PdfPTable table1 = new PdfPTable(1);
                        table1.setHorizontalAlignment(Element.ALIGN_CENTER); //垂直居中
                        table1.getDefaultCell().setBorderWidth(0); //不显示边框

                       /* BarcodeQRCode qr = new BarcodeQRCode(orderDto.getSn(), 150, 150, null);//此处是用于生成的二维码，因此扫描出来的信息也是密文
                        Image image = qr.getImage();
                        cell = new PdfPCell();
                        cell.setImage(image);
                        cell.setFixedHeight(80f);
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table1.addCell(cell);

                        cell = new PdfPCell();
                        cell.setPhrase(new Phrase("辅助码:" + orderDto.getSn(), font));
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table1.addCell(cell);*/

                        cell = new PdfPCell(table1);
                        cell.setRowspan(infoDtos.size());
                        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                        table.addCell(cell);
                    }

                }
            }


            //核准信息
            cell = new PdfPCell(new Phrase("核准信息", cellfont));
            cell.setColspan(3);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            cell.setBackgroundColor(BaseColor.BLACK);
            table.addCell(cell);

            StringBuffer buffer = new StringBuffer();

            if (printSetDto.getDeposit() != null && printSetDto.getDeposit()) {
                //获取定金支付方式
                if (orderDto.getDepositPayType() != null && !orderDto.getDepositPayType().equals("")) {
                    String type = TaOnlinePayType.valueOf(orderDto.getDepositPayType()).getTitle();
                    buffer.append("已收定金:" + orderDto.getDeposit().setScale(2).toString() + "元(" + type + ")\n");
                } else {
                    buffer.append("已收定金:" + orderDto.getDeposit().setScale(2).toString() + "元\n");
                }
            }
            if (printSetDto.getRetainage() != null && printSetDto.getRetainage()) {
                buffer.append("应收尾款:" + orderDto.getTotalAmount().subtract(orderDto.getDeposit()).setScale(2).toString() + "元\n");
            }
            if (printSetDto.getReceivable() != null && printSetDto.getReceivable()) {
                buffer.append("共计应收:" + orderDto.getTotalAmount().setScale(2).toString() + "元\n");
            }

            cell = new PdfPCell(new Phrase(buffer.toString(), font));
            cell.setColspan(2);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("接待人签字：", font));
            cell.setRowspan(2);
            cell.setMinimumHeight(60);
            cell.setHorizontalAlignment(Element.ALIGN_TOP);
            table.addCell(cell);

            buffer = new StringBuffer();
            if (printSetDto.getRealRetainage() != null && printSetDto.getRealRetainage()) {
                if (orderDto.getFinalPayType() != null && !orderDto.getFinalPayType().equals("")) {
                    //如果是线下支付
                    if (orderDto.getOfflinePaid() != null) {
                        buffer.append("实收尾款:" + orderDto.getOfflinePaid().toString() + "元(" + TaOfflinePayType.valueOf(orderDto.getFinalPayType()).getTitle() + ")\n");
                    } else {
                        buffer.append("实收尾款:" + orderDto.getAmountPaid().subtract(orderDto.getDeposit()).setScale(2).toString() + "元(" + TaOnlinePayType.valueOf(orderDto.getFinalPayType()).getTitle() + ")\n");
                    }
                } else {
                    buffer.append("实收尾款:" + orderDto.getAmountPaid().subtract(orderDto.getDeposit()).setScale(2).toString() + "元\n");
                }
            }
            if (printSetDto.getRealTotal() != null && printSetDto.getRealTotal()) {
                buffer.append("共计实收:" + orderDto.getTotalAmount().setScale(2).toString() + "元\n");
            }
            cell = new PdfPCell(new Phrase(buffer.toString(), font));
            cell.setColspan(2);
            cell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(cell);

            //写入表格数据
            document.add(table);

            // 关闭文档
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
