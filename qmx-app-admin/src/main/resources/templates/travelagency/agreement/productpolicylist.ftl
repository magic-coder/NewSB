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
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;


            /*form.verify({
                travelagencyId: [/[\S]+/, "请选择旅行社"]
            });*/

            //提交iframe
            form.on('submit(submit)', function () {
                var ppids = $("input[name=ppid]");
                var productIds = $("input[name=productId]");
                var minNumbers = $("input[name=minNumber]");
                var maxNumbers = $("input[name=maxNumber]");
                var prices = $("input[name=price]");
                var json = [];
                var $tr = "";
                for (var i = 0; i < ppids.length; i++) {
                    json.push({
                        "ppid": $(ppids[i]).val(),
                        "productId": $(productIds[i]).val(),
                        "minNumber": $(minNumbers[i]).val(),
                        "maxNumber": $(maxNumbers[i]).val(),
                        "price": $(prices[i]).val()
                    });
                    $tr += '<input name="ppid" value="' + $(ppids[i]).val() + '"/>' +
                            '<input name="productId" value="' + $(productIds[i]).val() + '"/>' +
                            '<input name="minNumber" value="' + $(minNumbers[i]).val() + '"/>' +
                            '<input name="maxNumber" value="' + $(maxNumbers[i]).val() + '"/>' +
                            '<input name="price" value="' + $(prices[i]).val() + '"/>';
                }
                parent.$('#json${productId}').val(JSON.stringify(json));
                parent.$("#${productId}").html($tr);

                parent.layer.close(index);
            });

            $(function () {
                var jsonStr = parent.$('#json${productId}').val();
                var json = jQuery.parseJSON(jsonStr);
                for (var i = 0; i < json.length; i++) {
                    $("#table").append("<tr>\n" +
                            "        <td>\n" +
                            "            <input type=\"hidden\" name=\"ppid\" value=\"" + json[i].ppid + "\">\n" +
                            "            <input type=\"hidden\" name=\"productId\" value=\"${productId}\">\n" +
                            "            <input name=\"minNumber\" value=\"" + json[i].minNumber + "\" lay-verify=\"required\" autocomplete=\"off\"\n" +
                            "                   class=\"layui-input\">\n" +
                            "        </td>\n" +
                            "        <td>\n" +
                            "            <input name=\"maxNumber\" value=\"" + json[i].maxNumber + "\" lay-verify=\"required\" autocomplete=\"off\"\n" +
                            "                   class=\"layui-input\">\n" +
                            "        </td>\n" +
                            "        <td>\n" +
                            "            <input name=\"price\" value=\"" + json[i].price + "\" lay-verify=\"required\" autocomplete=\"off\" class=\"layui-input\">\n" +
                            "        </td>\n" +
                            "        <td><input class=\"layui-btn deleteItem\" data-id=\"" + json[i].ppid + "\"\n" +
                            "                           value=\"删除\" type=\"button\"</td>\n" +
                            "    </tr>");

                }
            });
        });
        $(document).on("click", "#addtr", function () {
            $("#table").append("<tr>\n" +
                    "        <td>\n" +
                    "            <input type=\"hidden\" name=\"ppid\" value=\"\">\n" +
                    "            <input type=\"hidden\" name=\"productId\" value=\"${productId}\">\n" +
                    "            <input name=\"minNumber\" value=\"\" lay-verify=\"required|number\" autocomplete=\"off\"\n" +
                    "                   class=\"layui-input\">\n" +
                    "        </td>\n" +
                    "        <td>\n" +
                    "            <input name=\"maxNumber\" value=\"\" lay-verify=\"required|number\" autocomplete=\"off\"\n" +
                    "                   class=\"layui-input\">\n" +
                    "        </td>\n" +
                    "        <td>\n" +
                    "            <input name=\"price\" value=\"\" lay-verify=\"required|number\" autocomplete=\"off\" class=\"layui-input\">\n" +
                    "        </td>\n" +
                    "        <td><input class=\"layui-btn deleteItem\"" +
                    "                           value=\"删除\" type=\"button\"</td>\n" +
                    "    </tr>");
        });

        $(document).on("blur", "input[name='minNumber']", function () {
            var $this = $(this);
            var tr = $(this).parents("tr:eq(0)");
            if (parseInt(tr.index()) != 1) {
                //获取上一行的maxNumber值
                var maxNumber = tr.prev().find("input[name='maxNumber']").val();
                var minNumber = $this.val();
                if (parseInt(minNumber) <= parseInt(maxNumber)) {
                    layer.msg("数量必须大于上一梯度价格的最大数量，请重新填写!");
                    $this.val("");
                }
            }
        });
        $(document).on("blur", "input[name='maxNumber']", function () {
            var $this = $(this);
            var tr = $(this).parents("tr:eq(0)");
            //获取minNumber值
            var minNumber = tr.find("input[name='minNumber']").val();
            var maxNumber = $this.val();
            if (parseInt(minNumber) > parseInt(maxNumber)) {
                layer.msg("数量设置有误,请重新填写!");
                $this.val("");
            }
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
    <input id="addtr" class="layui-btn" type="button" style="margin-left: 10px;" value="新增">
    <table id="table" class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;">
        <tr>
            <td>
                数量大于
            </td>
            <td>
                数量小于等于
            </td>
            <td>
                产品价格（支持两位小数）
            </td>
            <td>
                操作
            </td>
        </tr>
    <#--<#list page as dto>
        <tr>
            <td>
                <input type="hidden" name="ppid" value="${dto.id!?c}">
                <input type="hidden" name="productId" value="${productId}">
                <input name="minNumber" value="${dto.minNumber!}" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </td>
            <td>
                <input name="maxNumber" value="${dto.maxNumber!}" lay-verify="required" autocomplete="off"
                       class="layui-input">
            </td>
            <td>
                <input name="price" value="${dto.price!}" lay-verify="required" autocomplete="off" class="layui-input">
            </td>
            <td>删除</td>
        </tr>
    </#list>-->
    </table>


    <div align="center">
        <button class="layui-btn" lay-submit="" lay-filter="submit">确定</button>
        <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
    </div>
</form>
</body>
</html>