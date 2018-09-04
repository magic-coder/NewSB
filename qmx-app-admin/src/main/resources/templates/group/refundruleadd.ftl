<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加信息</title>
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
            $("input:radio,input:checkbox").change(function(){
                $("input[name='"+$(this).attr("name")+"']:checked").each(function(){
                    $($(this).attr("dest")).attr("disabled", false);
                });
                $("input[name='"+$(this).attr("name")+"']").not(":checked").each(function(){
                    $($(this).attr("dest")).attr("disabled", true);
                });
            });

            $("#canRefundLableYes").click(function () {
                $("tr[name=refundConditionTr]").show();
                $("tr[name=refundConditionTr]").find('input').attr("checked",'checked');
            });
            $("#canRefundLableNo").click(function () {
                $("tr[name=refundConditionTr]").hide();
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
<form id="inputForm" action="/group/refundrule" method="post">
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
                <span class="tips">名称</span>
            </td>
        </tr>
        <tr>
            <th>
                退款设置:
            </th>
            <td>
                <label id="canRefundLableYes"><input type="radio" name="canRefund" dest="select[name=partRefund]" value="true" checked />可以退款
                    <select name="partRefund">
                        <option value="false">不支持部分退</option>
                        <option value="true">支持部分退</option>
                    </select>
                </label>
                <label id="canRefundLableNo"><input type="radio" name="canRefund" value="false" />不可退款</label>
                <span class="tips">请务必保证退款设置与退款说明的内容一致</span>
            </td>
        </tr>
        <tr name="refundConditionTr">
            <th>
                退款审核:
            </th>
            <td>
                <label><input type="radio" name="refundAuditType" checked value="NOT_AUTO_AUDIT" />人工审核，系统不自动审核</label>
                <label><input type="radio" name="refundAuditType" dest="select[name=unauditedAutoAgreeRefundHours]" value="FIX_HOUR_AUTO_AUDIT" />
                    申请 <select name="unauditedAutoAgreeRefundHours" disabled>
                    <#list 24..1 as a>
                        <option value="${a!}">${a!}</option>
                    </#list>
                    </select> 小时后不人工审核系统自审核
                </label>
                <label><input type="radio" name="refundAuditType" dest="select[name=autoRefundAuditTime]" value="FIX_TIME_AUTO_AUDIT" />
                    每天<select name="autoRefundAuditTime" disabled>
                    <#list 1..23 as a>
                        <option value="${a!}:00">${a!}:00</option>
                        <option value="${a!}:30">${a!}:30</option>
                    </#list>
                    </select>
                    系统自动审核</label>
            </td>
        </tr>
        <tr name="refundConditionTr">
            <th>
                <label><input type="checkbox" name="limitRefundAdvance" dest="input[name=refundValidType],input[name=refundAfterValidEndDay],input[name=refundAdvanceHour],input[name=refundAdvanceDay]" /> 退款时效设置:</label>
            </th>
            <td>
                <label>
                    <input type="radio" name="refundValidType" disabled value="ADVANCE" />
                    使用有效期截止前的 <input type="text" name="refundAdvanceDay" value="0" class="text digits required" style="width: 30px;" disabled />&nbsp;天<input type="text" name="refundAdvanceHour" value="0" class="text digits required" style="width: 30px;" disabled />点可退款&nbsp;</label>
                <label>
                    <input type="radio" name="refundValidType" disabled checked value="AFTER" />
                    使用有效期截止后的 <input type="text" name="refundAfterValidEndDay" value="0" class="text digits required" style="width: 30px;" disabled />&nbsp;天内可退款&nbsp;</label><span class="tips">产品使用有效期过后多少天可退（0：表示有效期过后就不能退）</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>退款说明:
            </th>
            <td>
                <textarea name="refundInfo" class="text required" maxlength="500">退款说明</textarea>
                <div class="blank"></div>
                <span class="tips">必须包含以下内容：【客人申请退款的时间及方式】【是否支持改期】  500字以内。</span>
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