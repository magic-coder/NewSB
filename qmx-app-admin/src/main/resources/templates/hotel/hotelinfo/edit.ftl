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
    <input type="hidden" name="memberId" class="text" maxlength="20" value="${dto.memberId!}" id="memberId"/>
    <input type="hidden" name="groupSupplierId" class="text" maxlength="20" value="${dto.groupSupplierId!}"
           id="groupSupplierId"/>
    <input type="hidden" name="supplierId" class="text" maxlength="20" value="${dto.supplierId!}"/>
    <input type="hidden" name="supplierFlag" class="text" maxlength="20" value="${dto.supplierFlag!}"/>
    <ul id="tab" class="tab">
        <li>
            <input type="hidden" class="text" value="${dto.id!}" name="id"/>
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
                <input type="text" name="name" value="${dto.name!}" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店经度:
            </th>
            <td>
                <input type="text" name="longitude" value="${dto.longitude!}" class="text" maxlength="20"/>
                <button class="button">定位</button>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>酒店电话:
            </th>
            <td>
                <input type="text" name="phone" class="text" value="${dto.phone!}" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店纬度:
            </th>
            <td>
                <input type="text" name="latitude" value="${dto.latitude!}" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>传真号:
            </th>
            <td>
                <input type="text" name="faxes" value="${dto.faxes!}" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店城市:
            </th>
            <td>
                <input type="text" name="city" value="${dto.city!}" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店地址:
            </th>
            <td>
                <input type="text" name="address" value="${dto.address!}" class="text" maxlength="30"/>
            </td>
            <th>
                <span class="requiredField"></span>酒店星级:
            </th>
            <td>
                <!--<input type="text" name="star" class="text" maxlength="20" title="请输入正确的星级"/>-->
                <select name="star" id="star" class="text">
                    <option value="2"
                    <#if '${dto.star!}'='2'> selected='selected'</#if>
                    >二星级以下/经济</option>
                    <option value="3"
                    <#if '${dto.star!}'='3'> selected='selected'</#if>
                    >三星级/舒适</option>
                    <option value="4"
                    <#if '${dto.star!}'='4'> selected='selected'</#if>
                    >四星级/高档</option>
                    <option value="5"
                    <#if '${dto.star!}'='5'> selected='selected'</#if>
                    >五星级/豪华</option>
                </select>
                <!-- <span style="color: red">(星级范围为：1,1.5,2,2.5,3,3.5,4,4.5,5)</span>-->
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店楼层:
            </th>
            <td>
                <input type="text" name="floors" value="${dto.floors!}" class="text" maxlength="20"/>
            </td>
            <th>
                <span class="requiredField"></span>房间数:
            </th>
            <td>
                <input type="text" name="rooms" value="${dto.rooms!}" class="text" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店介绍:
            </th>
            <td>
                <textarea class="text" name="introduce">${dto.introduce!}</textarea>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>酒店设施:
            </th>
            <td>
                <#list facilitiesList as info>
                    <label>
                        <input type="checkbox" name="hotelFacilities" value="${info!}"
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
                        <input type="checkbox" name="hotelService" value="${info!}"
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
                <input type="submit" class="button" value="提交" onclick="getHotelFacilities()"/>
                <a href="/hotelInfo/list" class="button">返回</a>
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