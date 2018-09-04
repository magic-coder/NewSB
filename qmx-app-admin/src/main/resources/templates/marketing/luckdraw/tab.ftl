<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>跑马灯活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="luckdraw">class="layui-this"</#if>><a href="../WxLuckdraw/list">活动列表</a></li>
        <li <#if type=="participate">class="layui-this"</#if>><a href="../WxLuckdrawParticipate/list">活动记录</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../WxLuckdrawRecord/list">跑马灯记录</a></li>
        <li <#if type=="prizes">class="layui-this"</#if>><a href="../WxLuckdrawRecord/prizeList">中奖记录</a></li>
    </ul>
</div>