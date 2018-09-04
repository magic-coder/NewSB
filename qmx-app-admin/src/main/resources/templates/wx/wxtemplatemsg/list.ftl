<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>模板消息列表</title>
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
    <legend>模板列表</legend>
</fieldset>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <div class="layui-input-inline">
                <select name="type" lay-filter="aihao" lay-verify="required">
                    <option value="">--使用场景--</option>
                    <option value="activity" <#if dto.type?? && dto.type=="activity">selected</#if>>活动中奖时</option>
                    <option value="fahuo" <#if dto.type?? && dto.type=="fahuo">selected</#if>>发送入园凭证</option>
                    <option value="agent1" <#if dto.type?? && dto.type=="agent1">selected</#if>>发展一级代理</option>
                    <option value="agent2" <#if dto.type?? && dto.type=="agent2">selected</#if>>发展二级代理</option>
                    <option value="commissio1" <#if dto.type?? && dto.type=="commissio1">selected</#if>>一级返佣</option>
                    <option value="commissio2" <#if dto.type?? && dto.type=="commissio2">selected</#if>>二级返佣</option>
                    <option value="kf_online" <#if dto.type?? && dto.type=="kf_online">selected</#if>>在线客服自动回复</option>
                    <option value="coupon_num" <#if dto.type?? && dto.type=="coupon_num">selected</#if>>优惠券领取时</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="state" lay-filter="aihao" lay-verify="required">
                    <option value="" >--消息状态--</option>
                    <option value="1" <#if dto.state?? && dto.state==true>selected</#if>>启用</option>
                    <option value="0" <#if dto.state?? && dto.state==false>selected</#if>>禁用</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select name="enable" lay-filter="aihao" lay-verify="required">
                    <option value="">--是否启用微信模板--</option>
                    <option value="1" <#if dto.enable?? && dto.enable==true>selected</#if>>启用</option>
                    <option value="0" <#if dto.enable?? && dto.enable==false>selected</#if>>禁用</option>
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
            <button onclick="location.href='add';" class="layui-btn layui-btn-normal">添加模板消息</button>
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
                使用场景
            </th>
            <th>
                是否使用微信模板
            </th>
            <th>
                状态
            </th>
            <th>
               模板内容
            </th>
            <th>
                <span>操作</span>
            </th>
        </tr>
    <#list page.records as dto>
        <tr>
            <td style="text-align: center">
                <input type="checkbox" name="ids" value="${dto.id!}"/>
            </td>
            <td style="text-align: center">
            ${(dto.type.title)!}
            </td>
            <td style="text-align: center">
                <#if dto.enable==true>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <td style="text-align: center">
                <#if dto.state==true>
                    <span style="color:green;">√</span>
                <#else>
                    <span style="color:red;">×</span>
                </#if>
            </td>
            <td style="text-align: center">
            ${dto.content!}
            </td>
            <td style="text-align: center">
                <input type="button" onclick="location.href='edit?id=${dto.id!?c}';"
                       class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!?c}" id="viewBtn"
                       value="编辑"/>
                <input type="button" onclick="del('${dto.id?c}')" class="layui-btn layui-btn-normal layui-btn-sm" data-id="${dto.id!}" id="viewBtn"
                       value="删除"/>
            </td>
        </tr>
    </#list>
    </table>
<#include "/include/my_pagination.ftl">

<script type="text/javascript">
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
</body>
</html>