<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>门票列表</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
    <script src="${base}/resources/common/js/jquery-3.2.1.min.js"></script>
    <script src="${base}/resources/common/js/common.tools.js"></script>
    <script src="${base}/resources/common/js/html5shiv.min.js"></script>
    <script src="${base}/resources/common/js/respond.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#onLineProduct").click(function () {
                if (!confirm("确定要上架该产品吗？")) {
                    return;
                }
                var val = $(this).attr('data-id');
                var reqData = {};
                reqData.id = val;
                $.ajax({
                    url: 'shelvesTickets',
                    type: 'POST', //GET
                    //async:true,    //或false,是否异步
                    data: reqData,
                    //timeout:5000,    //超时时间
                    dataType: 'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success: function (resp) {
                        if (resp) {
                            if (resp.errorCode == 0) {
                                alert('上架成功')
                                location.reload(true);
                            } else {
                                alert(resp.errorMsg)
                            }
                        }
                    },
                    error: function (xhr, textStatus) {
                        alert(xhr.responseText)
                    }
                });
            });
            $("#offLineProduct").click(function () {
                if (!confirm("确定要下架该产品吗？")) {
                    return;
                }
                var val = $(this).attr('data-id');
                var reqData = {};
                reqData.id = val;
                $.ajax({
                    url: 'underTickets',
                    type: 'POST', //GET
                    //async:true,    //或false,是否异步
                    data: reqData,
                    //timeout:5000,    //超时时间
                    dataType: 'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success: function (resp) {
                        if (resp) {
                            if (resp.errorCode == 0) {
                                alert('下架成功')
                                location.reload(true);
                            } else {
                                alert(resp.errorMsg)
                            }
                        }
                    },
                    error: function (xhr, textStatus) {
                        alert(xhr.responseText)
                    }
                });
            });
        })
    </script>
</head>
<body class="gds">
<div class="container-fluid">
    <form class="form-inline" action="">
        <div class="gds-search list">
            <div class="row">
                <div class="form-group">
                    <input type="text" value="" name="name" class="form-control gds-input"
                           placeholder="产品名称">
                    <input type="text" value="" name="sn" class="form-control gds-input"
                           placeholder="产品编码">
                </div>
                <div class="form-group">
                    <label>产品状态</label>
                    <select class="selectpicker" name="marketable">
                        <option value="">请选择</option>
                        <option value="true">已上架</option>
                        <option value="false">已下架</option>
                    </select>
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="submit" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>

        </div>
        <div class="gds-operation">
            <div class="row">
                <a class="btn gds-btn-2" href="/group/ticketorhotel/add">新增</a>
            </div>
        </div>
        <div class="panel-group" id="accordion">

            <div class="gds-panel">
                <div id="collapse1" class="panel-collapse ">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-4">
                                <span class="gds-state-active">已上架</span>
                                恐龙主题房双人套餐
                            </div>
                            <div class="col-sm-3">编码：467963</div>
                            <div class="col-sm-3">包含：水上乐园成人票、恐龙主题大床房</div>
                            <div class="col-sm-4 text-right">

                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <#--<#list page.records as ticket>
            <div class="gds-panel">

                <div id="collapse${ticket.id!}" class="panel-collapse ">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-4">
                                <#if ticket.marketable>
                                    <span class="gds-state-active">已上架</span>${ticket.name!}[${ticket.ticketTypeName!}]
                                <#else>
                                    <span class="gds-state-muted">已下架</span>${ticket.name!}[${ticket.ticketTypeName!}]
                                </#if>
                            </div>
                            <div class="col-sm-3">编码：${ticket.sn!}</div>
                            <div class="col-sm-3">创建人：${ticket.createUser!'-'}</div>
                            <div class="col-sm-4 text-right">
                                <a href="editTickets?id=${ticket.id}" class="gds-fg-blue">编辑</a>
                                <a id="offLineProduct" data-id="${ticket.id!}" class="gds-fg-blue">下架</a>
                                <a id="onLineProduct" data-id="${ticket.id!}" class="gds-fg-blue">上架</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </#list>-->
        </div>
    <#--<#include "/include/pagination_new.ftl">-->
    </form>
</div>
<script src="${base}/resources/common/js/jquery-3.2.1.js"></script>
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
</body>
</html>