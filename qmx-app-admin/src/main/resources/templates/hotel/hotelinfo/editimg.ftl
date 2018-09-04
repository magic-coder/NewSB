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
    <script type="text/javascript">
        $().ready(function () {

            var $inputForm = $("#inputForm");
            var $selectAll = $("#inputForm .selectAll");
            var $areaId = $("#areaId");
        [@flash_message /]
        });
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
    </div>
</div>
<form id="inputForm" action="updateImg.jhtml" method="post">
    <ul id="tab" class="tab">
        <li>
            <input type="button" value="基本信息"/>

        </li>
    </ul>
    <table class="input tabContent">
        <tr>
            <td>
                <input type="hidden" name="id" value="${dto.id!}"/>
                <input type="hidden" name="hid" value="${dto.hid!}"/>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>图片路径:
            </th>
            <td>
                <input type="text" name="url" class="text" maxlength="20" value="${dto.url!}"/>

            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>是否主图:
            </th>
            <td>
                <#if '${(dto.ismain!)?c}'=='true'>
                    <input type="radio" name="ismain" value="true" checked="checked"/>是
                    <input type="radio" name="ismain" value="false"/>不是
                    <#elseif '${(dto.ismain!)?c}'=='false'/>
                    <input type="radio" name="ismain" value="true"/>是
                    <input type="radio" name="ismain" value="false" checked="checked"/>不是
                    <#else/>
                    <input type="radio" name="ismain" value="true"/>是
                    <input type="radio" name="ismain" value="false"/>不是
                </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>图片属性:
            </th>
            <td>
                <select name="attribute" class="text">
                    <#list attribute as info>
                        <option value="${info!}"
                        <#if '${info!}'=='${dto.attribute!}'>selected</#if>
                        >${info.type!}</option>
                    </#list>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField"></span>图片类型:
            </th>
            <td>
                <select name="type" class="text">
                    <#list type as info>
                        <option value="${key!}"
                        <#if info='${dto.type!}'>selected</#if>
                        >${info.type!}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </table>
    <table class="input">
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="提交"/>
                <input type="button" class="button" value="返回" onclick="history.back();"/>
            </td>
        </tr>
    </table>
</form>
</body>
</html>