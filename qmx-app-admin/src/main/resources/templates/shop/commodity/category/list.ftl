<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>供应商列表</title>
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
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>

    <![endif]-->
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.render();
        });


    </script>
</head>
<body>
<!--搜索-->
<form class="form-inline" action="list">
    <div class="gds-search list">
        <div class="row">
            <div class="form-group">
                <label for="exampleInputName2">品类名称</label>
                <input type="text" name="categoryName" value="${dto.categoryName!}"
                       class="form-control gds-input" placeholder="品类名称" autocomplete="on">
            </div>
            <div class="gds-group">
                <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                <button type="submit" class="btn btn-default gds-btn-1">重置</button>
            </div>
        </div>
    </div>
</form>
<!--列表-->
<div class="gds-operation">
    <div class="row">
    <@shiro.hasPermission name="createCategory">
        <button type="submit" class="btn btn-default gds-btn-1" onclick="location.href='add';">新增品类</button>
    </@shiro.hasPermission>
    </div>
</div>
<div class="panel-group" id="accordion">
    <div class="gds-panel">
    <#list page.records as dto>
        <div class="panel-heading">
            <div class="panel-title row">
                <div class="col-sm-3">
                    <span class="gds-1d2">品类名称：</span>
                    <a class="gds-collapse-action collapsed" data-toggle="collapse"
                       data-parent="#accordion" href="#a${dto.id!}" aria-expanded="false">${dto.categoryName!}</a>
                </div>
                <div class="col-sm-1">
                    <p class="gds-d8 text-muted">序号：${dto.serialNumber!}</p>
                </div>
                <div class="col-sm-3">
                    <p class="gds-d8 text-muted">创建时间： ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}</p>
                </div>
                <div class="col-sm-2">
                    <p class="gds-d8 text-muted">创建人： ${dto.createName!}</p>
                </div>
                <div class="col-sm-6 text-right">
                    <@shiro.hasPermission name="createCommodity">
                        <a onclick="location.href='/commodity/info/add?id=${dto.id!}';"
                           class="btn gds-btn-2">新增</a>
                    </@shiro.hasPermission>
                    <@shiro.hasPermission name="editCategory">
                        <a class="btn gds-btn-2" onclick="location.href='edit?id=${dto.id!?c}';">编辑</a>
                    </@shiro.hasPermission>
                    <@shiro.hasPermission name="deleteCategory">
                        <a type="button" class="btn gds-btn-2" onclick="del('${dto.id!}')">删除</a>
                    </@shiro.hasPermission>
                </div>
            </div>
        </div>
        <div id="a${dto.id}" class="panel-collapse collapse">
            <div class="panel-body">
                <#if dto.infoDtos??>
                    <#list dto.infoDtos as info>
                        <div class="row">
                            <div class="col-sm-3">
                                商品名称：${info.name!}
                            </div>
                            <div class="col-sm-4">
                                创建时间：${(info.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
                            </div>
                            <div class="col-sm-2">创建人：${info.createName!}</div>
                            <div class="col-sm-6 text-right">
                                <@shiro.hasPermission name="editCommodity">
                                    <a class="gds-fg-blue"
                                       onclick="location.href='/commodity/info/edit?id=${info.id!}';">编辑</a>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name="deleteCommodity">
                                    <a class="gds-fg-blue"
                                       onclick="delProduct('${info.id!}')">删除</a>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name="viewCommodity">
                                    <a class="gds-fg-blue"
                                       onclick="location.href='/commodity/info/disPlay?id=${info.id!}';">查看</a>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name="commodityStorage">
                                    <a class="gds-fg-blue" onclick="rukun('${info.id!}')">出/入库</a>
                                </@shiro.hasPermission>
                                <@shiro.hasPermission name="viewLog">
                                    <a class="gds-fg-blue" onclick="rukunList('${info.id!}')">操作日志</a>
                                </@shiro.hasPermission>
                            </div>
                        </div>
                    </#list>
                </#if>
            </div>
        </div>
    </#list>
    </div>
</div>
</tbody>
</table>
<#include "/include/my_pagination.ftl">
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="${base}/resources/module/shop/js/jquery.1.12.4.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/admin/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
<script type="text/javascript">
    //删除分组
    function del(id) {
        layer.confirm('您真的确定要删除吗？\n\n请确认！', {
            btn: ['确定', '取消'] //按钮
        }, function () {
            $.ajax({
                url: '/commodity/category/delete',
                type: 'GET', //GET
                async: true,    //或false,是否异步
                data: {"id": id},
                success: function (result) {
                    if (result.data == "success") {
                        layer.msg(result.msg);
                        /*$(this).parents().parents().parents().remove();*/
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.msg);
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
                url: '/commodity/info/delete?id=' + id,
                type: 'GET', //GET
                async: true,    //或false,是否异步
                data: {"id": id},
                success: function (result) {
                    if (result.state == "success") {
                        layer.msg(result.msg);
                        setTimeout(function () {
                            location.reload(true);
                        }, 500);
                    } else {
                        layer.msg(result.msg);
                    }
                }
            });
        });
    }
</script>
<script type="text/javascript">

    //入库弹窗
    function rukun(id) {
        layer.open({
            type: 2,
            area: ['500px', '450px'],
            title: '商品入库信息',
            shade: 0.6, //遮罩透明度
            maxmin: true, //允许全屏最小化
            anim: 1,//0-6的动画形式，-1不开启
            shadeClose: true,
            content: '/commodity/storage/storage?cid=' + id
        });
    }
    //入库信息
    function rukunList(id) {
        layer.open({
            type: 2,
            title: '',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['800px', '500px'],
            content: '/commodity/storage/list?cid=' + id
        });
    }
</script>
<#--消息提示框-->
<#--<style>
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
<strong id="tip"></strong>
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