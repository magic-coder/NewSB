<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>刮刮卡活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="scratchCard">class="layui-this"</#if>><a href="../WxScratchCard/list">活动列表</a></li>
        <li <#if type=="participate">class="layui-this"</#if>><a href="../WxScratchCardParticipate/list">活动参与</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../WxScratchCardRecord/list">刮刮卡记录</a></li>
        <li <#if type=="prizes">class="layui-this"</#if>><a href="../WxScratchCardRecord/prizeList">中奖记录</a></li>
    </ul>
</div>