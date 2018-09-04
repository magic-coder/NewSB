<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/resources/admin/css/ext.css" rel="stylesheet" type="text/css"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/image.js"></script>
    <script type="text/javascript" src="${base}/bak/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
</head>
<body>

<form id="imgForm" method="post" class="layui-form" name="imgForm" action="update">
    <input type="hidden" name="groupId" value="${dto.groupId!?c}"/>
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>编辑发布信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">商品品类</label>
            <div class="layui-input-inline">
            <#--<select name="categorys" lay-filter="test" class="categorys" lay-verify="required">
                <option value="">请选择</option>
            <#list commodityCategoryDto as info>
                <option value="${info.id!}"
                        <#if dto.catogaryId=info.id>selected</#if>>${info.categoryName!}</option>
            </#list>
            </select>-->

                <input type="hidden" value="${info.id?c!}" name="categorys"/>${categoryDto.categoryName!}
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">商品</label>
            <div class="layui-input-inline">
            <#--<select name="cid" class="choice" id="cid" lay-filter="cid" lay-verify="required">

                <option value="">请选择</option>
            <#list dto.commodityInfoDtoList as info>
                <option value="${info.id}" <#if info.id=dto.cid>selected</#if>>${info.name}</option>
            </#list>
            </select>-->
            <#list dto.productInfoDtoList as info>
                <#if info.id==dto.cid>
                    <input type="hidden" value="${info.id}" name="cid"/>${info.name}
                </#if>
            </#list>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">发布名称</label>
            <div class="layui-input-inline">
                <input type="text" name="releaseName" autocomplete="off" lay-verify="required"
                       value="${dto.releaseName!}" class="layui-input"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">发布价格</label>
            <div class="layui-input-inline">
                <input type="text" name="salePrice" autocomplete="off" lay-verify="salePrice"
                       value="${dto.salePrice!}"
                       class="layui-input"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">发布库存</label>
            <div class="layui-input-inline">
                <input type="text" name="saleStock" autocomplete="off" lay-verify="saleStock"
                       value="${dto.saleStock!}"
                       class="layui-input"/>
                <input type="hidden" id="notStock" value="${dto.surpluStock!}"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">发布序号</label>
            <div class="layui-input-inline">
                <input type="text" name="serial" autocomplete="off" lay-verify="serial" value="${dto.serial!}"
                       class="layui-input"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">商品图片</label>
    <#-- <input type="text" name="serial" autocomplete="off" class="layui-input"/>-->
        <div class="productImageArea">
            <div class="example"></div>
            <a class="prev browse" href="javascript:void(0);" hidefocus="true"></a>
            <div class="scrollable">
            <#--<input type="hidden" lay-verify="img"/>-->
                <ul class="items">
                <#if dto.imageDtos??>
                    <#list dto.imageDtos as info>
                        <li>
                            <div class="productImageBox">
                                <div class="productImagePreview png"><img src="${info.url!}"/>
                                    暂无图片
                                </div>
                                <input type="hidden" name="focusimagepath" id="focusimagepath" value="${info.url!}"
                                       lay-verify="img">
                                <div class="productImageOperate">
                                    <a class="left" href="javascript: void(0);" alt="左移" hidefocus="true"></a>
                                    <a class="right" href="javascript: void(0);" title="右移" hidefocus="true"></a>
                                    <a class="delete" href="javascript: void(0);" title="删除" hidefocus="true"></a>
                                </div>
                                <a class="productImageUploadButton" href="javascript:;">
                                    <div>上传新图片</div>
                                </a>
                            </div>
                        </li>
                    </#list>
                <#else>
                    <li>
                        <div class="productImageBox">
                            <div class="productImagePreview png">暂无图片</div>
                            <div class="productImageOperate">
                                <a class="left" href="javascript: void(0);" alt="左移" hidefocus="true"></a>
                                <a class="right" href="javascript: void(0);" title="右移" hidefocus="true"></a>
                                <a class="delete" href="javascript: void(0);" title="删除" hidefocus="true"></a>
                            </div>
                            <input type="hidden" name="focusimagepath" value="">
                            <a class="productImageUploadButton" href="javascript:;">
                                <div>上传新图片</div>
                            </a>
                        </div>
                    </li>
                </#if>
                </ul>
            </div>
            <a class="next browse" href="javascript:void(0);" hidefocus="true"></a>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">发货方式:</label>
            <div class="layui-input-inline">
                <input name="mailingMethod" lay-verify="required" type="radio" value="1"
                       class="layui-input" <#if dto.mailingMethod==1>checked</#if>>快递
                <input name="mailingMethod" lay-verify="required" type="radio" value="2"
                       class="layui-input" <#if dto.mailingMethod==2>checked</#if>>发码
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">短信模板</label>
            <div class="layui-input-inline">
                <select name="smsTemplateId" lay-verify="required">
                    <option value="">请选择</option>
                <#if smsTemplates??>
                    <#list smsTemplates as st>
                        <option value="${st.id?c!}"
                                <#if "${st.id!}"=='${dto.smsTemplateId!}'>selected</#if>>${st.name!}</option>
                    </#list>
                </#if>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline" style="width: auto">
            <label class="layui-form-label">取消设置</label>
            <div class="layui-input-inline" style="width: auto">
                <input type="text" name="autoCancelTime" autocomplete="off" lay-verify="autoCancelTime"
                       class="layui-input" value="${dto.autoCancelTime!}"/>
            </div>
            <span>分钟后不支付自动取消 (默认2×60，最短5分钟，最大值不可超过21600分钟)</span>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">购买须知</label>
        <div class="layui-input-block">
                <textarea name="purchaseNotes" placeholder="请输入内容" lay-verify="required" lay-verify="required"
                          class="layui-textarea" style="width: 40%;">${dto.purchaseNotes!}</textarea>
            <span class="tips">500字以内</span>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">描述</label>
        <div class="layui-input-block">
            <textarea name="description" class="editor">${dto.description!}</textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<script type="text/javascript">
    layui.use(['form', 'table', 'laydate', 'jquery'], function () {
        var $ = layui.$;
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        // form.render('select');
        form.render();
        /*根据品类id获取商品*/
        form.on('select(test)', function (data) {
            var parent = $(data).parent();
            var id = $(".categorys").val();
            var choice = parent.children(".choice");
            $(".commodityInfoData").remove();
            $.ajax({
                url: '/commodityRelease/findCommodity',
                type: 'GET',
                async: true,
                data: {"categoryId": id},
                success: function (result) {
                    for (var key in result.dto) {
                        $(".choice").append("<option class='commodityInfoData' value=" + key + ">" + result.dto[key] + "</option>");
                    }
                    form.render('select');
                }
            });
        });

        form.verify({
            serial: [/^\d+$/, "请填写正确的序号！"],
            salePrice: [/(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/, "请填写正确的发布价格！"]
        });

        //验证发布库存
        form.verify({
            saleStock: function (value, item) {
                var stock = $("#notStock").val();
                if (!(/^\d+$/.test(value))) {
                    return "请填写正确的发布库存！";
                }
                if (parseInt(value) > parseInt(stock)) {
                    return '该商品库存不足，目前剩余未发布的库存为' + stock;
                }
            }
        });

        form.verify({
            autoCancelTime: function (value, item) {
                if (value < 5) {
                    return "最短取消5分钟！";
                }
                if (value > 21600) {
                    return "最大值不可超过21600分钟！";
                }
                if (!(/^\d+$/.test(value))) {
                    return "请填写正确的取消时间！";
                }
            }
        });

        //验证图片上传
        form.verify({
            img: function (value, item) {
                var img = $("#focusimagepath").val();
                if (img == null || img == undefined || img == '') {
                    return '请至少上传一张商品导图';
                }
            }
        });

    });

    //上传
    $(".productImageUploadButton").each(function () {
        var $this = $(this);
        new AjaxUpload($this, {
            action: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
            name: 'file',
            autoSubmit: true,
            responseType: "json",
            onChange: function (file, ext) {
                if (!(ext && /^(jpg|png|gif|jpeg|bmp)$/.test(ext))) {
                    alert("上传文件格式错误");
                    return false;
                }
            },
            onSubmit: function (file, ext) {
                $this.text("正在上传...");
                $this.attr("disabled", true);
            },
            onComplete: function (file, response) {
                $this.text("上传");
                $this.attr("disabled", false);
                if (response) {
                    var filepath = response.url;
                    $this.prev().val(filepath);
                }
            }
        });
    });
</script>
</body>
</html>