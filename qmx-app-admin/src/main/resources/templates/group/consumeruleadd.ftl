<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加信息</title>
<#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $().ready(function() {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    name: "required"
                }
            });
            $("input:radio,input:checkbox").change(function () {
                $("input[name='" + $(this).attr("name") + "']:checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", false);
                });
                $("input[name='" + $(this).attr("name") + "']").not(":checked").each(function () {
                    $($(this).attr("dest")).attr("disabled", true);
                });
            });
            $("#selectCheckTicketMember").click(function () {
                var browserFrameId = "browserFrame" + (new Date()).valueOf() + Math.floor(Math.random() * 1000000);
                var $browser = $('<div class="xxBrowser" style="height:290px;"><\/div>');
                $browserFrame = $('<iframe id="' + browserFrameId + '" name="' + browserFrameId + '" src="${base}/tickets/tickets/listMemberInDialog" style="width:100%; height:100%;" frameborder="0"><\/iframe>').appendTo($browser);
                var $dialog = $.dialog({
                    title: "选择验票人",
                    content: $browser,
                    width: 670,
                    modal: true,
                    ok: "确定",
                    cancel: "关闭",
                    onOk: function () {
                        var $checkedIds = $(window.frames[browserFrameId].document).find("input[name='ids']:enabled:checked");
                        var html = [];
                        $checkedIds.each(function () {
                            var id = $(this).val();
                            var tr = $(this).parents("tr:eq(0)");
                            if ($("tr." + id).size() == 0) {
                                html.push("<tr class='" + id + "'><td><input type='hidden' name='checkTicketMemberIds' value='" + id + "'/>" + tr.find("td:eq(3)").text() + "</td><td>" + tr.find("td:eq(1)").text() + "</td><td><a href='javascript:;' onclick='$(this).parent().parent().remove()'>删除</a></td></tr>");
                            }
                        });
                        $("#checkTicketMemberTable").append(html.join(''));
                        return true;
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加信息
    </div>
</div>
<form id="inputForm" action="/group/consumerule" method="post">
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <span class="tips">添加信息</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>名称:
            </th>
            <td>
                <input type="text" name="name" class="text" maxlength="300" style="width: 300px;" />
                <span class="tips">名称</span>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>选择验票人:
            </th>
            <td>
                <label><input type="checkbox" checked="checked" name="isSupplierCheck" value="true"/>供应商可验票</label>
                <button type="button" id="selectCheckTicketMember" class="button">加验票人</button>
                <table id="checkTicketMemberTable" width="100%">
                    <tr class="title">
                        <td>验票人姓名</td>
                        <td>验票人用户名</td>
                        <td>操作</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>入园地址:
            </th>
            <td>
                <input name="passAddress" class="text required" placeholder="请详细填写客人进入园区的地址" style="width: 300px;"
                       value="景区/游乐园入口"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>入园方式:
            </th>
            <td>
                <label>
                    <input type="radio" checked="checked" class="required" name="passType" value="VIRTUAL"/> 凭兑换凭证直接入园
                </label>
                <br/>
                <label>
                    <input type="radio" dest="input[name=pickupAddress]" class="required" name="passType"
                           value="ENTITY"/> 凭兑换凭证换票，
                    换票地址：<input name="pickupAddress" class="text required" placeholder="请详细填写换票的地址"
                                style="width: 300px;" disabled/>
                </label>
            </td>
        </tr>
        <tr>
            <th>
                <label><input type="checkbox" name="canUseMultipleTimes" dest="input[name=availableTimes]"/>是否多次票:</label>
            </th>
            <td>
                <label><input type="text" name="availableTimes" class="text required" placeholder="次数" style="width: 80px;" disabled/></label>
            </td>
        </tr>
        <tr>
            <th>
                <label>
                    <input type="checkbox" name="limitUseTimeRange" dest="select[name=useTimeRangeStart],select[name=useTimeRangeEnd]" value="true" />使用时段:
                </label>
            </th>
            <td>
                <select name="useTimeRangeStart" class="required" disabled>
                <#list 5..23 as a>
                    <option value="${a!}:00">${a!}:00</option>
                    <option value="${a!}:30">${a!}:30</option>
                </#list>
                </select> -
                <select name="useTimeRangeEnd" class="required" disabled>
                <#list 5..23 as a>
                    <option value="${a!}:00">${a!}:00</option>
                    <option value="${a!}:30">${a!}:30</option>
                </#list>
                    <option value="00:00">00:00</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <label>
                    <input type="checkbox" name="bookLimitType" dest="input[id=DELAY_BOOK_HOURS]" class="required" value="DELAY_BOOK_HOURS"/>
                    使用时间限制:
                </label>
            </th>
            <td>
                <label>
                    预订后 <input id="DELAY_BOOK_HOURS" type="text" name="enterSightDelayBookHour" class="text digits required" value="" style="width: 30px;" disabled/> 小时才能入园
                </label><br/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>预定须知:
            </th>
            <td>
                <textarea name="remind" class="text required" maxlength="1000">预定须知</textarea>
                <div class="blank"></div>
                <span class="tips">必须包含以下内容：【入园凭证】【入园凭证发送时间及方式】【入园/换票时间及地址】  1000字以内。</span>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="提交" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>