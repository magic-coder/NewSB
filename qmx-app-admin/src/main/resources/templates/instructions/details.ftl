<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${base}/bak/resources/layui/css/layui.css"  media="all">
</head>
<body>
&nbsp;&nbsp;&nbsp;&nbsp;<button style="margin-top: 15px;" class="layui-btn layui-btn-normal" onclick="javascript:history.back(-1)">返  回</button><br>
<#--<h3 class="text-center">${data.details!}?</h3>-->
<#--<script src="${base}/bak/resources/layui/layui.js"></script>-->
${data.details!}
<#--<script>-->
    <#--layui.use(['util', 'laydate', 'layer'], function(){-->
        <#--var util = layui.util-->
                <#--,laydate = layui.laydate-->
                <#--,layer = layui.layer;-->
        <#--//固定块-->
        <#--util.fixbar({-->
            <#--bar1: true-->
<#--//            ,bar2: true-->
            <#--,css: {right: 30, bottom: 550}-->
            <#--,bgcolor: '#4c8ea1'-->
            <#--,click: function(type){-->
                <#--if(type === 'bar1'){-->
                    <#--window.location.href.history.back(-1);-->
                    <#--layer.msg('icon是可以随便换的')-->
                <#--} else if(type === 'bar2') {-->
                    <#--layer.msg('两个bar都可以设定是否开启')-->
                <#--}-->
            <#--}-->
        <#--});-->
    <#--});-->
<#--</script>-->
<#--<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">-->
    <#--<legend>使用说明列表</legend>-->
<#--</fieldset>-->

<#--&lt;#&ndash;<div class="layui-btn-group demoTable">&ndash;&gt;-->
    <#--&lt;#&ndash;<button class="layui-btn" data-type="getCheckData">获取选中行数据</button>&ndash;&gt;-->
    <#--&lt;#&ndash;<button class="layui-btn" data-type="getCheckLength">获取选中数目</button>&ndash;&gt;-->
    <#--&lt;#&ndash;<button class="layui-btn" data-type="isAll">验证是否全选</button>&ndash;&gt;-->
<#--&lt;#&ndash;&lt;#&ndash;</div>&ndash;&gt;   /help/getlist/&ndash;&gt;-->

<#--<table class="layui-table" lay-data="{width: 1100, height:520, url:'/help/getlist/', page:true, id:'idTest'}" lay-filter="demo">-->
    <#--<thead>-->
    <#--<tr>-->
        <#--<th lay-data="{field:'id', width:200}">说明编号</th>-->
        <#--<th lay-data="{field:'title', width:350}">说明标题</th>-->
        <#--<th lay-data="{field:'conut', width:100}">被浏览数</th>-->
        <#--<th lay-data="{fixed: 'right', width:400, toolbar: '#barDemo'}"></th>-->
    <#--</tr>-->
    <#--</thead>-->
<#--</table>-->

<#--<script type="text/html" id="barDemo">-->
    <#--<a class="layui-btn layui-btn-sm" lay-event="detail">查看</a>-->
    <#--&lt;#&ndash;<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>&ndash;&gt;-->
    <#--&lt;#&ndash;<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>&ndash;&gt;-->
<#--</script>-->


<#--<script src="${base}/bak/resources/layui/layui.js" charset="utf-8"></script>-->
<#--<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 &ndash;&gt;-->
<#--<script>-->
    <#--layui.use('table', function(){-->
        <#--var table = layui.table;-->
        <#--//监听表格复选框选择-->
        <#--table.on('checkbox(demo)', function(obj){-->
            <#--console.log(obj)-->
        <#--});-->
        <#--//监听工具条-->
        <#--table.on('tool(demo)', function(obj){-->
            <#--var data = obj.data;-->
            <#--if(obj.event === 'detail'){-->
                <#--layer.msg('ID：'+ data.id + ' 的查看操作');-->
                <#--window.location.href="/help/getdetails?id="+data.id;-->
            <#--} else if(obj.event === 'del'){-->
                <#--layer.confirm('真的删除行么', function(index){-->
                    <#--obj.del();-->
                    <#--layer.close(index);-->
                <#--});-->
            <#--} else if(obj.event === 'edit'){-->
                <#--layer.alert('编辑行：<br>'+ JSON.stringify(data))-->
            <#--}-->
        <#--});-->

<#--//        var $ = layui.$, active = {-->
<#--//            getCheckData: function(){ //获取选中数据-->
<#--//                var checkStatus = table.checkStatus('idTest')-->
<#--//                        ,data = checkStatus.data;-->
<#--//                layer.alert(JSON.stringify(data));-->
<#--//            }-->
<#--//            ,getCheckLength: function(){ //获取选中数目-->
<#--//                var checkStatus = table.checkStatus('idTest')-->
<#--//                        ,data = checkStatus.data;-->
<#--//                layer.msg('选中了：'+ data.length + ' 个');-->
<#--//            }-->
<#--//            ,isAll: function(){ //验证是否全选-->
<#--//                var checkStatus = table.checkStatus('idTest');-->
<#--//                layer.msg(checkStatus.isAll ? '全选': '未全选')-->
<#--//            }-->
<#--//        };-->

        <#--$('/*.demoTable*/ .layui-btn').on('click', function(){-->
            <#--var type = $(this).data('type');-->
            <#--active[type] ? active[type].call(this) : '';-->
        <#--});-->
    <#--});-->
<#--</script>-->

</body>
</html>