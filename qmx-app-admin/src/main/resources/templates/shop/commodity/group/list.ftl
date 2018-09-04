<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap.css" rel="stylesheet"/>
    <link href="${base}/resources/admin/bootstrap/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/module/shop/css/gds.css" rel="stylesheet"/>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'element'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;
            var element = layui.element;
        });
    </script>
</head>

<body class="gds">
<div class="container-fluid">
    <form id="listForm" class="form-inline" action="list" method="get">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <label>分组名称</label>
                    <input type="text" class="form-control gds-input" placeholder="分组名称" name="groupName"
                           value="${dto.groupName!}" autocomplete="on">
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="reset" class="btn btn-default gds-btn-1" onclick="location.href='list';">重置</button>
                </div>
            </div>
        </div>
    </form>
    <!--列表-->
    <div class="gds-operation">
        <div class="row">
        <@shiro.hasPermission name="createGroup">
            <button type="button" onclick="location.href='add';" class="btn btn-default gds-btn-1">添加商品商城组</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="copyShopLink">
            <#if shopUrl??>
                <button type="button" data-clipboard-text="${shopUrl!}" class="btn btn-default gds-btn-1">复制商城链接
                </button>
            </#if>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="slideShow">
            <button type="button" class="btn btn-default gds-btn-1"
                    onclick="location.href='/commodity/flashview/list';">
                商品商城轮播设置
            </button>
        </@shiro.hasPermission>
        </div>
    </div>
    <!--折叠-->
    <div class="panel-group" id="accordion">
    <#list page.records as info >
        <div class="gds-panel">
            <div class="panel-heading">
                <div class="panel-title row">
                    <div class="col-sm-2">
                        <span class="gds-1d2">组名：</span>
                        <a class="gds-collapse-action collapsed" data-toggle="collapse"
                           data-parent="#accordion" href="#a${info.id!}" aria-expanded="false">${info.groupName!}</a>
                    </div>
                    <div class="col-sm-1">
                        <p class="gds-d8 text-muted">序号：${info.groupNumber!}</p>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">创建人：${info.createName!}</p>
                    </div>
                    <div class="col-sm-1">
                        <p class="gds-d8 text-muted">状态：
                            <#if '${info.status!?c}'=='true'>
                                启用
                            <#elseif '${info.status!?c}'=='false'>
                                禁用</#if></p>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">创建时间：${(info.createTime!)?string("yyyy-MM-dd HH:mm:ss")}</p>
                    </div>
                    <div class="col-sm-8 text-right">
                        <span>
                            <@shiro.hasPermission name="releaseCommodity">
                                <a class="btn gds-btn-2"
                                   onclick="window.location.href='/commodity/release/addRelease?groupId=${info.id!}'">新增发布</a>
                            </@shiro.hasPermission>
                            <@shiro.hasPermission name="editGroup">
                                <a class="btn gds-btn-2" onclick="location.href='edit?id=${info.id!}'">编辑</a>
                            </@shiro.hasPermission>
                            <@shiro.hasPermission name="deleteGroup">
                                <a type="button" class="btn gds-btn-2" onclick="del('${info.id!}')">删除</a>
                            </@shiro.hasPermission>
                            <@shiro.hasPermission name="copyGroupLink">
                                <a class="btn gds-btn-2" data-clipboard-text="${info.groupUrl}">复制组链接</a>
                            </@shiro.hasPermission>
                        </span>
                    </div>
                </div>
            </div>
            <div id="a${info.id!}" class="panel-collapse collapse">
                <div class="panel-body">
                    <#if info.releaseDtos??>
                        <#list info.releaseDtos as release>
                            <div class="row">
                                <div class="col-sm-2">
                            <span class="gds-state-active">
                                <#if release.status?string("true","false")='true'>
                                    已上架
                                <#else >
                                    已下架
                                </#if>
                            </span>${release.releaseName!}
                                </div>
                                <div class="col-sm-1">序号：${release.serial!}</div>
                                <div class="col-sm-2">库存：${release.saleStock!}</div>
                                <div class="col-sm-2">价格：${(release.salePrice!)?string("currency")}</div>
                                <div class="col-sm-3">
                                    创建时间：${(release.createTime!)?string("yyyy-MM-dd HH:mm:ss")}</div>
                                <div class="col-sm-8">
                                    <@shiro.hasPermission name="editRelease">
                                        <a class="gds-fg-blue"
                                           onclick="location.href='/commodity/release/edit?id=${release.id!}&groupId=${info.id!}'">编辑</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="deleteRelease">
                                        <a class="gds-fg-blue" onclick="delProduct('${release.id!}')">删除</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="soldPutAway">
                                        <a class="gds-fg-blue"
                                           onclick="location.href='/commodity/release/soldPutAway?groupId=${info.id!}&releaseId=${release.id}'">
                                            <#if release.status?string("true","false")='true'>
                                                下架
                                            <#else >
                                                上架
                                            </#if></a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="viewLog">
                                        <a class="gds-fg-blue" onclick="getLog('${release.id!}')">日志</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="copyReleaseLink">
                                        <a class="btn gds-fg-blue"
                                           data-clipboard-text="${release.releaseUrl}">复制产品链接</a>
                                    </@shiro.hasPermission>
                                </div>
                            </div>
                        </#list>
                    </#if>
                </div>
            </div>
        </div>
    </#list>
    </div>
<#include "/include/my_pagination.ftl">
</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="${base}/resources/module/shop/js/jquery.1.12.4.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/admin/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
<script src="${base}/resources/common/js/clipboard.min.js"></script>

<script>
    var clipboard = new ClipboardJS('.btn');

    clipboard.on('success', function (e) {
        layer.msg("复制成功！");
    });

    clipboard.on('error', function (e) {
        layer.msg("复制失败！");
    });
</script>
<script type="text/javascript">
    //删除分组
    function del(id) {
        layer.confirm('您真的确定要删除吗？\n\n请确认！', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: '/commodity/group/delete',
                type: 'GET', //GET
                async: true,    //或false,是否异步
                data: {"id": id},
                success: function (result) {
                    if (result.data == "success") {
                        layer.msg("操作成功");
                        /*$(this).parents().parents().parents().remove();*/
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.data);
                    }
                }
            });
        });
    }
    //删除商品
    function delProduct(id) {
        layer.confirm('您真的确定要删除吗？\n\n请确认！', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: '/commodity/release/delete',
                type: 'GET', //GET
                async: true,    //或false,是否异步
                data: {"id": id},
                success: function (result) {
                    if (result.data == "success") {
                        layer.msg("操作成功");
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.data);
                    }
                }
            });
        });
    }
    //启用和禁用
    function updateState(id) {
        $.ajax({
            url: '/commodity/group/updateState',
            type: 'GET', //GET
            async: true,    //或false,是否异步
            data: {"id": id},
            success: function (result) {
                if (result.data == "success") {
                    layer.msg("操作成功");
                    setTimeout(function () {
                        location.reload(true);
                    }, 500);
                } else {
                    layer.msg(result.data);
                }
            }
        });
    }
</script>
<script type="text/javascript">
    function getLog(id) {
        layer.open({
            type: 2,
            title: '',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['850px', '550px'],
            content: '/commodity/release/logList?rid=' + id
        });
    }
</script>
<#--消息提示框-->
<style>
    #tip {
        position: absolute;
        top: 85px;
        left: 50%;
        display: none;
        z-index: 9999;
        color: red;
        font-size: 20px;
    }
</style>
<#--<strong id="tip"></strong>
<script>
    //tip是提示信息，type:'success'是成功信息，'danger'是失败信息,'info'是普通信息,'warning'是警告信息
    function showTip(tip, type) {
        var $tip = $('#tip');
        $tip.stop(true).prop('class', 'alert alert-' + type).text(tip).css('margin-left', -$tip.outerWidth() / 2).fadeIn(500).delay(2000).fadeOut(500);
    }

    var Script = function () {
    <#if msg??>
        showTip("${msg}", "success");
    </#if>
    }();
</script>-->
</body>
</html>