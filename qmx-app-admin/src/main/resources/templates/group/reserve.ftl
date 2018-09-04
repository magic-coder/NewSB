<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>产品预订</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<#include "/include/common_header_include.ftl">
</head>
<body class="gds">
<div class="container-fluid">
    <form class="form-inline" action="" method="get">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">产品名称</label>
                    <input type="text" name="name" value="" class="form-control gds-input" placeholder="产品名称">
                </div>
                <div class="form-group">
                    <label for="exampleInputName2">产品ID</label>
                    <input type="text" name="sn" value="" class="form-control gds-input" placeholder="产品ID">
                </div>
                <div class="form-group">
                    <label>是否上架</label>
                    <select class="selectpicker" name="marketable">
                        <option value="">--是否上架--</option>
                        <option value="true">已上架</option>
                        <option value="false">未上架</option>
                    </select>
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="submit" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>
        </div>
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

                <tr>
                    <td>1</td>
                    <td>
                        恐龙园水陆套票（10153）
                    </td>
                    <td>
                    <span style="color: red;font-size: 26px;">￥358.00
                </span></td>
                    <td>
                        恐龙园
                    </td>
                    <td>2018-05-07 11:46:05</td>
                    <td>是</td>
                    <td>
                        <a class="btn gds-btn-1" href="javascript:alert('权限不足');">预定</a>
                    </td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>
                        恐龙主题房双人套餐（467963）
                    </td>
                    <td>
                    <span style="color: red;font-size: 26px;">￥998.00
                </span></td>
                    <td>
                        恐龙园
                    </td>
                    <td>2018-04-02 17:29:25</td>
                    <td>是</td>
                    <td>
                        <a class="btn gds-btn-1" href="javascript:alert('权限不足');">预定</a>
                    </td>
                </tr>

            <#--<#list page.records as product>
                <tr>
                    <td>${product_index+1}</td>
                    <td>
                    ${product.ticketTypeName!}-${product.fullName!}(${product.sn})
                    </td>
                    <td>
                    <span style="color: red;font-size: 26px;">￥${product.marketPrice?string(",##0.00")}
                    </td>
                    <td>
                    ${product.sightName!}
                    </td>
                    <td>${product.createTime?datetime}</td>
                    <td>${product.marketable?string("是", "否")}</td>
                    <td>
                        <#if product.marketable>
                            <a class="btn gds-btn-1" href="addTicketsOrder?id=${product.id!}">预定</a>
                        <#else>
                            已下架
                        </#if>
                    </td>
                </tr>
            </#list>-->
            </table>
        </div>
    <#--<#include "/include/pagination_new.ftl">-->
    </form>
</div>

<script type="text/javascript" src="${base}/resources/common/js/jquery-3.2.1.js"></script>
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>

</body>
</html>