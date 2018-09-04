<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>商品入库</title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.$;

            laydate.render({
                elem: "#useLife"
            });
        });
    </script>
    <style type="text/css">
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form method="post" name="storageFrom" id="storageFrom" action="getStorage" class="layui-form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>核销列表</legend>
    </fieldset>
    <form class="layui-form" action="list" method="get">
    </form>
    <div class="layui-form-item">
        &nbsp;
        <div class="layui-inline">
            <div class="layui-input-inline">
            </div>

        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th>
            订单号
        </th>
        <th>
            联系人
        </th>
        <th>
            产品名称
        </th>
        <th>
            创建创建时间
        </th>
        <td>
            操作
        </td>
    </tr>
    <tbody>
    <#list orderList as dto>
    <tr>
        <td>
        ${dto.id!}
        </td>
        <td>
            <#if dto.mailingMethod==1>
                <#if dto.userAddressDto??>
                    <li>${dto.userAddressDto.consignee!}</li>
                    <li>${dto.userAddressDto.phone!}</li>
                    <li>${dto.userAddressDto.fullAddress!}</li>
                </#if>
            <#elseif  dto.mailingMethod==2>
                <li>${dto.contactName!}</li>
                <li>${dto.contactPhone!}</li>
            </#if>
        </td>
        <td>
        ${dto.releaseName!}
        </td>
        <td>
        ${(dto.createTime!)?string("yyyy-MM-dd HH:mm:ss")}
        </td>
        <td>
            <button class="layui-btn layui-btn-sm layui-btn-normal " onclick="verifyCode('${dto.verifyId?c!}')">核销</button>
        </td>
    </tr>
    </#list>
    </tbody>
</table>

<script type="text/javascript">
    //提交
    function sub() {
        $.ajax({
            url: 'verifycode',
            type: 'get',
            data: $('#storageFrom').serialize(),
            dataType: 'json',
            success: function (result) {
                if (result.data == 'success') {
                    layer.msg('检验成功', {
                        time: 1000//0.5s后自动关闭
                    });
                } else {
                    /*var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);*/
                    layer.msg('检验失败', {
                        time: 1000//0.5s后自动关闭
                        // btn: ['明白了', '知道了']
                    });
                }
                /*        var index = parent.layer.getFrameIndex(window.name);
                          parent.layer.close(index);*/
                //刷新父窗口页面
                // parent.location.reload();
                setTimeout(function () {
                    parent.location.reload();
                }, 1500);
            }
        })
    }

    //核销
    function verifyCode(data) {
       $.ajax({
           url: 'verifycode',
           type: 'get',
           data: {"id":data},
           dataType: 'json',
           success: function (result) {
               if (result.data == 'success') {
                   layer.msg('检验成功', {
                       time: 1000//0.5s后自动关闭
                   });
               } else {
                   /*var index = parent.layer.getFrameIndex(window.name);
                   parent.layer.close(index);*/
                   layer.msg('检验失败', {
                       time: 1000//0.5s后自动关闭
                   });
               }
               /*        var index = parent.layer.getFrameIndex(window.name);
                         parent.layer.close(index);*/
               //刷新父窗口页面
               setTimeout(function () {
                   parent.location.reload();
               }, 1500);
           }
       })
    }
</script>
</body>
</html>