<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>预定规则</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        $(function () {
            $(".viewRule").click(function () {
                var data = $(this).attr('data-id');
                layer.open({
                    type: 2,
                    title: '预览',
                    area: ['680px', '450px'], //宽高
                    fix: true, //固定
                    content: '../bookRule/view?id=' + data
                });
            });
        })
    </script>
</head>

<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>预定规则</legend>
</fieldset>
<form id="listForm" class="layui-form" action="" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">规则名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="name" value="" placeholder="规则名称"/>
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
<div class="layui-form-item" style="margin-left: 10px;">
    <a href="/group/reserverule/add" class="layui-btn">
        添加
    </a>
</div>
<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            序号
        </th>
        <th>
            规则名称
        </th>
        <th>
            创建人 / 所属供应商
        </th>
        <th>
            创建 / 修改时间
        </th>
    </tr>
    </thead>
    <tbody>

    <tr>
        <td>1</td>
        <td>组合预定规则01</td>
        <td>jg001/nbcs</td>
        <td>2018-04-16 18:08:34 / 2018-04-20 19:16:31</td>
    </tr>

    <tr>
        <td>2</td>
        <td>组合预定规则02</td>
        <td>jg001/nbcs</td>
        <td>2018-04-09 16:41:46 / 2018-04-20 19:16:49</td>
    </tr>

    <tr>
        <td>3</td>
        <td>组合预定规则03</td>
        <td>jg001/nbcs</td>
        <td>2018-04-02 17:11:19 / 2018-04-02 17:11:19</td>
    </tr>

    <#--<#list page.records as dto>
    <tr>
        <td>
        ${dto_index+1}
        </td>
        <td>
        ${dto.name!}
        </td>
        <td>
        ${dto.createAccount!} / ${dto.supplierAccount!}
        </td>
        <td>
        ${dto.createTime?datetime} / ${dto.updateTime?datetime}
        </td>
        <td>
            <a class="viewRule" data-id="${dto.id!}">[预览]</a>
            <@shiro.hasPermission name = "admin:editBookRule">
                <a href="edit?id=${dto.id!}">[编辑]</a>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "admin:deleteBookRule">
                <a href="delete?id=${dto.id!}">[删除]</a>
            </@shiro.hasPermission>
        </td>
    </tr>
    </#list>-->
    </tbody>
</table>
<#--<#include "/include/my_pagination.ftl">-->
</body>
</html>