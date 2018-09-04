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
            // 表单验证
            $("input").attr("disabled",true);
            $("select").attr("disabled",true);
        });
    </script>
</head>
<body>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>名称:
				<input type="hidden" name="supplierId" value="${dto.supplierId!}"/>
            </th>
            <td>
                <input type="text" name="name" value="${dto.name!}" class="text" maxlength="300" style="width: 300px;" />
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>选择验票人:
            </th>
            <td>
                <label><input type="checkbox" checked="checked" name="isSupplierCheck" value="true"/>供应商可验票</label>
                <table id="checkTicketMemberTable" width="100%">
                    <tr class="title">
                        <td>验票人姓名</td>
                        <td>验票人用户名</td>
                        <td>操作</td>
                    </tr>
                    <#if dto.checkUsers??>
                    <#list dto.checkUsers as member>
                        <#if dto.supplierId != member.id>
                            <tr class="${member.id}">
                                <td>${member.username}</td>
                                <td><input type="hidden" name="checkTicketMemberIds" value="${member.id}"/>${member.username}</td>
                                <td>
                                    <a href="javascript:;" onclick="$(this).parent().parent().remove();">删除</a>
                                </td>
                            </tr>
                        </#if>
                    </#list>
                    </#if>
                </table>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>入园地址:
            </th>
            <td>
                <input name="passAddress" class="text required" placeholder="请详细填写客人进入园区的地址" style="width: 300px;"
                       value="景区/游乐园入口"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>入园方式:
            </th>
            <td>
                <label>
                    <input type="radio" class="required" name="passType" value="VIRTUAL"<#if dto.passType=='VIRTUAL'> checked</#if> /> 凭兑换凭证直接入园
                </label>
                <br/>
                <label>
                    <input type="radio" dest="input[name=pickupAddress]" class="required" name="passType" value="ENTITY"<#if dto.passType=='ENTITY'> checked</#if> /> 凭兑换凭证换票，
                    换票地址：<input name="pickupAddress" class="text required" placeholder="请详细填写换票的地址" style="width: 300px;" value="${dto.pickupAddress!}" disabled />
                </label>
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox" name="canUseMultipleTimes" <#if dto.canUseMultipleTimes>checked</#if> dest="input[name=availableTimes]"/>是否多次票:</label>
            </th>
            <td>
                <label><input type="text" name="availableTimes" class="text required" value="${dto.availableTimes!}" placeholder="次数" style="width: 80px;"<#if !dto.canUseMultipleTimes>disabled</#if>/></label>
            </td>
        </tr>
        <tr>
            <th>
                <label>
                    <input type="checkbox" name="limitUseTimeRange"<#if dto.limitUseTimeRange?? && dto.limitUseTimeRange> checked</#if> dest="select[name=useTimeRangeStart],select[name=useTimeRangeEnd]" value="true" />使用时段:
                </label>
            </th>
            <td>
            <#assign limitUseTimeRangeFlag = dto.limitUseTimeRange?? && dto.limitUseTimeRange/>
                <select name="useTimeRangeStart" class="required" <#if !limitUseTimeRangeFlag>disabled</#if>>
                <#list 5..23 as a>
                    <option value="${a}:00"<#if dto.useTimeRangeStart?? && dto.useTimeRangeStart == (a + ':00')> selected</#if>>${a}:00</option>
                    <option value="${a}:30"<#if dto.useTimeRangeStart?? && dto.useTimeRangeStart == (a + ':30')> selected</#if>>${a}:30</option>
                </#list>
                </select> -
                <select name="useTimeRangeEnd" class="required" <#if !limitUseTimeRangeFlag>disabled</#if>>
                <#list 5..23 as a>
                    <option value="${a}:00"<#if dto.useTimeRangeEnd?? && dto.useTimeRangeEnd == (a + ':00')> selected</#if>>${a}:00</option>
                    <option value="${a}:30"<#if dto.useTimeRangeEnd?? && dto.useTimeRangeEnd == (a + ':30')> selected</#if>>${a}:30</option>
                </#list>
                    <option value="00:00"<#if dto.useTimeRangeEnd?? && dto.useTimeRangeEnd == '00:00'> selected</#if>>00:00</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                使用时间限制:
            </th>
            <td>
                <label>
                    预订后 <input id="DELAY_BOOK_HOURS" type="text" name="enterSightDelayBookHour" class="text digits required" value="${dto.enterSightDelayBookHour!}" style="width: 30px;" /> 小时才能入园
                </label><br/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>使用须知:
            </th>
            <td>
                ${dto.remind!'预定须知'}
            </td>
        </tr>
    </table>
</body>
</html>