<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
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
<#include "tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input type="text" name="userName" value="${dto.userName!}" autocomplete="off"
                       class="layui-input" placeholder="请输入用户名">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="cardNum" value="${dto.cardNum!}" autocomplete="off"
                       class="layui-input" placeholder="请输入会员卡号">
            </div>
            <div class="layui-input-inline">
                <select name="carType" class="input_1">
                    <option value="">卡类型</option>
                    <option value="common" <#if dto.carType?? && dto.carType=="common">selected</#if>>普通</option>
                    <option value="senior" <#if dto.carType?? && dto.carType=="senior">selected</#if>>高级</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="synState" class="input_1">
                    <option value="">同步状态</option>
                    <option value="1" <#if dto.synState?? && dto.synState==true>selected</#if>>已同步</option>
                    <option value="0" <#if dto.synState?? && dto.synState==false>selected</#if>>未同步</option>
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
            <input id="copy" type="button" style="width: 120px;" title="${copyurl!}" class="layui-btn layui-btn-normal copy" value="复制发布地址"/>
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
                名字
            </th>
            <th>
                卡号
            </th>
            <th>
                卡类型
            </th>
            <th>
                余额
            </th>
            <th>
                积分
            </th>
            <th>
                同步
            </th>
            <#--<th>
                状态
            </th>-->
            <th>
                更新日期
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td>
                <input type="checkbox" name="ids" value="${dto.id}"/>
            </td>
            <td>
            ${dto.userName!}
            </td>
            <td>
            ${dto.cardNum!}
            </td>
            <td>
                <#if dto.carType=="senior">
                    <span style="color:red;">高级会员</span>
                <#else>
                    <span style="color:green;">普通会员</span>
                </#if>
            </td>
            <td>
                <span style="color:red;">${dto.balance!}&nbsp;￥</span>
            </td>
            <td>
            ${dto.integral!}
            </td>
            <td>
                <#if dto.synState>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <#--<td>
                <#if dto.enable>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>-->
            <td>
                ${dto.updateTime?string("yyyy-MM-dd HH:mm:ss")}
            </td>
            <td>
                <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm"
                       value="编辑"/>
                <input type="button" onclick="location.href='visit?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm"
                       value="查看详情"/>
                <input type="button" onclick="location.href='integral?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm"
                       value="积分消费"/>
                <input type="button" onclick="del('${dto.id!?c}')" class="layui-btn layui-btn-normal layui-btn-sm"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">
<script type="text/javascript" src="${base}/bak/js/ZeroClipboard.js"></script>
<script type="text/javascript">
    $(function(){
        $("input.copy").each(function(){

            var Zero = ZeroClipboard;
            Zero.moviePath = "${base}/resources/module/shop/swf/ZeroClipboard.swf";

            var clip = new ZeroClipboard.Client();
            clip.setHandCursor(true);
            var obj = $(this);
            var id = $(this).attr("id");
            clip.glue(id);

            var txt=$("#"+id).attr("title");//设置文本框中的内容

            //鼠标移上时改变按钮的样式
            clip.addEventListener( "mouseOver", function(client) {
                obj.css("color","#FF6600");
                clip.setText(txt);
            });
            //鼠标移除时改变按钮的样式
            clip.addEventListener( "mouseOut", function(client) {
                obj.css("color","");
            });
            //这个是复制成功后的提示
            clip.addEventListener( "complete", function(){
                alert("已经复制到剪切板！\n"+txt);
            });
        });
    });

    function del(id) {
        var msg = "确定要删除吗？\n\n请确认！";
        if (confirm(msg)==true){
            window.location.href="delete?id="+id;
        }else{
            return false;
        }
    }
</script>
</body>
</html>