<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>助力活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="activity">class="layui-this"</#if>><a href="../wxAssistanceActivity/list">助力活动列表</a></li>
        <li <#if type=="participate">class="layui-this"</#if>><a href="../wxAssistanceParticipate/list">活动参与</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../wxAssistanceRecord/list">活动记录</a></li>
        <li <#if type=="prizes">class="layui-this"</#if>><a href="../wxAssistanceRecord/prizeList">领取记录</a></li>
    </ul>
</div>