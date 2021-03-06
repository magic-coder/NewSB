<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
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
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>会员优惠规则列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
        <#--<label class="layui-form-label">等级名称</label>-->
        <#--<div class="layui-input-inline">-->
        <#--<input type="text" name="cardNumber" value="${dto.cardNumber!}" autocomplete="off"-->
        <#--class="layui-input" placeholder="请输入卡号">-->
        <#--</div>-->
            <label class="layui-form-label">等级名称</label>
            <div class="layui-input-inline">
                <input type="text" name="levelName" value="${dto.levelName!}" autocomplete="off"
                       class="layui-input" placeholder="请输入名称">
            </div>
            <#--<label class="layui-form-label">产品名称</label>-->
            <#--<div class="layui-input-inline">-->
                <#--<input type="text" name="associatedName" value="${dto.associatedName!}" autocomplete="off"-->
                       <#--class="layui-input" placeholder="请输入产品名称">-->
            <#--</div>-->
            <div class="layui-input-inline">
                <select name="superposition" lay-filter="aihao" <#--lay-verify="required"-->>
                    <option value="">--是否与优惠券叠加--</option>
                    <option value="1" <#if dto.superposition?? && dto.superposition==true>selected</#if>>是</option>
                    <option value="0" <#if dto.superposition?? && dto.superposition==false>selected</#if>>否</option>
                </select>
            </div>

        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll" style=""/>
        </th>
    <#--<th>-->
    <#--<a href="javascript:;" class="sort" name="name">会员姓名(卡号)</a>-->
    <#--</th>-->
        <th>
            等级名称
        </th>
        <#--<th>-->
            <#--关联产品-->
        <#--</th>-->
        <th>
            折扣率
        </th>
        <th>
            是否与优惠券叠加
        </th>
        <th>
            操作
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td>
        ${dto.levelName!}
        </td>
        <#--<td>-->
        <#--${dto.associatedName!}-->
        <#--</td>-->
        <td>
            <span style="color: red;<#--font-weight: bold"-->">1 : </span>${dto.rate!}
        </td>
        <td>
            <#if dto.superposition?? && dto.superposition==true>是</#if>
            <#if dto.superposition?? && dto.superposition==false>否</#if>
        </td>
    <#--<td>-->
    <#--${dto.pastTime?datetime!}-->
    <#--</td>-->
        <td>
            <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                   class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                   value="编辑"/>
            <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm"
                   data-id="${dto.id!}" id="viewBtn"
                   value="删除"/>
        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript">
    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        layer.confirm(msg, {title: "会员删除确认"}, function () {
            window.location.href = "delete?id=" + id;
        })

    }
</script>
</body>
</html>