<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;//重点处


            //监听量返类型
            form.on('select(type)', function (data) {
                var type = data.value;
                if (type == 'amount') {
                    $("#repeat").show();
                } else {
                    $("#repeat").hide();
                }
            });

            //提交iframe
            form.on('submit(submit1)', function () {
                var productIds = $("input[name=productId]");
                var type = $("#type option:selected");
                var returnType = $("#returnType option:selected");
                var number = $("input[name=number]");
                var returnNumber = $("input[name=returnNumber]");
                var repeat = $("input[name=repeat]:checked");
                var jsonqb = [];
                var $qbtr = "";
                jsonqb.push({
                    // "ppid": $(ppids[i]).val(),
                    "productId": $(productIds).val(),
                    "type": $(type).val(),
                    "returnType": $(returnType).val(),
                    "number": $(number).val(),
                    "returnNumber": $(returnNumber).val(),
                    "repeat": $(repeat).val()
                });
                $qbtr += '<input name="qbProductId" value="' + $(productIds).val() + '"/>' +
                        '<input name="type" value="' + $(type).val() + '"/>' +
                        '<input name="returnType" value="' + $(returnType).val() + '"/>' +
                        '<input name="number" value="' + $(number).val() + '"/>' +
                        '<input name="returnNumber" value="' + $(returnNumber).val() + '"/>' +
                        '<input name="repeat" value="' + $(repeat).val() + '"/>';
                parent.$('#jsonqb${productId}').val(JSON.stringify(jsonqb));
                parent.$("#qb${productId}").html($qbtr);
                parent.layer.close(index);
            });

            $(function () {
                var jsonStr = parent.$('#jsonqb${productId}').val();
                var json = jQuery.parseJSON(jsonStr);
                for (var i = 0; i < json.length; i++) {
                    var type = json[i].type;
                    $("#number").val(json[i].number);
                    $("#returnNumber").val(json[i].returnNumber);
                    $("#type").val(json[i].type);
                    $("#returnType").val(json[i].returnType);
                    $("input[name='repeat'][value='" + json[i].repeat + "']").attr("checked", true);
                    /* $("#repeat").hide();
                     $("#number").val(json[i].number);
                     $("#returnNumber").val(json[i].returnNumber);
                     $("#type").val(json[i].type);
                     $("#returnType").val(json[i].returnType);*/
                }
                form.render();
            });
        });

        // 删除梯度价格
        $(document).on("click", ".deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                if ($this.attr("data-id")) {
                    $.ajax({
                        url: "deleteProductPolicy",
                        type: "POST",
                        data: {id: $this.attr("data-id")},
                        dataType: "json",
                        beforeSend: function () {
                        },
                        success: function (datas) {
                        }
                    });
                }
                $this.closest("tr").remove();
                layer.close(index);
            }, function () {
            });
        });
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="#" method="post">
    <table id="table" class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
        <input type="hidden" name="productId" value="${productId!}">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">量返规则：</label>
            </div>
        </div>
        <div class="layui-form-item">
        <#-- <div class="layui-inline">
             <label class="layui-form-label">量返规则：</label>
         </div>-->
            &nbsp; &nbsp;
            <div class="layui-inline">
                <div class="layui-form-mid">订单</div>
                <div class="layui-input-inline">
                    <div class="layui-input-inline" style="width:auto;">
                        <select name="type" id="type" lay-filter="type">
                        <#list type as info>
                            <option value="${info!}" <#if info=='money'>selected</#if>>${info.title!}</option>
                        </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-form-mid">达到</div>
                <div class="layui-input-inline" style="width: auto">
                    <div class="layui-input-inline" style="width:auto">
                        <input autocomplete="off" lay-verify="required|number" name="number" id="number"
                               class="layui-input"
                               style="width: 50px;">
                    </div>
                </div>
                <div class="layui-form-mid">返</div>
                <div class="layui-input-inline">
                    <div class="layui-input-inline" style="width:auto;">
                        <select name="returnType" id="returnType">
                        <#list type as info>
                            <option value="${info!}">${info.title!}</option>
                        </#list>
                        </select>
                    </div>
                </div>
                <div class="layui-input-inline" style="width: auto">
                    <div class="layui-input-inline" style="width:auto;">
                        <input autocomplete="off" lay-verify="required|number" name="returnNumber" id="returnNumber"
                               class="layui-input"
                               style="width: 50px;">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 280px;">是否允许单个订单达到量返标准就重复领取：</label>
                <div class="layui-input-inline">
                    <input type="radio" name="repeat" value="true" title="是">
                    <input type="radio" name="repeat" value="false" title="否" checked>
                </div>
            </div>
        </div>
    </table>
    <div align="center">
        <button class="layui-btn" lay-submit="" lay-filter="submit1">确定</button>
        <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
    </div>
</form>
</body>
</html>