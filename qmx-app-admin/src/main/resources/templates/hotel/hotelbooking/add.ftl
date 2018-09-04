<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
<script src="http://yui.yahooapis.com/3.5.1/build/yui/yui-min.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/common.js"></script>
<script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/bak/js/yui-min.js"></script>-->
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;
            laydate.render({
                elem: '#sTime'
                , min: '${.now?datetime}'
                , done: function (value, date) {
                    var min = $.extend({}, date);
                    min.month = min.month - 1;
                    endIns.config.min = min;
                    $(endIns.config.elem).focus().val('');
                }
            });
            var endIns = laydate.render({
                elem: '#eTime',
                done: function (value) {
                    var sTime = $("#sT").val();
                    var eTime = $("#eT").val();
                    $.ajax({
                        url: '/hotel/hotelBooking/findHotel',
                        type: 'POST',
                        async: false,
                        //dataType:'json',
                        data: {"sTime": sTime, "eTime": eTime},
                        success: function (result) {
                            $(".selectHotelId").remove();
                            for (var key in result) {
                                $("#selectHotel").after("<option class='selectHotelId' value=" + key + ">" + result[key] + "</option>");
                            }
                            form.render('select');
                        }
                    })
                }
            });

            form.on('checkbox(mtime)', function (data) {
                var mtime = data.value;
                if (mtime == '1') {
                    $("input[name='sTime']").attr("disabled", false);
                    $("input[name='eTime']").attr("disabled", false);
                } else {
                    $("input[name='sTime']").attr("disabled", true);
                    $("input[name='eTime']").attr("disabled", true);
                }
            });
        })
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>预订</legend>
</fieldset>
<form action="/hotel/hotelOrder/save" method="post" id="signupForm" class="layui-form">
    <!--支付状态-->
    <input name="paymentStatus" value="unpaid" type="hidden"/>
    <!--库存量-->
    <input type="hidden" id="stock" value="${stock!}"/>
    <!--酒店id-->
    <input type="hidden" name="hotleId" id="hotleId" value="${dto.hid!}"/>
    <!--使用天数-->
    <input type="hidden" name="nights" id="nt" value="${days!}" readonly="readonly" class="text required"/>
    <!--产品id-->
    <input type="hidden" name="productId" id="pId" value="${dto.id!}"/>
    <!--总金额-->
    <input type="hidden" name="payment" id="totalPrice" readonly="readonly" class="text required"/>
    <!--预定日期数组，预定当天和离店时间-->
    <input type="hidden" id="orderDateStr" name="orderDateStr" value='${rateDto.jsonArrayDate!}'/>
    <!--预定日期和价格，入住几晚的时间-->
    <input type="hidden" id="orderDataStr" name="orderDataStr" value='${rateDto.jsonArrayDatePrice!}'/>
    <!--总价格-->
    <input type="hidden" id="total" value="${rateDto.total!}"/>
    <input type="hidden" id="checkInPeronalData" name="checkInPerson"/>
    <!--入住时间-->
    <input type="hidden" id="checkIn" name="checkIn" value="${sTime!}"/>
    <!--离店时间-->
    <input type="hidden" id="checkOut" name="checkOut" value="${eTime!}"/>
    <!--支付时间-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 110px;">购买产品名称</label>
            <div class="layui-form-mid">${dto.name}</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 110px;">订购房间数</label>
            <div class="layui-input-inline">
                <input class="layui-input" id="number" name="roomNumber" onchange="onChange()"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: auto">
        <#--<div class="layui-form-mid"><input type="checkbox" lay-skin="primary" name="mtime" id="mtime"/></div>-->
            <label class="layui-form-label" style="width: 110px;">
                <input type="checkbox" lay-skin="primary" lay-filter="mtime" name="mtime" id="mtime" value="1"/>修改预订时间
            </label>
            <div class="layui-input-inline">
                <input disabled id="sTime" name="sTime"
                       placeholder="订房时间起" class="layui-input" value="${sTime}" <#--onchange="mTime()"-->/>
            </div>
            <div class="layui-input-inline">
                <input disabled id="eTime" name="eTime"
                       placeholder="订房时间止" class="layui-input" value="${eTime}" <#--onchange="mTime()"-->/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 110px;">订房信息</label>
        <div class="layui-input-block">
            <table id="innerTable" class="layui-table" style="width: 350px;">
                <tr id="orderData">
                    <th>日期</th>
                    <th>价格</th>
                </tr>
            <#list rateDtoList as info>
                <tr class="showOrder">
                    <td align="center"><#--入住：${sTime!}<br/>离店：${eTime!}-->${info.date!}</td>
                    <td align="center">${info.marketPrice!}${info.advisePrice!}<span
                            class="roomNumbers"></span></span></td>
                </tr>
            </#list>
                <input type="hidden" id="showOrderData"/>
                <tr>
                    <th align="right">使用天数：<span id="days">${days!}</span>（晚）</th>
                    <th align="right">总价格：<span id="totalShow">0</span>（元）</th>
                </tr>
            </table>
        </div>
    </div>
<#list contactList as info>
    <#if info=='name'>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 110px;">联系人姓名</label>
                <div class="layui-input-inline">
                    <input name="contactName" class="layui-input"/>
                </div>
            </div>
        </div>
    </#if>
    <#if info=='phone'>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 110px;">联系人手机号码</label>
                <div class="layui-input-inline">
                    <input name="contactPhone" class="layui-input"/>
                </div>
            </div>
        </div>
    </#if>
    <#if info=='idCard'>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 110px;">联系人身份证</label>
                <div class="layui-input-inline">
                    <input name="contactIdCard" class="layui-input"/>
                </div>
            </div>
        </div>
    </#if>
</#list>
<#if (checkInInfoList?size>0)>
    <div class="layui-form-item">
        <label class="layui-form-label" style="width: 110px;">入住人信息</label>
        <div class="layui-input-block">
            <table id="checkInData" class="layui-table" style="width: auto">
                <tr>
                    <#list checkInInfoList as info>
                        <#if info='name'>
                            <th>姓名:</th>
                            <td><input name="chinkInName" class="layui-input"/></td>
                        </#if>
                        <#if info='pinyin'>
                            <th>姓名拼音:</th>
                            <td><input name="chinkInPingyin" class="layui-input"/></td>
                        </#if>
                        <#if info='mobile'>
                            <th>手机号码:</th>
                            <td><input name="chinkInPhone" class="layui-input"/></td>
                        </#if>
                    </#list>
                </tr>
                <!--判断产品的所需要的入住人信息-->
                <#assign idFlag=0 />
                <#list checkInInfoList as info>
                    <#if '${info!}'='idCard'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='Passport'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='TaiwanPermit'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='HKAndMacauPermit'>
                        <#assign idFlag=1 />
                    </#if>
                </#list>
                <#if idFlag=1>
                    <tr class="checkInPersonDataTr2">
                        <th>证件号码:</th>
                        <td style="width: auto">
                            <select name='idData' class='layui-input'>
                                <option value="">-证件类型-</option>
                                <#list checkInInfoList as info>
                                    <#if '${info!}'='idCard'>
                                        <option value='Idcard'>身份证</option>
                                    </#if>
                                    <#if '${info!}'='Passport'>
                                        <option value='Passport'>护照</option>
                                    </#if>
                                    <#if '${info!}'='TaiwanPermit'>
                                        <option value='TaiwanPermit'>台胞证</option>
                                    </#if>
                                    <#if '${info!}'='HKAndMacauPermit'>
                                        <option value='HKAndMacauPermit'>港澳通行证</option>
                                    </#if>
                                </#list>
                            </select>
                            <input name='checkInPersonIdCard' class='layui-input'/>
                        </td>
                    </tr>
                </#if>
                <input type="hidden" id="tableAdd"/>
            </table>
        </div>
    </div>
</#if>
<#--<table class="layui-table" style="display: none">
    <tr class="data1">
    <#list checkInInfoList as info>
        <#if info='name'>
            <th>入住人姓名:</th>
            <td><input name="chinkInName" class="layui-input"/></td>
        </#if>
        <#if info='pinyin'>
            <th>姓名拼音:</th>
            <td><input name="chinkInPingyin" class="layui-input"/></td>
        </#if>
        <#if info='mobile'>
            <th>手机号码:</th>
            <td><input name="chinkInPhone" class="layui-input"/></td>
        </#if>
    </#list>
    </tr>
<#if idFlag=1>
    <tr class="data2">
        <th>证件号码:</th>
        <td style="width: auto">
            <select name='idData' class='layui-input'>
                <option value="">-证件类型-</option>
                <#list checkInInfoList as info>
                    <#if '${info!}'='idCard'>
                        <option value='Idcard'>身份证</option>
                    </#if>
                    <#if '${info!}'='Passport'>
                        <option value='Passport'>护照</option>
                    </#if>
                    <#if '${info!}'='TaiwanPermit'>
                        <option value='TaiwanPermit'>台胞证</option>
                    </#if>
                    <#if '${info!}'='HKAndMacauPermit'>
                        <option value='HKAndMacauPermit'>港澳通行证</option>
                    </#if>
                </#list>
            </select>
            <input name='checkInPersonIdCard' class='layui-input'/>
        </td>
    </tr>
</#if>
</table>-->
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="submit" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
<#--<table class="input tabContent" id="tabAdd">
&lt;#&ndash; <tr>
     <th>购买产品名称:&nbsp;</th>
     <td>
         <input type="text" class="text required" readonly="readonly" value="${dto.name}" name="productName"/>
         <span style="color: red">预订须知：${dto.bookingNotice!}</span></td>
 </tr>
 <tr>
     <th>
         订购房间数:
     </th>
     <td>
         <input type="text" style="width: 30px" id="number" name="roomNumber" onchange="onChange()"/>
         <!--可预订房间数小于5&ndash;&gt;
     &lt;#&ndash;<input name="roomNumber" id="number"  onchange="onChange()" type="text" class="text required"  />&ndash;&gt;
     &lt;#&ndash;<select name="roomNumber" id="roomNumber" onchange="onChange()">
         <option class="selectRoomNumbers" value="">-房间数-</option>
     <#list 1..stock as t>
         <option class="selectRoomNumber" value=" ${t}"> ${t}</option>
     </#list>
         <input type="hidden" id="roomNumberHidden"/>
     </select>&ndash;&gt;
     </td>
 </tr>
 <tr>
     <th><input type="checkbox" name="mtime" id="mtime" value="1"/>修改预订时间：</th>
     <td>
     &lt;#&ndash;入住时间：<input disabled="disabled" id="sTime" name="checkIn" type="text"
                 onfocus="WdatePicker({minDate:'%y-%M-%d'})" placeholder="订房时间起" value="${sTime!}"/>
     离店时间：<input disabled="disabled" id="eTime" name="checkOut" type="text"
                 onFocus="WdatePicker({minDate:'#F{$dp.$D(\'sTime\')}',maxDate:'2020-10-01'})" placeholder="订房时间止" value="${eTime!}"/>
     <input type="button" value="查询" onclick="mTime()" disabled="disabled" id="mTimeButton"
            name="mTimeButton"/>&ndash;&gt;
         入住时间：<input disabled="disabled" id="sTime" name="sTime" type="text"
                     placeholder="订房时间起" class="Wdate" value="${sTime}" onchange="mTime()"/>
         离店时间：<input disabled="disabled" id="eTime" name="eTime" type="text"
                     placeholder="订房时间止" class="Wdate" value="${eTime}" onchange="mTime()"/>
     &lt;#&ndash;<input type="button" value="查询" onclick="mTime()" disabled="disabled" id="mTimeButton"
            name="mTimeButton"/>&ndash;&gt;
         <span id="tips" style="color: red"></span>
     </td>
 </tr>
 <tr>
     <th>订房信息:</th>
     <td>
         <table id="innerTable">
             <tr id="orderData">
                 <th>日期</th>
                 <th>价格</th>
             </tr>
         <#list rateDtoList as info>
             <tr class="showOrder">
                 <td align="center">&lt;#&ndash;入住：${sTime!}<br/>离店：${eTime!}&ndash;&gt;${info.date!}</td>
                 <td align="center">${info.marketPrice!}${info.advisePrice!}<span
                         class="roomNumbers"></span></span></td>
             </tr>
         </#list>
             <input type="hidden" id="showOrderData"/>
             <tr>
                 <th align="right">使用天数：<span id="days">${days!}</span>（晚）</th>
                 <th align="right">总价格：<span id="totalShow">0</span>（元）</th>
             </tr>
         </table>
     </td>
 </tr>
<#list contactList as info>
 <#if info="name">
     <tr id="personalData">
         <th><span class="requiredField">*</span>联系人姓名:</th>
         <td>
             <input type="text" name="contactName" class="text required"/>
         </td>
     </tr>
 </#if>
 <#if info=="phone">
     <tr>
         <th><span class="requiredField">*</span>联系人手机号码:</th>
         <td>
             <input name="contactPhone" type="text" class="text required"/>
         </td>
     </tr>
 </#if>
 <#if info="idCard">
     <tr id="personalData">
         <th><span class="requiredField">*</span>联系人身份证:</th>
         <td>
             <input type="text" name="contactIdCard" class="text required"/>
         </td>
     </tr>
 </#if>
</#list>&ndash;&gt;
<#if (checkInInfoList?size>0)>
    <tr>
        <th>入住人信息:</th>
        <td>
            <table id="checkInData">
                <tr class="checkInPersonDataTr1">
                    <#list checkInInfoList as info>
                        <#if info='name'>
                            <th>姓名:</th>
                            <td><input type="text" name="chinkInName" class="text required"/></td>
                        </#if>
                        <#if info='pinyin'>
                            <th>姓名拼音:</th>
                            <td><input type="text" name="chinkInPingyin" class="text required"/></td>
                        </#if>
                        <#if info='mobile'>
                            <th>手机号码:</th>
                            <td><input type="text" name="chinkInPhone" class="text required"/></td>
                        </#if>
                    </#list>
                </tr>
                <!--判断产品的所需要的入住人信息&ndash;&gt;
                <#assign idFlag=0 />
                <#list checkInInfoList as info>
                    <#if '${info!}'='idCard'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='Passport'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='TaiwanPermit'>
                        <#assign idFlag=1 />
                    </#if>
                    <#if '${info!}'='HKAndMacauPermit'>
                        <#assign idFlag=1 />
                    </#if>
                </#list>
                <#if idFlag=1>
                    <tr class="checkInPersonDataTr2">
                        <th><span class='requiredField'></span>证件号码:</th>
                        <#if idFlag=1 >
                            <td>
                                <select name='idData' class='required'>
                                    <option value="">-证件类型-</option>
                                    <#list checkInInfoList as info>
                                        <#if '${info!}'='idCard'>
                                            <option value='Idcard'>身份证</option>
                                        </#if>
                                        <#if '${info!}'='Passport'>
                                            <option value='Passport'>护照</option>
                                        </#if>
                                        <#if '${info!}'='TaiwanPermit'>
                                            <option value='TaiwanPermit'>台胞证</option>
                                        </#if>
                                        <#if '${info!}'='HKAndMacauPermit'>
                                            <option value='HKAndMacauPermit'>港澳通行证</option>
                                        </#if>
                                    </#list>
                                </select>
                                <input type='text' name='checkInPersonIdCard' class='text required'/>
                            </td>
                        </#if>
                    </tr>
                </#if>
                <input type="hidden" id="tableAdd"/>
            </table>
        </td>
    </tr>
</#if>
    <tr style="display: none">
        <td>
            <table>
                <tbody class="alldata">
                <tr class="data1">
                <#list checkInInfoList as info>
                    <#if info='name'>
                        <th>入住人姓名:</th>
                        <td><input type="text" name="chinkInName" class="text required"/></td>
                    </#if>
                    <#if info='pinyin'>
                        <th>姓名拼音:</th>
                        <td><input type="text" name="chinkInPingyin" class="text required"/></td>
                    </#if>
                    <#if info='mobile'>
                        <th>手机号码:</th>
                        <td><input type="text" name="chinkInPhone" class="text required"/></td>
                    </#if>
                </#list>
                </tr>
                <#if idFlag=1>
                <tr class="data2">
                    <th><span class='requiredField'></span>证件号码:</th>
                    <#if idFlag=1 >
                        <td>
                            <select name='idData' class='required'>
                                <option value="">-证件类型-</option>
                                <#list checkInInfoList as info>
                                    <#if '${info!}'='idCard'>
                                        <option value='Idcard'>身份证</option>
                                    </#if>
                                    <#if '${info!}'='Passport'>
                                        <option value='Passport'>护照</option>
                                    </#if>
                                    <#if '${info!}'='TaiwanPermit'>
                                        <option value='TaiwanPermit'>台胞证</option>
                                    </#if>
                                    <#if '${info!}'='HKAndMacauPermit'>
                                        <option value='HKAndMacauPermit'>港澳通行证</option>
                                    </#if>
                                </#list>
                            </select>
                            <input type='text' name='checkInPersonIdCard' class='text required'/>
                        </td>
                    </#if>
                </tr>
                </#if>
                </tbody>
            </table>
        </td>
    </tr>
    <tr>
        <th></th>
        <td>
            <input type="submit" class="button" value="保存" onclick="data()"/>
            <input type="button" class="button" value="返回" onclick="history.back();"/>
        </td>
    </tr>
</table>-->
</form>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                hotleId: {min: 1},
                IdAndName: {min: 1},
                sTime: 'required',
                eTime: 'required',
                roomNumber: {required: true, digits: true, range: [1, 5]},
                nights: 'required',
                payment: 'required',
                contactPhone: {required: true, digits: true},
                contactName: 'required',
                credentialsType_1: {min: 1},
                idCard: 'required'
            },
            messages: {
                hotleId: '必选',
                IdAndName: '必选',
                sTime: '必填',
                eTime: '必填',
                roomNumber: {required: '房间数量不能为空', digits: '只能输入整数', range: jQuery.format('房间数不能为‘0’或不能超过‘5’间')},
                nights: '使用天数',
                payment: '总金额不能为空',
                contactPhone: {required: '电话号码不能为空', digits: '只能输入整数'},
                contactName: '必填',
                credentialsType_1: '必选',
                idCard: '必填'
            }
        });
    }();
</script>
<script type="text/javascript">
    //时间修改
    $('#mtime').click(function () {
        // do something
        if ($("#mtime").attr("checked")) {
            $("input[name='sTime']").attr("disabled", false);
            $("input[name='eTime']").attr("disabled", false);
        } else {
            $("input[name='sTime']").attr("disabled", true);
            $("input[name='eTime']").attr("disabled", true);
        }

    });

    //入住人信息，每一个房间需要一个入住人信息
    function onChange() {
        var stock = $("#stock").val();
        stock = parseInt(stock);
        var total = $("#total").val();
        // var number = $("#roomNumber").find("option:selected").val();
        var number = $("#number").val()
        number = parseInt(number);
        $(".roomNumbers").html("x" + number);
        //每个房间需要至少一个人的入住信息
        if (number > 0) {
            $(".checkInPersonDataTr1").remove();
            $(".checkInPersonDataTr2").remove();
        }
        for (var i = 0; i < number; i++) {
            $("#tableAdd").before("<tr class='checkInPersonDataTr1'>" + $(".data1").html() + "</tr>");
            $("#tableAdd").before("<tr class='checkInPersonDataTr2'>" + $(".data2").html() + "</tr>");
        }
        var totalPrice = total * number;
        $("#totalShow").text(totalPrice);
        $("#totalPrice").val(totalPrice);
        if (number > stock) {
            alert("该时间段内最多能预定" + stock + "间房");
            return;
        }
    }
    //入住人信息组合
    function data() {
        var ind = $("#checkInData tr").length;
        var select;
        var idCardNum;
        var chinkInName;
        var chinkInPingyin;
        var chinkInPhone;
        var dataArry = [];
        $("#checkInData tr").each(function (index, item) {
            index = $(this).index() + 1;
            if (index % 2 == 0) {
                select = $(this).find('td').find('select').val();
                idCardNum = $(this).find('td').find('input').val();
                //Console.log(select+"  "+idCardNum+"---"+"chinkInName:"+chinkInName+"chinkInPingyin:"+chinkInPingyin+"chinkInPhone:"+chinkInPhone);
                var data = {};
                data.chinkInName = chinkInName;
                data.chinkInPingyin = chinkInPingyin;
                data.chinkInPhone = chinkInPhone;
                data.select = select;
                data.idCardNum = idCardNum;
                dataArry.push(data);
            } else {
                chinkInName = $(this).children('td').find("input[name='chinkInName']").val();
                chinkInPingyin = $(this).children('td').find("input[name='chinkInPingyin']").val();
                chinkInPhone = $(this).children('td').find("input[name='chinkInPhone']").val();
            }
        });
        $("#checkInPeronalData").val(JSON.stringify(dataArry));
    }
    //改变入住和离店时间
    function mTime() {
        var pId = $("#pId").val();
        var hotleId = $("#hotleId").val();
        //入住时间
        var sTime = $("#sTime").val();
        //离店时间
        var eTime = $("#eTime").val();
        $("#checkIn").val(sTime);
        $("#checkOut").val(eTime);
        $.ajax({
            url: '/hotel/hotelBooking/mTime',
            type: 'POST', //GET
            async: false,    //或false,是否异步
            data: {"sTime": sTime, "eTime": eTime, "id": pId, "hid": hotleId},
            success: function (data) {
                var Data = data;
                for (var key in Data) {
                    if ("total" == key) {
                        $("#total").val(Data[key]);
                    }
                    if ("jsonArrayDate" == key) {
                        $("#orderDateStr").val(Data[key]);
                    }
                    if ("jsonArrayDatePrice" == key) {
                        $(".showOrder").remove();
                        $("#orderDataStr").val(Data[key]);
                        var str = JSON.parse(Data[key]);
                        for (var i = 0; i < str.length; i++) {
                            $("#showOrderData").before("<tr class='showOrder'> " +
                                    "<td align='center'>" + str[i].date + "</td> " +
                                    "<td align='center'>" + str[i].price +
                                    "<span class='roomNumbers'></span></span></td> " +
                                    "</tr>");
                        }
                    }
                    if ("daysBetween" == key) {
                        $("#nt").val(Data[key]);
                        $("#days").text(Data[key]);
                    }
                    if ("stock" == key) {
                        $("#stock").val(Data[key]);
                        $(".selectRoomNumber").remove();
                        if (Data[key] == 0) {
                            $("#tips").html("tips:您选择的部分入住日期满房，请修改日期或重新选择房型");
                        } else {
                            $("#tips").html("");
                        }
                        for (var i = 1; i < Data[key] + 1; i++) {
                            var num = Data[key] + 1 - i;
                            $(".selectRoomNumbers").after("<option class='selectRoomNumber' value=" + num + ">" + num + "</option>");
                        }
                    }
                }
            }
        });
    }
    //日历插件的使用
    $(function () {
        var validate_date_Array = new Array();
        var pId = $("#pId").val();
        //查询所有有效的日期
        $.ajax({
            type: "POST",
            url: "/hotel/hotelBooking/productStock",
            dataType: "json",
            async: false,
            data: {"pId": pId},
            success: function (data) {
                //var dataObj=data.dataObj;
                var dataObj = data;
                //循环得到的List集合，放入数组中
                $.each(dataObj, function (index) {
                    validate_date_Array[index] = dataObj[index];
                });
                //给个默认值
                $("#sTime").val(validate_date_Array[0]);
            }
        });
        //!****关键代码****绑定日期控件的onfocus事件，同时将上面得到的有效日期数据绑定到控件中
        $("#sTime").on("focus", function (dp) {
            WdatePicker({
                opposite: true,//如果不设置则disabledDates参数中的值会是“无效日期”
                disabledDates: validate_date_Array,//绑定数组
                maxDate: '#F{$dp.$D(\'eTime\',{d:-1})}',
                onpicked: function (dp) { //点击某一日期后触发
                    //获取当前选中的日期
                    var curDate = dp.cal.getNewDateStr();
                }
            });
        });
        //!****关键代码****绑定日期控件的onfocus事件，同时将上面得到的有效日期数据绑定到控件中
        $("#eTime").on("focus", function (dp) {
            WdatePicker({
                opposite: true,//如果不设置则disabledDates参数中的值会是“无效日期”
                disabledDates: validate_date_Array,//绑定数组
                onpicked: function (dp) { //点击某一日期后触发
                    //获取当前选中的日期
                    var curDate = dp.cal.getNewDateStr();
                }
            });
        });
    });
</script>

</body>
</html>