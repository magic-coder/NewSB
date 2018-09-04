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
                <span class="tips">名称</span>
            </td>
        </tr>
        <tr>
            <th>
                退款设置:
            </th>
            <td>
                <label id="canRefundLableYes"><input type="radio" name="canRefund" dest="select[name=partRefund]" value="true" <#if dto.canRefund> checked</#if> />可以退款
                    <select name="partRefund">
                        <option value="true"<#if dto.partRefund> selected</#if>>支持部分退</option>
                        <option value="false"<#if !dto.partRefund> selected</#if>>不支持部分退</option>
                    </select>
                </label>
                <label id="canRefundLableNo"><input type="radio" name="canRefund" value="false"<#if dto.canRefund==false> checked</#if> />不可退款</label>
                <span class="tips">请务必保证退款设置与退款说明的内容一致</span>
            </td>
        </tr>
        <tr name="refundConditionTr" <#if !dto.canRefund>style="display: none;" </#if>>
            <th>
                退款审核:
            </th>
            <td>
                <label><input type="radio" name="refundAuditType" checked value="NOT_AUTO_AUDIT" <#if dto.refundAuditType == 'NOT_AUTO_AUDIT'> checked</#if> />人工审核，系统不自动审核</label>
                <label><input type="radio" name="refundAuditType" dest="select[name=unauditedAutoAgreeRefundHours]" value="FIX_HOUR_AUTO_AUDIT"<#if dto.refundAuditType == 'FIX_HOUR_AUTO_AUDIT'> checked</#if> />
                    申请 <select name="unauditedAutoAgreeRefundHours"<#if dto.refundAuditType != 'FIX_HOUR_AUTO_AUDIT'> disabled</#if> >
                    <#list 24..1 as a>
                        <option value="${a!}">${a!}</option>
                    </#list>
                    </select> 小时后不人工审核系统自审核
                </label>
                <label><input type="radio" name="refundAuditType" dest="select[name=autoRefundAuditTime]" value="FIX_TIME_AUTO_AUDIT"<#if dto.refundAuditType == 'FIX_TIME_AUTO_AUDIT'> checked</#if> />
                    每天<select name="autoRefundAuditTime"<#if dto.refundAuditType != 'FIX_TIME_AUTO_AUDIT'> disabled</#if> >
                    <#list 1..23 as a>
                        <#assign xx = a + ':00'/>
                        <option <#if xx == dto.autoRefundAuditTime>selected</#if> value="${a!}:00">${a!}:00</option>
                        <#assign xx2 = a + ':30'/>
                        <option <#if xx2 == dto.autoRefundAuditTime>selected</#if> value="${a!}:30">${a!}:30</option>
                    </#list>
                    </select>
                    系统自动审核</label>
            </td>
        </tr>
        <tr name="refundConditionTr">
            <th>
                <label>
                    <input type="checkbox" name="limitRefundAdvance" dest="input[name=refundValidType],input[name=refundAfterValidEndDay],input[name=refundAdvanceHour],input[name=refundAdvanceDay]" <#if dto.limitRefundAdvance> checked</#if>/> 退款时效设置:</label>
            </th>
            <td>
                <label>
                    <input type="radio" name="refundValidType"  <#if dto.refundValidType =='ADVANCE'>checked</#if> value="ADVANCE" />
                    使用有效期截止前的 <input type="text" name="refundAdvanceDay" value="${dto.refundAdvanceDay!}" class="text digits required" style="width: 30px;" />&nbsp;天<input type="text" name="refundAdvanceHour" value="${dto.refundAdvanceHour!}" class="text digits required" style="width: 30px;" disabled />点可退款&nbsp;</label>
                <label>
                    <input type="radio" name="refundValidType" <#if dto.refundValidType == 'AFTER'>checked</#if> value="AFTER" />
                    使用有效期截止后的 <input type="text" name="refundAfterValidEndDay" value="${dto.refundAfterValidEndDay!}" class="text digits required" style="width: 30px;"  />&nbsp;天内可退款&nbsp;</label><span class="tips">产品使用有效期过后多少天可退（0：表示有效期过后就不能退）</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>退款说明:
            </th>
            <td>
                ${dto.refundInfo!'退款说明'}
            </td>
        </tr>
    </table>
</body>
</html>