<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <script type="text/javascript" src="${base}/bak/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/input.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_003.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_004.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_006.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_005.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_002.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
    <style type="text/css">
        .error {
            color: Red;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
    </div>
</div>
<form id="signupForm" action="update.jhtml" method="post" name="signupForm">
    <input type="hidden" id="pro_value" name="pro_value" style="width: 1000px;"/>
    <input type="hidden" id="pro_value1" name="pro_value1" style="width: 1000px;"/>
    <input type="hidden" id="pro_value2" name="pro_value2" style="width: 1000px;"/>
    <input type="hidden" id="pro_value3" name="pro_value3" style="width: 1000px;"/>
    <input type="hidden" id="datePriceData" name="datePriceData" value='${distribution!}' style="width: 1000px;"/>
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息" id="change"/>

        </li>
        <li>
            <input type="button" value="扩展设置" id="change1"/>
        </li>
    </ul>
    <table class="input tabContent" id="productTableOne">
        <tr>
            <th>
                <span class="requiredField">*</span>产品名称:
            </th>
            <td>
            ${dto.name!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>房型:
            </th>
            <td>
            ${dto.ridName!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>状态:
            </th>
            <td>
            <#if '${dto.status!}'=='上架'>上架</#if>
            <#if '${dto.status!}'=='下架'>下架</#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>窗型:
            </th>
            <td>
            <#if '${dto.windowType!}'=='1'>有窗
            <#elseif '${dto.windowType!}'=='2'>无窗
            <#elseif '${dto.windowType!}'=='3'>部分有窗
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>加床:
            </th>
            <td>
            <#if '${dto.rollawayBed!}'=='1'>能
            <#elseif '${dto.rollawayBed!}'=='2'>不能
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>房间设施:
            </th>
            <td>
                <span class="requiredField"></span>便利设施:
            <#list data.amenitiesList as amenities>
                <label>
                    <input type="checkbox" name="amenities" disabled value="${amenities!}"
                           <#if dto.roomFacilities?contains(amenities)>checked</#if>/>${amenities!}
                </label>
            </#list>
                <br/>
                <span class="requiredField"></span>媒体科技:
            <#list data.mediaList as medias>
                <label>
                    <input type="checkbox" name="media" disabled value="${medias!}"
                           <#if dto.roomFacilities?contains(medias)>checked</#if>/>${medias!}
                </label>
            </#list>
                <br/>
                <span class="requiredField"></span>食品和饮品:
            <#list data.foodsList as foods>
                <label>
                    <input type="checkbox" name="foods" disabled value="${foods!}"
                           <#if dto.roomFacilities?contains(foods)>checked</#if>/>${foods!}
                </label>
            </#list>
                <br/>
                <span class="requiredField"></span>浴室:
            <#list data.showerList as showers>
                <label>
                    <input type="checkbox" name="foods" disabled value="${showers!}"
                           <#if dto.roomFacilities?contains(showers)>checked</#if>/>${showers!}
                </label>
            </#list>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>服务:
            </th>
            <td>
            <#list data.serversList as servers>
                <label>
                    <input type="checkbox" name="service" disabled value="${servers!}"
                           <#if dto.service?contains(servers)>checked</#if>/>${servers!}
                </label>
            </#list>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>预订须知:
            </th>
            <td>
            ${dto.bookingNotice!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>描述:
            </th>
            <td>
            ${dto.description!}
            </td>
        </tr>
    </table>
    <table class="input tabContent" id="productTableTwo" style="display: none">
        <tr>
            <th>
                退款设置:
            </th>
            <td>
            <#if '${dto.refundSet!}'=='1'>
                <label><input type="radio" name="refundSet" id="refundSet" value="1" disabled checked="checked"/>可以退款
                    <select name="partRefund" disabled>
                        <option value="1" <#if '${dto.partRefund!}'=='1'> selected</#if>>支持部分退款
                        </option>
                        <option value="2" <#if '${dto.partRefund!}'=='2'> selected</#if>>不支持部分退款</option>
                    </select></label>
                <label><input type="radio" name="refundSet" id="refundSet" value="2" disabled/>不可退款</label>
            <#else >
                <label><input type="radio" name="refundSet" id="refundSet" value="1" disabled/>可以退款
                    <select name="partRefund" disabled>
                        <option value="1">支持部分退款
                        </option>
                        <option value="2">不支持部分退款</option>
                    </select></label>
                <label><input type="radio" name="refundSet" id="refundSet" value="2" checked disabled/>不可退款</label>
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                退款审核:
            </th>
            <td>
            <#if '${dto.refundCheck!}'=='1'>
                <label><input type="radio" name="refundCheck" id="refundCheck1" value="1" disabled checked/>系统自动审核,审核时间:
                    <input type="text" style="width: 30px;" name="refundCheckTime"
                           value="${dto.refundCheckTime!}" disabled/>分钟<span
                            class="tips">填0为立即审核</span></label></label>
                <label><input type="radio" name="refundCheck" id="refundCheck" disabled value="2"/>人工审核</label>
            <#else >
                <label><input type="radio" name="refundCheck" id="refundCheck1" value="1" disabled/>系统自动审核,审核时间:
                    <input type="text" style="width: 30px;" name="refundCheckTime" disabled/>分钟<span
                            class="tips">填0为立即审核</span></label>
                <label><input type="radio" name="refundCheck" id="refundCheck" value="2"
                              checked="checked" disabled/>人工审核</label>
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                取消时间:
            </th>
            <td>
                下单后<input type="text" name="cancelTime" value="${dto.cancelTime!}"
                          style="width: 30px;" disabled/>分钟未支付取消订单</label>
                <span
                        class="tips">默认下单后30分钟取消订单</span>
            </td>
        </tr>
        <tr>
            <th>
                联系人信息:
            </th>
            <td>
            <#if  dto.contacts?contains("phone")>
                <label><input type="checkbox" name="contacts1" value="phone" checked="checked"
                              disabled="disabled"/>手机号</label>
            <#else >
                <label><input type="checkbox" name="contacts1" value="phone" disabled/>手机号</label>
            </#if>
            <#if  dto.contacts?contains("name")>
                <label><input type="checkbox" name="contacts1" value="name" checked="checked"
                              disabled="disabled"/>姓名</label>
            <#else >
                <label><input type="checkbox" name="contacts1" disabled value="name"/>姓名</label>
            </#if>
            <#if  dto.contacts?contains("idCard")>
                <label><input type="checkbox" name="contacts1" disabled value="idCard" checked/>身份证</label>
            <#else >
                <label><input type="checkbox" name="contacts1" disabled value="idCard"/>身份证</label>
            </#if>
            </td>
        </tr>
        <tr>
        <#if '${dto.checkIn!}'=='2'>
            <th>
                <input type="checkbox" name="checkIn" id="checkIn" value="1" disabled/>入住人信息:
            </th>
            <td>
                <span class="radioGroup">
                    <label><input type="radio" name="checkInNum" id="checkInNum" value="1" checked="checked" disabled/>需要每个入住人信息</label>
                    <label><input type="radio" name="checkInNum" id="checkInNum" value="2" disabled/>仅需要一个入住人信息</label>
                </span>
                <br/>
                <div style="background: #f5f5f5; margin: 5px; padding: 5px;">
                    <label><input type="checkbox" checked="checked" name="checkInInfoName" value="name" disabled/><input
                            type="hidden" name="checkInInfo" value="name"/>姓名</label>
                    <label><input type="checkbox" name="checkInInfo" value="pinyin" disabled/> 拼音</label>
                    <label><input type="checkbox" name="checkInInfo" value="mobile" disabled/> 手机号码</label>
                    <br/>
                    <label><input type="checkbox" name="checkInInfo" value="idCard" disabled/> 身份证</label>
                    <label><input type="checkbox" name="checkInInfo" value="Passport" disabled/> 护照</label>
                    <label><input type="checkbox" name="checkInInfo" value="TaiwanPermit" disabled/> 台胞证</label>
                    <label><input type="checkbox" name="checkInInfo" value="HKAndMacauPermit" disabled/> 港澳通行证</label>
                    <span class="tips">若勾选多个，客人只需填写一个</span>
                    <br/>
                    <label><input type="checkbox" name="checkInOther1" id="checkInOther1" value="1" disabled/>
                        <input type="text" name="checkInInfoOther1" id="checkInInfoOther1" class="text required"
                               placeholder="其他1"
                               style="width: 80px;" disabled/></label>
                    <label><input type="checkbox" name="checkInOther2" id="checkInOther2" value="1" disabled/>
                        <input type="text" name="checkInInfoOther2" id="checkInInfoOther2" class="text required"
                               placeholder="其他2"
                               style="width: 80px;" disabled/></label>
                    <span class="tips">您可以自定义客人信息，如航班号等</span>
                </div>
            </td>
        <#else>
            <th>
                <input type="checkbox" name="checkIn" id="checkIn" value="1" checked disabled/>入住人信息:
            </th>
            <td>
                <span class="radioGroup">
                    <#if '${dto.checkInNum!}'=='1'>
                        <label><input type="radio" name="checkInNum" id="checkInNum" value="1" checked="checked"
                                      disabled/>需要每个入住人信息</label>
                    <label><input type="radio" name="checkInNum" id="checkInNum" value="2" disabled/>仅需要一个入住人信息</label>
                    <#else >
                        <label><input type="radio" name="checkInNum" id="checkInNum" value="1"
                                      disabled/>需要每个入住人信息</label>
                    <label><input type="radio" name="checkInNum" id="checkInNum" value="2" checked disabled/>仅需要一个入住人信息</label>
                    </#if>
                     </span>
                <br/>
                <div style="background: #f5f5f5; margin: 5px; padding: 5px;">
                    <label><input type="checkbox" checked="checked" name="checkInInfoName" value="name" disabled/>
                        <input type="hidden" name="checkInInfo" value="name"/>姓名</label>
                    <#if dto.checkInInfo?contains("pinyin")>
                        <label><input type="checkbox" name="checkInInfo" value="pinyin" disabled checked/> 拼音</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="pinyin" disabled/> 拼音</label>
                    </#if>
                    <#if dto.checkInInfo?contains("mobile")>
                        <label><input type="checkbox" name="checkInInfo" value="mobile" disabled checked/> 手机号码</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="mobile" disabled/> 手机号码</label>
                    </#if>
                    <br/>
                    <#if dto.checkInInfo?contains("idCard")>
                        <label><input type="checkbox" name="checkInInfo" value="idCard" checked disabled/> 身份证</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="idCard" disabled/> 身份证</label>
                    </#if>
                    <#if dto.checkInInfo?contains("Passport")>
                        <label><input type="checkbox" name="checkInInfo" value="Passport" disabled checked/> 护照</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="Passport" disabled/> 护照</label>
                    </#if>
                    <#if dto.checkInInfo?contains("TaiwanPermit")>
                        <label><input type="checkbox" name="checkInInfo" value="TaiwanPermit" disabled checked/>
                            台胞证</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="TaiwanPermit" disabled/> 台胞证</label>
                    </#if>
                    <#if dto.checkInInfo?contains("HKAndMacauPermit")>
                        <label><input type="checkbox" name="checkInInfo" value="HKAndMacauPermit" checked disabled/>
                            港澳通行证</label>
                    <#else>
                        <label><input type="checkbox" name="checkInInfo" value="HKAndMacauPermit" disabled/>
                            港澳通行证</label>
                    </#if>

                    <span class="tips">若勾选多个，客人只需填写一个</span>
                    <br/>
                    <#if '${dto.checkInOther1!}'=='1'>
                        <label><input type="checkbox" name="checkInOther1" id="checkInOther1" value="1" disabled
                                      checked/>
                            <input type="text" name="checkInInfoOther1" id="checkInInfoOther1" class="text required"
                                   placeholder="其他1"
                                   style="width: 80px;" value="${dto.checkInInfoOther1!}" disabled/></label>
                    <#else >
                        <label><input type="checkbox" name="checkInOther1" id="checkInOther1" value="1" disabled/>
                            <input type="text" name="checkInInfoOther1" id="checkInInfoOther1" class="text required"
                                   placeholder="其他1"
                                   style="width: 80px;" disabled/></label>
                    </#if>
                    <#if '${dto.checkInOther2!}'=='1'>
                        <label><input type="checkbox" name="checkInOther2" id="checkInOther2" value="1" checked
                                      disabled/>
                            <input type="text" name="checkInInfoOther2" id="checkInInfoOther2" class="text required"
                                   placeholder="其他2"
                                   style="width: 80px;" value="${dto.checkInInfoOther2!}" disabled/></label>
                    <#else >
                        <label><input type="checkbox" name="checkInOther2" id="checkInOther2" value="1" disabled/>
                            <input type="text" name="checkInInfoOther2" id="checkInInfoOther2" class="text required"
                                   placeholder="其他2"
                                   style="width: 80px;" disabled/></label>
                    </#if>
                    <span class="tips">您可以自定义客人信息，如航班号等</span>
                </div>
            </td>
        </#if>
        </tr>
        <tr>
            <th>
                短信模板:
            </th>
            <td>
            <#if '${dto.note!}'=='1'>阿里云测
            <#elseif '${dto.note!}'=='2'>酒店模版
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                预定限制:
            </th>
            <td>
            <#if '${dto.reserveLimit!}'=='1'>
                <label><input type="radio" name="reserveLimit" id="reserveLimit1" value="1" checked
                              disabled/>无预定时间限制</label>
                <br/>
                <label><input type="radio" name="reserveLimit" value="2" style="width: 30px;" id="reserveLimit"
                              disabled/>提前
                    <input type="text" name="reserveLimitDay" style="width: 30px;" disabled/>天的
                    <input type="text" name="reserveLimitHour" style="width: 30px;" disabled/>:<input type="text"
                                                                                                      name="reserveLimitMinute"
                                                                                                      style="width: 30px;"
                                                                                                      disabled/>点之前预定</label>
            <#else >
                <label><input type="radio" name="reserveLimit" id="reserveLimit1" value="1" disabled/>无预定时间限制</label>
                <br/>
                <label><input type="radio" name="reserveLimit" value="2" style="width: 30px;" id="reserveLimit"
                              checked disabled/>提前
                    <input type="text" name="reserveLimitDay" style="width: 30px;" value="${dto.reserveLimitDay!}"
                           disabled
                    />天的
                    <input type="text" name="reserveLimitHour" style="width: 30px;" value="${dto.reserveLimitHour!}"
                           disabled
                    />:
                    <input type="text" name="reserveLimitMinute" style="width: 30px;"
                           value="${dto.reserveLimitMinute!}" disabled/>点之前预定</label>
            </#if>
            </td>
        </tr>
        <tr>
        <#if '${dto.hourRoom!}'=='1'>
            <th>
                <label><input type="checkbox" name="hourRoom" id="hourRoom" value="1" checked disabled/>钟点房:</label>
            </th>
            <td>
                <label>在<select name="hourRoomTimes" id="hourRoom1" disabled>
                    <#list startTime as info>
                        <option value="${info!}"
                                <#if '${dto.hourRoomTimes!}'=='${info!}'>selected</#if>>${info!}
                        </option>
                    </#list>
                </select>--<select name="hourRoomTimes1" id="hourRoom2" disabled>
                    <#list endTime as info>
                        <option value="${info!}"
                                <#if '${dto.hourRoomTimes1!}'=='${info!}'>selected</#if>>${info!}
                        </option>
                    </#list>
                </select>时间段内，每
                    <input type="text" name="hourRoomHour" style="width: 30px;" id="hourRoomHour"
                           value="${dto.hourRoomHour!}" disabled/>小时<input
                            type="text" id="hourRoomPlace" name="hourRoomPlace" style="width: 30px;"
                            value="${dto.hourRoomPlace}" disabled/>元</label>
            </td>
        <#else>
            <th>
                <label><input type="checkbox" name="hourRoom" id="hourRoom" value="1" disabled/>钟点房:</label>
            </th>
            <td>
                <label>在<select name="hourRoomTimes" id="hourRoom1" disabled>
                    <#list startTime as info>
                        <option value="${info!}">${info!}</option>
                    </#list>
                </select>-- <select name="hourRoomTimes1" id="hourRoom2" disabled>
                    <#list endTime as info>
                        <option value="${info!}">${info!}</option>
                    </#list>
                </select>时间段内，每
                    <input type="text" name="hourRoomHour" style="width: 30px;" id="hourRoomHour" disabled="disabled"/>小时<input
                            type="text" id="hourRoomPlace" name="hourRoomPlace" style="width: 30px;"
                            disabled="disabled"/>元</label>
            </td>
        </#if>
        </tr>
        <tr>
        <#if '${dto.addService!}'=='1'>
            <th>
                <label><input type="checkbox" name="addService" id="addService" value="1" checked
                              disabled/>增值服务:</label>
            </th>
            <td>
                <label>服务类型:<select name="addServiceType" id="addServiceType" disabled>
                    <option value="breakfast" <#if '${dto.addServiceType!}'=='breakfast'>selected</#if>>早餐
                    </option>
                </select>;数量:<input type="text" name="addServiceCount" id="addServiceCount" style="width: 30px;"
                                    value="${dto.addServiceCount!}" disabled/>;成本价:
                    <input type="text" name="addServicePlace" id="addServicePlace" style="width: 30px;"
                           value="${dto.addServicePlace!}" disabled/></label>
            </td>
        <#else>
            <th>
                <label><input type="checkbox" name="addService" id="addService" value="1" disabled/>增值服务:</label>
            </th>
            <td>
                <label>服务类型:<select name="addServiceType" id="addServiceType" disabled>
                    <option value="breakfast">早餐</option>
                </select>;数量:<input type="text" name="addServiceCount" id="addServiceCount" style="width: 30px;"
                                    disabled/>;成本价:
                    <input type="text" name="addServicePlace" id="addServicePlace" style="width: 30px;"
                           disabled/></label>
            </td>
        </#if>
        </tr>
    </table>
    <table class="input" align="center" id="rateTable">
        <tbody>
        <tr class="needdate ">
            <th>设置产品价格
            </th>
            <td>
                <div class="choose_date_month">
                    <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}" date="${.now?string("yyyy-MM")}-01"
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
                </div>

            </td>
        </tr>
        </tbody>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //表单验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                floors: 'number',
                status: 'required',
                floors: 'required',
                breakfast: 'required',
                rollawayBed: 'required'

            },
            messages: {
                floors: '请输入正确的楼层!',
                status: '必选',
                floors: '请输入楼层信息',
                breakfast: '请输入早餐信息',
                rollawayBed: '必选'
            }
        });
    }();
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
            str += "<p class='price' style='width: 100px;'>挂:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price' style='width: 100px;'>执:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
            str += "<p class='price' style='width: 100px;'>库:<em>" + (value.stock ? value.stock : '0') + "</em></p>";
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
    function getStock() {
        var riqi = $("#useDate").val();
        var roomId = $("#rid").val();
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
    function changeDays() {
        var startTime = $("#startDate_1").val();
        var endTime = $("#endDate_1").val();
        var roomId = $("#rid").val();
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
</script>
<script type="text/javascript">
    $("#change").click(function () {
        $("#productTableOne").css('display', 'block');
        $("#productTableTwo").css('display', 'none');
        $("#rateTable").css('display', 'block');
    });
    $("#change1").click(function () {
        $("#productTableOne").css('display', 'none');
        $("#productTableTwo").css('display', 'block');
        $("#rateTable").css('display', 'none');
    });
    $('#hourRoom').click(function () {
        // do something
        if ($("#hourRoom").attr("checked")) {
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
    });
    $('#checkIn').click(function () {
        // do something
        if ($("#checkIn").attr("checked")) {
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
    });
    $('#checkInOther1').click(function () {
        // do something
        if ($("#checkInOther1").attr("checked")) {
            $("input[name='checkInInfoOther1']").attr("disabled", false);
        } else {
            $("input[name='checkInInfoOther1']").attr("disabled", true);
        }
    });
    $('#checkInOther2').click(function () {
        // do something
        if ($("#checkInOther2").attr("checked")) {
            $("input[name='checkInInfoOther2']").attr("disabled", false);
        } else {
            $("input[name='checkInInfoOther2']").attr("disabled", true);
        }
    });
    $('#refundCheck1').click(function () {
        // do something
        $("input[name='refundCheckTime']").attr("disabled", false);
    });
    $("#refundCheck").click(function () {
        $("input[name='refundCheckTime']").attr("disabled", true);
    });
    $('#reserveLimit').click(function () {
        // do something
        $("input[name='reserveLimitDay']").attr("disabled", false);
        $("input[name='reserveLimitHour']").attr("disabled", false);
        $("input[name='reserveLimitMinute']").attr("disabled", false);
    });
    $('#addService').click(function () {
        // do something
        if ($("#addService").attr("checked")) {
            $("#addServiceType").attr("disabled", false);
//            $("#addServiceType").removeAttr("disabled");
            $("#addServiceCount").attr("disabled", false);
            $("#addServicePlace").attr("disabled", false);
        } else {
            $("#addServiceType").attr("disabled", true);
            $("#addServiceCount").attr("disabled", true);
            $("#addServicePlace").attr("disabled", true);
        }
    });
    $("#reserveLimit1").click(function () {
        $("input[name='reserveLimitDay']").attr("disabled", true);
        $("input[name='reserveLimitHour']").attr("disabled", true);
        $("input[name='reserveLimitMinute']").attr("disabled", true);
    });
    //获取产品服务
    function getProductServer() {
        var pro_value = [];
        //产品服务
        $('input[name="service"]:checked').each(function () {
            pro_value.push($(this).val())
        });
        $("#pro_value").val(JSON.stringify(pro_value));
    }
    //获取产品设施
    function getProductFacility() {
        var amenities = [];
        var media = [];
        var foods = [];
        var shower = [];
        //便利设施
        $('input[name="amenities"]:checked').each(function () {
            amenities.push($(this).val());
        });
        //媒体科技
        $('input[name="media"]:checked').each(function () {
            media.push($(this).val());
        });
        //食品和饮品
        $('input[name="foods"]:checked').each(function () {
            foods.push($(this).val());
        });
        //浴室
        $('input[name="shower"]:checked').each(function () {
            shower.push($(this).val());
        });
        //媒体科技
        var bianli = {"便利设施": amenities};
        var meiti = {"媒体科技": media};
        var shipin = {"食品和饮品": foods};
        var yushi = {"浴室": shower};
        var zonghe = [];
        zonghe.push(bianli);
        zonghe.push(meiti);
        zonghe.push(shipin);
        zonghe.push(yushi);
        $("#pro_value1").val(JSON.stringify(zonghe));
    }
    //获取联系人信息
    function getContacts() {
        var contacts = [];
        $('input[name="contacts1"]:checked').each(function () {
            contacts.push($(this).val());
        });
        $("#pro_value2").val(JSON.stringify(contacts));
    }
    //获取入住人信息
    function getCheckIn() {
        var checkIn = [];
        if ($("#checkIn").attr("checked")) {
            checkIn.push("name");
            $('input[name="checkInInfo"]:checked').each(function () {
                checkIn.push($(this).val());
            });
        } else {
            checkIn.push(null);
        }
        $("#pro_value3").val(JSON.stringify(checkIn));
    }
    function tijiao() {
        getCheckIn();
        getContacts();
        getProductFacility();
        getProductServer();
        $("form[name='signupForm']").submit();
    }
</script>
<script type="text/javascript" src="${base}/js/calendarprice2.js"></script>
</body>
</html>