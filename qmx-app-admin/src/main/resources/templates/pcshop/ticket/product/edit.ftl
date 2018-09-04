<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/resources/module/shop/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>
</head>
<body>
<form class="layui-form" action="/pcticket/product/update" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <input name="id" value="${dto.id!}" type="hidden"/>
        <label class="layui-form-label" style="width: 150px;">选择产品</label>
        <div class="layui-input-inline">
            <input type="hidden" id="outId" name="outId" lay-verify="outId" value="${dto.outId!?c}"/>
            <input value="${dto.outName!}" class="layui-input" disabled/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">产品名称</label>
        <div class="layui-input-inline">
            <input id="name" name="name" class="layui-input" value="${dto.name!}" lay-verify="required"/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 700px;">
            <label class="layui-form-label" style="width: 150px;position: relative ;margin-top: 5%">产品图片</label>
            <div class="layui-input-block">
                <input type="hidden" name="imgurl" lay-verify="imgurl" autocomplete="off" class="layui-input"
                       value="${dto.imgurl!}">
                <img class="imageStyleImg" alt="" height="151" width="171" style="border: solid" src="${dto.imgurl!}"/>
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
                <li style="color: red;">(请上传width*height：171*151px大小且小于1M的图片)</li>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">总库存</label>
        <div class="layui-input-inline">
            <input name="maxStock" autocomplete="off" class="layui-input" lay-verify="maxStock"
                   value="${dto.maxStock!}"/>
        </div>
    </div>
    <!--预定规则-->
    <div class="layui-form-item" style="display: none;">
        <label class="layui-form-label" style="width: 150px;">预定规则</label>
        <div class="layui-input-inline">
            <input type="hidden" id="bookingRules" name="bookingRules" value="${dto.bookingRules!}"/>
            <input name="bookings" id="bookings" lay-verify="required" autocomplete="off" class="layui-input"
                   placeholder="选择预定规则" value="${dto.bookingName!}" readonly="readonly">
        </div>
        <label class="layui-form-label" style="width: 150px;">退款规则</label>
        <div class="layui-input-inline">
            <input type="hidden" id="refundRules" name="refundRules" value="${dto.refundRules!}"/>
            <input name="refund" id="refund" lay-verify="required" autocomplete="off" class="layui-input"
                   placeholder="选择退款规则" value="${dto.refundName!}" readonly="readonly">
        </div>
        <label class="layui-form-label" style="width: 150px;">检票规则</label>
        <div class="layui-input-inline">
            <input type="hidden" id="ticketRules" name="ticketRules" value="${dto.ticketRules!}"/>
            <input name="ticket" id="ticket" lay-verify="required" autocomplete="off" class="layui-input"
                   placeholder="选择检票规则" value="${dto.ticketName!}" readonly="readonly">
        </div>
    </div>
    <!--可售卖日期-->
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">售卖日期设置</label>
        <div class="layui-input-inline">
            <input name="saleStart" id="saleStart" autocomplete="off"
                   class="layui-input" value="${dto.saleStart!}" lay-verify="saleStart">
        </div>
        <div class="layui-form-mid">至</div>
        <div class="layui-input-inline">
            <input name="saleEnd" id="saleEnd"
                   autocomplete="off" value="${dto.saleEnd!}" class="layui-input" lay-verify="saleEnd">
        </div>
    </div>
    <!--指定游玩日期-->
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">是否指定游玩日期</label>
        <div class="layui-input-block">
            <input lay-filter="playState" name="playState" title="是" value="1" type="radio" id="playState1"
                   <#if '${dto.playState!?c}'=='true'>checked</#if>/>
            <input name="playState" lay-filter="playState" value="0" title="否" type="radio" id="playState2"
                   <#if '${dto.playState!?c}'=='false'>checked</#if>/>
        </div>
    </div>
    <!--有效期设置-->
    <div class="layui-form-item" id="fixedTerm2" <#if '${dto.playState!?c}'=='false'>style="display: none"</#if>>
        <label class="layui-form-label" style="width: 150px;">有效期设置</label>
        <div class="layui-form-mid">
            用户选定当天内有效
        </div>
    </div>
    <!--固定有效期设置-->
    <div class="layui-form-item" id="fixedTerm1"  <#if '${dto.playState!?c}'=='true'>style="display: none"</#if>>
        <label class="layui-form-label" style="width: 150px;">固定有效期设置</label>
        <div class="layui-input-inline">
            <input name="usefulStart" id="firstCooperationTime" autocomplete="off"
                   class="layui-input" lay-verify="usefulStart" value="${dto.usefulStart!}">
        </div>
        <div class="layui-form-mid">至</div>
        <div class="layui-input-inline">
            <input name="usefulEnd" id="firstCooperationTime1" autocomplete="off"
                   class="layui-input" lay-verify="usefulEnd" value="${dto.usefulEnd!}">
        </div>
    </div>
    <!--使用有效期星期设置-->
    <div class="layui-form-item" id="usefulWeek"  <#if '${dto.playState!?c}'=='true'>style="display: none"</#if>>
        <label class="layui-form-label" style="width: 150px;">使用有效期星期设置</label>
        <div class="layui-input-block">
            <input name="usefulWeek" value="1" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("1")>checked</#if>/>一
            <input name="usefulWeek" value="2" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("2")>checked</#if>/>二
            <input name="usefulWeek" value="3" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("3")>checked</#if>/>三
            <input name="usefulWeek" value="4" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("4")>checked</#if>/>四
            <input name="usefulWeek" value="5" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("5")>checked</#if>/>五
            <input name="usefulWeek" value="6" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("6")>checked</#if>/>六
            <input name="usefulWeek" value="0" type="checkbox" class="layui-input"
                   <#if '${dto.usefulWeek}'?contains("0")>checked</#if>/>日
        </div>
    </div>
    <!--前端可选日期设置-->
    <div class="layui-form-item" id="selectDate" <#if '${dto.playState!?c}'=='false'>style="display: none"</#if>>
        <label class="layui-form-label" style="width: 150px;">前端可选日期设置</label>
        <div class="layui-input-block">
            <input name="selectDate" value="today" type="checkbox" id="playState1"
                   class="layui-input" <#if '${dto.selectDate!}'?contains('today')>checked</#if>/>今天
            <input name="selectDate" value="tomorrow" type="checkbox" id="playState2" class="layui-input"
                   <#if '${dto.selectDate!}'?contains('tomorrow')>checked</#if>/>明天
            <input name="selectDate" value="afterTomorrow" type="checkbox" id="playState2" class="layui-input"
                   <#if '${dto.selectDate!}'?contains('afterTomorrow')>checked</#if>/>后天
            <input name="selectDate" value="moreDate" type="checkbox" id="playState2" class="layui-input"
                   <#if '${dto.selectDate!}'?contains('moreDate')>checked</#if>/>更多日期
        </div>
    </div>
    <!--售卖模式-->
<#--<div class="layui-form-item" id="saleState" <#if '${dto.playState!?c}'=='true'>style="display: none"</#if>>
    <label class="layui-form-label" style="width: 150px;">售卖模式</label>
    <div class="layui-input-block">
        <input name="saleState" lay-filter="saleState" value="1" title="长期售卖" type="radio"
               <#if '${dto.saleState!?c}'=='true'>checked</#if>/>
        <input name="saleState" lay-filter="saleState" id="saleState1" value="0" type="radio"
               <#if '${dto.saleState!?c}'=='false'>checked</#if>
               title="自定义售卖日期及价格"/>
    </div>
</div>-->
    <!--售卖价-->
    <div class="layui-form-item" id="stockPrice"
         <#if '${dto.playState!?c}'=='true' >style="display: none"</#if>>
        <label class="layui-form-label" style="width: 150px;">售卖价</label>
        <div class="layui-input-inline">
            <input name="salePrice" autocomplete="off" class="layui-input" lay-verify="salePrice"
                   value="${dto.salePrice!}"/>
        </div>
        <label class="layui-form-label">日库存</label>
        <div class="layui-input-inline">
            <input name="dayMaxStock" autocomplete="off" class="layui-input" lay-verify="dayMaxStock"
                   value="${dto.dayMaxStock!}"/>
        </div>
    <#--<label class="layui-form-label" style="width: auto">日剩余库存:${dto.dayMaxStockFlag!"0"}</label>-->
    <#--<div class="layui-input-inline">
        <input name="maxStock" autocomplete="off" class="layui-input" lay-verify="maxStock"
               value="${dto.maxStock!}"/>
    </div>-->
    </div>
    <!--售卖设置-->
    <div class="layui-form-item layui-form-text" id="pricedate"
         <#if '${dto.playState!?c}'=='false'>style="display: none" </#if>>
        <label class="layui-form-label" style="width: 150px;">售卖设置</label>
        <input type="hidden" id="datePriceData" name="datePriceData" style="width: 1000px;" value='${distribution!}'/>
        <div class="choose_date_month">
            <div id="calendarcontainer" ndate="${.now?string('yyyy-MM-dd')}" date="${.now?string('yyyy-MM')}-01"
                 month="${.now?string('MM')}">
                <div class="choose_month_bar">
                    <div id="prevbutton" class="month_bar prev" title="前一月">
                        <span>&lt;</span>
                        <strong id="prevmonth"></strong>
                    </div>
                    <div id="nextbutton" class="month_bar next" title="后一月">
                        <strong id="nextmonth"></strong>
                        <span>&gt;</span>
                    </div>
                </div>
                <div class="year_month">
                    <span id="year"></span>
                    <span class="month" id="month"></span>
                </div>
                <div class="week clrfix">
                    <span>周日</span>
                    <span>周一</span>
                    <span>周二</span>
                    <span>周三</span>
                    <span>周四</span>
                    <span>周五</span>
                    <span>周六</span>
                </div>
                <div class="date" id="date"></div>
            </div>
            <div class="module_calendar_do">
                <span style="color:white;">点击页面下方保存按钮，库存设置才能生效。</span>
                <input type="button" id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray"/>
                <input type="button" id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray"/>
                <input type="button" id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray"/>
            </div>
        </div>
        <div id="calender-right" class="module_calendar_data" style="display:none;">
            <div class="data_item">
                <label class="cap">
                    日期：</label><span id="showDate"></span>
                <input id="useDate" type="hidden"/>
            </div>
            <div class="data_item">
                <label for="sellPrice" class="cap">销售价格</label>
                <input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                       id="sellPrice"/>
                <span class="data_unit">元</span></div>
            <div class="data_item">
                <label for="distPrice" class="cap">日最大库存</label>
                <input type="text" value="" class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                       id="suggestPrice"/>
                <span class="data_unit"></span></div>
        <#-- <div class="data_item">
             <label for="stockNum" class="cap">最大总库存</label>
             <input type="text" value="1" class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')"
                    id="stockNum"/>
             <span class="data_unit">张</span></div>-->
            <div class="data_item_do">
                <input type="button" id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray"/>
                <input type="button" id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">预定须知</label>
        <div class="layui-input-block">
            <textarea name="booking" placeholder="请输入内容" lay-verify="required" class="layui-textarea"
                      style="width: 40%;" id="bookingRemind">${dto.booking!}</textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">退款说明</label>
        <div class="layui-input-block">
            <textarea name="refundInfo" placeholder="请输入内容" lay-verify="required" class="layui-textarea"
                      style="width: 40%;" id="refundRemind">${dto.refundInfo!}</textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 150px;">使用说明</label>
        <div class="layui-input-block">
            <textarea name="remind" placeholder="请输入内容" lay-verify="required" class="layui-textarea"
                      style="width: 40%;" id="ticketRemind">${dto.remind!}</textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>

<#--批量价格-->
<div id="dateStock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong id="title">批量设置可售时间</strong></div>
                <div class="valid_date_price">
                    <table class="input">
                        <tbody>
                        <tr>
                            <td align="right">时间段&nbsp;</td>
                            <td>
                                <div>
                                    <label class="time_limit_unit time_limit_large" for="startDate_1">
                                        <i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})"
                                               name="startDate" id="startDate_1"
                                               style="width: auto"/>&nbsp;至&nbsp;</label>
                                    <label class="time_limit_unit time_limit_large" for="endDate_1"><i
                                            class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_1\',{d:0});}'})"
                                               name="endDate" id="endDate_1" style="width: auto"/></label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 10px"></tr>
                        <tr>
                            <td align="right">星期&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                <div class="idsOfWeek">
                                    <input type="checkbox" name="weeks" value="1" checked/>一&nbsp;
                                    <input type="checkbox" name="weeks" value="2" checked/>二&nbsp;
                                    <input type="checkbox" name="weeks" value="3" checked/>三&nbsp;
                                    <input type="checkbox" name="weeks" value="4" checked/>四&nbsp;
                                    <input type="checkbox" name="weeks" value="5" checked/>五&nbsp;
                                    <input type="checkbox" name="weeks" value="6" checked/>六&nbsp;
                                    <input type="checkbox" name="weeks" value="0" checked/>七
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 10px"></tr>
                        <tr>
                            <td align="right" style="text-align:right;"><label for="sellPrice_1"><span
                                    class="must_be">*</span>销售价格&nbsp;</label></td>
                            <td><input type="text" class="input_medium layui-input" name="sellPrice_1"
                                       onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                       id="sellPrice_1" style="width: auto"/>
                            </td>
                        </tr>
                        <tr style="height: 20px"></tr>
                        <tr>
                            <td align="right" id="settle-label" style="text-align:right">
                                <label for="stockNum_1"><span class="must_be">*</span>日最大库存&nbsp;</label>
                            </td>
                            <td id="settle-input">
                                <input type="text" value="" class="input_medium layui-input" name="suggestPrice_1"
                                       onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                       id="suggestPrice_1" style="width: auto"/>&nbsp;
                            </td>
                        </tr>
                        <#--<tr>
                            <td align="right" id="totalStock-label" style="text-align:right;">
                                <label for="totalStockNum_1"><span
                                        class="must_be">*</span>最大总库存&nbsp;</label>
                            </td>
                            <td id="totalStock-input">
                                <input type="text" class="input_medium layui-input" value=""
                                       name="stockNum_1"
                                       onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                       id="stockNum_1" style="width: auto"/>&nbsp;
                            </td>
                        </tr>-->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="dialog_do">
            <input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
            <input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消"/></div>
    </div>
</div>
<#--批量取消-->
<div id="unstock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong>时间段设置</strong></div>
                <div class="valid_date_price">
                    <table class="input">
                        <tbody>
                        <tr>
                            <td align="right">时间段&nbsp;</td>
                            <td>
                                <div>
                                    <label class="time_limit_unit time_limit_large" for="startDate">
                                        <i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})"
                                               name="startDate" id="startDate_3"/>&nbsp;至&nbsp;</label>
                                    <label class="time_limit_unit time_limit_large" for="endDate"><i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_3\',{d:0});}'})"
                                               name="endDate" id="endDate_3"/></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">星期&nbsp;</td>
                            <td>
                                <div class="idsOfWeek">
                                    <input type="checkbox" name="weeks" value="1" checked/>一&nbsp;
                                    <input type="checkbox" name="weeks" value="2" checked/>二&nbsp;
                                    <input type="checkbox" name="weeks" value="3" checked/>三&nbsp;
                                    <input type="checkbox" name="weeks" value="4" checked/>四&nbsp;
                                    <input type="checkbox" name="weeks" value="5" checked/>五&nbsp;
                                    <input type="checkbox" name="weeks" value="6" checked/>六&nbsp;
                                    <input type="checkbox" name="weeks" value="0" checked/>七
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="dialog_do">
            <input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
            <input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消"/></div>
    </div>
</div>
<link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script>
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;
        //验证
        form.verify({
            outId: [/[\S]+/, "请选择产品！"],
            imgurl: [/[\S]+/, '请上传图片！'],
            salePrice: [/(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^[0-9]\.[0-9]([0-9])?$)/, "请填写正确的售卖金额！"],
            dayMaxStock: [/^\d+$/, "请填写正确的日最大库存！"],
            maxStock: [/^\d+$/, "请填写正确的最大库存！"],
            usefulStart: [/[\S]+/, "请选择有效日期！"],
            usefulEnd: [/[\S]+/, "请选择有效日期！"],
            saleStart: [/[\S]+/, "请选择售卖有效日期！"],
            saleEnd: [/[\S]+/, "请选择售卖有效日期！"]
        });
        //初始化日历
        laydate.render({
            elem: '#firstCooperationTime' //指定元素
        });
        laydate.render({
            elem: '#firstCooperationTime1' //指定元素
        });
        laydate.render({
            elem: '#saleStart'//指定元素
            , type: 'datetime'
        });
        laydate.render({
            elem: '#saleEnd'//指定元素
            , type: 'datetime'
        });
        //监听是否指定游玩日期
        form.on('radio(playState)', function (data) {
            var flag = data.value;
            if (flag == 1) {
                $("#fixedTerm2").show();
                $("#fixedTerm1").hide();
                $("#usefulWeek").hide();
                $("#saleState").hide();
                $("#selectDate").show();
                $("#stockPrice").hide();
                $("#pricedate").show();
                $("input[name='salePrice']").attr("lay-verify", "");
                $("input[name='dayMaxStock']").attr("lay-verify", "");
                // $("input[name='maxStock']").attr("lay-verify", "");
                $("input[name='usefulStart']").attr("lay-verify", "");
                $("input[name='usefulEnd']").attr("lay-verify", "");
                $("#title").html("批量设置可游玩时间");
            } else {
                $("#fixedTerm1").show();
                $("#fixedTerm2").hide();
                $("#usefulWeek").show();
                $("#saleState").show();
                $("#selectDate").hide();
                $("#stockPrice").show();
                $("#pricedate").hide();
                $("input[name='usefulStart']").attr("lay-verify", "usefulStart");
                $("input[name='usefulEnd']").attr("lay-verify", "usefulEnd");
                $("#title").html("批量设置可售时间");
                var val = $('input:radio[name="saleState"]:checked').val();
                if (val == 0) {
                    $("#pricedate").show();
                    $("#stockPrice").hide();
                } else {
                    $("input[name='salePrice']").attr("lay-verify", "salePrice");
                    $("input[name='dayMaxStock']").attr("lay-verify", "dayMaxStock");
                    // $("input[name='maxStock']").attr("lay-verify", "maxStock");
                }
            }
        });
        //监听售卖日期设置
        form.on('radio(saleState)', function (data) {
            var flag = data.value;
            if (flag == 0) {
                $("#stockPrice").hide();
                $("#pricedate").show();
                $("input[name='salePrice']").attr("lay-verify", "");
                $("input[name='dayMaxStock']").attr("lay-verify", "");
                //$("input[name='maxStock']").attr("lay-verify", "");
            } else {
                $("#stockPrice").show();
                $("#pricedate").hide();
                $("input[name='salePrice']").attr("lay-verify", "salePrice");
                $("input[name='dayMaxStock']").attr("lay-verify", "dayMaxStock");
                //$("input[name='maxStock']").attr("lay-verify", "maxStock");
            }
        });
        $(document).ready(function () {
            if ("${dto.playState?string("true","false")}" == "true") {
                $("input[name='usefulStart']").attr("lay-verify", "");
                $("input[name='usefulEnd']").attr("lay-verify", "");
                $("input[name='salePrice']").attr("lay-verify", "");
                $("input[name='dayMaxStock']").attr("lay-verify", "");
                //$("input[name='maxStock']").attr("lay-verify", "");
            }
        });
        form.render();
    });

    $().ready(function () {

        jQuery("button.test1").each(function () {
            var $this = $(this);
            uploadCompletes1($this);
        });
        jQuery("button.test2").each(function () {
            var $this = $(this);
            uploadCompletes2($this);
        });
    });

    function uploadCompletes1($this) {
        layui.use('upload', function () {
            var upload = layui.upload;
            //执行实例
            upload.render({
                elem: $this //绑定元素
                , url: '${base}/file/upload?fileType=image&token=' + getCookie("token") //上传接口
                , done: function (res) {
                    //如果上传失败
                    if (res.code > 0) {
                        return layer.msg('上传失败');
                    }
                    //上传成功
                    ($this).prev().attr("src", res.data);
                    ($this).parent().find("input[name='imgurl']").val(res.data);
                }
                , error: function () {
                    //请求异常回调
                    alert("异常!!!");
                }
            });
        });
    }
</script>
<script type="text/javascript">

    function tdFillCallBack(td) {
        var value = $(td).data('data');
        var str = '';
        if (value) {
            str += "<p class='price'>售:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price'>日:<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
            //str += "<p class='price'>总:<em>" + (value.stock ? value.stock : '') + "</em></p>";
        }
        return str;
    }

    function tdClickCallBack(o) {
        $("#useDate").val($(o).attr('data-date'));
        $("#showDate").text($(o).attr('data-date'));
        $("#sellPrice").val('');
        $("#suggestPrice").val('');
        $("#stockNum").val('');
        var data = $(o).data('data');
        if (data) {
            $("#suggestPrice").val(data.suggestPrice);
            $("#sellPrice").val(data.sellPrice);
            $("#stockNum").val(data.stock);
        }
    }
</script>
<#--<script type="text/javascript" src="${base}/resources/admin/js/calendarprice2.js"></script>-->
<script type="text/javascript" src="${base}/resources/admin/js/calendarprice2.js"></script>
</html>