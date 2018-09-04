<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>自动回复</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<#include "tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <input type="hidden" name="msgTypes" value="${type!}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">关键字</label>
            <div class="layui-input-inline">
                <input type="text" name="keyvalue" value="${dto.keyvalue!}" autocomplete="off"
                       class="layui-input" placeholder="关键字">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list?msgTypes=TEXT';" class="layui-btn layui-btn-primary">
                    重置
                </button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
        <#if type=="TEXT">
            <button onclick="location.href='add?msgTypes=text';" class="layui-btn layui-btn-normal">新建文本回复</button>
            <input type="hidden" name="msgTypes" value="TEXT"/>
        </#if>
        <#if type=="NEWS">
            <button onclick="location.href='add?msgTypes=news';" class="layui-btn layui-btn-normal">新建图文回复</button>
            <input type="hidden" name="msgTypes" value="NEWS"/>
        </#if>
        <#if type=="IMAGE">
            <button onclick="location.href='add?msgTypes=image';" class="layui-btn layui-btn-normal">新建图片回复</button>
            <input type="hidden" name="msgTypes" value="IMAGE"/>
        </#if>
        <#if type=="MUSIC">
            <button onclick="location.href='add?msgTypes=music';" class="layui-btn layui-btn-normal">新建语音回复</button>
            <input type="hidden" name="msgTypes" value="MUSIC"/>
        </#if>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th class="check" style="text-align: center">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th style="text-align: center">
            关键字
        </th>
        <th style="text-align: center">
            消息内容
        </th>
        <th style="text-align: center">
            时间
        </th>
        <th style="text-align: center">
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td style="text-align: center">
            <input name="id" type="checkbox" value="${(dto.id)!}"/>
        </td>
        <td style="text-align: center">
        ${(dto.keyvalue)!}
        </td>
        <#if dto.msgTypes!="IMAGE">
            <td style="text-align: center">
                <#if dto.msgTypes=="TEXT">
                    <p class="fg_black_s">${(dto.content)!}</p>
                <#elseif dto.msgTypes=="NEWS">
                    <p class="fg_black_s">${(dto.title)!}</p>
                <#elseif dto.msgTypes=="MUSIC">
                    <p class="fg_black_s">${(dto.title)!}</p>
                </#if>
            </td>
        <#else>
            <td style="text-align: center">

            </td>
        </#if>
        <td style="text-align: center">
        ${dto.updateTime?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td style="text-align: center">
            <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="编辑"/>
            <input type="button" onclick="del('${dto.id?c}','${(dto.msgTypes)!}')"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="删除"/>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">


<script type="text/javascript">
    function del(id, msgTypes) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg) == true) {
            alert(id);
            alert(msgTypes);
            window.location.href = "delete.jhtml?id=" + id + "&" + "msgTypes=" + msgTypes;
        } else {
            return false;
        }
    }

</script>
</body>
</html>