<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加模块</title>
    <link href="${base}/css/common.css" rel="stylesheet" type="text/css" />
    <link href="${base}/css/wx/wxSystem.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${base}/js/operate.js"></script>
    <script type="text/javascript" src="${base}/js/datePicker/WdatePicker.js"></script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        编辑模块
    </div>
</div>
<form id="inputForm" action="update.jhtml" method="post">
    <input type="hidden" name="id" value="${dto.id!}"/>
    <input type="hidden" name="number" value="${dto.number!}"/>
    <input type="hidden" name="totalVote" value="${dto.totalVote!}"/>
    <input type="hidden" name="browse" value="${dto.browse!}"/>
    <input name="createTime" type="hidden" value="<#if dto.createTime??>${dto.createTime?string('yyyy-MM-dd HH:mm:ss')}</#if>"/>
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息" />
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>
                活动名称:
            </th>
            <td>
                <input  type="text" name="name" required="required" value="${dto.name!}"/>
            </td>
        </tr>
        <tr>
            <th>
                活动图片:
            </th>
            <td>
                <input type="text" name="imgLogo" required="required" value="${dto.imgLogo!}" <#-- readonly="readonly" -->/>
                <#--<input type="button" id="showlogo" class="button bg_white-bor_grey" value="${message("admin.browser.select")}" />-->
            </td>
        </tr>
        <tr>
            <th>
                有效时间:
            </th>
            <td>
                <input name="startTime" <#if (dto.startTime)??>value="${dto.startTime?string('yyyy-MM-dd HH:mm:ss')}"</#if> class="Wdate" onfocus="WdatePicker({readOnly:true,dateFmt: 'yyyy-MM-dd HH:mm:ss',minDate:''})" required="required"/>&nbsp;至
                <input name="endTime" <#if (dto.endTime)??>value="${dto.endTime?string('yyyy-MM-dd HH:mm:ss')}"</#if> class="Wdate" onfocus="WdatePicker({readOnly:true,dateFmt: 'yyyy-MM-dd HH:mm:ss',minDate:'${.now?string('yyyy-MM-dd')}'})" required="required"/>
            </td>
        </tr>
        <tr>
            <th>
                奖品内容:
            </th>
            <td>
                <textarea name="prizeContent" rows="10" cols="50" required="required">${dto.prizeContent!}</textarea>
            </td>
        </tr>
        <tr>
            <th>
                规则内容:
            </th>
            <td>
                <textarea name="ruleContent" rows="10" cols="50" required="required">${dto.ruleContent!}</textarea>
            </td>
        </tr>
        <tr>
            <th>
                投票周期:
            </th>
            <td>
                <input type="text" id="cycle" name="cycle" required="required" value="${dto.cycle!}"/>
            </td>
        </tr>
        <tr>
            <th>
                投票次数:
            </th>
            <td>
                <input type="text" id="count" name="count" required="required" value="${dto.count!}"/>
            </td>
        </tr>
        <tr>
            <th>
                单个作品投票上限:
            </th>
            <td>
                <input type="text" id="ceiling" name="ceiling" required="required" value="${dto.ceiling!}"/>
            </td>
        </tr>
        <tr>
            <th>
                是否有效:
            </th>
            <td>
                <input name="enable" type="radio" value="true"<#if dto.enable==true> checked="checked" </#if> />是
                <input name="enable" type="radio" value="false"<#if dto.enable==false> checked="checked" </#if> />否
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <a class="button" onclick="submitform();">保存</a>
                <a class="button" href="javascript:history.go(-1);">返回</a>
                <input style="display: none;" class="add_1" type="submit" id="sub" value="submit" />
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    function submitform(){
        var reg = /^[1-9]\d*$/;
        var cycle=$("#cycle").val();
        if (!reg.test(cycle)) {
            alert("请输入有效的数");
            return false;
        }
        var count=$("#count").val();
        if (!reg.test(count)) {
            alert("请输入有效的数");
            return false;
        }
        var ceiling=$("#ceiling").val();
        if (!reg.test(ceiling)) {
            alert("请输入有效的数");
            return false;
        }
        document.getElementById ('sub').click();
    }
</script>
</body>
</html>