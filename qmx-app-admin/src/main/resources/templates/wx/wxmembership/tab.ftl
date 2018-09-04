<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>会员管理</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="list">class="layui-this"</#if>><a href="../wxMembership/list">会员卡管理</a></li>
        <li <#if type=="rule">class="layui-this"</#if>><a href="../wxMembershipRule/list">规则管理</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../wxMembershipRecord/list">充值/消费记录</a></li>
    </ul>
</div>