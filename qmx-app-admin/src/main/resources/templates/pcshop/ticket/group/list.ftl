<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>Bootstrap 101 Template</title>
<#include "/include/common_header_include.ftl">
    <!-- Bootstrap -->
    <link href="${base}/resources/assets/bootstrap/css/bootstrap.css" rel="stylesheet"/>
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/admin/bootstrap/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/module/shop/css/gds.css" rel="stylesheet"/>
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/bak/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.zclip.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>

    <![endif]-->
</head>
<body class="gds">
<div class="container-fluid">
    <!--搜索-->
    <form class="form-inline" method="get" action="list">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">组名称</label>
                    <input type="text" class="form-control gds-input" placeholder="组名称" name="gName"
                           value="${dto.gName!}">
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="reset" onclick="location.href='list';" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>
        </div>
    </form>
    <!--列表-->
    <div class="gds-operation">
        <div class="row">
        <@shiro.hasPermission name="pc_createGroup">
            <button type="submit" class="btn btn-default gds-btn-1" onclick="location.href='add';">新增门票商城组</button>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="pc_copyShopLink">
            <#if shopUrl??>
                <input type="button" class="btn btn-default gds-btn-1" data-clipboard-text="${shopUrl!}"
                       value="复制商城链接"/>
            </#if>
        </@shiro.hasPermission>
        <@shiro.hasPermission name="pc_slideShow">
            <button type="button" class="btn btn-default gds-btn-1"
                    onclick="location.href='/pcticket/flashview/list';">
                门票商城轮播设置
            </button>
        </@shiro.hasPermission>
        </div>
    </div>
    <!--折叠-->
    <div class="panel-group" id="accordion">

    <#list page.records as dto>
        <div class="gds-panel">
            <div class="panel-heading">
                <div class="panel-title row">
                    <div class="col-sm-4">
                        <span class="gds-1d2">组名：</span><a class="gds-collapse-action collapsed"
                                                           data-toggle="collapse"
                                                           data-parent="#accordion"
                                                           href="#a${dto.id?c!}"
                                                           aria-expanded="false">${dto.gName!}
                        (${dto.memberName!})</a>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">序号：${dto.serial!}</p>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">状态：
                            <#if '${dto.status!?c}'=='true'>
                                启用
                            <#elseif '${dto.status!?c}'=='false'>
                                禁用</#if></p>
                    </div>

                    <div class="col-sm-4 text-right">
                        <@shiro.hasPermission name="pc_createTicket">
                            <a class="btn gds-btn-2" href="/pcticket/product/add?groupId=${dto.id?c!}">新增产品</a>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="pc_editGroup">
                            <a class="btn gds-btn-2" href="edit?id=${dto.id!?c}">编辑</a>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="pc_deleteGroup">
                            <a class="btn gds-btn-2" onclick="del('${dto.id?c!}')">删除</a>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="pc_copyGropLink">
                            <input type="button" class="btn gds-btn-2" data-clipboard-text="${dto.groupUrl!}"
                                   value="复制组链接"/>
                        </@shiro.hasPermission>
                    </div>
                </div>
            </div>
            <div id="a${dto.id!}" class="panel-collapse collapse">
                <div class="panel-body">
                    <#if dto.products??>
                        <#list dto.products as info>
                            <div class="row">
                                <div class="col-sm-4">
                                    <span class="gds-state-active">
                                        <#if info.status?string("true","false")=="true">
                                            启用
                                        <#else>
                                            禁用
                                        </#if></span>${info.name!}
                                </div>
                                <div class="col-sm-2">编码：${info.sn!}</div>
                                <div class="col-sm-3">
                                    创建人：${info.createName!}(${(info.createTime!)?string("yyyy-MM-dd HH:mm:ss")})
                                </div>
                                <div class="col-sm-6 text-right">
                                    <@shiro.hasPermission name="pc_editTicket">
                                        <a class="gds-fg-blue"
                                           onclick="location.href='/pcticket/product/edit?id=${info.id!?c}'">编辑</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="pc_deleteTicket">
                                        <a class="gds-fg-blue" onclick="delProduct('${info.id?c!}')">删除</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="pc_updateTicketStatus">
                                        <a class="gds-fg-blue"
                                           href="/pcticket/product/updateStatus?id=${info.id!}"><#if '${info.status!?c}'=='false'>
                                            启用
                                        <#elseif '${info.status!?c}'=='true'>禁用
                                        </#if></a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="pc_copyTicketLink">
                                        <a class="gds-fg-blue btn"
                                           data-clipboard-text="${info.ticketUrl!}">复制产品链接</a>
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
    //删除分组
    function del(id) {
        layer.confirm('您真的确定要删除吗？\n\n请确认！', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: '/pcticket/group/delete',
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
                url: '/pcticket/product/delete',
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
</script>
<script>
    //复制
    var clipboard = new ClipboardJS('.btn');

    clipboard.on('success', function (e) {
        layer.msg("复制成功！");
    });

    clipboard.on('error', function (e) {
        layer.msg("复制失败！");
    });
</script>
</body>
</html>