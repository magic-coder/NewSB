<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>产品授权</title>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript">
        $().ready(function () {

        });
    </script>
</head>
<body>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>产品授权</legend>
</fieldset>
<form id="listForm" class="layui-form" action="" method="get">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">产品ID</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="productSn" value="" placeholder="产品ID"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">产品名称</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="productName" value="" placeholder="产品名称"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">授权人</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="supplierAccount" value=""
                       placeholder="授权人"/>
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
    <a href="/group/distribution/add" class="layui-btn">添加授权</a>
</div>

<table id="listTable" class="layui-table">
    <thead>
    <tr>
        <th class="check">
            <input type="checkbox" id="selectAll"/>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="member">分销商</a>
        </th>
        <th>
            <a href="javascript:;" class="sort">授权产品（ID）</a>
        </th>
        <th>
            是否上架
        </th>
        <th>
            <a href="javascript:;" class="sort">授权总库存（-1不限）</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="state">状态</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="operator">授权人</a>
        </th>
        <th>
            <a href="javascript:;" class="sort" name="createDate">操作时间</a>
        </th>

    </tr>
    </thead>
    <tbody>

    <tr>
        <td>
            <input name="ids" value="995980676433993730" type="checkbox">
        </td>
        <td>
            2020（2020二级）
        </td>
        <td>
            <span title="恐龙主题房双人套餐">
            恐龙主题房双人套餐
            </span>
            （467963）
        </td>
        <td>
            已上架
        </td>
        <td>
            10000
        </td>
        <td>
            授权正常
            <span class="trueIcon">&nbsp;</span>
        </td>
        <td>
            1919一级
        </td>
        <td>
            <span title="2018-05-14 18:54:32">2018-05-14 18:54:32</span>
        </td>

    </tr>

    <tr>
        <td>
            <input name="ids" value="986154271940591617" type="checkbox">
        </td>
        <td>
            csfx（测试分销商）
        </td>
        <td>
            <span title="恐龙园水陆套票">
            恐龙园水陆套票
            </span>
            （10153）
        </td>
        <td>
            已上架
        </td>
        <td>
            -1
        </td>
        <td>
            授权正常
            <span class="trueIcon">&nbsp;</span>
        </td>
        <td>
            测试供应商
        </td>
        <td>
            <span title="2018-05-14 15:19:16">2018-05-14 15:19:16</span>
        </td>

    </tr>

    <tr>
        <td>
            <input name="ids" value="983582087053357057" type="checkbox">
        </td>
        <td>
            csfx（测试分销商）
        </td>
        <td>
            <span title="恐龙园水陆套票">
            恐龙园水陆套票
            </span>
            （10153）
        </td>
        <td>
            已上架
        </td>
        <td>
            -1
        </td>
        <td>
            授权正常
            <span class="trueIcon">&nbsp;</span>
        </td>
        <td>
            测试供应商
        </td>
        <td>
            <span title="2018-04-20 16:28:49">2018-04-20 16:28:49</span>
        </td>

    </tr>

    <#--<#list page.records as admin>
    <tr>
        <td>
            <input type="checkbox" name="ids" value="${admin.id!}"/>
        </td>
        <td>
        ${admin.memberAccount!}（${admin.memberName!}）
        </td>
        <td>
            <span title="${admin.productName!}">
            ${admin.productName!}
            </span>
            （${admin.product.sn!}）
        </td>
        <td>
        ${admin.product.marketable?string("已上架", "已下架")}
        </td>
        <td>
        ${admin.stock!}
        </td>
        <td>
            <#if admin.enable>
                <#if admin.priceModifyFlag>
                    授权异常
                <#else>
                    授权正常
                </#if>
            <#else>
                授权已删除
            </#if>
            <span class="${admin.enable?string("true", "false")}Icon">&nbsp;</span>
        </td>
        <td>
        ${admin.supplierName!}
        </td>
        <td>
            <span title="${admin.updateTime?datetime}">${admin.updateTime?datetime}</span>
        </td>
        <td>
            <@shiro.hasPermission name = "admin:updateTicketsDistribution">
                <a href="edit?id=${admin.id!}">[修改授权]</a>
            </@shiro.hasPermission>
            <@shiro.hasPermission name = "admin:deleteTicketsDistribution">
                <a class="del" url="delete?id=${admin.id!}">[删除授权]</a>
            </@shiro.hasPermission>
            <a href="view?id=${admin.id!}">[授权详情]</a>
        </td>
    </tr>
    </#list>-->
    </tbody>
</table>
<script type="text/javascript">
    $(function () {
        $(".del").click(function () {
            var flag = window.confirm("确定删除？");
            if (flag == true) {
                var url = $(this).attr("url");
                location.href = url;
            }
        });
    })
</script>
<#--<#include "/include/my_pagination.ftl">-->
</body>
</html>