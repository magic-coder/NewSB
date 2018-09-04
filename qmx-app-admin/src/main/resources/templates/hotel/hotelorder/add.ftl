<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css"/>
    <script src="http://yui.yahooapis.com/3.5.1/build/yui/yui-min.js"></script>
    <script type="text/javascript" src="${base}/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/js/common.js"></script>
    <script type="text/javascript" src="${base}/js/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/js/yui-min.js"></script>

    <style>
        body{padding:0;margin:0 10px;}
        .title{padding:0;margin:10px 0;font:700 18px/1.5 \5fae\8f6f\96c5\9ed1;}
        .title em{font-style:normal;color:#C00;font-size:14px;}
        .title a{font:400 14px/1.5 Tahoma;}
        .example{margin-top:10px;}
        .example button{margin:0 5px 10px 0;}
    </style>
    <style type="text/css">
        #signupForm label.error{
            color: red;
        }
    </style>
</head>
<body>

<form action="save" method="post" id="signupForm">
    <input type="hidden" name="productName" id="pName" />
    <input type="hidden" name="productId" id="pId"/>
    <input type="hidden" id="dataJsonObjec"/>
    <input type="hidden" id="hotelProductData"/>
    <input type="hidden" id="getOrderData" name="orderDataStr"/>
    <input type="hidden" id="getOrderDate" name="orderDateStr" />
    <input name="payment" id="orderTotal"  type="text"   />
    <table class="input tabContent">
        <tr>
            <th></th>
            <td id="J_Example" class="example">
                <button type="button" class="J_Limit" id="test" data-limit="90">显示酒店状态</button>
            <#-- <button type="button" onclick="_getDateDiff()">示例</button>-->
            </td>
        </tr>
        <tr>
            <th>购买产品名称:&nbsp;</th>
            <td>
                酒店名称:
                <select id="hotel" name="hotleId" onchange="hotelChange()">
                    <option>-酒店名称-</option>
                <#list dto as info>
                    <option value="${info.id}"> ${info.name}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th>房态</th>
            <td>
                <div id="state" style="position: relative; width: 450px; height: 400px;"></div>
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>入住时间:</th>
            <td>
                <input name="checkIn" readonly="readonly"  id="ci" type="text" onclick="WdatePicker()" placeholder="入住日期" />
                <input name="checkOut" readonly="readonly"  id="co" type="text" onclick="WdatePicker({minDate: '#F{$dp.$D(\'checkIn\')}'})" placeholder="离店日期" />
            </td>
        </tr>
<#--        <tr>
            <th>
                产品单价:
            </th>
            <td>
                <input name="productPrice" readonly="readonly" id="price" onchange="priceChange()" type="text" class="text required"  />
            </td>
        </tr>-->
        <tr>
            <th>订房信息:</th>
            <td>
                <table>
                    <tr align="left" id="orderData">
                        <th>日期</th>
                        <th>产品名称</th>
                        <th>单价(元)</th>
                    </tr>

                </table>

            </td>
        </tr>
        <tr>
            <th>
                订购房间数:
            </th>
            <td>
                <input name="roomNumber" id="number" onchange="priceChange()" type="text" class="text required"  />
            </td>
        </tr>
        <tr>
            <th>
                使用天数:
            </th>
            <td>
                <input name="nights" id="nt" readonly="readonly"  type="text" class="text required"  />
            </td>
        </tr>
        <tr>
            <th>
                总金额:
            </th>
            <td>
                <input name="payment" id="total" type="text" readonly="readonly" class="text required"  />
            </td>
        </tr>
        <tr>
            <th>
                支付状态:
            </th>
            <td>
                <select name="paymentStatus" class="required">
                    <option value="unpaid">未支付</option>
                    <option value="paid">已支付</option>
                </select>
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>联系人手机号码:</th>
            <td>
                <input name="contactPhone" type="text" class="text required"  />
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>联系人姓名:</th>
            <td>
                <input type="text" name="contactName"  class="text required"  />
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>证件类型:</th>
            <td>
                <select name="idCardType" class="required">
                    <option value="Idcard">-证件类型-</option>
                    <option value="Idcard">身份证</option>
                    <option value="Passport">护照</option>
                    <option value="TaiwanPermit">台胞证</option>
                    <option value="HKAndMacauPermit">港澳通行证</option>
                </select>
                <input type="text" name="idCard"  class="text required"  />
            </td>
        </tr>
        <tr>
            <th></th>
            <td>
                <input type="submit" class="button" value="保存" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="${base}/js/jquery.validate.min.js"></script>
<script type="text/javascript">
    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                hotleId:{min:1},
                IdAndName:{min:1},
                checkIn:'required',
                checkOut:'required',
                roomNumber:{required:true,digits:true},
                nights:'required',
                payment:'required',
                contactPhone:{required:true,digits:true,rangelength:[11,11]},
                contactName:'required',
                credentialsType_1:{min:1},
                idCard:'required'
            },
            messages: {
                hotleId:'必选',
                IdAndName:'必选',
                checkIn:'必填',
                checkOut:'必填',
                roomNumber:{required:'房间数量不能为空',digits:'只能输入整数'},
                nights:'使用天数',
                payment:'总金额不能为空',
                contactPhone:{required:'电话号码不能为空',digits:'只能输入整数',rangelength: jQuery.format('请输入11为的电话号码')},
                contactName:'必填',
                credentialsType_1:'必选',
                idCard:'必填'
            }
        });
    }();
</script>
<script type="text/javascript">
    var hotelProductData;
    //价格信息表展示
    function everyDayPrice(depDate,endDate) {
        var start;
        var end;
        var productName=$("#pName").val();
        var totalPrice=0;
        //var orderDataStr='';
        var orderDataStr2=[];
        var orderDataStr3=[];
        for(var i = 0; i < hotelProductData.length; i++){
            if(endDate==hotelProductData[i].date){
                end=i;
            }
            if(depDate==hotelProductData[i].date){
                start=i;
            }
        }
        $(".orderDataCeshi").remove();
        //var data1=$("#dataJsonObjec").val();
        alert(hotelProductData.length);
        for(var i = 0; i < hotelProductData.length; i++){
            var orderDataStr1={};
            var orderDataStr4={};
            if (i>=end && i<=start){
                $("#orderData").after('<tr align="center" class="orderDataCeshi"><td>'+
                        hotelProductData[i].date+
                        '</td><td>'+productName+'</td><td>'+
                        hotelProductData[i].price+'</td></tr>');
                orderDataStr1.date=hotelProductData[i].date;
                orderDataStr1.price=hotelProductData[i].price;
                orderDataStr4.date=hotelProductData[i].date;
                orderDataStr2.push(orderDataStr1);
                orderDataStr3.push(orderDataStr4);
               // orderDataStr=hotelProductData[i].date+','+hotelProductData[i].price+'='+orderDataStr;
                if (i!=end){
                    totalPrice+=hotelProductData[i].price;
                }
            }
        }
        //订单价格，以及订单日期
        $("#getOrderData").val(JSON.stringify(orderDataStr2));
        //订单日期
        $("#getOrderDate").val(JSON.stringify(orderDataStr3));
        //每一天订单总价格
        $("#orderTotal").val(totalPrice);
    }
    //日历
    var config = {
        modules: {
            'price-calendar': {
                fullpath: '${base}/js/price-calendar.js',
                type    : 'js',
                requires: ['price-calendar-css']
            },
            'price-calendar-css': {
                fullpath: '${base}/css/price-calendar.css',
                type    : 'css'
            }
        }
    };
    YUI(config).use('price-calendar', 'jsonp', function(Y) {
        var sub  = Y.Lang.sub;
        var url = 'http://fgm.cc/learn/calendar/price-calendar/getData.asp?minDate={mindate}&maxDate={maxdate}&callback={callback}';

        //价格日历实例
        var oCal = new Y.PriceCalendar({
            container: '#state'
        });


        //点击确定按钮
        oCal.on('confirm', function() {
            alert('入住时间：' + this.get('depDate') + '\n离店时间：' + this.get('endDate'));
            everyDayPrice(this.get('depDate'),this.get('endDate'));
            $("#ci").val(this.get('depDate'));
            $("#co").val(this.get('endDate'));
            $("#nt").val(oCal._getDateDiff(this.get('depDate'),this.get('endDate')));

        });

        //点击取消按钮
        oCal.on('cancel', function() {
            this.set('depDate', '').set('endDate', '').render();
        });

        Y.one('#J_Example').delegate('click', function(e) {
           // data1={"2017-10-30":{"roomNum":0,"price":11.0},"2017-11-01":{"roomNum":-1,"price":111.0},"2017-11-02":{"roomNum":-1,"price":111.0},"2017-11-03":{"roomNum":-1,"price":111.0},"2017-11-04":{"roomNum":-1,"price":111.0},"2017-10-25":{"roomNum":3,"price":1.0},"2017-10-26":{"roomNum":5,"price":3.0},"2017-10-27":{"roomNum":82,"price":77.0},"2017-10-28":{"roomNum":2,"price":88.0},"2017-10-29":{"roomNum":7,"price":99.0}};
            var data1=$("#dataJsonObjec").val();
                data1=JSON.parse(data1);
            var that= this,
                    oTarget = e.currentTarget;
            switch(true) {
                    //时间范围限定
                case oTarget.hasClass('J_Limit'):
                    this.set('data', null)
                            .set('depDate', '')
                            .set('endDate', '')
                            .set('minDate', '')
                            .set('afterDays', oTarget.getAttribute('data-limit'));
                    if(!oTarget.hasAttribute('data-date')) {
                        this.set('date', new Date())
                    }
                    else {
                        var oDate = oTarget.getAttribute('data-date');
                        this.set('minDate', oDate);
                        this.set('date', oDate);
                    }
                    oTarget.ancestor().one('.J_RoomStatus') ?
                            oTarget.ancestor().one('.J_RoomStatus').setContent('\u663e\u793a\u623f\u6001').removeClass('J_Show') :
                            oTarget.ancestor().append('<button type="button" class="J_RoomStatus">\u663e\u793a\u623f\u6001</button>');
                    break;
                    //异步拉取酒店数据
                case oTarget.hasClass('J_RoomStatus'):
                    oTarget.toggleClass ('J_Show');
                    if(oTarget.hasClass('J_Show'))
                        Y.jsonp(
                                sub(url, {
                                    mindate:this.get('minDate'),
                                    maxdate:this.get('maxDate')
                                }),
                                {
                                    on: {
                                        success: function(data) {
                                            that.set('data', data1);
                                            oTarget.setContent('\u9690\u85cf\u623f\u6001')
                                        }
                                    }
                                }
                        );
                    else {
                        this.set('data', null);
                        oTarget.setContent('\u663e\u793a\u623f\u6001');
                    }
                    break;
            }
        }, 'button', oCal);
    });

    //将产品名称和产品id放到隐藏的input框中
    function productIdAndName() {
        var productI=jQuery("#selectIdAndName  option:selected").val();
        var productN=jQuery("#selectIdAndName  option:selected").text();
        $("#pName").val(productN);
        $("#pId").val(productI);
        productChange();

    }
    //选择酒店之后获取酒店的全部产品
    function hotelChange() {
        var hotleId=jQuery("#hotel  option:selected").val();
        $("#deletSelect").remove();
        $.ajax({
            url: '/hotelOrder/findProdutByHotelId',
            type: 'POST', //GET
            async: true,    //或false,是否异步
            data: {"hotleId": hotleId},
            success: function (data) {
                var optionstring = "";
                var Data=data;
                for(var key in Data){
                optionstring += "<option value=" +key+" >" + Data[key]+ "</option>";
                }
                $("#hotel").after("<span id='deletSelect'>&nbsp;&nbsp;产品名称:&nbsp;"+"" +
                        "<select id='selectIdAndName' name='IdAndName' onchange='productIdAndName()'>"+
                        "<option value='请选择'>请选择...</option> "+optionstring+"</select></span>");
            }
        });
    }
    //选择产品之后获得获得价格信息
    function productChange() {
        var productId=jQuery("#selectIdAndName  option:selected").val();
        $.ajax({
            url: '/hotelOrder/findProdutByProductId',
            type: 'POST', //GET
            async: true,    //或false,是否异步
            data: {"productId": productId},
            success: function (data) {
                var Data=data;
                for(var key in Data){
                    //日期
                    $("#dataJsonObjec").val(key);
                    //价格和房间信息
                    hotelProductData=Data[key];
                    $("#hotelProductData").val(Data[key]);
                }
            }
        });
    }
    //价格和数量的计算
    function priceChange() {
        var num=$("#number").val();
        var tal=$("#orderTotal").val();
        var total=tal*num;
        $("#orderTotal").val(total);
        $("#total").val(total);
    }
</script>

</body>
</html>