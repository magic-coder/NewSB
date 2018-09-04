<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加订单</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js"
            charset="UTF-8"></script>
    <script type="text/javascript"
            src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"
            charset="UTF-8"></script>
    <script type="text/javascript">
        /*var layedit;
        layui.use(['form', 'table', 'laydate', 'layedit'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({elem: "#beginDate"});
            laydate.render({elem: "#endDate"});
            laydate.render({elem: "#prizeBeginDate"});
            laydate.render({elem: "#prizeEndDate"});

            layedit = layui.layedit;
            layedit.set({
                uploadImage: {
                    url: '${base}/file/upload?fileType=image&token=' + getCookie("token") //接口url
                    , type: 'post' //默认post
                }
            });
            index = layedit.build('demo'); //建立编辑器
            form = layui.form;
            form.on('submit(submit)', function (data) {
                $("#content").val(layedit.getContent(index));
                console.log(data.elem); //被执行事件的元素DOM对象，一般为button对象
                console.log(data.form); //被执行提交的form对象，一般在存在form标签时才会返回
                console.log(data.field); //当前容器的全部表单字段，名值对形式：{name: value}
                //return false;
            });
        });*/

        $(function () {
            $(function () {
                $("input[name=vsdate]").datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                });
                $("input[name=vedate]").datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                });
            });
        });
    </script>
</head>
<body class="gds gds-modal">
<form id="inputForm" action="" method="post">
    <div class="gds-modal-content">
        <div class="reserve-iframe">
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-10">产品名称：
                        <span>
                            <input type="text" class="form-control" placeholder="产品名称"/>
                        </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">预订规则：
                        <span>
                            <select class="form-control" style="width: auto">
                                <option>请选择</option>
                                <option>组合预定规则01</option>
                                <option>组合预定规则02</option>
                                <option>组合预定规则03</option>
                            </select>
                        </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">退款规则：
                        <span>
                            <select class="form-control" style="width: auto">
                                <option>请选择</option>
                                <option>组合退款规则01</option>
                                <option>组合退款规则02</option>
                                <option>组合退款规则03</option>
                            </select>
                        </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">使用规则：
                        <span>
                            <select class="form-control" style="width: auto">
                                <option>请选择</option>
                                <option>组合使用规则01</option>
                                <option>组合使用规则02</option>
                                <option>组合使用规则03</option>
                            </select>
                        </span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-10" style="width: auto;">
                        <div class="form-group">
                            出售日期设置：
                            <input name="vsdate" readonly class="form-control" data-date-format="yyyy-mm-dd"
                                   data-link-format="yyyy-mm-dd"/>
                            &nbsp;—&nbsp;
                            <input name="vedate" readonly class="form-control" data-date-format="yyyy-mm-dd"
                                   data-link-format="yyyy-mm-dd"/>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-10">产品包含：
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">选择门票1
                        <span>
                            <select class="form-control" style="width: auto">
                                <option>请选择</option>
                                <option>水上乐园成人票</option>
                                <option>陆地乐园成人票</option>
                            </select>
                        </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">选择门票2
                        <span>
                            <select class="form-control" style="width: auto">
                                <option>请选择</option>
                                <option>水上乐园成人票</option>
                                <option>陆地乐园成人票</option>
                            </select>
                        </span>
                    </div>
                </div>

                <#--<div class="row">
                    <div class="col-sm-10">预订须知
                        <span>
                        <textarea id="demo" style="display: none;"></textarea>
                        <input id="content" name="content" type="hidden" value=""/>
                    </span>
                    </div>
                </div>-->

                <div class="modal-footer" style="text-align: left">
                    <button type="button" onclick="javascript:alert('联系管理员获取新增组合权限');" lay-submit
                            lay-filter="submitAddOrder"
                            class="btn btn-warning">保存
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
</html>