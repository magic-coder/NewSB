<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>裂变分销</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="list">class="layui-this"</#if>><a href="list">佣金记录</a></li>
        <li><a href="javascript:alert('完善中');">佣金处理</a></li>
        <li <#if type=="info">class="layui-this"</#if>><a href="info">佣金概要</a></li>
        <li <#if type=="query">class="layui-this"</#if>><a href="query">结算查询</a></li>
        <li <#if type=="product">class="layui-this"</#if>><a href="product">佣金设置</a></li>
        <li <#if type=="config">class="layui-this"</#if>><a href="config">分销设置</a></li>
    </ul>
</div>