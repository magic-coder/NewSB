<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>门票列表</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/list.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/js/bootstrap-paginator.js"></script>
    <style type="text/css">
        .promotion {
            color: #cccccc;
        }

        .synchro_prompt {
            color: #81d8fc;
            border: solid 1px #81d8fc;
            display: inline-block;
        }
    </style>
    <script type="text/javascript">
        $().ready(function () {

            var $listForm = $("#listForm");
            var $moreButton = $("#moreButton");
            var $filterSelect = $("#filterSelect");
            var $filterOption = $("#filterOption a");

            //编辑
            $(".but").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    location.href = "edit.jhtml?id=" + val;
                } else {
                    alert("你还未选中记录或选择了多条记录");
                    return false;
                }
            });

            //编辑
            $("#copyButton").click(function () {
                if ($("tr").hasClass("selected") && $(".selected").length == 1) {
                    var val = $(".selected > td > input").val();
                    $.dialog({
                        type: "warn",
                        content: "确定要复制选中产品？",
                        onOk: function () {
                            $.ajax({
                                url: "copy.jhtml",
                                type: "POST",
                                data: {id: val},
                                dataType: "json",
                                cache: false,
                                success: function (message) {
                                    $.message(message);
                                    if (message.type == "success") {
                                        location.reload(true);
                                    }
                                }
                            });
                        }
                    });
                } else {
                    $(".but").attr("href", "javascript:;");
                    alert("您未选或选择了多个！");
                }
            });

            //上架
            $("#shelvesButton").click(function () {
                if ($("tr").hasClass("selected") && $(".selected > td > span").hasClass("falseIcon")) {
                    //var val = $(".selected > td > input").val();
                    var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
                    $.dialog({
                        type: "warn",
                        content: "确定要上架选中产品？",
                        onOk: function () {
                            $.ajax({
                                url: "shelves.jhtml",
                                type: "POST",
                                data: $checkedIds.serialize(),
                                dataType: "json",
                                cache: false,
                                success: function (message) {
                                    $.message(message);
                                    if (message.type == "success") {
                                        location.reload(true);
                                    }
                                }
                            });
                        }
                    });
                    return false;
                } else {
                    alert("您未选中记录! / 此产品已上架!");
                }

            });


            //下架
            $("#underButton").click(function () {
                if ($("tr").hasClass("selected") && $(".selected > td > span").hasClass("trueIcon")) {
                    //var val = $(".selected > td > input").val();
                    var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
                    $.dialog({
                        type: "warn",
                        content: "确定要下架选中产品？",
                        onOk: function () {
                            $.ajax({
                                url: "under.jhtml",
                                type: "POST",
                                data: $checkedIds.serialize(),
                                dataType: "json",
                                cache: false,
                                success: function (message) {
                                    $.message(message);
                                    if (message.type == "success") {
                                        location.reload(true);
                                    }
                                }
                            });
                        }
                    });
                    return false;
                } else {
                    alert("您未选中记录! / 此产品已下架!");
                }

            });

            //推荐
            $("#recommenButton").click(function () {
                if ($("tr").hasClass("selected") && $(".selected > td > span").hasClass("trueIcon")) {
                    //var val = $(".selected > td > input").val();
                    var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
                    $.dialog({
                        type: "warn",
                        content: "确定要推荐选中产品？",
                        onOk: function () {
                            $.ajax({
                                url: "../recommen/save.jhtml?" + $checkedIds.serialize(),
                                type: "POST",
                                success: function (message) {
                                    alert("成功");
                                    /* setTimeout(function() {
                                            location.reload(true);
                                        }, 1000); */
                                }
                            });
                        }
                    });
                    return false;
                } else {
                    alert("您未选中记录!");
                }
            });

        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        产品列表
    </div>
</div>
<form id="listForm" action="list.jhtml" method="get">
    <div class="bar">
        <input type="text" name="productName" value="${queryVO.name!}" placeholder="产品名称" style="width: 180px;"/>
        <input type="text" name="productSn" value="${queryVO.sn!}" placeholder="产品ID"/>
        <select name="marketable">
            <option value="">--是否上架--</option>
            <option value="true"
            <#if queryVO.marketable?? && queryVO.marketable == 'true'> selected</#if>
            >已上架
            </option>
            <option value="false"
            <#if queryVO.marketable?? && queryVO.marketable == 'false'> selected</#if>
            >未上架
            </option>
        </select>

        <button type="submit" class="button">查询</button>
        <button type="button" class="button" onclick="location.href='list.jhtml';">重置</button>
    </div>
    <div class="bar">
    <@shiro.hasPermission name = "admin:addTickets">
        <div class="menuWrap">
            <a href="addTickets" id="addSelect" class="button">
                新建门票
            </a>
        </div>
    </@shiro.hasPermission>
    <@shiro.hasPermission name = "admin:deleteProduct">
        <a href="javascript:;" id="deleteButton" class="button">
            删除
        </a>
    </@shiro.hasPermission>

    <@shiro.hasPermission name = "admin:topProduct">
        <a href="javascript:;" id="shelvesButton" class="button">
            上架
        </a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name = "admin:underProduct">
        <a href="javascript:;" id="underButton" class="button">
            下架
        </a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name = "admin:copyProduct">
        <a href="javascript:;" id="copyButton" class="button">
            复制
        </a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name = "admin:addRecommen">
        <a href="javascript:;" id="recommenButton" class="button">
            推荐
        </a>
    </@shiro.hasPermission>
    </div>
<table id="listTable" class="list">
<tr>
    <th class="check">
        <input type="checkbox" id="selectAll"/>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="name">产品名称(产品ID)</a>
    </th>
    <th>
        <span>票型</span>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="sales">销量</a>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="company">目的地</a>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="isMarketable">是否上架</a>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="createDate">添加时间</a>
    </th>
    <th>
        <a href="javascript:;" class="sort" name="operator">添加人</a>
    </th>
    <th>
        <span>操作</span>
    </th>
    </tr>
    <#list page.records as product>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${product.id}"/>
            </td>
            <td>
                <#if product.productSource?? && product.productSource != 'local'>
                <span class="synchro_prompt">接口</span>
                </#if>
            ${product.fullName!}
                (${product.sn})
            </td>
            <td>
            <#if product.ticketsType??>
                ${product.ticketsType.name!}
            <#else>
                -
            </#if>
            </td>
                <td>
                    ${product.sales}
                </td>
            <td>
                <#if product.sight??>
                    ${product.sight.sightName}
                <#else>
                -
                </#if>
            </td>
            <td>
                <span class="${product.marketable?string("true", "false")}Icon">&nbsp;</span>
            </td>
            <td>
                <span title="${product.createTime?datetime}">${product.createTime?datetime}</span>
            </td>
            <td>
            ${product.createBy}
            </td>
            <td>
                <@shiro.hasPermission name = "admin:editProduct">
                    <a href="edit.jhtml?id=${product.id}">[编辑]</a>
                </@shiro.hasPermission>
            </td>
        </tr>
    </#list>
</table>
    <#include "/include/pagination.ftl">
</form>
</body>
</html>