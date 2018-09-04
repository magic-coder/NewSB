<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>砍价活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="bargain">class="layui-this"</#if>><a href="../wxBargainActivity/list">活动列表</a></li>
        <li <#if type=="participate">class="layui-this"</#if>><a href="../wxBargainParticipate/list">活动记录</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../wxBargainRecord/list">砍价记录</a></li>
    </ul>
</div>