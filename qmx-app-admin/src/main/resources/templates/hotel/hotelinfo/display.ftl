<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
    <link href="${base}/bak/css/common.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${base}/bak/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/bak/js/common.js"></script>
    <script type="text/javascript" src="${base}/bak/js/datePicker/WdatePicker.js"></script>
    <style type="text/css">
        .roles label {
            width: 150px;
            display: block;
            float: left;
            padding-right: 6px;
        }
    </style>
    <style type="text/css">
        #signupForm td {
            width: 400px;
        }

        #signupForm th {
            width: 100px;
        }
    </style>
    <script type="text/javascript">
        $().ready(function () {

            var $inputForm = $("#inputForm");
            var $selectAll = $("#inputForm .selectAll");
            var $areaId = $("#areaId");
        [@flash_message /]
        });
    </script>
    <style type="text/css">
        #signupForm label.error {
            color: Red;
            /*font-size: 13px;
            margin-left: 5px;
            padding-left: 16px;*/
            /*background: url("error.png") left no-repeat;*/
        }
    </style>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
    </div>
</div>
<form id="signupForm" action="update.jhtml" method="post">
    <!--酒店设备-->
    <input type="hidden" name="hotelFacilities" id="chk_value"/>
    <!--酒店服务-->
    <input type="hidden" name="hotelService" id="service_value"/>
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息" id="change"/>
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>

            </th>
            <td>

                <input type="button" class="button" value="查看图片"
                       onclick="location.href='/hotelInfo/imgList?hid=${dto.id!}'"/>
            </td>
        </tr>


        <tr>
            <th>
                <span class="requiredField">*</span>酒店名称:
            </th>
            <td>
            ${dto.name!}
            </td>
            <th>
                <span class="requiredField"></span>酒店经度:
            </th>
            <td>
            ${dto.longitude!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>酒店电话:
            </th>
            <td>
            ${dto.phone!}
            </td>
            <th>
                <span class="requiredField"></span>酒店纬度:
            </th>
            <td>
            ${dto.latitude!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>传真号:
            </th>
            <td>
            ${dto.faxes!}
            </td>
            <th>
                <span class="requiredField"></span>酒店城市:
            </th>
            <td>
            ${dto.city!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店地址:
            </th>
            <td>
            ${dto.address!}
            </td>
            <th>
                <span class="requiredField"></span>酒店星级:
            </th>
            <td>
                <#if '${dto.star!}'='2'>
                    二星级以下/经济
                    <#elseif '${dto.star!}'='3'>
                        三星级/舒适
                        <#elseif '${dto.star!}'='4'>
                            四星级/高档
                            <#elseif '${dto.star!}'='5'>
                                五星级/豪华
                </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店楼层:
            </th>
            <td>
            ${dto.floors!}
            </td>
            <th>
                <span class="requiredField"></span>房间数:
            </th>
            <td>
            ${dto.rooms!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店介绍:
            </th>
            <td>
            ${dto.introduce!}
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店设施:
            </th>
            <td>
                <#list facilitiesList as info>
                    <label>
                        <input type="checkbox" name="specialService" disabled value="${info!}"
                        <#if dto.hotelFacilities?contains(info)>checked</#if>
                        />${info!}
                    </label>
                </#list>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店服务:
            </th>
            <td>
                <#list serviceList as info>
                    <label>
                        <input type="checkbox" name="servicesItem" disabled value="${info!}"
                        <#if dto.hotelService?contains(info)>checked</#if>
                        />${info!}
                    </label>
                </#list>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="${base}/bak/js/jquery.validate.min.js"></script>
<script type="text/javascript">
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

    //验证
    var Script = function () {
        $("#signupForm").validate({
            rules: {
                name: 'required',
                star: {max: 5},
                phone: 'required',
                faxes: 'required'
            },
            messages: {
                name: '酒店名称不能为空',
                star: '输入的星级不合规范或超出范围!',
                phone: '电话不能为空!',
                faxes: '传真号不能为空!'
            }
        });
    }();
</script>
</body>
</html>