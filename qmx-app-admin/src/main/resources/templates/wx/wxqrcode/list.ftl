<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>二维码</title>
    <script type="text/javascript" src="${base}/resources/module/wx/js/showDialog.js"></script>
    <link rel="stylesheet" href="${base}/bak/css/wx/showDialog.css" />
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>二维码列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">场景值</label>
            <div class="layui-input-inline">
                <input id="scene" type="text" name="sceneId" value="${dto.sceneId!}${dto.sceneStr!}" autocomplete="off"
                       class="layui-input" placeholder="场景值">
            </div>
            <div class="layui-input-inline">
                <select id="type" name="actionName" ONCHANGE="changeName();">
                    <option value="">--类型--</option>
                    <option value="QR_LIMIT_SCENE" <#if dto.actionName?? && dto.actionName=="QR_LIMIT_SCENE">selected</#if>>永久的整型参数值</option>
                    <option value="QR_LIMIT_STR_SCENE" <#if dto.actionName?? && dto.actionName=="QR_LIMIT_STR_SCENE">selected</#if>>永久的字符串参数值</option>
                    <option value="QR_SCENE" <#if dto.actionName?? && dto.actionName=="QR_SCENE">selected</#if>>临时的整型参数值</option>
                    <option value="QR_STR_SCENE" <#if dto.actionName?? && dto.actionName=="QR_STR_SCENE">selected</#if>>临时的字符串参数值</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
<div class="layui-form-item">
    &nbsp;
    <div class="layui-inline">
        <div class="layui-input-inline">
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">新增</button>
        </div>
    </div>
</div>
    <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
           lay-size="sm" lay-filter="sysBalanceTableEvent">
        <tr>
            <th class="check">
                <input type="checkbox" id="selectAll"/>
            </th>
            <th>
                类型
            </th>
            <th>
                场景值
            </th>
            <th>
                URL
            </th>
            <th>
                时间
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td style="text-align: center">
                <input name="id" type="checkbox" value="${(dto.id)!}"/>
            </td>
            <td style="text-align: center">
            ${(dto.actionName.title)!}
            </td>
            <td style="text-align: center">
            ${dto.sceneId!}${(dto.sceneStr)!}
            </td>
            <td style="text-align: center">
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" onclick="showqrcode('${(dto.url)!}')" value="预览"/>
                <input type="button" class="layui-btn layui-btn-normal layui-btn-sm" onclick="location.href='download?url=https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=${dto.ticket!}';" value="下载"/>
            </td>
            <td style="text-align: center">
            ${dto.createTime?string("yyyy-MM-dd HH:mm:ss")}
            </td>
            <td style="text-align: center">
                <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">


<script type="text/javascript">
    function showqrcode(url){
        $.ajax({
            type: "post",
            url: "../wxutils/getqrcode?url="+url,
            success: function(msg){
                showInfo("<img src='"+msg+"' />");
            }
        });
    }

    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            alert(id);
            window.location.href="delete.jhtml?id="+id;
        }else{
            return false;
        }
    }
</script>
<script type="text/javascript">
    function changeName(){
        var type = $("#type").val();
//        if($("#scene").val()==""){
//            return;
//        }
        if(type=="QR_LIMIT_STR_SCENE"||type=="QR_LIMIT_SCENE"){
            $("#scene").attr("name","sceneStr");
        }else if(type=="QR_SCENE"||type=="QR_STR_SCENE"){
            $("#scene").attr("name","sceneId");
            if(isNaN($("#scene").val())){
                alert("临时二维码场景值必须为数字");
                return;
            }
        }
//        $("#inputForm").submit();
    }
</script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script>
    var Script = function () {
        $("#listForm").validate({
            rules: {
                actionName: "required",
                sceneId: "required",
                sceneStr: "required",
            },
            messages: {
                actionName: "必须选择一个",
                sceneId: "必填项",
                sceneStr: "必填项",
            }
        });
    }();
</script>

</body>
</html>