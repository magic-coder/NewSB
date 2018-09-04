<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            form.verify({
                groupNumber: [/^[1-9]\d*$/, "请填写正确的分组序号！"]
            })
        });
    </script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
</head>
<body>
<form id="imgForm" class="layui-form" method="post" name="imgForm" action="update">
    <input type="hidden" name="id" value="${dto.id!}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>编辑信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">分组名称</label>
            <div class="layui-input-inline">
                <input type="text" name="groupName" lay-verify="required" autocomplete="off" value="${dto.groupName!}"  class="layui-input"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">序号</label>
            <div class="layui-input-inline">
                <input type="text" name="groupNumber" lay-verify="groupNumber" autocomplete="off" value="${dto.groupNumber!}" class="layui-input"/>
            </div>
        </div>
    </div>
    <!--组状态-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">组状态</label>
            <div class="layui-input-inline">
                <input name="status" lay-verify="required" autocomplete="off" type="radio"
                       value="true" title="启用" <#if dto.status?string("true","false")=="true">checked</#if>>
                <input name="status" lay-verify="required" autocomplete="off" type="radio"
                       value="false" title="禁用" <#if dto.status?string("true","false")=="false">checked</#if>>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
<script type="text/javascript">
    /*根据品类id获取商品*/
   /* function findCommodity() {
        var id = $("#categorys").val();
        $.ajax({
            url: '/commodityGroup/getInfoById',
            type: 'GET',
            async: true,
            data: {"categoryId": id},
            success: function (result) {
                $("#commodity").html("");
                for (var key in result.commodityInfo) {
                    $("#commodity").append("<input type='checkbox' name='commodityInfo' value='" + key + "'/>" + result.commodityInfo[key] + "");
                }
            }
        });
    }*/

            <!--实现表格选中删除行-->
            /*    function deleteText() {
                    $("input[name='delete']:checked").each(function () { // 遍历选中的checkbox
                        n = $(this).parents("tr").index();  // 获取checkbox所在行的顺序
                        $("table#msgTable").find("tr:eq(" + n + ")").remove();
                    })
                }*/

    //数据提交验证
    /*function submitData() {
        var ids=new Array();
        $("select[name='categorys']").each(function(index,item){
                    ids.push($(this).val());
                }
        );
        if(mm(ids)){
            alert('不能选择相同的品类！');
            return;
        }
        $("form").submit();
    }*/
    //验证数组中是否包含相同的字符串的正则表达式
    /*function mm(a)
    {
        return /(\x0f[^\x0f]+)\x0f[\s\S]*\1/.test("\x0f"+a.join("\x0f\x0f") +"\x0f");
    }*/
            /*根据品类id获取商品*/
    /*function findCommodity(obj) {
                var parent = $(obj).parent();
                var label = parent.children(".commodity");
                var id =  parent.children(".categorys").val();
                $.ajax({
                    url: '/commodityGroup/getInfoById',
                    type: 'GET',
                    async: true,
                    data: {"categoryId": id},
                    success: function (result) {
                        label.html("");
                        for (var key in result.commodityInfo) {
                            label.append("<input type='checkbox' name='commodityInfo' value='" + key + "'/>" + result.commodityInfo[key] + "");
                        }
                    }
                });
            }*/

    /*删除父级元素*/
    /*function deleteParent(e){
        var parent = $(e).parent();
        var num = parent.parent().children().length;
        if(num>=2){
            parent.remove();
        }
    }*/
    /*添加元素*/
    /*function addElement(e,a){
        var rootNode = eval("$(e)" + repeatStr(".parent()",a+1));
        var obj = rootNode.find('p:last').clone();
        obj.children(".commodity").html("");
        obj.find('input').val("");
        obj.find('a.mws_bg_box').html("+");
        obj.find('select option').eq(0).attr("selected",true);
        rootNode.append(obj);
    }*/

</script>

</html>