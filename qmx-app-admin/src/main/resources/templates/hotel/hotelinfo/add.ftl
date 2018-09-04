<#--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css">
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <link href="${base}/bak/css/bootstrap.min.css"/>
    <link type="text/css" href="${base}/bak/css/jquery-ui-1.9.2.custom.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="${base}/bak/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery-ui-1.9.2.custom.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/bootstrap-paginator.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_003.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_004.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_006.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_005.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery_002.js"></script>
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/input.js"></script>
    <style type="text/css">
        .error {
            color: red;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var $inputForm = $("#inputForm");
            var $selectAll = $("#inputForm .selectAll");
            var $areaId = $("#areaId");

            $("#account1").dropqtable({
                vinputid: "supplierFlag", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "getSpecialSupplierByAdmin", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierFlag").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account1").val(supplier.account);
                    }
                }
            });

            $("#account2").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "getSupplierByAdmin", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account2").val(supplier.account);
                    }
                }
            });

            $("#account3").dropqtable({
                vinputid: "supplierId", //值所存放的区域
                dropwidth: "auto", //下拉层的宽度
                selecteditem: {text: "", value: ""}, //默认值
                editable: false,
                tableoptions: {
                    autoload: true,
                    url: "getSupplierByAdmin", //查询响应的地址
                    qtitletext: "请输入供应商名称", //查询框的默认文字
                    textField: 'trueName',
                    valueField: 'id',
                    colmodel: [
                        // {name: "id", displayname: "员工id", width: "150px"},
                        {name: "account", displayname: "供应商账号", width: "100px"},
                        {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                    ],
                    onSelect: function (supplier) {
                        $("#supplierId").val(supplier.id);
                        $("#username").val(supplier.username);
                        $("#account3").val(supplier.account);
                    }
                }
            });
        });
    </script>
    <script type="text/javascript">
        var indexkucun;
        var indexfangxin;
        var str;
        var strData;
        var roomTypeName;
        <!--添加房型&ndash;&gt;
        $(function () {
            $("#dialog").dialog({
                autoOpen: false,  //设置对话框打开的方式  不是自动打开
                show: "blind",  //打开时的动画效果
                //hide:"explode",  //关闭时的动画效果
                modal: true,       //true遮罩效果  false非遮罩效果
                buttons: {
                    //添加按钮的操作
                    "确定": function () {
                        //var str = typeof indexfangxin;
                        var flag = true;
                        var data = {};
                        roomTypeName = $("#room_name").val();
                        data.roomName = $("#room_name").val();
                        data.floor = $("#floor").val();
                        data.windowType = $("#windowType").val();
                        data.bedType = $('#bedType option:selected') .val();
                        data.bedSize = $("#bedSize").val();
                        data.area = $("#area").val();
                        data.maxOccupancy = $("#maxOccupancy").val();
                        str = JSON.stringify(data);
                        setData();
                        $(this).dialog("close");  //关闭对话框
                    },
                    "取消": function () {
                        $(this).dialog("close");  //关闭对话框
                    }
                },
                draggable: true,  //true表示可以拖动（默认的），false不可以拖动
                //closeOnEscape:false,  //是否采用esc键关闭对话框，false不采用。true采用，为默认的
                title: "添加房型",  //对话框的标题
                position: "center",   //对话框弹出的位置（top  left  right center bottom 默认值是center）
                width: 700,   //对话框的宽度
                height: 400,   //对话框的高度
                resizable: true,  //是否可以改变的操作 true可以改变尺寸，默认值为true
                zIndex: 1,

            });
            //触发连接的事件 当你点击时 连接 打开一个对话
//            $(".dialog_link").click(function () {
//                indexfangxin = 1;
//                $("#dialog").dialog("open");  //open参数  打开对话框
//            });
        });
        <!--添加库存&ndash;&gt;
        $(function () {
            $("#dialog1").dialog({
                autoOpen: false,  //设置对话框打开的方式  不是自动打开
                show: "blind",  //打开时的动画效果
                //hide:"explode",  //关闭时的动画效果
                modal: true,       //true遮罩效果  false非遮罩效果
                buttons: {
                    //添加按钮的操作
                    "确定": function () {
                        strData = $("#datePriceData").val();
                        setStockData();
                        $(this).dialog("close");  //关闭对话框
                    },
                    "取消": function () {
                        $(this).dialog("close");  //关闭对话框
                    }
                },
                draggable: true,  //true表示可以拖动（默认的），false不可以拖动
                //closeOnEscape:false,  //是否采用esc键关闭对话框，false不采用。true采用，为默认的
                title: "添加库存",  //对话框的标题
                position: "center",   //对话框弹出的位置（top  left  right center bottom 默认值是center）
                width: 800,   //对话框的宽度
                height: 400,   //对话框的高度
                resizable: true,  //是否可以改变的操作 true可以改变尺寸，默认值为true
                zIndex: 1,
            });
        });

        function setUp(obj) {
            indexfangxin = 1;
            var tr = obj.parentNode.parentNode;
            indexfangxin = tr.rowIndex;
            $("#dialog").dialog("open");  //open参数  打开对话框
        }
        function setData() {
            $("table#indextest").find("tr:eq(" + indexfangxin + ")").find("input[name='companyType']").val(roomTypeName);
            $("table#indextest").find("tr:eq(" + indexfangxin + ")").find("input[name='roomTypeData']").val(str);
        }
        function setStock(obj) {
            indexkucun = 1;
            var tr = obj.parentNode.parentNode;
            indexkucun = tr.rowIndex;
            $("#dialog1").dialog("open");  //open参数  打开对话框
        }
        function setStockData() {
            $("table#indextest").find("tr:eq(" + indexkucun + ")").find("input[name='roomTypeStock']").val(strData);
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">

    </div>
</div>
<form id="signupForm" action="save.jhtml" method="post" name="signupForm">
    <!--酒店设备&ndash;&gt;
    <input type="hidden" name="hotelFacilities" id="chk_value"/>
    <!--酒店服务&ndash;&gt;
    <input type="hidden" name="hotelService" id="service_value"/>
    <!--房型信息&ndash;&gt;
    <input type="hidden" name="roomType" id="roomType"/>
&lt;#&ndash;库存信息&ndash;&gt;

    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>
                <span class="requiredField">*</span>酒店名称:
            </th>
            <td>
                <input type="text" name="name" class="text" maxlength="20"/>
            </td>

            <th>
                <span class="requiredField"></span>酒店经度:
            </th>
            <td>
                <input type="text" name="longitude" class="text" maxlength="20"/>
                <button class="button">定位</button>
            </td>
        </tr>
    <@shiro.hasRole name="admin">
        <tr>
            <th>
                <span class="requiredField"></span>选择供应商:
            </th>
            <td>
                <input type="hidden" id="supplierFlag" name="supplierFlag"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account1" class="text" name="account"/><span class="tips">选择主供应商</span>
                <br/>
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account2" class="text" name="account"/><span class="tips">选择关联供应商</span>
            </td>
        </tr>
    </@shiro.hasRole>
    <@shiro.hasPermission name="selectSupplier">
        <tr>
            <th>
                <span class="requiredField"></span>选择供应商:
            </th>
            <td>
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account3" class="text" name="account"/><span class="tips">选择关联供应商</span>
            </td>
        </tr>
    </@shiro.hasPermission>
        <tr>
            <th>
                <span class="requiredField">*</span>酒店电话:
            </th>
            <td>
                <input type="text" name="phone" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店纬度:
            </th>
            <td>
                <input type="text" name="latitude" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>传真号:
            </th>
            <td>
                <input type="text" name="faxes" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店城市:
            </th>
            <td>
                <input type="text" name="city" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店地址:
            </th>
            <td>
                <input type="text" name="address" class="text" maxlength="30"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店星级:
            </th>
            <td>
                <!--<input type="text" name="star" class="text" maxlength="20" title="请输入正确的星级"/>&ndash;&gt;
                <select name="star" id="star" class="text">
                    <option value="2">二星级以下/经济</option>
                    <option value="3">三星级/舒适</option>
                    <option value="4">四星级/高档</option>
                    <option value="5">五星级/豪华</option>
                </select>
                <!-- <span style="color: red">(星级范围为：1,1.5,2,2.5,3,3.5,4,4.5,5)</span>&ndash;&gt;
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店楼层:
            </th>
            <td>
                <input type="text" name="floors" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店房间总数:
            </th>
            <td>
                <input type="text" name="rooms" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>房型:
            </th>
            <td>
                <table width="100%" id="indextest">
                    <tbody>
                    <tr class="title">
                        <th>
                            <span class="requiredField">*</span>类型名称
                        </th>
                        <td>
                            操作
                        </td>
                    </tr>
                    <tr id="addRooTypeData" style="display: none">
                        <th>
                            <input name="companyType" class="text" type="text" readonly="readonly">
                            <input name="roomTypeData" class="text" type="hidden"/>
                            <input name="roomTypeStock" class="text" type="hidden"/>
                        </th>
                        <td>
                            <button type="button" class="dialog_link" onclick="setUp(this)">设置</button>
                            <button type="button" class="dialog_link1" onclick="setStock(this)">库存设置</button>
                            <button type="button" onclick="deleteRoomType(this)">-</button>
                            <button type="button" onclick="addRoomType()">+</button>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <input name="companyType" class="text" type="text" readonly="readonly">
                            <input name="roomTypeData" class="text" type="hidden"/>
                            <input name="roomTypeTime" class="text" type="hidden"/>
                        </th>
                        <td>
                            <button type="button" class="dialog_link" onclick="setUp(this)">设置</button>
                            <button type="button" class="dialog_link1" onclick="setStock(this)">库存设置</button>
                            <button type="button" onclick="deleteRoomType(this)">-</button>
                            <button type="button" onclick="addRoomType()">+</button>
                        </td>
                    </tr>
                    <input type="hidden" id="additem"/>
                    </tbody>
                </table>
                <!--房型弹框&ndash;&gt;
                <table id="dialog">
                    <tr>
                        <th>房型名称:</th>
                        <td><input type="text" id="room_name" name="name" class="text" maxlength="20"/></td>
                        <th>楼层:</th>
                        <td><input type="text" id="floor" name="floor" class="text" maxlength="20"
                                   placeholder="如：8或者8-10"/></td>
                    </tr>
                    <tr>
                        <th>窗形:</th>
                        <td>
                            <select name="windowType" id="windowType" class="text">
                                <option value="1">有窗</option>
                                <option value="2">无窗</option>
                            </select>
                        </td>
                        <th>床形:</th>
                        <td><select name="bedType" id="bedType">
                            <option value="单床">单床</option>
                            <option value="双床">双床</option>
                            <option value="多床">多床</option>
                            <option value="圆床">圆床</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th>床宽:</th>
                        <td><input type="text" id="bedSize" name="bedSize" class="text" maxlength="20"/><span
                                class="tips">范围：0.5-3m</span></td>
                        <th>房面积:</th>
                        <td><input type="text" id="area" name="area" class="text" maxlength="20"
                                   placeholder="如：50或者50-70"/></td>
                    </tr>
                    <tr id="">
                        <th>最大入住:</th>
                        <td><input type="text" id="maxOccupancy" name="maxOccupancy" class="text" maxlength="30"/></td>
                    </tr>
                </table>
                <!--库存弹框&ndash;&gt;
                <table id="dialog1">
                    <tr>

                        <td>
                            <div class="choose_date_month">
                                <input id="datePriceData" name="datePriceData" type="hidden">
                                <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}"
                                     date="${.now?string("yyyy-MM")}-01"
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
                                    <span style="color:white;">点击页面下方保存按钮，日房量设置才能生效。</span>
                                    <input id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray"
                                           type="button">
                                </div>
                            </div>
                            <div id="calender-right" class="module_calendar_data" style="display: none;">
                                <div class="data_item">
                                    <label class="cap" for="date">
                                        日期：</label><span id="showDate"></span>
                                    <input id="useDate" type="hidden" name="date">
                                </div>
                                <div class="data_item">
                                    <label for="stock" class="cap">库存：</label>
                                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')"
                                           id="stockNum"
                                           type="text" name="stock">
                                    <span class="data_unit">间</span></div>
                                <div class="data_item_do">
                                    <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"
                                           type="button">
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            &lt;#&ndash;批量设置&ndash;&gt;
                <div id="dateStock" class="allBox">
                    <div class="allMask"></div>
                    <div class="dialog_box"
                         style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
                        <div class="dialog_close" title="关闭">×</div>
                        <div class="dialog_caption"></div>
                        <div class="dialog_content" style="overflow: visible; height: auto;">
                            <div class="dialog_form_mid">
                                <div class="valid_price_caption"><strong>日房量时间段设置</strong>
                                    <span class="form_new_notes form_error_notes" style="right:30px;">
                                    &lt;#&ndash;<i class="warn">i</i><span class="error">日授权模式&ndash;&gt;</span></span></div>
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
                                                            <label for="stockNum_1"><span class="must_be">*</span>每日库存&nbsp;</label>
                                                        </td>
                                                        <td id="settle-input">
                                                            <input type="text" class="input_medium"
                                                                   name="stockNum_1"
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
            &lt;#&ndash;批量设置结束&ndash;&gt;
            </td>
        </tr>
        <tr>
            <th>
                酒店设施:
            </th>
            <td>
            <#list facilitiesList as info>
                <label><input type="checkbox" name="specialService" value="${info}"/>${info}</label>
            </#list>
            </td>
        </tr>
        <tr>
            <th>
                酒店服务:
            </th>
            <td>
            <#list serviceList as info>
                <label><input type="checkbox" name="servicesItem" value="${info}"/>${info}</label>
            </#list>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店介绍:
            </th>
            <td>
                <textarea class="text" name="introduce"></textarea>
            </td>
        </tr>

        <tr>
            <td style="text-align: right; padding-right: 10px;">
                <strong>图片列表:</strong>
            </td>
            <td>
                <table id="listTable">
                    <tr id="addtr" style="display: none">
                        <th>
                            <span class="requiredField">*</span>图片:
                        </th>
                        <td><input type="hidden" name="img_id"/>

                            <input type="text" name="img_url" class="text" maxlength="20"/>
                        </td>
                        <th>
                            <span class="requiredField"></span>图片属性:
                        </th>
                        <td>
                            <select name="img_attribute">
                                <option value="">请选择</option>
                            <#list attributes as attribute>
                                <option value="${attribute}">${attribute.type}</option>
                            </#list>
                            </select>
                        </td>
                        <th>
                            <span class="requiredField"></span>图片类型:
                        </th>
                        <td>
                            <select name="img_type">
                                <option value="">请选择</option>
                            <#list types as type>
                                <option value="${type}">${type.type}</option>
                            </#list>
                            </select>
                            <input type="checkbox" name="delete"/>
                        </td>
                    </tr>

                    <tr>
                        <th>
                            <span class="requiredField">*</span>图片:
                        </th>
                        <td>
                            <input type="hidden" name="img_id"/>
                            <input type="text" name="img_url" class="text" maxlength="20"/>
                        </td>
                        <th>
                            <span class="requiredField"></span>图片属性:
                        </th>
                        <td>
                            <select name="img_attribute">
                                <option value="">请选择</option>
                            <#list attributes as attribute>
                                <option value="${attribute}">${attribute.type}</option>
                            </#list>
                            </select>
                        </td>
                        <th>
                            <span class="requiredField"></span>图片类型:
                        </th>
                        <td>
                            <select name="img_type">
                                <option value="">请选择</option>
                            <#list types as type>
                                <option value="${type}">${type.type}</option>
                            </#list>
                            </select>
                            <input type="checkbox" name="delete"/>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <td colspan="4" align="center">
                <input type="submit" id="btn" class="button" value="提交" onclick="getHotelFacilities()"/>
                <input type="button" class="button" value="添加" onclick="appendText()"/>
                <input type="button" class="button" value="删除" onclick="deleteText()"/>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
<table id="tableData" width="500px">
</table>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //添加房型
    function addRoomType() {
        $("#addRooTypeData").html();
        $("#addRooTypeData").after("<tr>" + $("#addRooTypeData").html() + "</tr>");
    }
    //删除房型
    function deleteRoomType(obj) {
        $(obj).parent().parent().remove();
    }
    //添加
    function appendText() {
        $("#addtr").html();
        $("#addtr").after("<tr>" + $("#addtr").html() + "</tr>");
    }
    //删除
    function deleteText() {
        $("input[name='delete']:checked").each(function () { // 遍历选中的checkbox
            n = $(this).parent().parent().index();  // 获取checkbox所在行的顺序
            $("table#listTable").find("tr:eq(" + n + ")").remove();
        })
    }
    //获取酒店设施
    function getHotelFacilities() {
        var chk_value = [];
        var service_value = [];
        //酒店基本设施
        $('input[name="specialService"]:checked').each(function () {
            chk_value.push($(this).val())
        });
        //酒店服务
        $('input[name="servicesItem"]:checked').each(function () {
            service_value.push($(this).val());
        });
        $("#chk_value").val(JSON.stringify(chk_value));
        $("#service_value").val(JSON.stringify(service_value));
    }
    //
    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                name: {
                    required: true
                },
                star: {
                    max: 5
                },
                phone: {
                    required: true
                },
                faxes: {
                    required: true
                }
            },
            messages: {
                name: {
                    required: '酒店名称必填！'
                },
                star: {
                    required: ''
                },
                phone: {
                    required: '电话不能为空!'
                },
                faxes: {
                    required: '传真号不能为空!'
                }
            }
        });
    }();


    //注册表单验证

</script>

<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
&lt;#&ndash;日历设置&ndash;&gt;
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
</html>-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <link href="${base}/bak/js/dropdown/dropdown.css" rel="stylesheet" type="text/css">
    <link href="${base}/bak/css/product.css" rel="stylesheet" type="text/css">
    <link href="${base}/bak/js/datePicker/skin/WdatePicker.css"/>
    <link type="text/css" href="${base}/bak/css/jquery-ui-1.9.2.custom.min.css" rel="stylesheet"/>
<#--<script type="text/javascript" src="${base}/bak/js/jquery.js"></script>-->
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
<#--<script type="text/javascript" src="${base}/bak/js/jquery.tools.js"></script>-->
    <script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/jquery-ui-1.9.2.custom.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/bak/js/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
<#--<script type="text/javascript" src="${base}/resources/common/js/jquery-migrate-1.2.1.js"></script>-->

</head>
<body>
<form class="layui-form" action="save" method="post">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">酒店名称</label>
            <div class="layui-input-inline">
                <input name="name" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">酒店经度</label>
            <div class="layui-input-inline">
                <input name="carBrand" lay-verify="required" autocomplete="off" class="layui-input">
            </div>
            <button class="layui-btn">定位</button>
        </div>
    </div>
<@shiro.hasRole name="admin">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierFlag" name="supplierFlag"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account1" class="layui-input" name="account"/><span class="tips">选择主供应商</span>
                <br/>
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account2" class="layui-input" name="account"/><span class="tips">选择关联供应商</span>
            </div>
        </div>
    </div>
</@shiro.hasRole>
<@shiro.hasPermission name="selectSupplier">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">选择供应商</label>
            <div class="layui-input-inline">
                <input type="hidden" id="supplierId" name="supplierId"/>
                <input type="hidden" id="username" class="text" name="username"/>
                <input type="text" id="account3" class="layui-input" name="account"/><span class="tips">选择关联供应商</span>
            </div>
        </div>
    </div>
</@shiro.hasPermission>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">酒店电话</label>
            <div class="layui-input-inline">
                <input id="phone" name="phone" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">酒店纬度</label>
            <div class="layui-input-inline">
                <input id="latitude" name="latitude" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">传真号</label>
            <div class="layui-input-inline">
                <input id="faxes" name="faxes" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">酒店城市</label>
            <div class="layui-input-inline">
                <input id="city" name="city" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">酒店地址</label>
            <div class="layui-input-inline">
                <input id="address" name="address" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">酒店星级</label>
            <div class="layui-input-inline">
                <select name="star" id="star" class="layui-input">
                    <option value="2">二星级以下/经济</option>
                    <option value="3">三星级/舒适</option>
                    <option value="4">四星级/高档</option>
                    <option value="5">五星级/豪华</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">酒店楼层</label>
            <div class="layui-input-inline">
                <input id="floors" name="floors" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">酒店房间总数</label>
            <div class="layui-input-inline">
                <input id="rooms" name="rooms" autocomplete="off" class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">房型</label>
            <div class="layui-input-inline">
                <table id="indextest" class="layui-table" style="width: 500px;">
                    <tr>
                        <td width="100">
                            类型名称
                        </td>
                        <td width="100">
                            操作
                        </td>
                    </tr>
                    <tr id="addRooTypeData" style="display: none">
                        <th>
                            <input name="companyType" class="layui-input" type="text" readonly="readonly">
                            <input name="roomTypeData" class="text" type="hidden"/>
                            <input name="roomTypeStock" class="text" type="hidden"/>
                        </th>
                        <td>
                            <button type="button" class="dialog_link" onclick="setUp(this)">设置</button>
                            <button type="button" class="dialog_link1" onclick="setStock(this)">库存设置</button>
                            <button type="button" onclick="deleteRoomType(this)">-</button>
                            <button type="button" onclick="addRoomType()">+</button>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <input name="companyType" class="layui-input" type="text" readonly="readonly">
                            <input name="roomTypeData" class="text" type="hidden"/>
                            <input name="roomTypeTime" class="text" type="hidden"/>
                        </th>
                        <td>
                            <button type="button" class="dialog_link" onclick="setUp(this)">设置</button>
                            <button type="button" class="dialog_link1" onclick="setStock(this)">库存设置</button>
                            <button type="button" onclick="deleteRoomType(this)">-</button>
                            <button type="button" onclick="addRoomType()">+</button>
                        </td>
                    </tr>
                    <input type="hidden" id="additem"/>
                </table>
                <table id="dialog" class="layui-table">
                    <tr>
                        <th>房型名称:</th>
                        <td><input type="text" id="room_name" name="name" class="layui-input" maxlength="20"/></td>
                        <th>楼层:</th>
                        <td><input type="text" id="floor" name="floor" class="layui-input" maxlength="20"
                                   placeholder="如：8或者8-10"/></td>
                    </tr>
                    <tr>
                        <th>窗形:</th>
                        <td>
                            <div class="layui-form-item">
                                <div class="layui-input-inline">
                                    <select name="windowType" id="windowType" class="layui-input">
                                        <option value="1">有窗</option>
                                        <option value="2">无窗</option>
                                    </select>
                                </div>
                            </div>
                        </td>
                        <th>床形:</th>
                        <td>
                            <div class="layui-form-item">
                                <div class="layui-input-inline">
                                    <select name="bedType" id="bedType" class="layui-input">
                                        <option value="单床">单床</option>
                                        <option value="双床">双床</option>
                                        <option value="多床">多床</option>
                                        <option value="圆床">圆床</option>
                                    </select>
                                </div>
                            </div>

                        </td>
                    </tr>
                    <tr>
                        <th>床宽:</th>
                        <td><input type="text" id="bedSize" name="bedSize" class="layui-input" maxlength="20"/><span
                                class="tips">范围：0.5-3m</span></td>
                        <th>房面积:</th>
                        <td><input type="text" id="area" name="area" class="layui-input" maxlength="20"
                                   placeholder="如：50或者50-70"/></td>
                    </tr>
                    <tr id="">
                        <th>最大入住:</th>
                        <td><input type="text" id="maxOccupancy" name="maxOccupancy" class="layui-input"
                                   maxlength="30"/></td>
                    </tr>
                </table>
                <table id="dialog1">
                    <tr>

                        <td>
                            <div class="choose_date_month">
                                <input id="datePriceData" name="datePriceData" type="hidden">
                                <div id="calendarcontainer" ndate="${.now?string("yyyy-MM-dd")}"
                                     date="${.now?string("yyyy-MM")}-01"
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
                                    <span style="color:white;">点击页面下方保存按钮，日房量设置才能生效。</span>
                                    <input id="batchset" hidefocus="true" value="批量设置" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="batchunset" hidefocus="true" value="批量取消" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="clearall" hidefocus="true" value="全部取消" class="do_btn do_btn_gray"
                                           type="button">
                                </div>
                            </div>
                            <div id="calender-right" class="module_calendar_data" style="display: none;">
                                <div class="data_item">
                                    <label class="cap" for="date">
                                        日期：</label><span id="showDate"></span>
                                    <input id="useDate" type="hidden" name="date">
                                </div>
                                <div class="data_item">
                                    <label for="stock" class="cap">库存：</label>
                                    <input class="input_small" onkeyup="this.value=this.value.replace(/[^\d]/g,'-1')"
                                           id="stockNum"
                                           type="text" name="stock">
                                    <span class="data_unit">间</span></div>
                                <div class="data_item_do">
                                    <input id="pricesave" hidefocus="true" value="保存" class="do_btn do_btn_gray"
                                           type="button">
                                    <input id="pricecancel" hidefocus="true" value="取消" class="do_btn do_btn_gray"
                                           type="button">
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div class="layui-inline">
        <label class="layui-form-label">酒店设施</label>
        <div class="layui-input-block">
        <#list facilitiesList as info>
            <input type="checkbox" name="hotelFacilities" lay-skin="primary" value="${info}"
                   title="${info}"/>
        </#list>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">酒店服务</label>
        <div class="layui-input-block">
        <#list serviceList as info>
            <input type="checkbox" name="hotelService" value="${info}" title="${info}" lay-skin="primary"/>
        </#list>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">酒店介绍</label>
        <div class="layui-input-block">
            <textarea class="layui-textarea" name="introduce" placeholder="请输入内容"
                      style="width: 350px;height: 120px;"></textarea>
        </div>
    </div>
<#--<div class="layui-inline">
    <label class="layui-form-label">图片列表</label>
    <div class="layui-input-block">
        <textarea class="layui-textarea" name="introduce" placeholder="请输入内容"
                  style="width: 350px;height: 120px;"></textarea>
    </div>
</div>-->
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
    <div id="dateStock" class="allBox">
        <div class="allMask"></div>
        <div class="dialog_box"
             style="display: block; position: fixed; left: 50%; top: 30%; margin-left:-255px; margin-top:-122.5px;">
            <div class="dialog_close" title="关闭">×</div>
            <div class="dialog_caption"></div>
            <div class="dialog_content" style="overflow: visible; height: auto;">
                <div class="dialog_form_mid">
                    <div class="valid_price_caption"><strong>日房量时间段设置</strong>
                        <span class="form_new_notes form_error_notes" style="right:30px;">
                                    &lt;#&ndash;<i class="warn">i</i><span class="error">日授权模式&ndash;&gt;</span></span>
                    </div>
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
                                                <label for="stockNum_1"><span class="must_be">*</span>每日库存&nbsp;</label>
                                            </td>
                                            <td id="settle-input">
                                                <input type="text" class="input_medium"
                                                       name="stockNum_1"
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
    </td>
    </tr>
</form>
</body>
<link href="${base}/resources/admin/css/product.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="${base}/bak/js/calendarprice2.js"></script>
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

        upload.render({
            elem: '#travelCardBtn',
            url: '${base}/file/upload?fileType=image&token=' + getCookie("token"),
            done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                //上传成功
                $("#travelCard").val(res.data);
            },
            error: function () {
                //请求异常回调
                alert("异常!!!");
            }
        });

        $("#account1").dropqtable({
            vinputid: "supplierFlag", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "", value: ""}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getSpecialSupplierByAdmin", //查询响应的地址
                qtitletext: "请输入供应商名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    // {name: "id", displayname: "员工id", width: "150px"},
                    {name: "account", displayname: "供应商账号", width: "100px"},
                    {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (supplier) {
                    $("#supplierFlag").val(supplier.id);
                    $("#username").val(supplier.username);
                    $("#account1").val(supplier.account);
                }
            }
        });


        $("#account2").dropqtable({
            vinputid: "supplierId", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "", value: ""}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getSupplierByAdmin", //查询响应的地址
                qtitletext: "请输入供应商名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    // {name: "id", displayname: "员工id", width: "150px"},
                    {name: "account", displayname: "供应商账号", width: "100px"},
                    {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (supplier) {
                    $("#supplierId").val(supplier.id);
                    $("#username").val(supplier.username);
                    $("#account2").val(supplier.account);
                }
            }
        });

        $("#account3").dropqtable({
            vinputid: "supplierId", //值所存放的区域
            dropwidth: "auto", //下拉层的宽度
            selecteditem: {text: "", value: ""}, //默认值
            editable: false,
            tableoptions: {
                autoload: true,
                url: "getSupplierByAdmin", //查询响应的地址
                qtitletext: "请输入供应商名称", //查询框的默认文字
                textField: 'trueName',
                valueField: 'id',
                colmodel: [
                    // {name: "id", displayname: "员工id", width: "150px"},
                    {name: "account", displayname: "供应商账号", width: "100px"},
                    {name: "username", displayname: "供应商名称", width: "100px"}//表格定义
                ],
                onSelect: function (supplier) {
                    $("#supplierId").val(supplier.id);
                    $("#username").val(supplier.username);
                    $("#account3").val(supplier.account);
                }
            }
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
<script type="text/javascript">
    var indexkucun;
    var indexfangxin;
    var str;
    var strData;
    var roomTypeName;
    //添加房型
    $(function () {
        $("#dialog").dialog({
            autoOpen: false,  //设置对话框打开的方式  不是自动打开
            show: "blind",  //打开时的动画效果
            //hide:"explode",  //关闭时的动画效果
            modal: true,       //true遮罩效果  false非遮罩效果
            buttons: {
                //添加按钮的操作
                "确定": function () {
                    //var str = typeof indexfangxin;
                    var flag = true;
                    var data = {};
                    roomTypeName = $("#room_name").val();
                    data.roomName = $("#room_name").val();
                    data.floor = $("#floor").val();
                    data.windowType = $("#windowType").val();
                    data.bedType = $('#bedType option:selected').val();
                    data.bedSize = $("#bedSize").val();
                    data.area = $("#area").val();
                    data.maxOccupancy = $("#maxOccupancy").val();
                    str = JSON.stringify(data);
                    setData();
                    $(this).dialog("close");  //关闭对话框
                },
                "取消": function () {
                    $(this).dialog("close");  //关闭对话框
                }
            },
            draggable: true,  //true表示可以拖动（默认的），false不可以拖动
            //closeOnEscape:false,  //是否采用esc键关闭对话框，false不采用。true采用，为默认的
            title: "添加房型",  //对话框的标题
            position: "center",   //对话框弹出的位置（top  left  right center bottom 默认值是center）
            width: 700,   //对话框的宽度
            height: 400,   //对话框的高度
            resizable: true,  //是否可以改变的操作 true可以改变尺寸，默认值为true
            zIndex: 1,

        });
        //触发连接的事件 当你点击时 连接 打开一个对话
//            $(".dialog_link").click(function () {
//                indexfangxin = 1;
//                $("#dialog").dialog("open");  //open参数  打开对话框
//            });
    });

    //添加库存
    $(function () {
        $("#dialog1").dialog({
            autoOpen: false,  //设置对话框打开的方式  不是自动打开
            show: "blind",  //打开时的动画效果
            //hide:"explode",  //关闭时的动画效果
            modal: true,       //true遮罩效果  false非遮罩效果
            buttons: {
                //添加按钮的操作
                "确定": function () {
                    strData = $("#datePriceData").val();
                    setStockData();
                    $(this).dialog("close");  //关闭对话框
                },
                "取消": function () {
                    $(this).dialog("close");  //关闭对话框
                }
            },
            draggable: true,  //true表示可以拖动（默认的），false不可以拖动
            //closeOnEscape:false,  //是否采用esc键关闭对话框，false不采用。true采用，为默认的
            title: "添加库存",  //对话框的标题
            position: "center",   //对话框弹出的位置（top  left  right center bottom 默认值是center）
            width: 800,   //对话框的宽度
            height: 400,   //对话框的高度
            resizable: true,  //是否可以改变的操作 true可以改变尺寸，默认值为true
            zIndex: 1,
        });
    });

    function setUp(obj) {
        indexfangxin = 1;
        var tr = obj.parentNode.parentNode;
        indexfangxin = tr.rowIndex;
        $("#dialog").dialog("open");  //open参数  打开对话框
    }
    function setData() {
        $("table#indextest").find("tr:eq(" + indexfangxin + ")").find("input[name='companyType']").val(roomTypeName);
        $("table#indextest").find("tr:eq(" + indexfangxin + ")").find("input[name='roomTypeData']").val(str);
    }
    function setStock(obj) {
        indexkucun = 1;
        var tr = obj.parentNode.parentNode;
        indexkucun = tr.rowIndex;
        $("#dialog1").dialog("open");  //open参数  打开对话框
    }
    function setStockData() {
        $("table#indextest").find("tr:eq(" + indexkucun + ")").find("input[name='roomTypeStock']").val(strData);
    }
</script>
<script type="text/javascript">
    function tdFillCallBack(td) {
        var value = $(td).data('data');
        var str = '';
        if (value) {
            str += "<p class='price'>售:￥<em>" + (value.sellPrice ? value.sellPrice : '') + "</em></p>";
            str += "<p class='price'>日:<em>" + (value.suggestPrice ? value.suggestPrice : '') + "</em></p>";
            /*str += "<p class='price'>总:<em>" + (value.stock ? value.stock : '') + "</em></p>";*/
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
<script type="text/javascript">
    //添加房型
    function addRoomType() {
        $("#addRooTypeData").html();
        $("#addRooTypeData").after("<tr>" + $("#addRooTypeData").html() + "</tr>");
    }
    //删除房型
    function deleteRoomType(obj) {
        $(obj).parent().parent().remove();
    }
    //添加
    function appendText() {
        $("#addtr").html();
        $("#addtr").after("<tr>" + $("#addtr").html() + "</tr>");
    }
    //删除
    function deleteText() {
        $("input[name='delete']:checked").each(function () { // 遍历选中的checkbox
            n = $(this).parent().parent().index();  // 获取checkbox所在行的顺序
            $("table#listTable").find("tr:eq(" + n + ")").remove();
        })
    }
    //获取酒店设施
    function getHotelFacilities() {
        var chk_value = [];
        var service_value = [];
        //酒店基本设施
        $('input[name="specialService"]:checked').each(function () {
            chk_value.push($(this).val())
        });
        //酒店服务
        $('input[name="servicesItem"]:checked').each(function () {
            service_value.push($(this).val());
        });
        $("#chk_value").val(JSON.stringify(chk_value));
        $("#service_value").val(JSON.stringify(service_value));
    }
</script>
</html>
