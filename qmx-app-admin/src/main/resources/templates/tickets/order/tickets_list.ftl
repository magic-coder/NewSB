<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>门票预订</title>
    <!-- Bootstrap -->
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet" />
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet" />
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
<#include "/include/common_header_include.ftl">
</head>
<body class="gds">
<div class="container-fluid">
    <!--搜索-->
    <form class="form-inline" action="ticketsList" method="get">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">产品名称</label>
                    <input type="text" name="name" value="${name!}" class="form-control gds-input" placeholder="产品名称">
                </div>
                <div class="form-group">
                    <label for="exampleInputName2">产品ID</label>
                    <input type="text" name="sn" value="${sn!}" class="form-control gds-input" placeholder="产品ID">
                </div>
                <div class="form-group">
                    <label>是否上架</label>
                    <select class="selectpicker" name="marketable">
                        <option value="">--是否上架--</option>
                        <option value="true" <#if marketable?? && marketable == 'true'> selected</#if>>已上架</option>
                        <option value="false" <#if (marketable?? && marketable == 'false')> selected</#if>>未上架</option>
                    </select>
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="submit" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>
        </div>
    <!--表格-->
    <div class="gds-container">
        <table class="table gds-table table-bordered">
            <tr>
                <th>NO</th>
                <th>门票名称</th>
                <th>价格</th>
                <th>景区名称</th>
                <th>添加日期</th>
                <th>是否上架</th>
                <th>操作</th>
            </tr>
            <#if currentMember.userType == 'distributor'>
                <#list page.records as dto>
                    <tr>
                        <td>${dto_index+1}</td>
                        <td>
                        ${dto.product.ticketTypeName!}-${dto.product.fullName!}(${dto.productSn!})
                            <#if dto.enable>
                                <#if dto.priceModifyFlag>
                                    <span style="color: red;font-size: 20px;">授权异常</span>
                                </#if>
                            <#else>
                                <span style="color: red;font-size: 20px;">授权已删除</span>
                            </#if>
                        <td>
                    <span style="color: red;font-size: 26px;">￥${dto.marketPrice?string(",##0.00")}</span>
                        </td>
                        <td>
                        ${dto.product.sightName!}
                        </td>
                        <td>${dto.createTime?datetime}</td>
                        <td>${dto.product.marketable?string("是", "否")}</td>
                        <td>
                            <#if dto.product.marketable>
                                <a class="btn gds-btn-1" href="addTicketsOrder?id=${dto.productId!}">预定</a>
                            <#--<input type="button" class="btn gds-btn-1" id="bookTickets" data-id="${product.id!}" value="预订">-->
                            <#--<button onclick="toBook('${product.id!}')" class="btn gds-btn-1" data-toggle="modal" id="bookTickets" data-id="${product.id!}" data-target="#myModal">预定</button>-->
                            <#else>
                                已下架
                            </#if>
                        </td>
                    </tr>
                </#list>
            <#else>
                <#list page.records as product>
                    <tr>
                        <td>${product_index+1}</td>
                        <td>
                            ${product.ticketTypeName!}-${product.fullName!}(${product.sn})
                        </td>
                        <td>
                            <span style="color: red;font-size: 26px;">￥${product.marketPrice?string(",##0.00")}</span>
                        </td>
                        <td>
                            ${product.sightName!}
                        </td>
                        <td>${product.createTime?datetime}</td>
                        <td>${product.marketable?string("是", "否")}</td>
                        <td>
                            <#if product.marketable>
                                <a class="btn gds-btn-1" href="addTicketsOrder?id=${product.id!}">预定</a>
                            <#--<input type="button" class="btn gds-btn-1" id="bookTickets" data-id="${product.id!}" value="预订">-->
                                <#--<button onclick="toBook('${product.id!}')" class="btn gds-btn-1" data-toggle="modal" id="bookTickets" data-id="${product.id!}" data-target="#myModal">预定</button>-->
                            <#else>
                                已下架
                            </#if>
                        </td>
                    </tr>
                </#list>
            </#if>
        </table>
    </div>
    <!--分页-->
    <#include "/include/pagination_new.ftl">
    </form>
</div>
<#--<form class="form-inline">
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog gds-modal-iframe">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">预定产品信息</h4>
                </div>
                <iframe id="bookIframe" width="100%" height="650px" frameborder="0"></iframe>
            </div>
        </div>
    </div>
</form>-->
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script type="text/javascript" src="${base}/resources/common/js/jquery-3.2.1.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
<#--<script>
    layui.use(['form','table','laydate'], function(){
        var table = layui.table,form = layui.form;
        $(document).on("click","#bookTickets",function(){
            var data = $(this).attr("data-id");
            var index = layer.open({
                type: 2,
                title: '门票预订',
                area: ['680px', '500px'], //宽高
                fix: true, //固定
                content: 'addTicketsOrder?id='+data
            });
        });
    });
</script>-->
</body>
</html>