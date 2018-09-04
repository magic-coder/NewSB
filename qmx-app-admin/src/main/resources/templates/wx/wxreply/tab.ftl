<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
    <legend>回复列表</legend>
</fieldset>
<div class="layui-tab layui-tab-brief">
    <ul class="layui-tab-title">
        <li <#if type=="TEXT">class="layui-this"</#if>><a href="list?msgTypes=TEXT">文本回复</a></li>
        <li <#if type=="NEWS">class="layui-this"</#if>><a href="list?msgTypes=NEWS">图文回复</a></li>
        <li <#if type=="MUSIC">class="layui-this"</#if>><a href="list?msgTypes=MUSIC">语音回复</a></li>
        <li <#if type=="IMAGE">class="layui-this"</#if>><a href="list?msgTypes=IMAGE">图片回复</a></li>
    </ul>
</div>