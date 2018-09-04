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
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>二维码分销</legend>
</fieldset>
<div class="container-fluid">
    <!--搜索-->
    <form class="form-inline" method="get" action="list">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">组名称</label>
                    <input type="text" class="form-control gds-input" placeholder="组名称" name="name"
                           value="${dto.name!}">
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
        <@shiro.hasPermission name="qrCreateGroup">
            <button type="submit" class="btn btn-default gds-btn-1" onclick="location.href='add';">添加二维码产品组</button>
        </@shiro.hasPermission>
        </div>
    </div>
    <!--折叠-->
    <div class="panel-group" id="accordion">

    <#list page.records as dto>
        <div class="gds-panel">
            <div class="panel-heading">
                <div class="panel-title row">
                    <div class="col-sm-3">
                        <span class="gds-1d2"></span><a class="gds-collapse-action collapsed" data-toggle="collapse"
                                                        data-parent="#accordion"
                                                        href="#a${dto.id!}"
                                                        aria-expanded="false">${dto.name!}</a>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">所属人：${dto.memberName!}</p>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">扫码次数：${dto.scanTimes!}</p>
                    </div>
                    <div class="col-sm-2">
                        <p class="gds-d8 text-muted">状态：
                            <#if '${dto.status!?c}'=='true'>
                                启用
                            <#elseif '${dto.status!?c}'=='false'>
                                禁用</#if></p>
                    </div>
                    <div class="col-sm-10 text-right">
                        <@shiro.hasPermission name="qrCreateProduct">
                            <a class="btn gds-btn-2" href="/qrcode/product/add?groupId=${dto.id!?c}">新增产品</a>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="qrDeleteGroup">
                            <a class="btn gds-btn-2" onclick="del('${dto.id?c!}')">删除</a>
                        </@shiro.hasPermission>
                        <@shiro.hasPermission name="qrEditGroup">
                            <a class="btn gds-btn-2" href="edit?id=${dto.id!?c}">编辑</a>
                        </@shiro.hasPermission>
                        <a class="btn gds-btn-2" onclick="viewGp('${dto.id!?c}')">预览</a>
                        <#if '${dto.carousel!?c}'=='true'>
                            <a class="btn gds-btn-2" href="/qrcode/flashview/list?groupId=${dto.id?c!}">设置轮播</a>
                        </#if>
                    <#-- <input type="button" class="btn gds-btn-2" data-clipboard-text="${dto.groupUrl}" value="复制链接"/>-->
                    </div>
                </div>
            </div>
            <div id="a${dto.id!}" class="panel-collapse collapse">
                <div class="panel-body">
                    <#if dto.products??>
                        <#list dto.products as info>
                            <div class="row">
                                <div class="col-sm-3">
                                ${info.name!}
                                </div>
                                <div class="col-sm-2">
                                    二维码售价：${info.salePrice!?string(",##0.00")}
                                </div>
                                <div class="col-sm-2">
                                    扫码次数：${info.scanTimes!}
                                </div>
                                <div class="col-sm-5">
                                    创建人：${info.createName!}
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3">
                                    <#--所属产品：-->${info.outName!}<span class="gds-state-active">
                                    <#if info.status?? && info.status>
                                        已上架
                                    <#else>
                                        未上架
                                    </#if></span>
                                </div>
                                <div class="col-sm-2">
                                    库存：${info.maxStock!}
                                </div>

                                <div class="col-sm-2">
                                    成交量：${info.turnover!}
                                </div>
                                <div class="col-sm-3">
                                    创建时间：${(info.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
                                </div>
                                <div class="col-sm-2 text-right">
                                    <@shiro.hasPermission name="qrEditProduct">
                                        <a class="gds-fg-blue"
                                           onclick="location.href='/qrcode/product/edit?id=${info.id!?c}'">编辑</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="qrDeleteProduct">
                                        <a class="gds-fg-blue" onclick="delProduct('${info.id?c!}')">删除</a>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="qrUpdateProductStatus">
                                        <a class="gds-fg-blue"
                                           href="/qrcode/product/updateStatus?id=${info.id!}"><#if '${info.status!?c}'=='false'>
                                            启用
                                        <#elseif '${info.status!?c}'=='true'>禁用</#if></a>
                                    </@shiro.hasPermission>
                                    <a class="gds-fg-blue" onclick="viewPt('${info.id}')">预览</a>
                                </div>
                            </div>
                            &nbsp;
                            <div class="row"></div>
                            <div class="row"></div>
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
<script>
    //删除分组
    function del(id) {
        layer.confirm('您真的确定要删除吗？\n\n请确认！', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: '/qrcode/group/delete',
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
                url: '/qrcode/product/delete',
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

<script language="JavaScript">
    //预览产品二维码
    function viewPt(id) {
        layer.open({
            type: 2,
            title: '',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['500px', '550px'],
            content: '/qrcode/product/view?id=' + id
        });
    }
    //预览分组二维码
    function viewGp(id) {
        layer.open({
            type: 2,
            title: '',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['500px', '550px'],
            content: '/qrcode/group/view?id=' + id
        });
    }

</script>
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
</body>
</html>