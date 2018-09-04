<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate', 'element'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var element = layui.element;
        });
        $().ready(function() {
            jQuery("button.test1").each(function() {
                var $this = $(this);
                uploadCompletes1($this);
            });
        });
        function uploadCompletes1($this) {
            layui.use('upload', function(){
                var upload = layui.upload;
                //执行实例
                upload.render({
                    elem: $this //绑定元素
                    ,url: '${base}/file/upload?fileType=image&token='+getCookie("token") //上传接口
                    ,done: function(res){
                        //如果上传失败
                        if(res.code > 0){
                            return layer.msg('上传失败');
                        }
                        //上传成功
                        ($this). prev().val(res.data);
                    }
                    ,error: function(){
                        //请求异常回调
                        alert("异常!!!");
                    }
                });
            });
        }
    </script>
</head>
<body>
<#include "tab.ftl"/>
<form class="layui-form" action="saveconfig" method="post">
    <input type="hidden" name="id" value="<#if dto.id??>${dto.id!?c}</#if>"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-inline">
                <input name="state" value="true" title="启用" type="radio" <#if dto.state?? && dto.state>checked</#if>>
                <input name="state" value="false" title="禁用" type="radio" <#if dto.state?? && !dto.state>checked</#if>>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">线下结算</label>
            <div class="layui-input-inline">
                <input name="offlineSettlement" value="true" title="是" type="radio" <#if dto.offlineSettlement?? && dto.offlineSettlement>checked</#if>>
                <input name="offlineSettlement" value="false" title="否" type="radio" <#if dto.offlineSettlement?? && !dto.offlineSettlement>checked</#if>>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">提示信息</label>
            <div class="layui-input-inline">
                <input name="title" placeholder="如:点击完善个人信息" autocomplete="off" class="layui-input" value="${dto.title!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">信息</label>
            <div class="layui-input-block">
                <input name="infos" value="name" <#if dto.infos?? && dto.infos?index_of("name") gt -1>checked="checked"</#if> lay-skin="primary" title="姓名" type="checkbox">
                <input name="infos" value="phone" <#if dto.infos?? && dto.infos?index_of("phone") gt -1>checked="checked"</#if> lay-skin="primary" title="手机号" type="checkbox">
                <input name="infos" value="cardNo" <#if dto.infos?? && dto.infos?index_of("cardNo") gt -1>checked="checked"</#if> lay-skin="primary" title="银行卡卡号" type="checkbox">
                <input name="infos" value="bankName" <#if dto.infos?? && dto.infos?index_of("bankName") gt -1>checked="checked"</#if> lay-skin="primary" title="开户银行" type="checkbox">
                <input name="infos" value="bankAddress" <#if dto.infos?? && dto.infos?index_of("bankAddress") gt -1>checked="checked"</#if> lay-skin="primary" title="开户行支行地址" type="checkbox">
                <input name="infos" value="alipay" <#if dto.infos?? && dto.infos?index_of("alipay") gt -1>checked="checked"</#if> lay-skin="primary" title="支付宝账号" type="checkbox">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label">二维码底图</label>
            <div class="layui-input-inline" style="width: 30%;">
                <input name="bigPath" lay-verify="required" style="display: inline;width: 190px;" maxlength="3" autocomplete="off" class="layui-input" value="${dto.bigPath!}">
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">二维码宽度</label>
            <div class="layui-input-inline">
                <input name="qrcodeWidth" lay-verify="required" maxlength="3" autocomplete="off" class="layui-input" value="${dto.qrcodeWidth!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">二维码高度</label>
            <div class="layui-input-inline">
                <input name="qrcodeHeight" lay-verify="required" maxlength="3" autocomplete="off" class="layui-input" value="${dto.qrcodeHeight!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">位移的宽度</label>
            <div class="layui-input-inline">
                <input name="qrcodeRelativeWidth" lay-verify="required" maxlength="3" autocomplete="off" class="layui-input" value="${dto.qrcodeRelativeWidth!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">位移的高度</label>
            <div class="layui-input-inline">
                <input name="qrcodeRelativeHeight" lay-verify="required" maxlength="3" autocomplete="off" class="layui-input" value="${dto.qrcodeRelativeHeight!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </div>
</form>
</body>
</html>