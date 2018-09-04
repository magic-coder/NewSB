<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $().ready(function() {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    name: "required"
                }
            });
            // 表单验证
            $("input:radio,input:checkbox").change(function () {
                $("input[name='" + $(this).attr("name") + "']:checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", false);
                });
                $("input[name='" + $(this).attr("name") + "']").not(":checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", true);
                });
            });

            $("#passengerInfoPerNumInput").keyup(function () {
                if (isNaN($(this).val())) {
                    $(this).val(0);
                }
                $("#passengerInfoPerNum").val(parseInt($(this).val()));
            });
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加信息
    </div>
</div>
<form id="inputForm" action="/group/reserverule" method="post">
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <span class="tips">添加信息</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>规则名称:
            </th>
            <td>
                <input type="text" name="name" class="text" maxlength="300" style="width: 300px;" />
                <span class="tips">规则名称</span>
            </td>
        </tr>
        <tr>
            <th>
                <label>
                    <input type="checkbox" name="needPassengerInfoCheck"
                           dest="input[name=passengerInfoPerNum],input[name=needPassengerInfo],input[name=needPassengerInfoOther_Check],#passengerInfoPerNumInput,input[name=passengerInfoType]"/>
                    是否需要游玩人信息:</label>
            </th>
            <td>
					<span class="radioGroup">
					<label><input type="radio" name="passengerInfoType" value="ALL" checked disabled/>需要每个客人的信息</label>
					<label><input type="radio" name="passengerInfoType" value="ONE" disabled/>仅需要一位客人信息</label>
					</span>
                <br/>
                <div style="background: #f5f5f5; margin: 5px; padding: 5px;">
                    <label><input type="checkbox" name="needPassengerInfo" value="name" disabled/>姓名</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="pinyin" disabled/> 拼音</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="mobile" disabled/> 手机号码</label>
                    <br/>
                    <label><input type="checkbox" name="needPassengerInfo" value="Idcard" disabled/> 身份证</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="Passport" disabled/> 护照</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="TaiwanPermit" disabled/> 台胞证</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="HKAndMacauPermit" disabled/>
                        港澳通行证</label>
                    <span class="tips">若勾选多个，客人只需填写一个</span>
                    <br/>
                    <label>
                        <input type="checkbox" name="needPassengerInfoOther_Check"
                               dest="input[name=needPassengerInfoOther1]" disabled/>
                        <input type="text" name="needPassengerInfoOther1" class="text" placeholder="其他1" style="width: 80px;" disabled/></label>
                    <label><input type="checkbox" name="needPassengerInfoOther_Check"
                                  dest="input[name=needPassengerInfoOther2]" disabled/>
                        <input type="text" name="needPassengerInfoOther2" class="text" placeholder="其他2" style="width: 80px;" disabled/></label>
                    <span class="tips">您可以自定义客人信息，如航班号等</span>
                </div>
            </td>
        </tr>

        <tr>
            <th>
                取消设置:
            </th>
            <td>
                <input type="text" name="autoCancelTime" class="text digits" min="1" value="120" style="width: 80px;" /> 分钟后不支付自动取消 <span class="tips">默认2×60，最短5分钟，最大值不可超过21600分钟</span>
            </td>
        </tr>
        <tr>
            <th>
                预定限制:
            </th>
            <td>
                <label>
                    <input type="radio" checked="checked" name="bookLimitType" class="required" checked value="NO_LIMIT"/>
                    无预订时间限制
                </label><br/>
                <label>
                    <input type="radio" name="bookLimitType" dest="input[id=ADVANCE_BOOK_TIME]" class="required" value="ADVANCE_BOOK_TIME"/>
                    提前 <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceDay" class="text digits required" value="0" style="width: 30px;" disabled/> 天的 <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceHour" class="text digits required" max="23" value="23" style="width: 30px;" disabled/> : <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceMinute" class="text digits required" max="59" value="59" style="width: 30px;" disabled/> 之前预定
                </label><br/>
                <label>
                    <input type="radio" name="bookLimitType" dest="select[name=bookTimeRangeStart],select[name=bookTimeRangeEnd]" class="required" value="BOOK_LIMIT_TIME_RANGE"/>
                    指定时间范围内购买
                    <select name="bookTimeRangeStart" class="required" disabled>
                    <#list 5..23 as a>
                        <option value="${a!}:00">${a!}:00</option>
                        <option value="${a!}:30">${a!}:30</option>
                    </#list>
                    </select> -
                    <select name="bookTimeRangeEnd" class="required" disabled>
                    <#list 5..23 as a>
                        <option value="${a!}:00">${a!}:00</option>
                        <option value="${a!}:30">${a!}:30</option>
                    </#list>
                        <option value="00:00">00:00</option>
                    </select>
                </label><br/>
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox" name="perPhoneMaxNumCheck" dest="input[name=perPhoneMaxNum],input[name=phoneLimitDays]" /> 手机限制:</label>
            </th>
            <td>
                同一手机号每
                <input type="text" name="phoneLimitDays" class="text digits required" style="width: 80px;" disabled />天
                最多预订 <input type="text" name="perPhoneMaxNum" class="text digits required" style="width: 80px;" disabled />张门票
            </td>
        </tr>
        <tr>
            <th><label><input type="checkbox" name="perIdcardMaxNumCheck" dest="input[name=perIdcardMaxNum],input[name=idcardLimitDays]" /> 身份证号预定限制:</label>
            </th>
            <td>
                同一身份证号每
                <input type="text" name="idcardLimitDays" class="text digits required" style="width: 80px;" disabled />天
                最多只能预订 <input type="text" name="perIdcardMaxNum" class="text digits required" style="width: 80px;" disabled /> 张门票
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox" name="idcardPrefixCheck" dest="input[name=idcardPrefix]" /> 地区预定限制:</label>
            </th>
            <td>
                <input type="text" name="idcardPrefix" class="text" style="width: 80px;" disabled />
                <span class="tips">身份证地区编码</span>
            </td>
        </tr>
        <tr>
            <th>订单预定限制</th>
            <td>
                <label for="minBuyNum" class="cap">每单最少购买：</label>
                <input type="text" value="1" style="width:80px;" class="text digits required" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="minBuyNum" name="minBuyNum"/>
                <span class="data_unit">张门票</span>
                <br/>
                <label for="maxBuyNum" class="cap">每单最多购买：</label>
                <input type="text" value="999" style="width:80px;" class="text digits required" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maxBuyNum" name="maxBuyNum"/>
                <span class="data_unit">张门票</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>预定须知:
            </th>
            <td>
                <textarea name="remind" class="text required" maxlength="1000">预定须知</textarea>
                <div class="blank"></div>
                <span class="tips">必须包含以下内容：【入园凭证】【入园凭证发送时间及方式】【入园/换票时间及地址】  1000字以内。</span>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="提交" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>