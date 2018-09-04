<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>门票列表</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet" />
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet" />
    <script src="${base}/resources/common/js/jquery-3.2.1.min.js"></script>
    <script src="${base}/resources/common/js/common.tools.js"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="${base}/resources/common/js/html5shiv.min.js"></script>
    <script src="${base}/resources/common/js/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript">
        $(function () {
            $("#onLineProduct").click(function () {

                if(!confirm("确定要上架该产品吗？")){
                    return;
                }

                var val = $(this).attr('data-id');
                var reqData = {};
                reqData.id = val;
                $.ajax({
                    url:'shelvesTickets',
                    type:'POST', //GET
                    //async:true,    //或false,是否异步
                    data:reqData,
                    //timeout:5000,    //超时时间
                    dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success:function(resp){
                        if(resp){
                            if(resp.errorCode == 0){
                                alert('上架成功')
                                location.reload(true);
                            }else {
                                alert(resp.errorMsg)
                            }
                        }
                    },
                    error:function(xhr,textStatus){
                        alert(xhr.responseText)
                    }
                });
            });
            $("#offLineProduct").click(function () {
                if(!confirm("确定要下架该产品吗？")){
                    return;
                }
                var val = $(this).attr('data-id');
                var reqData = {};
                reqData.id = val;
                $.ajax({
                    url:'underTickets',
                    type:'POST', //GET
                    //async:true,    //或false,是否异步
                    data:reqData,
                    //timeout:5000,    //超时时间
                    dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
                    success:function(resp){
                        if(resp){
                            if(resp.errorCode == 0){
                                alert('下架成功')
                                location.reload(true);
                            }else {
                                alert(resp.errorMsg)
                            }
                        }
                    },
                    error:function(xhr,textStatus){
                        alert(xhr.responseText)
                    }
                });
            });
        })
    </script>
</head>
<body class="gds">
<div class="container-fluid">
    <!--搜索-->
    <form class="form-inline" action="listTicketsWithType">
        <div class="gds-search list">
            <div class="row">
                <#--<div class="form-group">
                    <label>产品</label>
                    <input type="text" class="form-control gds-input" placeholder="门票名称/门票编码">
                </div>
                <div class="form-group">
                    <label>产品状态</label>
                    <select class="selectpicker" name="marketable">
                        <option value="">请选择</option>
                        <option <#if queryDto?? && queryDto.marketable?? && queryDto.marketable>selected</#if> value="true">已上架</option>
                        <option <#if queryDto?? && queryDto.marketable?? && !queryDto.marketable>selected</#if> value="false">已下架</option>
                    </select>
                </div>-->
                <div class="form-group">
                    <label>景点</label>
                    <input type="text" name="sightName" value="${queryDto.sightName!}" class="form-control gds-input" placeholder="景点名称">
                    <#--<select name="sightId" class="selectpicker" data-live-search="true">
                        <option value="">请选择</option>
                    <#if sightList??>
                        <#list sightList as sight>
                            <option <#if queryDto??&& queryDto.sightId?? && queryDto.sightId == sight.id>selected</#if> value="${sight.id!}">${sight.sightName!}</option>
                        </#list>
                    </#if>
                    </select>-->
                </div>
                <div class="form-group">
                    <label>供应商</label>
                    <input type="text" name="supplierAccount" value="${queryDto.supplierAccount!}" class="form-control gds-input" placeholder="供应商账号">
                    <#--<select name="supplierId" class="selectpicker" data-live-search="true">
                        <option value="">请选择</option>
                    <#if supplierList??>
                        <#list supplierList as supplier>
                            <option <#if queryDto?? && queryDto.supplierId?? && queryDto.supplierId == supplier.id>selected</#if> value="${supplier.id}">${supplier.account}-${supplier.username!}</option>
                        </#list>
                    </#if>
                    </select>-->
                </div>
                <#--<div class="gds-group">
                    <div class="form-group">
                        <label>省份</label>
                        <select class="selectpicker" data-live-search="true">
                            <option selected="selected">四川</option>
                            <option>湖南</option>
                            <option>广州</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>市区</label>
                        <select class="selectpicker" data-live-search="true">
                            <option selected="selected">青羊区</option>
                            <option>双流区</option>
                            <option>高新区</option>
                        </select>
                    </div>
                </div>-->
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="submit" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>
            <#--<div class="row">
                <div class="form-group">
                    <label>创建人</label>
                    <input type="text" class="form-control gds-input" placeholder="">
                </div>

                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <button type="submit" class="btn btn-default gds-btn-1">重置</button>
                </div>
            </div>-->
        </div>
    <!--列表-->
    <div class="gds-operation">
        <div class="row">
            <@shiro.hasPermission name = "admin:addTicketsType">
                <a href="addTicketsType" id="addSelect" class="btn btn-default gds-btn-1">
                    新建票型
                </a>
            </@shiro.hasPermission>
        </div>
    </div>
    <!--折叠-->
    <div class="panel-group" id="accordion">
        <#list page.records as ticketsType>
        <div class="gds-panel">
            <div class="panel-heading">
                <div class="panel-title row">
                    <div class="col-sm-4">
                        <span class="gds-1d2">票型：</span><a class="gds-collapse-action collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapse${ticketsType.id!}" aria-expanded="false">${ticketsType.name!}</a>
                    </div>
                    <div class="col-sm-6">
                        <p class="gds-d8 text-muted">供应商：<#if ticketsType.supplierAccount??>${ticketsType.supplierAccount!}</#if></p>
                        <p class="gds-d8 text-muted">景点：<#if ticketsType.sightName??>${ticketsType.sightName!}</#if></p>
                    </div>
                    <div class="col-sm-4 text-right">
                        <@shiro.hasPermission name = "admin:addTickets">
                        <a href="addTickets?ticketTypeId=${ticketsType.id}" class="btn gds-btn-2">新增产品</a>
                        </@shiro.hasPermission>

                        <#--<a href="javascript:alert('不支持删除票型');" class="btn gds-btn-2">删除</a>-->
                    </div>
                </div>
            </div>
            <#if ticketsType.ticketsList??>
            <div id="collapse${ticketsType.id!}" class="panel-collapse collapse">
                <div class="panel-body">
                <#list ticketsType.ticketsList as tickets>
                    <div class="row">
                        <div class="col-sm-4">
                            <#if tickets.marketable>
                                <span class="gds-state-active">已上架</span>${tickets.name!}
                            <#else>
                                <span class="gds-state-muted">已下架</span>${tickets.name!}
                            </#if>
                        </div>
                        <div class="col-sm-3">编码：${tickets.sn!}</div>
                        <div class="col-sm-3">创建人：${tickets.createBy!}</div>
                        <div class="col-sm-4 text-right">
                            <@shiro.hasPermission name = "admin:editTickets">
                            <a href="editTickets?id=${tickets.id}" class="gds-fg-blue">编辑</a>
                            </@shiro.hasPermission>
                            <#if tickets.marketable>
                                <a id="offLineProduct" data-id="${tickets.id!}" class="gds-fg-blue">下架</a>
                            <#else>
                                <a id="onLineProduct" data-id="${tickets.id!}" class="gds-fg-blue">上架</a>
                            </#if>
                            <#--<a class="gds-fg-blue">复制</a>
                            <a class="gds-fg-blue">删除</a>-->
                        </div>
                    </div>
                </#list>
                </div>
            </div>
            </#if>
        </div>
        </#list>
    </div>
    <!--分页-->
    <#include "/include/pagination_new.ftl">
    </form>
</div>
<script src="${base}/resources/common/js/jquery-3.2.1.js"></script>
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
</body>
</html>