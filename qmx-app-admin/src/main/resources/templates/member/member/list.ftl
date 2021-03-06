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
    <legend>会员列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">卡号</label>
            <div class="layui-input-inline">
                <input type="text" name="cardNumber" value="${dto.cardNumber!}" autocomplete="off"
                       class="layui-input" placeholder="请输入卡号">
            </div>
            <label class="layui-form-label">会员名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="${dto.name!}" autocomplete="off"
                       class="layui-input" placeholder="请输入会员名">
            </div>
            <div class="layui-input-inline">
                <select name="state" lay-filter="aihao" lay-verify="required">
                    <option value="">--会员状态--</option>
                    <option value="normal" <#if dto.state?? && dto.state=="normal">selected</#if>>正常</option>
                    <option value="locking" <#if dto.state?? && dto.state=="locking">selected</#if>>锁定</option>
                    <option value="lose" <#if dto.state?? && dto.state=="lose">selected</#if>>挂失</option>
                    <option value="overdue" <#if dto.state?? && dto.state=="overdue">selected</#if>>过期</option>
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
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="name">会员姓名(卡号)</a>
        </th>
        <th>
            手机号码
        </th>
        <th>
            性别
        </th>
        <th>
            来源
        </th>
        <th>
            金额/积分
        </th>
        <th>
            会员等级
        </th>
        <th>
            会员状态
        </th>
        <th>
            过期时间
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
                <span title="${dto.name}">${dto.name}</span>(${dto.cardNumber})
        </td>
        <td>
        ${dto.mobile!}
        </td>
        <td>
            <#if dto.sex=="male">
                男
            <#elseif dto.sex=="female">
                女
            <#else>
                未知
            </#if>
        </td>
        <td>
            <#if dto.source=="wx">
                微信
            <#elseif dto.source=="xianxia">
                线下
            <#elseif dto.source=="xsht">
                线上后台
            </#if>
        </td>
        <td>
        ${dto.money}/${dto.integral}
        </td>
        <td>
        ${dto.levelName}
        </td>
        <td>
            <#if dto.state=="normal">
                正常
            <#elseif dto.state=="locking">
                锁定
            <#elseif dto.state=="lose">
                挂失
            <#elseif dto.state=="overdue">
                过期
            </#if>
        </td>
        <td>
        ${dto.pastTime?datetime!}
        </td>
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
        layer.confirm(msg,{ title: "会员删除确认" },function(){
            window.location.href = "delete.jhtml?id=" + id;
        })

    }
</script>
</body>
</html>