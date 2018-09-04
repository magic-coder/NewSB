<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
</head>
<body>
<#--<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>添加产品</legend>
</fieldset>-->
<form id="productForm" action="save" method="post" name="productForm" class="layui-form">
<#--<input type="hidden" id="pro_value" name="pro_value" style="width: 1000px;"/>
<input type="hidden" id="pro_value1" name="pro_value1" style="width: 1000px;"/>
<input type="hidden" id="pro_value2" name="pro_value2" style="width: 1000px;"/>
<input type="hidden" id="pro_value3" name="pro_value3" style="width: 1000px;"/>-->

    <div class="layui-tab">
        <ul class="layui-tab-title" style="text-align: center">
            <li class="layui-this">基本设置</li>
            <li>扩展设置</li>
        </ul>
        <div class="layui-tab-content">
            <div class="layui-tab-item layui-show">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">请选择酒店</label>
                        <div class="layui-input-inline">
                            <select name="hid" id="hid" lay-filter="hid" <#--onchange="getRoomType()"-->
                                    class="layui-input">
                                <option value="">请选择</option>
                            <#list hotel as info>
                                <option value="${info.id!}">${info.name!}</option>
                            </#list>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">房型</label>
                        <div class="layui-input-inline">
                            <select name="rid" id="rid" class="layui-input">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">产品名称</label>
                        <div class="layui-input-inline">
                            <input name="name" class="layui-input"/>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <input type="radio" name="status" value="上架" title="上架"/>
                            <input type="radio" name="status" value="下架" title="下架"/>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">窗型</label>
                        <div class="layui-input-inline">
                            <select name="windowType" class="layui-input">
                                <option value="1">有窗</option>
                                <option value="2">无窗</option>
                                <option value="3">部分有窗</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">加床</label>
                        <div class="layui-input-inline">
                            <input type="radio" name="rollawayBed" value="1" title="能"/>
                            <input type="radio" name="rollawayBed" value="2" title="不能"/>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">房间设施</label>
                        <div class="layui-input-block">
                            <div class="layui-form-mid">便利设施:</div>
                        <#list data.amenitiesList as info>
                            <input type="checkbox" name="amenities" id="amenities" lay-skin="primary"
                                   value="${info!}" title="${info!}"/>
                        </#list>
                            <hr/>
                            <div class="layui-form-mid">媒体科技:</div>
                        <#list data.mediaList as info>
                            <input type="checkbox" name="media" id="media" value="${info!}" lay-skin="primary"
                                   title="${info!}"/>
                        </#list>
                            <hr/>
                            <div class="layui-form-mid">食品和饮品:</div>
                        <#list data.foodsList as info>
                            <input type="checkbox" name="foods" id="foods" value="${info!}" lay-skin="primary"
                                   title="${info!}"/>
                        </#list>
                            <hr/>
                            <div class="layui-form-mid">浴室:</div>
                        <#list data.showerList as info>
                            <input type="checkbox" name="shower" id="shower" value="${info!}"
                                   lay-skin="primary" title="${info!}"/>
                        </#list>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">服务</label>
                        <div class="layui-input-block">
                        <#list data.serversList as info>
                            <input type="checkbox" name="service" id="service" value="${info!}"
                                   lay-skin="primary" title="${info!}"/>
                        </#list>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">预订须知</label>
                        <div class="layui-input-inline">
                            <textarea name="bookingNotice" class="layui-textarea"
                                      style="width: 500px;height: 150px;" placeholder="500字以内"></textarea>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">描述</label>
                        <div class="layui-input-inline">
                            <textarea name="description" class="layui-textarea"
                                      style="width: 500px;height: 150px;" placeholder="500字以内"></textarea>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-form-text" id="pricedate">
                <#--<input type="hidden" name="hid" value="${hid!}"/>
                <input type="hidden" name="roomId" id="roomId"/>-->
                    <input id="datePriceData" name="datePriceData" type="hidden" style="width: 1000px;">
                <#--<input id="productId" name="productId" type="hidden">
                <input type="hidden" id="hotelId" name="hotelId" style="width: 1000px;"/>-->
                    <label class="layui-form-label">设置产品价格</label>
                    <div class="choose_date_month">
                        <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}"
                             date="${.now?string("yyyy-MM")}-01"
                             month="${.now?string("MM")}">
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
                            <div class="date" id="date" onclick="getStock()">

                            </div>
                        </div>
                        <div class="module_calendar_do">
                            <span style="color:white;">点击页面下方保存按钮，价格设置才能生效。</span>
                            <input id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray" type="button">
                            <input id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray"
                                   type="button">
                            <input id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray" type="button">
                        </div>
                    </div>
                    <div id="calender-right" class="module_calendar_data" style="display: none;">
                        <div class="data_item">
                            <label class="cap" for="date">
                                日期：</label><span id="showDate"></span>
                            <input id="useDate" type="hidden" name="date">
                        </div>
                        <div class="data_item">
                            <label for="price" class="cap">
                                <span class="must_be">*</span>挂牌价：</label>
                            <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                   id="sellPrice"
                                   type="text" name="price">
                            <span class="data_unit">元</span></div>
                        <div class="data_item">
                            <label for="marketPrice" class="cap">
                                <span class="must_be"></span>执行价：</label>
                            <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                   id="suggestPrice" type="text" name="marketPrice">
                            <span class="data_unit">元</span></div>
                        <div class="data_item">
                            <label for="stock" class="cap">房型日房量：</label>
                            <span class="data_unit" id="roomStock"></span></div>
                    <#--<div class="data_item_do">-->
                        <div class="data_item">
                            <label for="stock" class="cap">产品日房量：</label>
                            <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')"
                                   id="stockNum"
                                   type="text" name="stock" onblur="tijiao1()">
                            <span class="data_unit">间</span></div>
                        <div class="data_item_do">
                            <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray" type="button">
                            <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"
                                   type="button">
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-tab-item">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">退款设置</label>
                        <div class="layui-input-block">
                            <div class="layui-input-inline" style="width: auto">
                                <input type="radio" name="refundSet" id="refundSet" value="1" checked
                                       title="可以退款"/>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <select name="partRefund" class="layui-input">
                                    <option value="1">支持部分退款</option>
                                    <option value="2">不支持部分退款</option>
                                </select>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="radio" name="refundSet" id="refundSet" value="2" title="不可退款"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">退款审核</label>
                        <div class="layui-input-block">
                            <div class="layui-input-inline" style="width: auto">
                                <input type="radio" name="refundCheck" lay-filter="refundCheck" id="refundCheck1"
                                       value="1" title="系统自动审核,审核时间:"/>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <input class="layui-input" name="refundCheckTime" disabled/>
                            </div>
                            <div class="layui-form-mid layui-word-aux">填0立即审核</div>
                            <div class="layui-form-mid">分钟</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="radio" name="refundCheck" lay-filter="refundCheck" id="refundCheck"
                                       value="2" checked title="人工审核"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">取消时间</label>
                        <div class="layui-input-block">
                            <div class="layui-form-mid">下单后</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="cancelTime" value="30" class="layui-input" style="width: 50px;"/>
                            </div>
                            <div class="layui-form-mid">分钟未支付取消订单</div>
                            <div class="layui-form-mid layui-word-aux">默认下单后30分钟取消订单</div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">联系人信息</label>
                        <div class="layui-input-block">
                            <input type="checkbox" lay-skin="primary" name="contacts" value="phone" title="手机号" checked
                                   disabled/>
                            <input type="checkbox" lay-skin="primary" name="contacts" value="name" title="姓名" checked
                                   disabled/>
                            <input type="checkbox" lay-skin="primary" name="contacts" value="idCard" title="身份证"/>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-inline" style="width: auto">
                        <input type="checkbox" name="checkIn" id="checkIn" lay-skin="primary" lay-filter="checkIn"
                               value="1"/>
                    </div>
                    <div class="layui-form-mid">入住人信息</div>
                    <div class="layui-input-block">
                        <div class="layui-form-mid">
                            <input type="radio" name="checkInNum" id="checkInNum" value="1" title="需要每个入住人信息"
                                   checked
                                   disabled/>
                            <input type="radio" name="checkInNum" id="checkInNum" title="仅需要一个入住人信息" value="2"
                                   disabled/>
                            <br/>
                            <input type="checkbox" checked lay-skin="primary" name="checkInInfoName" value="name"
                                   disabled title="姓名"/>
                            <input type="hidden" name="checkInInfo" value="name"/>
                            <input type="checkbox" lay-skin="primary" name="checkInInfo" value="pinyin" title="拼音"
                                   disabled/>
                            <input type="checkbox" lay-skin="primary" name="checkInInfo" value="mobile" title="手机号码"
                                   disabled/>
                            <br/>
                            <input type="checkbox" name="checkInInfo" lay-skin="primary" value="idCard" title="身份证"
                                   disabled/>
                            <input type="checkbox" name="checkInInfo" lay-skin="primary" value="Passport" title="护照"
                                   disabled/>
                            <input type="checkbox" name="checkInInfo" lay-skin="primary" value="TaiwanPermit"
                                   title="台胞证" disabled/>
                            <input type="checkbox" name="checkInInfo" lay-skin="primary" value="HKAndMacauPermit"
                                   title="港澳通行证" disabled/>
                            <br/>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="checkbox" name="checkInOther1" id="checkInOther1"
                                       lay-filter="checkInOther1" value="1" disabled lay-skin="primary"/>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="checkInInfoOther1" id="checkInInfoOther1" class="layui-input"
                                       placeholder="其他1" style="width: 80px;" disabled/>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="checkbox" name="checkInOther2" lay-filter="checkInOther2"
                                       id="checkInOther2" value="1" disabled lay-skin="primary"/>
                            </div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="checkInInfoOther2" id="checkInInfoOther2" class="layui-input"
                                       placeholder="其他2" style="width: 80px;" disabled/>
                            </div>
                            <br/>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">短信模版</label>
                        <div class="layui-input-inline">
                            <select name="note" class="layui-input">
                                <option value="">请选择~~</option>
                                <option value="1">阿里云测</option>
                                <option value="2">酒店模版</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">预定限制</label>
                        <div class="layui-input-block">
                            <input type="radio" name="reserveLimit" id="reserveLimit1" lay-filter="reserveLimit"
                                   value="1" title="无预定时间限制" checked/>
                            <br/>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="radio" name="reserveLimit" lay-filter="reserveLimit" value="2"
                                       style="width: 30px;" id="reserveLimit"/>
                            </div>
                            <div class="layui-form-mid">提前</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="reserveLimitDay" class="layui-input" style="width: 30px;" disabled/>
                            </div>
                            <div class="layui-form-mid">天的</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="reserveLimitHour" class="layui-input" style="width: 30px;"
                                       disabled/>

                            </div>
                            <div class="layui-form-mid">:</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="reserveLimitMinute" class="layui-input" style="width: 30px;"
                                       disabled/>
                            </div>
                            <div class="layui-form-mid">点之前预定</div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <div class="layui-input-inline" style="width: auto">
                            <input type="checkbox" name="hourRoom" id="hourRoom" lay-filter="hourRoom"
                                   lay-skin="primary" value="1"/>
                        </div>
                        <div class="layui-form-mid">钟点房</div>
                        <div class="layui-input-block" style="width: auto">
                            <div class="layui-form-mid">在</div>
                            <div class="layui-input-inline" style="width: auto">
                                <select name="hourRoomTimes" id="hourRoom1" disabled>
                                <#list startTime as info>
                                    <option value="${info!}">${info!}</option>
                                </#list>
                                </select>
                            </div>
                            <div class="layui-form-mid">--</div>
                            <div class="layui-input-inline" style="width: auto">
                                <select name="hourRoomTimes1" id="hourRoom2" disabled>
                                <#list endTime as info>
                                    <option value="${info!}">${info!}</option>
                                </#list>
                                </select>
                            </div>
                            <div class="layui-form-mid">时间段内，每</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="hourRoomHour" style="width: 30px;" id="hourRoomHour"
                                       disabled class="layui-input"/>
                            </div>
                            <div class="layui-form-mid">小时</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="text" id="hourRoomPlace" name="hourRoomPlace" style="width: 30px;"
                                       disabled class="layui-input"/>
                            </div>
                            <div class="layui-form-mid">元</div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <div class="layui-input-inline" style="width: auto">
                            <input type="checkbox" name="addService" lay-filter="addService" lay-skin="primary"
                                   id="addService" value="1"/>
                        </div>
                        <div class="layui-form-mid">增值服务</div>
                        <div class="layui-input-block" style="width: auto">
                            <div class="layui-form-mid">服务类型</div>
                            <div class="layui-input-inline" style="width: auto">
                                <select name="addServiceType" id="addServiceType" disabled class="layui-input">
                                    <option value="breakfast">早餐</option>
                                </select>
                            </div>
                            <div class="layui-form-mid">数量:</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input name="addServiceCount" id="addServiceCount" style="width: 30px;"
                                       disabled class="layui-input"/>
                            </div>
                            <div class="layui-form-mid">成本价</div>
                            <div class="layui-input-inline" style="width: auto">
                                <input type="text" name="addServicePlace" id="addServicePlace" style="width: 30px;"
                                       disabled class="layui-input"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                    <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
                </div>
            </div>
        </div>
    </div>
</form>
<#--批量设置-->
<div id="dateStock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong>价格时间段设置</strong>
                    <span class="form_new_notes form_error_notes" style="right:30px;">
                    <#--<i class="warn">i</i><span class="error">日授权模式--></span></span></div>
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
                                               onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'/*,onpicking:changeDays*/})"
                                               name="startDate" id="startDate_1"/>&nbsp;至&nbsp;</label>
                                    <label class="time_limit_unit time_limit_large" for="endDate_1"><i
                                            class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_1\',{d:0});}',onpicked:changeDays})"
                                               name="endDate" id="endDate_1"/></label>
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
                        <tr>
                            <td colspan="2">
                                <table width="100%">
                                    <tbody>
                                    <tr>
                                        <td align="right" style="text-align:right;"><label for="sellPrice_1"><span
                                                class="must_be">*</span>挂牌价&nbsp;</label></td>
                                        <td><input type="text" class="input_medium" name="sellPrice_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                                   id="sellPrice_1"/>&nbsp;元
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <label for="suggestPrice_1"><span class="must_be">*</span>执行价&nbsp;</label>
                                        </td>
                                        <td><input type="text" class="input_medium" name="suggestPrice_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                                   id="suggestPrice_1"/>&nbsp;元
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" id="settle-label" style="text-align:right;">
                                            <label for="stockNum_1"><span
                                                    class="must_be">*</span>该时间段每日有效房量&nbsp;</label>
                                        </td>
                                        <td id="minStock"></td>
                                    </tr>
                                    <tr>
                                        <td align="right" id="settle-label" style="text-align:right;">
                                            <label for="stockNum_1"><span class="must_be">*</span>产品日房量&nbsp;</label>
                                        </td>
                                        <td id="settle-input">
                                            <input type="text"<#-- value="-1"--> class="input_medium" name="stockNum_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')"
                                                   id="stockNum_1" onblur="tijiao()"/>&nbsp;
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="dialog_do">
            <input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"
                   id="btn1"/>
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
<script type="text/javascript">
    layui.use(['form', 'table', 'laydate', 'jquery', 'element'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.jquery;
        var element = layui.element;


        //监听需要授权的酒店
        form.on('select(hid)', function (data) {
            var hid = data.value;
            if (hid == "") {

                $("#rid").find("option").remove();
                form.render();
            } else {
                $.ajax({
                    type: 'GET',
                    url: '/hotelProduct/findAllRoom',
                    data: {'hid': hid},
                    dataType: 'json',
                    success: function (result) {
                        $("#rid").find("option").remove();
                        for (var key in result.data) {
                            $("#rid").append("<option value='" + key + "'>" + result.data[key] + "</option>");
                        }
                        form.render();
                    }
                });
            }
        });
        //监听退款审核
        form.on('radio(refundCheck)', function (data) {
            var type = data.value;
            if (type == '1') {
                $("input[name='refundCheckTime']").attr("disabled", false);
            } else {
                $("input[name='refundCheckTime']").attr("disabled", true);
            }
            form.render('radio');
        });

        //监听入住人信息
        form.on('checkbox(checkIn)', function (data) {
            if (data.elem.checked) {
                $("input[name='checkInNum']").attr("disabled", false);
                $("input[name='checkInInfo']").attr("disabled", false);
                $("input[name='checkInOther1']").attr("disabled", false);
                $("input[name='checkInOther2']").attr("disabled", false);
            } else {
                $("input[name='checkInNum']").attr("disabled", true);
                $("input[name='checkInInfo']").attr("disabled", true);
                $("input[name='checkInOther1']").attr("disabled", true);
                $("input[name='checkInOther2']").attr("disabled", true);
            }
            form.render();
        });
        //监听入住人信息其他1
        form.on('checkbox(checkInOther1)', function (data) {
            if (data.elem.checked) {
                $("input[name='checkInInfoOther1']").attr("disabled", false);
            } else {
                $("input[name='checkInInfoOther1']").attr("disabled", true);
            }
            form.render();
        });
        //监听入住人信息其他2
        form.on('checkbox(checkInOther2)', function (data) {
            if (data.elem.checked) {
                $("input[name='checkInInfoOther2']").attr("disabled", false);
            } else {
                $("input[name='checkInInfoOther2']").attr("disabled", true);
            }
            form.render();
        });
        //监听预定限制
        form.on('radio(reserveLimit)', function (data) {
            var type = data.value;
            if (type == '1') {
                $("input[name='reserveLimitDay']").attr("disabled", true);
                $("input[name='reserveLimitHour']").attr("disabled", true);
                $("input[name='reserveLimitMinute']").attr("disabled", true);
            } else {
                $("input[name='reserveLimitDay']").attr("disabled", false);
                $("input[name='reserveLimitHour']").attr("disabled", false);
                $("input[name='reserveLimitMinute']").attr("disabled", false);
            }
            form.render();
        });
        //监听钟点房
        form.on('checkbox(hourRoom)', function (data) {
            if (data.elem.checked) {
                $("#hourRoom1").attr("disabled", false);
                $("#hourRoom2").attr("disabled", false);
                $("#hourRoomHour").attr("disabled", false);
                $("#hourRoomPlace").attr("disabled", false);
            } else {
                $("#hourRoom1").attr("disabled", true);
                $("#hourRoom2").attr("disabled", true);
                $("#hourRoomHour").attr("disabled", true);
                $("#hourRoomPlace").attr("disabled", true);
            }
            form.render();
        });
        //监听增值服务
        form.on('checkbox(addService)', function (data) {
            if (data.elem.checked) {
                $("#addServiceType").attr("disabled", false);
                $("#addServiceCount").attr("disabled", false);
                $("#addServicePlace").attr("disabled", false);
            } else {
                $("#addServiceType").attr("disabled", true);
                $("#addServiceCount").attr("disabled", true);
                $("#addServicePlace").attr("disabled", true);
            }
            form.render();
        });
    });
</script>
<script type="text/javascript">
    function getStock() {
        var riqi = $("#useDate").val();
        var roomId = $("#rid").val();
        if (roomId == '') {
            // alert("请选择房型");
            layer.msg("请选择房型");
        } else {
            $.ajax({
                type: 'GET',
                url: '/hotelProduct/getStock',
                dataType: 'json',
                data: {'roomId': roomId, 'startTime': riqi, 'endTime': riqi},
                success: function (data) {
                    var stock1 = data.stock;
                    if (stock1 == null) {
                        $("#roomStock").html("房型无库存");
                        $("#stockNum").val(0);
                        $("#stockNum").attr("disabled", true);
                    } else {
                        $("#roomStock").html(stock1 + '间');
                        $("#stockNum").attr("disabled", false);
                    }

                }
            })
        }
    }
    function changeDays() {
        var startTime = $("#startDate_1").val();
        var endTime = $("#endDate_1").val();
        var roomId = $("#rid").val();
        if (roomId == null) {
            layer.msg("请选择房型");
        } else {
            $.ajax({
                type: 'GET',
                url: '/hotelProduct/getStock',
                dataType: 'json',
                data: {'roomId': roomId, 'startTime': startTime, 'endTime': endTime},
                success: function (data) {
                    var stock1 = data.stock;
                    if (stock1 == null) {
                        $("#minStock").html(0);
                    } else {
                        $("#minStock").html(stock1);
                    }
                }
            })
        }
    }
    function tijiao() {
        var num = $("#minStock").html();
        var num1 = $("#stockNum_1").val();
        if (parseInt(num) < parseInt(num1)) {
            layer.msg('"产品日房量"设置出错,原因:产品日房量不能大于该时间段每日有效房量');
        }
    }
    function tijiao1() {
        var stockNum = $("#stockNum").val();
        var stock = $("#roomStock").html();
        stock = stock.substring(0, stock.length - 1);
        var txtfocus = false;
        if (parseInt(stock) < parseInt(stockNum)) {
            layer.msg('"产品日房量"设置出错,原因:产品日房量不能大于房型日房量');
            $("#stockNum").removeAttr("onblur");
            txtfocus == true;
            if (txtfocus) {
                $("#stockNum").on('blur', tijiao1);
            }
        }
    }
</script>
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
            str += "<p class='price'>挂:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price'>执:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
            str += "<p class='price'>库:<em>" + (value.stock ? value.stock : '') + "</em></p>";
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
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
</body>
</html>