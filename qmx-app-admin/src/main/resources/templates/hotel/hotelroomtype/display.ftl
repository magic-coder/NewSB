<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
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
    <script type="text/javascript" src="${base}/bak/js/input.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
    <style type="text/css">
        .error {
            color: Red;
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
    </div>
</div>
<form action="update.jhtml" method="post" id="rateForm" method="post" autocomplete="off"
      novalidate="novalidate" name="rateForm">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>

        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <td>
                <input type="hidden" id="datePriceData" name="datePriceData" value='${distribution}'/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>房型名称:
            </th>
            <td>
            ${dto.name!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>楼层:
            </th>
            <td>
            ${dto.floor!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>床型:
            </th>
            <td>
            <#if '${dto.bedType!}'=='单床'>单床
            <#elseif '${dto.bedType!}'=='双床'>双床
            <#elseif '${dto.bedType!}'=='多床'>多床
            <#elseif '${dto.bedType!}'=='圆床'>圆床
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>床宽:
            </th>
            <td>
            ${dto.bedSize!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>房间面积:
            </th>
            <td>
            ${dto.area!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>最大入住人数:
            </th>
            <td>
            ${dto.maxOccupancy!}
            </td>
        </tr>
    </table>
    <table class="input" align="center" id="rateTable">
        <tbody>
        <tr class="needdate ">
            <th>房型库存
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
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    var Script = function () {
        $("#rateForm").validate({
            rules: {
                name: 'required',
                bedSize: {required: true, range: [0.5, 3]},
                /*bedSize: 'number',*/
                /* floor: 'number',*/
                area: 'required'
            },
            messages: {
                name: '房型名称不能为空',
                bedSize: jQuery.format("请输入一个介于 {0.5} 和 {3} 之间的值"),
                /*bedSize: '请输入正确的床宽',*/
                /*floor: "请输入正确的楼层",*/
                area: '请输入正确的面积'
            }
        });
    }();
</script>
<!--日历设置-->
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        //td.attr('marketPrice',value.marketPrice).attr('stockNum',value.quantity).attr('sellPrice',value.sellPrice).attr('childPrice',value.childPrice).attr('oldPrice',value.oldPrice).attr('distPrice',value.distPrice).attr('minBuyNum',value.minimum).attr('maxBuyNum',value.maximum);
        var str = '';
        if (value) {
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
            //$("#outSettlePrice").val("xx");
            $("#stockNum").val(data.stock);
        }
    }
</script>
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
</body>
</html>