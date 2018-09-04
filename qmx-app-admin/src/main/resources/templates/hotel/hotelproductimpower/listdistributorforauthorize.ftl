<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <title>分销商列表</title>
<#include "/include/common_header_include.ftl">
<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${base}/bak/js/jquery.js"></script>
<script type="text/javascript" src="${base}/bak/js/common.js"></script>
<script type="text/javascript" src="${base}/bak/js/list.js"></script>-->
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;

            laydate.render({
                elem: '#sdate'
            });
            laydate.render({
                elem: '#edate'
            });
        });
    </script>
</head>
<body>
<form id="list" action="listDistributorForAuthorize.jhtml" method="get" autocomplete="off" class="layui-form">
    <div class="bar">
        <div class="menuWrap">
            <select name="searchProperty">
                <option value="username" selected="selected">账号</option>
                <option value="email">E-mail</option>
                <option value="name">姓名</option>
            </select>
            <input id="searchValue" name="searchValue" maxlength="200" type="text">
        </div>
        <button type="submit" class="button">查询</button>
    </div>
    <table id="listTable" class="list">
        <tbody>
        <tr>
            <th class="check">
                <input id="selectAll" type="checkbox">
            </th>
            <th>
                <a href="javascript:;" class="sort" name="username">账号</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="role">角色</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="name">姓名</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="loginDate">最后登录日期</a>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="loginIp">最后登录IP</a>
            </th>
            <th>
                <span>状态</span>
            </th>
            <th>
                <a href="javascript:;" class="sort" name="createDate">创建日期</a>
            </th>
        </tr>
        <#if page ??>
            <#list page.records as info>
            <tr>
                <td>
                    <input name="ids" value="${info.id}" type="checkbox">
                </td>
                <td>
                ${info.id}
                </td>
                <td>
                    <#if '${info.userType!}'='distributor'>
                        一级分销商
                    <#elseif '${info.userType!}'='distributor2'>
                        二级分销商
                    </#if>
                </td>
                <td>
                ${info.account}
                </td>
                <td>
                ${info.username}
                </td>
                <td>
                    -----
                </td>
                <td>
                    <span class="green">正常</span>
                </td>
                <td>
                    <span title="2017-07-29 15:27:02">${info.createTime?datetime}</span>
                </td>
            </tr>
            </#list>
        </#if>
        </tbody>
    </table>
    <input id="orderProperty" name="orderProperty" value="" type="hidden">
    <input id="orderDirection" name="orderDirection" value="" type="hidden">
    <div class="pagination">
        <select id="pageSize" name="pageSize">
            <option value="10" selected="selected">10</option>
            <option value="20">20</option>
            <option value="50">50</option>
            <option value="100">100</option>
        </select>
        <span>共 7 条记录</span>
        <span class="firstPage">&nbsp;</span>
        <span class="previousPage">&nbsp;</span>
        <span class="currentPage">1</span>
        <span class="nextPage">&nbsp;</span>
        <span class="lastPage">&nbsp;</span>
        <span class="pageSkip">
			共1页 到第<input id="pageNumber" name="pageNumber" value="1" maxlength="9" onpaste="return false;">页<button
                type="submit">&nbsp;</button>
		</span>
    </div>
</form>

</body>
</html>