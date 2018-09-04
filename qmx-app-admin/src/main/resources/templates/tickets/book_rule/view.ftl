<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>预览信息</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript">
        $().ready(function() {
            var $inputForm = $("#inputForm");
            $("input").attr("disabled",true);
            $("select").attr("disabled",true);
        });
    </script>
</head>
<body>

    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>规则名称:
            </th>
            <td>
                <input type="text" name="name" value="${dto.name!}" class="text" maxlength="300" style="width: 300px;" />
                <span class="tips">规则名称</span>
            </td>
        </tr>
        <#if dto.passengerInfoType != 'NONE'>
            <#assign  checkFlag = 'checked'/>
        <#else>
            <#assign  disabledFlag = 'disabled'/>
        </#if>
        <tr>
            <th>
                <label>
                    <input type="checkbox" name="needPassengerInfoCheck" dest="input[name=passengerInfoType],input[name=passengerInfoPerNum],input[name=needPassengerInfo],input[name=needPassengerInfoOther_Check],#passengerInfoPerNumInput,input[name=passengerInfoType]" ${checkFlag!} /> 是否需要游玩人信息:
                </label>
            </th>
            <td class="needPassengerInfoCheckTd">
                <label><input type="radio" name="passengerInfoType" value="ALL" checked<#if dto.passengerInfoType == 'ALL'> checked</#if> ${disabledFlag!} />需要每个客人的信息</label>
                <label><input type="radio" name="passengerInfoType" value="ONE"<#if dto.passengerInfoType == 'ONE'> checked</#if> ${disabledFlag!} />仅需要一位客人信息</label>
                <br/>
                <div style="background: #f5f5f5; margin: 5px; padding: 5px;">
                <#assign xx = '' />
                <#if dto.needPassengerInfo??>
                    <#assign xx = dto.needPassengerInfo/>
                </#if>
                    <label><input type="checkbox" name="needPassengerInfo" value="name" <#if xx?index_of('name') gt -1> checked</#if> ${disabledFlag!} />姓名</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="pinyin"<#if xx?index_of('pinyin') gt -1> checked</#if> ${disabledFlag!} /> 拼音</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="mobile"<#if xx?index_of('mobile') gt -1> checked</#if> ${disabledFlag!} /> 手机号码</label>
                    <br/>
                    <label><input type="checkbox" name="needPassengerInfo" value="Idcard"<#if xx?index_of('Idcard') gt -1> checked</#if> ${disabledFlag!} /> 身份证</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="Passport"<#if xx?index_of('Passport') gt -1> checked</#if> ${disabledFlag!} /> 护照</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="TaiwanPermit"<#if xx?index_of('TaiwanPermit') gt -1> checked</#if> ${disabledFlag!} /> 台胞证</label>
                    <label><input type="checkbox" name="needPassengerInfo" value="HKAndMacauPermit"<#if xx?index_of('HKAndMacauPermit') gt -1> checked</#if> ${disabledFlag!} /> 港澳通行证</label>
                    <span class="tips">若勾选多个，客人只需填写一个</span>
                    <br/>
                    <label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther1]"<#if dto.needPassengerInfoOther1??> ${disabledFlag!}</#if> disabled /><input type="text" name="needPassengerInfoOther1" class="text digits required" placeholder="其他1" value="${dto.needPassengerInfoOther1!}" style="width: 80px;" ${disabledFlag!} /></label>
                    <label><input type="checkbox" name="needPassengerInfoOther_Check" dest="input[name=needPassengerInfoOther2]"<#if dto.needPassengerInfoOther2??> ${disabledFlag!}</#if> disabled /><input type="text" name="needPassengerInfoOther2" class="text digits required" placeholder="其他2" value="${dto.needPassengerInfoOther2!}" style="width: 80px;" ${disabledFlag!} /></label>
                    <span class="tips">您可以自定义客人信息，如航班号等</span>
                </div>
            </td>
        </tr>
        <tr>
            <th>
                取消设置:
            </th>
            <td>
                <input type="text" name="autoCancelTime" class="text digits" min="1" value="${dto.autoCancelTime!120}" style="width: 80px;" /> 分钟后不支付自动取消 <span class="tips">默认2×60，最短5分钟，最大值不可超过21600分钟</span>
            </td>
        </tr>
        <tr>
            <th>
                预定限制:
            </th>
            <td>
                <label>
                    <input type="radio" checked="checked" name="bookLimitType" class="required" checked <#if dto.bookLimitType=='NO_LIMIT'> checked</#if> value="NO_LIMIT"/>
                    无预订时间限制
                </label><br/>
                <label>
                    <input type="radio" name="bookLimitType" dest="input[id=ADVANCE_BOOK_TIME]" class="required" value="ADVANCE_BOOK_TIME" <#if dto.bookLimitType=='ADVANCE_BOOK_TIME'> checked</#if>/>
                    提前 <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceDay" class="text digits required" value="${dto.bookAdvanceDay!0}" style="width: 30px;" <#if dto.bookLimitType!='ADVANCE_BOOK_TIME'>disabled</#if>/> 天的 <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceHour" class="text digits required" max="23" value="${dto.bookAdvanceHour!'23'}" style="width: 30px;" <#if dto.bookLimitType!='ADVANCE_BOOK_TIME'>disabled</#if>/> : <input id="ADVANCE_BOOK_TIME" type="text" name="bookAdvanceMinute" class="text digits required" max="59" value="${dto.bookAdvanceMinute!'59'}" style="width: 30px;" <#if dto.bookLimitType!='ADVANCE_BOOK_TIME'>disabled</#if>/> 之前预定
                </label><br/>
                <label>
                    <input type="radio" name="bookLimitType" dest="select[name=bookTimeRangeStart],select[name=bookTimeRangeEnd]" class="required" value="BOOK_LIMIT_TIME_RANGE" <#if dto.bookLimitType == 'BOOK_LIMIT_TIME_RANGE'>checked</#if>/>
                    指定时间范围内购买
                    <select name="bookTimeRangeStart" class="required" <#if dto.bookLimitType!='BOOK_LIMIT_TIME_RANGE'>disabled</#if>>
                    <#list 5..23 as a>
                        <option value="${a!}:00"<#if dto.bookTimeRangeStart?? && dto.bookTimeRangeStart == (a + ':00')> selected</#if>>${a}:00</option>
                        <option value="${a!}:30"<#if dto.bookTimeRangeStart?? && dto.bookTimeRangeStart == (a + ':30')> selected</#if>>${a}:30</option>
                    </#list>
                    </select> -
                    <select name="bookTimeRangeEnd" class="required" <#if dto.bookLimitType!='BOOK_LIMIT_TIME_RANGE'>disabled</#if> >
                    <#list 5..23 as a>
                        <option value="${a!}:00"<#if dto.bookTimeRangeEnd?? && dto.bookTimeRangeEnd == (a + ':00')> selected</#if>>${a}:00</option>
                        <option value="${a!}:30"<#if dto.bookTimeRangeEnd?? && dto.bookTimeRangeEnd == (a + ':30')> selected</#if>>${a}:30</option>
                    </#list>
                        <option value="00:00"<#if dto.bookTimeRangeEnd?? && dto.bookTimeRangeEnd == '00:00'> selected</#if>>00:00</option>
                    </select>
                </label><br/>
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox"<#if dto.perPhoneMaxNum?? && dto.perPhoneMaxNum != -1>checked</#if> name="perPhoneMaxNumCheck" dest="input[name=perPhoneMaxNum],input[name=phoneLimitDays]" /> 手机限制:</label>
            </th>
            <td>
                同一手机号每
            <#assign phoneFlag = !dto.perPhoneMaxNum?? || dto.perPhoneMaxNum == -1 || !dto.phoneLimitDays?? || dto.phoneLimitDays ==-1/>
                <input type="text" name="phoneLimitDays" value="${dto.phoneLimitDays!}" class="text" style="width: 80px;"<#if phoneFlag>disabled</#if> />天
                最多预订 <input type="text" name="perPhoneMaxNum" value="${dto.perPhoneMaxNum!}" class="text" style="width: 80px;" <#if phoneFlag>disabled</#if> />张门票
            </td>
        </tr>
        <tr>
            <th><label><input <#if dto.perIdcardMaxNum?? && dto.perIdcardMaxNum != -1>checked</#if>  type="checkbox" name="perIdcardMaxNumCheck" dest="input[name=perIdcardMaxNum],input[name=idcardLimitDays]" /> 身份证号预定限制:</label>
            </th>
            <td>
                同一身份证号每
            <#assign idCardFlag = !dto.perIdcardMaxNum?? || dto.perIdcardMaxNum == -1 || !dto.idcardLimitDays?? || dto.idcardLimitDays ==-1/>
                <input type="text" name="idcardLimitDays" value="${dto.idcardLimitDays!}" class="text" style="width: 80px;" <#if idCardFlag>disabled</#if> />天
                最多只能预订 <input type="text" name="perIdcardMaxNum" value="${dto.perIdcardMaxNum!}" class="text" style="width: 80px;" <#if idCardFlag>disabled</#if> /> 张门票
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox" <#if dto.idcardPrefix??>checked</#if> name="idcardPrefixCheck" dest="input[name=idcardPrefix]" /> 地区预定限制:</label>
            </th>
            <td>
                <input type="text" name="idcardPrefix" value="${dto.idcardPrefix!}" class="text" style="width: 80px;" <#if !dto.idcardPrefix??>disabled</#if> />
                <span class="tips">身份证地区编码</span>
            </td>
        </tr>
        <tr>
            <th>订单预定限制</th>
            <td>
                <label for="minBuyNum" class="cap">每单最少购买：</label>
                <input type="text" value="${dto.minBuyNum!1}" style="width:80px;" class="text digits required" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="minBuyNum" name="minBuyNum"/>
                <span class="data_unit">张门票</span>
                <br/>
                <label for="maxBuyNum" class="cap">每单最多购买：</label>
                <input type="text" value="${dto.maxBuyNum!999}" style="width:80px;" class="text digits required" onkeyup="this.value=this.value.replace(/[^\d]/g,'')" id="maxBuyNum" name="maxBuyNum"/>
                <span class="data_unit">张门票</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>预定须知:
            </th>
            <td>
                ${dto.remind!'预定须知'}
            </td>
        </tr>
    </table>
</body>
</html>