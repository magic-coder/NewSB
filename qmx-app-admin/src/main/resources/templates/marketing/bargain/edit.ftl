<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>编辑</title>
    <link rel="stylesheet" href="${base}/bak/css/wx/wxSystem.css">
    <script type="text/javascript" src="${base}/resources/module/wx/js/operate.js"></script>

<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;

            laydate.render({elem: "#startDate"});
            laydate.render({elem: "#endDate"});
            laydate.render({elem: "#date"});

            form.on('radio(stockType)', function () {
                if ($(this).val() == 'TOTAL') {
                    $("div[id='TOTAL']").attr("style", "display:block");
                    $("div[id='DAY']").attr("style", "display:none");
                    $("#date").attr("lay-verify", "");
                    $("#numbers").attr("lay-verify", "");
                    $("#activityNum").attr("lay-verify", "required");
                    $('#date').attr("disabled", true);
                    $('#numbers').attr("disabled", true);
                    $('#activityNum').removeAttr("disabled");
                }else{
                    $("div[id='TOTAL']").attr("style", "display:none");
                    $("div[id='DAY']").attr("style", "display:block");
                    $("#date").attr("lay-verify", "required");
                    $("#numbers").attr("lay-verify", "required");
                    $("#activityNum").attr("lay-verify", "");
                    $('#activityNum').attr("disabled", true);
                    $('#date').removeAttr("disabled");
                    $('#numbers').removeAttr("disabled");
                }
            });
        });
        function addpic($this) {
            $("body").find("input[name=date]").attr("lay-key","");
            //同时绑定多个
            var $button = $("body").find("input[name=date]:last");
            console.log($button.get(0));
            layui.laydate.render({
                elem: $button.get(0)
                ,trigger: 'click'
            });
        }
        $().ready(function() {
            jQuery("button.test1").each(function() {
                var $this = $(this);
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
            });
        });
    </script>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label">活动名称</label>
        <div class="layui-input-inline">
            <input name="name" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.name!}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动产品</label>
        <div class="layui-input-inline">
            <input name="product" lay-verify="required" autocomplete="off" class="layui-input" value="${dto.product!}">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">参与者</label>
            <div class="layui-input-inline">
                <input name="cygz" value="true" title="需要" type="radio" <#if dto.cygz?? && dto.cygz>checked</#if>>
                <input name="cygz" value="false" title="不需要" type="radio" <#if dto.cygz?? && !dto.cygz>checked</#if>>
            </div>
            <div class="layui-form-mid">关注</div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">砍价者</label>
            <div class="layui-input-inline">
                <input name="kjgz" value="true" title="需要" type="radio" <#if dto.kjgz?? && dto.kjgz>checked</#if>>
                <input name="kjgz" value="false" title="不需要" type="radio" <#if dto.kjgz?? && !dto.kjgz>checked</#if>>
            </div>
            <div class="layui-form-mid">关注</div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">库存类型</label>
            <div class="layui-input-inline" style="width: 600px;">
                <input name="stockType" value="TOTAL" title="总库存（活动有效期内都能消费）" <#if dto.stockType=="TOTAL"> checked </#if> type="radio" lay-filter="stockType">
                <input name="stockType" value="DAY" title="日库存（需要用户指定游玩日期）" <#if dto.stockType=="DAY"> checked </#if> type="radio" lay-filter="stockType">
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="TOTAL" <#if dto.stockType=="DAY">style="display: none;"</#if>>
        <div class="layui-inline">
            <label class="layui-form-label">活动数量</label>
            <div class="layui-input-inline">
                <input id="activityNum" name="number" value="${dto.number!}" <#if dto.stockType=="DAY"> disabled="disabled" <#else> lay-verify="required" </#if> autocomplete="off" class="layui-input" placeholder="请输入整数" />
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="DAY" <#if dto.stockType=="TOTAL">style="display: none;"</#if>>
        <div class="layui-inline" style="width: 80%;">
            <label class="layui-form-label">库存信息</label>
            <div class="layui-input-inline" style="width: 80%;">
                <span style="color:red;"></span>
                <#if dto.stockType=="DAY">
                    <#list stocks as sto>
                    <p style="height: 50px;">
                        <input id="date" name="date" value="${sto.date!}" <#if dto.stockType=="DAY"> lay-verify="required" <#else> disabled="disabled" </#if> style="width: 150px;display: inline" lay-verify="" autocomplete="off" class="layui-input sDate" placeholder="日期">
                        <input id="numbers" name="numbers" value="${sto.number!}" <#if dto.stockType=="DAY"> lay-verify="required" <#else> disabled="disabled" </#if> style="width: 130px;display: inline" lay-verify="" autocomplete="off" class="layui-input" placeholder="库存">
                        <em class="mws_icon mws_ico_add" onclick="addElement(this,1);addpic(this)"></em>
                        <em class="mws_icon mws_ico_next" onclick="shiftDown(this);"></em>
                        <em class="mws_icon mws_ico_prev" onclick="shiftUp(this);"></em>
                        <em class="mws_icon mws_ico_delete" onclick="deleteParent(this);"></em>
                    </p>
                    </#list>
                </#if>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: 100%;">
            <label class="layui-form-label">背景图片</label>
            <div class="layui-input-inline" style="width: 320px;">
                <input id="imageurl" name="imageurl" value="${dto.imageurl!}" style="display: inline;width: 190px;" lay-verify="required" autocomplete="off" class="layui-input">
                <button type="button" class="layui-btn test1">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
            </div>
            <label class="layui-form-label" style="width: 160px;">建议尺寸：640*182</label>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">活动时间</label>
        <div class="layui-input-inline">
            <input id="startDate" name="startDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.startDate!?string("yyyy-MM-dd")}">
        </div>
        <div class="layui-form-mid">-</div>
        <div class="layui-input-inline">
            <input id="endDate" name="endDate" lay-verify="required" autocomplete="off" class="layui-input"
                   value="${dto.endDate!?string("yyyy-MM-dd")}">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">原价</label>
            <div class="layui-input-inline">
                <input name="maxPrice" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.maxPrice!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">砍价后价格</label>
            <div class="layui-input-inline">
                <input name="minPrice" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.minPrice!}">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">砍价范围</label>
            <div class="layui-input-inline">
                <input name="minBargainPrice" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.minBargainPrice!}">
            </div>
            <div class="layui-form-mid">-</div>
            <div class="layui-input-inline">
                <input name="maxBargainPrice" lay-verify="required" autocomplete="off" class="layui-input"
                       value="${dto.maxBargainPrice!}">
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">使用说明</label>
        <div class="layui-input-block">
            <textarea name="content" placeholder="使用说明" required="required"
                      class="layui-textarea">${dto.content!}</textarea>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>