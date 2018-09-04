<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>订单详情</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <link href="${base}/resources/module/system/css/bootstrap-tags.css" rel="stylesheet" />
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap/js/bootstrap.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    <!--[if lt IE 9]>
	<script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	<script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="${base}/resources/module/system/js/bootstrap-select.js"></script>
    <script src="${base}/resources/module/system/js/bootstrap-tags.js"></script>
</head>
<body class="gds">
<div class="container-fluid">
    <!--选项卡-->
    <div class="gds-container">
        <ul id="myTab" class="nav nav-tabs">
            <li class="active">
                <a href="#all" data-toggle="tab">全部记录</a>
            </li>
            <li>
                <a href="#self" data-toggle="tab">自营记录</a>
            </li>
            <li>
                <a href="#cooperate" data-toggle="tab">合作记录</a>
            </li>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="all">
                <table class="table gds-table table-bordered"">
                <tr>
                    <th>姓名 / 手机号</th>
                    <th>订单编号</th>
                    <th>产品编码 / 产品</th>
                    <th>价格*张数=</th>
                    <th>购买时间</th>
                    <th>消费时间</th>
                    <th>订单有效期</th>
                    <th>状态</th>
                    <th>同步状态</th>
                    <th>操作</th>
                </tr>
                <tr>
                    <td>张三<br/>18012345678</td>
                    <td>内：123456987654<br />外：123456987654</td>
                    <td>123456<br />王屋山国家级自然风景名胜区成人票</td>
                    <td>198.80*2=387.60</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />~<br/>2017.12.13</td>
                    <td>消费1张<br/>	退款1张<br/>申请退款1张</td>
                    <td>
                        <span class="text-muted">线下</span><br />
                        <span class="text-muted">未同步</span>
                    </td>
                    <td>
                        <a class="table-action">订单详情</a><br />
                        <a class="table-action">退款审核</a><br />
                        <a class="table-action">修改订单</a>
                    </td>
                </tr>
                <tr>
                    <td>张三<br/>18012345678</td>
                    <td>内：123456987654<br />外：123456987654</td>
                    <td>123456<br />王屋山国家级自然风景名胜区成人票</td>
                    <td>198.80*2=387.60</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />~<br/>2017.12.13</td>
                    <td>消费1张<br/>	退款1张<br/>申请退款1张</td>
                    <td>
                        <span class="text-muted">线下</span><br />
                        <span class="text-muted">未同步</span>
                    </td>
                    <td>
                        <a class="table-action">订单详情</a><br />
                        <a class="table-action">退款审核</a><br />
                        <a class="table-action">修改订单</a>
                    </td>
                </tr>
                <tr>
                    <td>张三<br/>18012345678</td>
                    <td>内：123456987654<br />外：123456987654</td>
                    <td>123456<br />王屋山国家级自然风景名胜区成人票</td>
                    <td>198.80*2=387.60</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />~<br/>2017.12.13</td>
                    <td>消费1张<br/>	退款1张<br/>申请退款1张</td>
                    <td>
                        <span class="text-muted">线下</span><br />
                        <span class="text-muted">未同步</span>
                    </td>
                    <td>
                        <a class="table-action">订单详情</a><br />
                        <a class="table-action">退款审核</a><br />
                        <a class="table-action">修改订单</a>
                    </td>
                </tr>
                <tr>
                    <td>张三<br/>18012345678</td>
                    <td>内：123456987654<br />外：123456987654</td>
                    <td>123456<br />王屋山国家级自然风景名胜区成人票</td>
                    <td>198.80*2=387.60</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />17:53:27</td>
                    <td>2017.12.12<br />~<br/>2017.12.13</td>
                    <td>消费1张<br/>	退款1张<br/>申请退款1张</td>
                    <td>
                        <span class="text-muted">线下</span><br />
                        <span class="text-muted">未同步</span>
                    </td>
                    <td>
                        <a class="table-action">订单详情</a><br />
                        <a class="table-action">退款审核</a><br />
                        <a class="table-action">修改订单</a>
                    </td>
                </tr>
                </table>
            </div>
            <div class="tab-pane fade" id="self">
                <p>自营记录</p>
            </div>
            <div class="tab-pane fade" id="cooperate">
                <p>合作记录</p>
            </div>
        </div>
    </div>
    <script>
        $(function () {
            $('#myTab li:eq(0) a').tab('show');
        });
    </script>
</body>
</html>