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
    <legend>粉丝列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" name="nickname" value="${dto.nickname!}" autocomplete="off"
                       class="layui-input" placeholder="用户名">
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
            <button id="synchroButton" class="layui-btn layui-btn-normal">同步用户</button>
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
            用户昵称
        </th>
        <th>
            用户头像
        </th>
        <th>
            关注时间
        </th>
        <th>
            性别
        </th>
        <th>
            所在城市
        </th>
        <th>
            分组
        </th>
        <th>
            来源
        </th>
    </tr>
<#list page.records as dto>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${dto.id}"/>
        </td>
        <td title="${dto.openid!}">
        ${dto.nickname!}
        </td>
        <td>
            <img src="${dto.headimgurl!}" style="width: 64px;height: 64px;"/>
        </td>
        <td>
        ${dto.subscribeTime!}
        </td>
        <td>
        ${dto.sex!}
        </td>
        <td>
        ${dto.city!}
        </td>
        <td>

        </td>
        <td>

        </td>
    </tr>
</#list>
</table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
    var $synchroButton = $("#synchroButton");
    var ok = true;
    $synchroButton.click(function () {
        if (ok) {
            ok = false;
            $.ajax({
                url: "synchroUser",
                type: "POST",
                data: "appid=${authorizationDto.authorizerAppid!}",
                dataType: "json",
                cache: false,
                success: function (info) {
                    ok = true;
                    if (info == 0) {
                        setTimeout(function () {
                            location.reload(true);
                        }, 1000);
                        alert("同步成功！");
                    } else {
                        alert("同步失败！");
                    }
                }
            });
        } else {
            alert("同步中，请稍等。。。");
        }
    });
</script>
</body>
</html>