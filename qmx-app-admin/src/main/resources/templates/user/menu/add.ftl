<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加菜单</title>
    <#include "/include/header_include_old.ftl">
    <script type="text/javascript">
        $(function () {
            var $inputForm = $("#inputForm");
            // 表单验证
            $inputForm.validate({
                rules: {
                    menuName: {
                        required: true
                    },
                    userTypes: {
                        required: true
                    }

                }
            });
            $("select[name=moduleId]").change(function(){
                $("select[name=parentId]").empty();     //清空seletct的数据
                $.ajax({
                    type: "POST",
                    url: "findModuleId",
                    data: {moduleId:$(this).val()},
                    success: function(respData){
                        if(respData.errorCode != 0){
                            alert(respData.errorMsg);
                            return;
                        }
                        var menuList = respData.data;
                        if(menuList){
                            var optionString = "<option value=''>ROOT</option>";
                            //判断
                            for(var i=0; i< menuList.length; i++){ //遍历，动态赋值
                                var menu = menuList[i];
                                optionString +="<option value=\""+menu.id+"\">"+menu.menuName+"</option>";  //动态添加数据
                                var menuLst = menu.menuBeans;
                                //console.info(menuLst);
                                if(menuLst){
                                    optionString += getMenuSelectList(menuLst);
                                }
                            }
                            // 为当前name为parentId的select添加数据。
                            $("select[name=parentId]").append(optionString);
                        }
                    }
                });
            });
            //触发change
            $("select[name=moduleId]").change();
        });

        function getMenuSelectList(menuList) {
            var optionString = "";
            for(var i = 0; i< menuList.length; i++){
                //遍历，动态赋值
                var menu = menuList[i];
                var space = '┝';
                for(var j = 0; j< menu.leaf; j++){
                    space += '┉';
                }
                optionString +="<option value=\""+menu.id+"\">"+space+menu.menuName+"</option>";
                var menuLst = menu.menuBeans;
                if(menuLst && menuLst.length > 0){
                    optionString += getMenuSelectList(menuLst);
                }
            }
            return optionString;
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加菜单
    </div>
</div>
<form id="inputForm" action="save" method="post">
    <br/>
    <p>添加菜单</p>
    <table class="input">
        <tr>
            <th>
                <span class="requiredField">*</span>菜单名称:
            </th>
            <td>
                <input type="text" name="menuName" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                菜单类型:
            </th>
            <td>
                <input type="text" name="menuType" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                链接地址:
            </th>
            <td>
                <input type="text" name="url" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                节点图标CSS类名:
            </th>
            <td>
                <input type="text" name="iconcls" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                权限代码:
            </th>
            <td>
                <input type="text" name="permission" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                所属模块:
            </th>
            <td>

                <select name="moduleId">
                <#list modules as module>
                    <option value="${module.id}">
                    ${module.moduleName}
                    </option>
                </#list>
                    所属菜单：
                </select>
                <select name="parentId">
                    <option value="">ROOT</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                用户类型:
            </th>
            <td>
                <#list userTypes as t>
                    <label>
                        <input type="checkbox" name="userTypes" value="${t!}" />${t.getName()!}
                    </label>
                </#list>
            </td>
        </tr>
        <tr>
            <th>
                是否展开:
            </th>
            <td>
                <input type="text" name="expand" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                排序:
            </th>
            <td>
                <input type="text" name="sortNo" class="text" maxlength="200" />
            </td>
        </tr>
        <tr>
            <th>
                菜单说明:
            </th>
            <td>
                <textarea rows="6" name="remark" cols="60"></textarea>
            </td>
        </tr>
        <tr>
            <th>
                &nbsp;
            </th>
            <td>
                <input type="submit" class="button" value="保存" />
                <input type="button" class="button" value="返回" onclick="history.back();" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>