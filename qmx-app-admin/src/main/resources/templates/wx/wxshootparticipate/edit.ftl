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
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息" />
        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <th>
                增加的票数:
            </th>
            <td>
                <input type="text" id="vote" name="vote" required="required" value=""/>
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
        var vote=$("#vote").val();
        if (!reg.test(vote)) {
            alert("请输入有效的数");
            return false;
        }
        document.getElementById ('sub').click();
    }
</script>
</body>
</html>