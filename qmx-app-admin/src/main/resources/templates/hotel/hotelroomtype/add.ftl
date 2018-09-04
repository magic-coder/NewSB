<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/css/dropdown.css" rel="stylesheet" type="text/css">
<link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css">
<link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
<script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_003.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_004.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_006.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_005.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_002.js"></script>
<script type="text/javascript" src="${base}/bak/js/common.js"></script>
<script type="text/javascript" src="${base}/bak/js/input.js"></script>-->
    <script>
        layui.use(['form', 'table', 'laydate', 'upload'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var upload = layui.upload;
            laydate.render({
                elem: '#validity'
            });

            form.verify({
                distributorId: [/[\S]+/, "请选择旅行社"]
            });

            form.verify({
                count: [/^\+?[1-9][0-9]*$/, '请输入正确的载客数!']
            });

        });
        //关联分销商
        $(document).on("click", "#userIdBtn", function () {
            var index = layer.open({
                type: 2,
                title: '关联旅行社',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getUser'
            });
        });
    </script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
    <style type="text/css">
        #signupForm label.error {
            color: Red;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <input type="hidden" name="hid" value="${hid}"/>
<#--<table class="input tabContent">
    <tr>
        <td>
            <input type="hidden" name="hid" value="${hid}"/>
            <input id="datePriceData" name="datePriceData" type="hidden">
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField">*</span>房型名称:
        </th>
        <td>
            <input type="text" name="name" class="text" maxlength="20" id="room_name"/>
            <label class="error" for="name"></label>
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField"></span>楼层:
        </th>
        <td>
            <input type="text" name="floor" class="text" maxlength="20" placeholder="如：8或者8-10"/>
            <label class="error" for="floor"></label>
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField"></span>床型:
        </th>
        <td>
            <select name="bedType">
                <option value="单床">单床</option>
                <option value="双床">双床</option>
                <option value="多床">多床</option>
                <option value="圆床">圆床</option>
            </select>
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField"></span>床宽:
        </th>
        <td>
            <input type="text" name="bedSize" class="text" maxlength="20"/><span class="tips">范围：0.5-3m</span>
            <label class="error" for="bedSize"></label>
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField"></span>房间面积:
        </th>
        <td>
            <input type="text" name="area" class="text" maxlength="20" placeholder="如：50或者50-70"/>
            <label class="error" for="area"></label>
        </td>
    </tr>
    <tr>
        <th>
            <span class="requiredField"></span>最大入住人数:
        </th>
        <td>
            <input type="text" name="maxOccupancy" class="text" maxlength="30"/>
        </td>
    </tr>
</table>-->
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">房型名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">楼层</label>
            <div class="layui-input-inline">
                <input name="floor" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="如：8或者8-10">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">床型</label>
            <div class="layui-input-inline">
                <select name="bedType" class="layui-input">
                    <option value="单床">单床</option>
                    <option value="双床">双床</option>
                    <option value="多床">多床</option>
                    <option value="圆床">圆床</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">床宽</label>
            <div class="layui-input-inline">
                <input name="bedSize" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="范围：0.5-3m">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">房间面积</label>
            <div class="layui-input-inline">
                <input name="area" lay-verify="required" autocomplete="off" class="layui-input"
                       placeholder="如：50或者50-70">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">最大入住人数</label>
            <div class="layui-input-inline">
                <input name="maxOccupancy" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item" id="pricedate">
        <label class="layui-form-label">设置房型库存</label>
        <input type="hidden" id="datePriceData" name="datePriceData" style="width: 1000px;"/>
        <div class="choose_date_month">
            <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}" date="${.now?string("yyyy-MM")}-01"
                 month="${.now?string("MM")}">
                <div class="choose_month_bar">
                    <div id="prevbutton" class="month_bar prev" title="前一月">
                        <span>&lt;</span>
                        <strong id="prevmonth"></strong>
                    </div>
                    <div id="nextbutton" class="month_bar next" title="后一月">
                        <strong id="nextmonth"></strong>
                        <span>&gt;</span>
                    </div>
                </div>
                <div class="year_month">
                    <span id="year"></span>
                    <span class="month" id="month"></span>
                </div>
                <div class="week clrfix">
                    <span>周日</span>
                    <span>周一</span>
                    <span>周二</span>
                    <span>周三</span>
                    <span>周四</span>
                    <span>周五</span>
                    <span>周六</span>
                </div>
                <div class="date" id="date">

                </div>
            </div>
            <div class="module_calendar_do">
                <span style="color:white;">点击页面下方保存按钮，库存设置才能生效。</span>
                <input id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray" type="button">
                <input id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray" type="button">
                <input id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray" type="button">
            </div>
        </div>
        <div id="calender-right" class="module_calendar_data" style="display: none;">
            <div class="data_item">
                <label class="cap" for="date">
                    日期：</label><span id="showDate"></span>
                <input id="useDate" type="hidden" name="date">
            </div>
            <div class="data_item">
                <label for="stock" class="cap">日房量：</label>
                <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')" id="stockNum"
                       type="text" name="stock" value="0">
                <span class="data_unit">间</span>
            <#--<div class="data_item_do">
                <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray" type="button">
                <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"
                       type="button">
            </div>-->
            </div>
            <div class="data_item_do">
                <input type="button" id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray"/>
                <input type="button" id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"/>
            </div>
        </div>
    </div>
    </div>
<#--<table class="input" align="center" id="rateTable">
    <tbody>
    <tr class="needdate ">
        <th>设置房型库存
        </th>
        <td>
            <div class="choose_date_month">
                <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}" date="${.now?string("yyyy-MM")}-01"
                     month="${.now?string("MM")}">
                    <div class="choose_month_bar">
                        <div id="prevbutton" class="month_bar prev" title="前一月">
                            <span>&lt;</span>
                            <strong id="prevmonth"></strong>
                        </div>
                        <div id="nextbutton" class="month_bar next" title="后一月">
                            <strong id="nextmonth"></strong>
                            <span>&gt;</span>
                        </div>
                    </div>
                    <div class="year_month">
                        <span id="year"></span>
                        <span class="month" id="month"></span>
                    </div>
                    <div class="week clrfix">
                        <span>周日</span>
                        <span>周一</span>
                        <span>周二</span>
                        <span>周三</span>
                        <span>周四</span>
                        <span>周五</span>
                        <span>周六</span>
                    </div>
                    <div class="date" id="date">

                    </div>
                </div>
                <div class="module_calendar_do">
                    <span style="color:white;">点击页面下方保存按钮，库存设置才能生效。</span>
                    <input id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray" type="button">
                    <input id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray" type="button">
                    <input id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray" type="button">
                </div>
            </div>
            <div id="calender-right" class="module_calendar_data" style="display: none;">
                <div class="data_item">
                    <label class="cap" for="date">
                        日期：</label><span id="showDate"></span>
                    <input id="useDate" type="hidden" name="date">
                </div>
                <div class="data_item">
                    <label for="stock" class="cap">日房量：</label>
                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')" id="stockNum"
                           type="text" name="stock" value="0">
                    <span class="data_unit">间</span>
                    <div class="data_item_do">
                        <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray" type="button">
                        <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"
                               type="button">
                    </div>
                </div>
        </td>
    </tr>
    <tr>
        <th>
            &nbsp;
        </th>
    </tr>
    </tbody>
</table>-->
<#--<table class="input" align="center">
    <tr>
        <td align="center">
            <input type="submit" id="btn" class="button" value="提交"/>
            <input type="button" class="button" value="返回" onclick="history.back();"/>
        </td>
    </tr>
</table>-->
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
<!--批量设置-->
<div id="dateStock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong>房型库存时间段设置</strong>
                    <span class="form_new_notes form_error_notes" style="right:30px;">
                    </span></span></div>
                <div class="valid_date_price">
                    <table class="input">
                        <tbody>
                        <tr>
                            <td align="right">时间段&nbsp;</td>
                            <td>
                                <div>
                                    <label class="time_limit_unit time_limit_large" for="startDate_1">
                                        <i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})"
                                               name="startDate" id="startDate_1"/>&nbsp;至&nbsp;</label>
                                    <label class="time_limit_unit time_limit_large" for="endDate_1"><i
                                            class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_1\',{d:0});}'})"
                                               name="endDate" id="endDate_1"/></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">星期&nbsp;</td>
                            <td>
                                <div class="idsOfWeek">
                                    <input type="checkbox" name="weeks" value="1" checked/>一&nbsp;
                                    <input type="checkbox" name="weeks" value="2" checked/>二&nbsp;
                                    <input type="checkbox" name="weeks" value="3" checked/>三&nbsp;
                                    <input type="checkbox" name="weeks" value="4" checked/>四&nbsp;
                                    <input type="checkbox" name="weeks" value="5" checked/>五&nbsp;
                                    <input type="checkbox" name="weeks" value="6" checked/>六&nbsp;
                                    <input type="checkbox" name="weeks" value="0" checked/>七
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table width="100%">
                                    <tbody>
                                    <tr>
                                        <td align="right" id="settle-label" style="text-align:right;">
                                            <label for="stockNum_1"><span class="must_be">*</span>日房量&nbsp;</label>
                                        </td>
                                        <td id="settle-input">
                                            <input type="text" class="input_medium" name="stockNum_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')"
                                                   id="stockNum_1"/>&nbsp;
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="dialog_do">
            <input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
            <input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消"/></div>
    </div>
</div>
<!--批量取消-->
<div id="unstock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong>时间段设置</strong></div>
                <div class="valid_date_price">
                    <table class="input">
                        <tbody>
                        <tr>
                            <td align="right">时间段&nbsp;</td>
                            <td>
                                <div>
                                    <label class="time_limit_unit time_limit_large" for="startDate">
                                        <i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'${.now?string('yyyy-MM-dd')}'})"
                                               name="startDate" id="startDate_3"/>&nbsp;至&nbsp;</label>
                                    <label class="time_limit_unit time_limit_large" for="endDate"><i class="i_hour"></i>
                                        <input type="text" class="Wdate"
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_3\',{d:0});}'})"
                                               name="endDate" id="endDate_3"/></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">星期&nbsp;</td>
                            <td>
                                <div class="idsOfWeek">
                                    <input type="checkbox" name="weeks" value="1" checked/>一&nbsp;
                                    <input type="checkbox" name="weeks" value="2" checked/>二&nbsp;
                                    <input type="checkbox" name="weeks" value="3" checked/>三&nbsp;
                                    <input type="checkbox" name="weeks" value="4" checked/>四&nbsp;
                                    <input type="checkbox" name="weeks" value="5" checked/>五&nbsp;
                                    <input type="checkbox" name="weeks" value="6" checked/>六&nbsp;
                                    <input type="checkbox" name="weeks" value="0" checked/>七
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="dialog_do">
            <input type="button" style="margin:2px 5px;" class="btn btn_orange" value="确定"/>
            <input type="button" style="margin:2px 5px;" class="btn btn_gray" value="取消"/></div>
    </div>
</div>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                name: 'required',
                bedSize: {required: true, range: [0.5, 3]},
                floor: 'required',
                area: 'number'
            },
            messages: {
                name: '房型名称不能为空',
                bedSize: jQuery.format("请输入一个介于 {0.5} 和 {3} 之间的值"),
                floor: "楼层信息不能为空",
                area: '请输入正确的面积'
            }
        });
    }();
</script>
<!--日历设置-->
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
            /*str += "<p class='price'>挂:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price'>执:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";*/
            str += "<p class='price'>库:<em>" + (value.stock ? value.stock : '') + "</em></p>";
        }
        return str;
    }
    function tdClickCallBack(o) {
        $("#useDate").val($(o).attr('data-date'));
        $("#showDate").text($(o).attr('data-date'));
        $("#sellPrice").val('');
        $("#suggestPrice").val('');
        $("#stockNum").val('');
        var data = $(o).data('data');
        if (data) {
            $("#suggestPrice").val(data.suggestPrice);
            $("#sellPrice").val(data.sellPrice);
            $("#stockNum").val(data.stock);
        }
    }
</script>
</body>
</html>