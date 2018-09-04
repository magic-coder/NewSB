<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>腕带管理</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="list">class="layui-this"</#if>><a href="../wxWristband/list">腕带信息</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../wxWristbandRecharge/list">充值记录</a></li>
        <li <#if type=="config">class="layui-this"</#if>><a href="../wxWristband/config">腕带信息设置</a></li>
    </ul>
</div>