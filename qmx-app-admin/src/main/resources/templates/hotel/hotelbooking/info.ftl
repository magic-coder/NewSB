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
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>

</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
    </div>
</div>

<input type="hidden" id="datePriceData" name="datePriceData" value='${distribution}'/>
<form id="signupForm" action="update.jhtml" method="post">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>

        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <td>
                <input type="hidden" name="id" class="text" maxlength="20" value="${dto.id!}"/>
            </td>
            <td>
                <input type="hidden" name="hid" class="text" maxlength="20" value="${dto.hid!}"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>房型名称:
            </th>
            <td>
            <#--<input type="text" name="name" class="text" maxlength="20" value="${dto.name!}" disabled="disabled"/>-->
           ${dto.name!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>状态:
            </th>
            <td>
            <#-- <select name="status">
                 <option value="">请选择状态</option>
             <#if '${dto.status!}'=='上架'>
                 <option value="上架" selected="selected">上架</option>
                 <option value="下架">下架</option>
             <#elseif '${dto.status!}'=='下架'>
                 <option value="上架">上架</option>
                 <option value="下架" selected="selected">下架</option>
             <#else>
                 <option value="上架">上架</option>
                 <option value="下架">下架</option>
             </#if>
             </select>-->
                ${dto.status!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>加床:
            </th>
            <td>
            <#-- <#if '${dto.rollawayBed}'=='0'>
                 <input type="radio" name="rollawayBed" value="1"/>能
                 <input type="radio" name="rollawayBed" value="0" checked="checked"/>不能
             <#elseif '${dto.rollawayBed}'=='1'>
                 <input type="radio" name="rollawayBed" value="1" checked="checked"/>能
                 <input type="radio" name="rollawayBed" value="0"/>不能
             <#else >
                 <input type="radio" name="rollawayBed" value="1"/>能
                 <input type="radio" name="rollawayBed" value="0"/>不能
             </#if>-->
            <#if '${dto.rollawayBed!}'=='1'>能加床<#else >不能加床</#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>房间设施:
            </th>
            <td>
            <#--<textarea name="roomFacilities" class="text">${dto.roomFacilities!}</textarea>-->
            <#--${dto.roomFacilities!}-->
                便利设施:
            <#list bianliList as info>
            ${info!},
            </#list>
                <br/>
                媒体科技:<#list meitiList as info>
            ${info!},
            </#list>
                <br/>
                食品和饮品:<#list foodList as info>
            ${info!},
            </#list>
                <br/>
                浴室:<#list yushiList as info>
            ${info!},
            </#list>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>预订须知:
            </th>
            <td>
            <#--<textarea name="bookingNotice" class="text" style="height: 60px;">${dto.bookingNotice!}</textarea>-->
                ${dto.bookingNotice!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>描述:
            </th>
            <td>
            <#--<textarea name="description" class="text">${dto.description!}</textarea>-->
                ${dto.description!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>服务:
            </th>
            <td>
            <#--<textarea name="service" class="text" style="height: 30px;">${dto.service!}</textarea>-->
            <#--${dto.service!}-->
            <#--<#if serversList??>-->
                <#list serviceList as info>
            ${info!}
            </#list>
            <#--</#if>-->
            </td>
        </tr>
    </table>
</form>
<table class="input">
    <tr class="needdate">
        <th>
        </th>
        <td>
            <div class="choose_date_month">
                <div id="calendarcontainer" ndate="${.now?string('yyyy-MM-dd')}" date="${.now?string('yyyy-MM')}-01"
                     month="${.now?string('MM')}">
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
                    <div class="date" id="date"></div>
                </div>
                <div class="module_calendar_do">

                </div>
            </div>
        </td>
    </tr>
    <tr>
        <th>
            &nbsp;
        </th>
        <td>
            <input type="button" class="button" value="返&nbsp;&nbsp;回" onclick="history.back()"/>
        </td>
    </tr>
</table>
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        var str = '';
        if (value) {
            // alert(value.type);
            var type = value.type;
            if (type == '1') {
                str += "<p class='price'>挂:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
                str += "<p class='price'>执:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
                str += "<p class='price'>库:<em>" + (value.stock ? value.stock : '') + "</em></p>";
            }
            if (type == '2') {
                str += "<p class='price'>结:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
                str += "<p class='price'>建:￥<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
//                str += "<p class='price'>库:<em>" + (value.stock ? value.stock : '') + "</em></p>";
            }

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