<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
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
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>
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
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form id="signupForm" action="saveOrUpdateOccupy.jhtml" method="get">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <td>
                <input type="hidden" name="rid" value="${rid!}" id="rid"/>
                <input type="hidden" name="hid" value="${hid!}"/>
                <input type="hidden" id="datePriceData" name="datePriceData" value='${distribution!}'
                       style="width: 1000px;"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>房型名称:
            </th>
            <td>
            ${name!}
            </td>
        </tr>
    </table>
    <table class="input" align="center" id="rateTable">
        <tbody>
        <tr class="needdate ">
            <th>设置房型占用
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
                        <div class="date" id="date" onclick="getStock()">

                        </div>
                    </div>
                    <div class="module_calendar_do">
                        <span style="color:white;">点击页面下方保存按钮，占用设置才能生效。</span>
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
                        <label for="stock" class="cap">房型总数：</label>
                        <span class="data_unit" id="roomStock"></span></div>
                    <div class="data_item">
                        <label for="stock" class="cap">占用库存：</label>
                        <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')"
                               id="stockNum"
                               type="text" name="stock" value="0">
                        <span class="data_unit">间</span></div>
                    <div class="data_item">
                        <label for="price" class="cap">
                            <span class="must_be">*</span>占用类型：</label>
                        <select name="price" id="sellPrice" class="input_small">
                            <option value="">请选择</option>
                        <#list data as info>
                            <option value="${info!}">${info.type!}</option>
                        </#list>
                        </select>
                    </div>
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
    </table>
    <table class="input" align="center">
        <tr>
            <td align="center">
                <input type="submit" id="btn" class="button" value="提交"/>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
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
                <div class="valid_price_caption"><strong>占用时间段设置</strong>
                    <span class="form_new_notes form_error_notes" style="right:30px;"></span></div>
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
                                               onfocus="WdatePicker({readOnly:true,minDate:'#F{$dp.$D(\'startDate_1\',{d:0});}',onpicked:changeDays})"
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
                                            <label for="stockNum_1"><span
                                                    class="must_be">*</span>该时间段每日有效库存&nbsp;</label>
                                        </td>
                                        <td id="minStock"></td>
                                    </tr>
                                    <tr>
                                        <td align="right" id="settle-label" style="text-align:right;">
                                            <label for="stockNum_1"><span class="must_be">*</span>每日占用库存&nbsp;</label>
                                        </td>
                                        <td id="settle-input">
                                            <input type="text" class="input_medium" name="stockNum_1"
                                                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'-1')"
                                                   id="stockNum_1"/>&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="text-align:right;"><label for="sellPrice_1"><span
                                                class="must_be">*</span>占用类型&nbsp;</label></td>
                                        <td>
                                            <select name="sellPrice_1" id="sellPrice_1" class="input_small">
                                                <option value="">请选择</option>
                                            <#list data as info>
                                                <option value="${info!}">${info.type!}</option>
                                            </#list>
                                            </select>
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
<script type="text/javascript" src="${base}/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    /*  var Script = function () {
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
      }();*/
</script>
<!--日历设置-->
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
            str += "<p class='price'>占:<em>" + (value.stock ? value.stock : '') + "</em></p>";
            /*str += "<p class='price'>类:<em>" + (value.occupyType ? value.occupyType : '') + "</em></p>";*/
            str += "<p class='price'>类:<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
        }
        return str;
    }
    function tdClickCallBack(o) {
        $("#useDate").val($(o).attr('data-date'));
        $("#showDate").text($(o).attr('data-date'));
        $("#sellPrice").val('');
        /* $("#occupyType").val('');*/
        $("#stockNum").val('');
        var data = $(o).data('data');
        if (data) {
            /*$("#occupyType").val(data.occupyType);*/
            $("#stockNum").val(data.stock);
            $("#sellPrice").val(data.sellPrice);
        }
    }
</script>
<script type="text/javascript">
    function getStock() {
        var riqi = $("#useDate").val();
        var roomId = $("#rid").val();
        $.ajax({
            type: 'GET',
            url: '/hotelRoomType/getStock',
            dataType: 'json',
            data: {'roomId': roomId, 'startTime': riqi, 'endTime': riqi},
            success: function (data) {
                var stock1 = data.stock;
                if (stock1 == null) {
                    $("#roomStock").html("未设置库存");
                    $("#stockNum").val(0);
                    $("#stockNum").attr("disabled", true);
                    $("#sellPrice").attr("disabled", true);
                } else {
                    $("#roomStock").html(stock1 + '间');
                    $("#stockNum").attr("disabled", false);
                    $("#sellPrice").attr("disabled", false);
                }

            }
        })
    }
    function changeDays() {
        var startTime = $("#startDate_1").val();
        var endTime = $("#endDate_1").val();
        var roomId = $("#rid").val();
        $.ajax({
            type: 'GET',
            url: '/hotelRoomType/getStock',
            dataType: 'json',
            data: {'roomId': roomId, 'startTime': startTime, 'endTime': endTime},
            success: function (data) {
                var stock1 = data.stock;
                if (stock1 == null) {
                    $("#minStock").html(0);
                } else {
                    $("#minStock").html(stock1);
                }
            }
        })
    }
</script>
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
</body>
</html>