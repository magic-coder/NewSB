<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>大转盘活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="turntable">class="layui-this"</#if>><a href="../WxTurntable/list">活动列表</a></li>
        <li <#if type=="participate">class="layui-this"</#if>><a href="../WxTurntableParticipate/list">活动参与</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../WxTurntableRecord/list">大转盘记录</a></li>
        <li <#if type=="prizes">class="layui-this"</#if>><a href="../WxTurntableRecord/prizeList">中奖记录</a></li>
    </ul>
</div>