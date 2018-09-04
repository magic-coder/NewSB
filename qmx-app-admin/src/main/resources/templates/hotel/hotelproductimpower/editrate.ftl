<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<#--<link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css"/>
<link href="${base}/bak/css/bootstrap.min.css"/>
<link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
<script type="text/javascript" src="${base}/bak/js/jquery.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
<script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
<script type="text/javascript" src="${base}/bak/js/common.js"></script>
<script type="text/javascript" src="${base}/bak/js/input.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_003.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_004.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_006.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_005.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery_002.js"></script>
<script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>-->
    <script type="text/javascript">
        layui.use(['form', 'table', 'laydate', 'jquery'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
            var $ = layui.jquery;
        });
    </script>
</head>
<body>
<form id="rateForm" action="update.jhtml" method="post" autocomplete="off"
      novalidate="novalidate" name="rateForm" class="layui-form">
    <input type="hidden" id="datePriceData" name="datePriceData" value='${distribution}'/>
    <input id="productId" name="productId" type="hidden" value="${dto.productId!}">
    <input id="hid" name="hid" type="hidden" value="${dto.hid!}">
    <input id="id" name="id" type="hidden" value="${dto.id!}">
    <input id="member" name="member" type="hidden" value="${dto.member!}">
    <input id="member" name="groupSupplierId" type="hidden" value="${dto.groupSupplierId!}">
    <input id="member" name="supplierId" type="hidden" value="${dto.supplierId!}">
    <input id="member" name="supplierFlag" type="hidden" value="${dto.supplierFlag!}">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">分销商</label>
            <div class="layui-form-mid">
                <input type="hidden" name="distributor" value="${dto.distributor!}"/>${dto.distributor!}
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">授权产品</label>
            <div class="layui-form-mid">
                <input type="hidden" name="productId" value="${dto.productId!}"/>${dto.productName!}
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-form-text" id="pricedate">
        <label class="layui-form-label">设置授权价格</label>
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
                <span style="color:white;">点击页面下方保存按钮，价格设置才能生效。</span>
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
                <label for="price" class="cap">
                    <span class="must_be">*</span>挂牌价：</label>
                <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice"
                       type="text" name="price">
                <span class="data_unit">元</span></div>
            <div class="data_item">
                <label for="marketPrice" class="cap">
                    <span class="must_be"></span>执行价：</label>
                <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                       id="suggestPrice" type="text" name="marketPrice">
                <span class="data_unit">元</span></div>
            <div class="data_item">
                <label for="stock" class="cap">库存：</label>
                <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')" id="stockNum"
                       type="text" name="stock">
                <span class="data_unit">间</span></div>
            <div class="data_item_do">
                <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray" type="button">
                <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray" type="button">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">状态</label>
        <div class="layui-input-block">
            <input type="radio" name="status" value="normal" title="正常" <#if dto.status=='normal'>checked</#if>/>
            <input type="radio" name="status" value="disable" title="禁用" <#if dto.status=='disable'>checked</#if>/>
            <input type="radio" name="status" value="apply" title="待审核" <#if dto.status=='apply'>checked</#if>/>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
<#--<table class="input" align="center">
&lt;#&ndash; <tr>
     <th>
         分销商:
     </th>
     <td>
         <input type="hidden" name="distributor" value="${dto.distributor!}"/>
     ${dto.distributor!}
     </td>
 </tr>
 <tr>
     <th>
         授权产品:
     </th>
     <td>
         <input type="hidden" name="productId" value="${dto.productId!}"/>
     ${dto.productName!}
     </td>
 </tr>&ndash;&gt;
    <tbody>
    <tr class="needdate ">
        <th>设置授权价格
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
                    <span style="color:white;">点击页面下方保存按钮，价格设置才能生效。</span>
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
                    <label for="price" class="cap">
                        <span class="must_be">*</span>挂牌价：</label>
                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" id="sellPrice"
                           type="text" name="price">
                    <span class="data_unit">元</span></div>
                <div class="data_item">
                    <label for="marketPrice" class="cap">
                        <span class="must_be"></span>执行价：</label>
                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                           id="suggestPrice" type="text" name="marketPrice">
                    <span class="data_unit">元</span></div>
                <div class="data_item">
                    <label for="stock" class="cap">库存：</label>
                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')" id="stockNum"
                           type="text" name="stock">
                    <span class="data_unit">间</span></div>
                <div class="data_item_do">
                    <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray" type="button">
                    <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray" type="button">
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <th><span class="requiredField">*</span>状态：</th>
        <td>
            <label><input type="radio" name="status" value="normal"
                          <#if '${dto.status!}'=='normal'>checked</#if>/>正常</label>
            <label><input type="radio" name="status" value="disable"
                          <#if '${dto.status!}'=='disable'>checked</#if>/>禁用</label>
            <label><input type="radio" name="status" value="apply" <#if '${dto.status!}'=='apply'>checked</#if>/>待审核</label>
        </td>
    </tr>
    </tbody>
</table>-->
<#--<table class="input" align="center">
    <tr>
        <td align="center">
            <input type="submit" class="button" value="提交"/>
            <input type="button" class="button" value="返回" onclick="history.back();"/>
        </td>
    </tr>
</table>-->
</form>
<div id="dateStock" class="allBox">
    <div class="allMask"></div>
    <div class="dialog_box"
         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
        <div class="dialog_close" title="关闭">×</div>
        <div class="dialog_caption"></div>
        <div class="dialog_content" style="overflow: visible; height: auto;">
            <div class="dialog_form_mid">
                <div class="valid_price_caption"><strong>价格时间段设置</strong>
                    <span class="form_new_notes form_error_notes" style="right:30px;">
                    <#--<i class="warn">i</i><span class="error">日授权模式</span>--></span></div>
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
                                        <td align="right" style="text-align:right;"><label for="sellPrice_1"><span
                                                class="must_be">*</span>挂牌价&nbsp;</label></td>
                                        <td><input type="text" class="input_medium" name="sellPrice_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                                   id="sellPrice_1"/>&nbsp;元
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <label for="suggestPrice_1"><span class="must_be">*</span>执行价&nbsp;</label>
                                        </td>
                                        <td><input type="text" class="input_medium" name="suggestPrice_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"
                                                   id="suggestPrice_1"/>&nbsp;元
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" id="settle-label" style="text-align:right;">
                                            <label for="stockNum_1"><span class="must_be">*</span>每日库存&nbsp;</label>
                                        </td>
                                        <td id="settle-input">
                                            <input type="text" class="input_medium" name="stockNum_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')"
                                                   id="stockNum_1"/>
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
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
            str += "<p class='price'>挂:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price'>执:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
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
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
</body>
</html>