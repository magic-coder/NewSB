<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>签到活动</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="sign">class="layui-this"</#if>><a href="../WxSignActivity/list">活动列表</a></li>
        <#--<li <#if type=="prize">class="layui-this"</#if>><a href="../WxSignPrize/list">活动奖品</a></li>
        <li <#if type=="rule">class="layui-this"</#if>><a href="../WxSignRule/list">活动规则</a></li>-->
        <li <#if type=="participate">class="layui-this"</#if>><a href="../WxSignParticipate/list">活动参与</a></li>
        <li <#if type=="record">class="layui-this"</#if>><a href="../WxSignRecord/list">活动记录</a></li>
        <li <#if type=="prizes">class="layui-this"</#if>><a href="../WxSignRecord/prizeList">中奖记录</a></li>
    </ul>
</div>