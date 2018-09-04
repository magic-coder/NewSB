<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>列表</title>
<#include "/include/common_header_include.ftl">
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
    <legend>预订</legend>
</fieldset>
<form action="add" method="post" id="signupForm" class="layui-form">
    <!--入住时间-->
    <input type="hidden" id="sTime" name="sTime" value=""/>
    <!--离店时间-->
    <input type="hidden" id="eTime" name="eTime" value=""/>
    <!--酒店id-->
    <input type="hidden" name="hid" id="hid" value=""/>
    <!--产品id-->
    <input type="hidden" name="id" id="id" value=""/>
    <!--库存量-->
    <input type="hidden" name="stock" id="stock" value=""/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">预订时间</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="sT" id="sT" placeholder="订房时间起"/>
            </div>
            <div class="layui-input-inline">
                <input class="layui-input" name="eT" id="eT" placeholder="订房时间止"/>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">预定酒店</label>
            <div class="layui-input-inline">
                <select id="hotelId" name="hotelId" lay-filter="hotelId"
                        class="layui-input">
                    <option value="" id="selectHotel">--请选择--</option>
                </select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">预定产品</label>
            <div class="layui-input-block">
                <table id="tableStyle" class="layui-table" style="width: 100%">
                    <tr>
                        <th>
                            产品名称
                        </th>
                        <th>
                            预订须知
                        </th>
                        <th>
                            加床
                        </th>
                        <th>
                            增值服务
                        </th>
                        <th>
                            操作
                        </th>
                    </tr>
                    <input type="hidden" id="addProduct"/>
                </table>
            </div>
        </div>
    </div>

</form>
<script type="text/javascript">
    layui.use(['form', 'table', 'laydate'], function () {
        var table = layui.table;
        var laydate = layui.laydate;
        var form = layui.form;
        var $ = layui.$;


        //执行一个laydate实例
        laydate.render({
            elem: '#sT'
            , min: '${.now?datetime}'
            , done: function (value, date) {
                var min = $.extend({}, date);
                min.month = min.month - 1;
                endIns.config.min = min;
                $(endIns.config.elem).focus().val('');
            }
        });
        var endIns = laydate.render({
            elem: '#eT',
            done: function (value) {
                var sTime = $("#sT").val();
                var eTime = $("#eT").val();
                $.ajax({
                    url: '/hotel/hotelBooking/findHotel',
                    type: 'POST',
                    async: false,
                    //dataType:'json',
                    data: {"sTime": sTime, "eTime": eTime},
                    success: function (result) {
                        $(".selectHotelId").remove();
                        for (var key in result) {
                            $("#selectHotel").after("<option class='selectHotelId' value=" + key + ">" + result[key] + "</option>");
                        }
                        form.render('select');
                    }
                })
            }
        });
        form.on('select(hotelId)', function (data) {
            $(".hotelProductData").remove();
            var hid = $("#hotelId").val();
            if (hid == "" || hid == null) {
                return;
            }
            var sTime = $("#sT").val();
            var eTime = $("#eT").val();
            if (sTime == "" || sTime == null) {
                $("#sTtips").html("请选择入住时间");
            }
            if (eTime == "" || eTime == null) {
                $("#eTtips").html("请选择离店时间");
                return;
            }
            $.ajax({
                url: '/hotel/hotelBooking/findProductLowStock',
                type: 'POST',
                async: false,
                data: {"hid": hid, "sTime": sTime, "eTime": eTime},
                success: function (data) {
                    for (var info in data) {
                        var arr = info.split("-");
                        var yuding = "预订";
                        //是可以床
                        var jiachuang = "不能加床";
                        var rollawayBed = data[info].rollawayBed;
                        if (rollawayBed == 1) {
                            jiachuang = "能加床";
                        }
                        //是否有增值服务
                        var addService = data[info].addService;
                        var addServiceType = "无";
                        if (addService == 1) {
                            addServiceType = data[info].addServiceType + "x" + data[info].addServiceCount;
                        }
                        $("#sTime").val($("#sT").val());
                        $("#eTime").val($("#eT").val());
                        var datas = arr[2] + "-" + arr[1] + "-" + arr[0];
                        if (arr[0] == 0) {
                            $("#addProduct").before("<tr  class='hotelProductData'>" +
                                    "<td>" + data[info].name + "</td>" +
                                    "<td>" + data[info].bookingNotice + "</td>" +
                                    "<td>" + jiachuang + "</td>" +
                                    "<td>" + addServiceType + "</td>" +
                                    "<td>" +
                                    "<a href='/hotel/hotelBooking/getHotelProductAndRateByProductId?productId=" + arr[1] + "' class='layui-btn'>查看</a>" +
                                    "</td><span>房间库存不足3间</span></tr>");
                        } else if (arr[0] < 3) {
                            $("#addProduct").before("<tr  class='hotelProductData'>" +
                                    "<td>" + data[info].name + "(库存小于3间)</td>" +
                                    "<td>" + data[info].bookingNotice + "</td>" +
                                    "<td>" + jiachuang + "</td>" +
                                    "<td>" + addServiceType + "</td>" +
                                    "<td><button value='" + datas + "' type='submit' class='layui-btn'>" + yuding + "</button>" +
                                    "<a href='/hotel/hotelBooking/getHotelProductAndRateByProductId?productId=" + arr[1] + "' class='layui-btn'>查看</a>" +
                                    "</td></tr>");
                        } else if (arr[0] >= 3) {
                            $("#addProduct").before("<tr  class='hotelProductData'>" +
                                    "<td>" + data[info].name + "</td>" +
                                    "<td>" + data[info].bookingNotice + "</td>" +
                                    "<td>" + jiachuang + "</td>" +
                                    "<td>" + addServiceType + "</td>" +
                                    "<td><button value='" + datas + "' type='submit' class='layui-btn'>" + yuding + "</button>" +
                                    "<a href='/hotel/hotelBooking/getHotelProductAndRateByProductId?productId=" + arr[1] + "' class='layui-btn'>查看</a>" +
                                    "</td></tr>");
                        }
                    }
                }
            })
        });

    })
</script>
<script type="text/javascript">
    $('#tableStyle').on('click', 'button', function (e) {
        var data = $(this).val();
        var str = data.split("-");
        $("#stock").val(str[2]);
        $("#id").val(str[1]);
        $("#hid").val(str[0]);
    });
</script>
</body>
</html>