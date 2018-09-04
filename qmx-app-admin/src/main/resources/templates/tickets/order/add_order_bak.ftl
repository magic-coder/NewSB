<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <title>添加订单</title>
    <link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
    <link href="${base}/resources/admin/dropdown/dropdown.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropdown.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/dropdown/jquery.dropqtable.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
    <script type="text/javascript" src="${base}/resources/admin/js/ajaxupload.js"></script>
    <script type="text/javascript">
        $().ready(function() {

            var $inputForm = $("#inputForm");
            var $isInvoice = $("#isInvoice");
            var $invoiceTitle = $("#invoiceTitle");
            var $tax = $("#tax");
            var $areaId = $("#areaId");

        <#if bookRule.passengerInfoType == 'ALL'>
            //需要每个顾客信息
            $("input[name=quantity]").bind("input propertychange change", function(event) {
                var quantity = $(this).val();
                if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
                    if($("#passengerInfoTable tr").size() > quantity) {
                        $("#passengerInfoTable tr:gt("+quantity+")").remove();
                    } else {
                        var html = [];
                        for(var i=0;i<quantity-$("#passengerInfoTable tr:gt(0)").size();i++) {
                            var index = $("#passengerInfoTable tr").size()+i;
                            <#assign x = bookRule.needPassengerInfo?split(',')>
                        html.push(
                            <@compress single_line = true>
                                    '<tr>
                                    <td><i class="warn">'+index+'</i></td>
                                <#if x?seq_contains('name')>
                                <td><input name="name_'+index+'" type="text" class="text required" /></td>
                                </#if>
                                <#if x?seq_contains('pinyin')>
                                        <td><input name="pinyin_'+index+'" type="text" class="text required" /></td>
                                </#if>
                                <#if x?seq_contains('mobile')>
                                        <td><input name="mobile_'+index+'" type="text" class="text required isMobile" /></td>
                                </#if>
                                <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                                        <td>
                                        <select name="credentialsType_'+index+'" class="required">
                                    <#if x?seq_contains('Idcard')>
                                            <option value="Idcard">身份证</option>
                                    </#if>
                                    <#if x?seq_contains('Passport')>
                                            <option value="Passport">护照</option>
                                    </#if>
                                    <#if x?seq_contains('TaiwanPermit')>
                                            <option value="TaiwanPermit">台胞证</option>
                                    </#if>
                                    <#if x?seq_contains('HKAndMacauPermit')>
                                            <option value="HKAndMacauPermit">港澳通行证</option>
                                    </#if>
                                        </select>
                                        <input name="credentials_'+index+'" type="text" class="text required" />
                                </#if>
                                    </td>
                                    </tr>');
                            </@compress>
                        }
                        $("#passengerInfoTable").append(html.join(''));
                    }
                }
            });
        <#elseif bookRule.passengerInfoType == 'ONE'>
            //仅需要一位顾客信息
        </#if>

            $.validator.addClassRules({
                orderItemPrice: {
                    required: true,
                    min: 0,
                    decimal: {
                        integer: 12,
                        fraction: 2
                    }
                },
                orderItemQuantity: {
                    required: true,
                    integer: true,
                    min: 1
                }
            });

            // 表单验证
            $inputForm.validate({
                rules: {
                    sn: {
                        pattern: /^[0-9a-zA-Z_-]+$/,
                        remote: {
                            url: "check_sn.jhtml",
                            cache: false
                        }
                    },
                    price: {
                        required: true,
                        decimal: {
                            integer: 12,
                            fraction: 2
                        }
                    },
                    quantity: {
                        required: true,
                        integer: true,
                        min: 1
                    },
                    point: {
                        required: true,
                        digits: true
                    },
                    freight: {
                        required: true,
                        min: 0,
                        decimal: {
                            integer: 12,
                            fraction: 2
                        }
                    },
                    productId: "required",
                    paymentMethodId: "required",
                    shippingMethodId: "required",
                    orderSourceId: "required",
                    smsThemeId: "required",
                    invoiceTitle: "required",
                    tax: {
                        required: true,
                        min: 0,
                        decimal: {
                            integer: 12,
                            fraction: 2
                        }
                    },
                    contactName: {
                        required: true,
                        //pattern: /^[0-9a-z_A-Z\u4e00-\u9fa5]+$/,
                    },
                    productName: "required",
                    beginDate: "required",
                    //areaId: "required",
                    //address: "required",
                    //zipCode: "required",
                    contactMobile: {
                        isMobile: true,
                        required: true
                    }
                },
                messages: {
                    sn: {
                        pattern: "admin.validate.illegal",
                        remote: "admin.validate.exist"
                    }
                }
            });

            $("input[name=quantity]").change();
        });

        function addItem(productId) {
            location.href='add.jhtml?productId='+productId;
        }
    </script>
</head>
<body>
<div class="path main">
    <div class="con_head bg_deepblue">
        添加订单
    </div>
</div>
<form id="inputForm" action="saveTicketsOrder" method="post">
    <table class="input">
        <tr>
            <th><span class="requiredField">*</span>购买产品:</th>
            <td>
            <#if dto.sight??>
            ${dto.sight.sightName} -
            </#if>
            ${dto.name}(${dto.sn})
                <input type="hidden" id="productId" name="productId" value="${dto.id}" />
            </td>
        </tr>
    <#if distribution??>
        <#if distribution.specifyDate>
            <tr>
                <th><span class="requiredField">*</span>使用日期:</th>
                <td>
                    <input id="beginDate" name="beginDate" class="Wdate text" />
                    <input type="hidden" name="priceSn" value="" />
                    <script type="text/javascript">
                        var prices = {<#list distribution.distributionPrices as price>'${price.useDate}':${price.authPrice},</#list>};
                        var disabledDates = [<#list distribution.distributionPrices as price>'${price.useDate}',</#list>];
                        $("#beginDate").click(function(){
                            WdatePicker({
                                minDate:'${.now?string("yyyy-MM-dd")}',
                                dateFmt:'yyyy-MM-dd',
                                //doubleCalendar:true,
                                opposite:true,
                                disabledDates:disabledDates,
                                onpicked:function(dp){
                                    //选中
                                    $("#price").val(prices[dp.cal.getDateStr()]);
                                }
                            });
                        });
                    </script>
                </td>
            </tr>
        </#if>
    <#else>
        <tr>
            <th>
                使用有效期:
            </th>
            <td>
                <label>
                    <input name="vsdate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd',minDate:'${.now?string('yyyy-MM-dd')}'})" class="text Wdate" /> 至
                    <input name="vedate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd',minDate:'${.now?string('yyyy-MM-dd')}'})" class="text Wdate" />&nbsp;</label><br/>
            </td>
        </tr>
        <tr>
            <th>
                使用星期:
            </th>
            <td>
                <label>
                    <input type="checkbox" name="weekDays" value="1" checked />一&nbsp;
                    <input type="checkbox" name="weekDays" value="2" checked />二&nbsp;
                    <input type="checkbox" name="weekDays" value="3" checked />三&nbsp;
                    <input type="checkbox" name="weekDays" value="4" checked />四&nbsp;
                    <input type="checkbox" name="weekDays" value="5" checked />五&nbsp;
                    <input type="checkbox" name="weekDays" value="6" checked />六&nbsp;
                    <input type="checkbox" name="weekDays" value="0" checked />日&nbsp;
            </td>
        </tr>
    </#if>
        <tr>
            <th>预订限制:</th>
            <td>
            <#if bookRule.bookLimitType == 'NO_LIMIT'>
                无需提前预定
            <#elseif bookRule.bookLimitType == 'ADVANCE_BOOK_TIME'>
                <#if bookRule.enterBookAdvanceDay == 0>
                    当天
                <#else>
                    使用前 ${bookRule.bookAdvanceDay} 天
                </#if>
            ${bookRule.bookAdvanceHour}:${(bookRule.bookAdvanceMinute?string('00'))!'00'} 之前预订
            <#elseif bookRule.bookLimitType == 'DELAY_BOOK_HOURS'>
                预订后 ${consumeRule.enterSightDelayBookHour} 小时才能使用
            <#elseif bookRule.bookLimitType == 'BOOK_LIMIT_TIME_RANGE'>
                只能在${bookRule.bookTimeRangeStart!}-${bookRule.bookTimeRangeEnd!}之间预定
            </#if>
            </td>
        </tr>
    <#if distribution??>
        <tr>
            <th>使用有效期:</th>
            <td>
                <#if distribution.specifyDate>
                    选定日期<#if distribution.useEffectiveDay = 1>当天<#else>${(distribution.useEffectiveDay)!}天</#if>内有效
                <#else>
                ${(distribution.vsdate)!}~${(distribution.vedate)!}
                </#if>
            </td>
        </tr>
    </#if>
        <tr>
            <th>退款说明:</th>
            <td>
            ${(refundRule.canRefund?string('可退款','不可退款'))!} / ${(refundRule.refundNeedAudit?string('需要审核','不需要审核'))!}
                <div class="blank"></div>
            <#if refundRule.refundInfo??>
            ${refundRule.refundInfo?replace("\n", "<br/>")}
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>产品单价:
            </th>
            <td>
            <#if distribution??>
                <#if distribution.specifyDate>
                    <input id="price" name="salePrice" type="text" readonly class="text" />
                <#else>
                    <input id="price" name="salePrice" type="text" readonly class="text" value="${distribution.sellPrice!0}" />
                </#if>
            <#else>
                <input name="salePrice" type="text" readonly class="text" value="${dto.marketPrice!}" />
                <input name="couponDiscount" type="hidden" class="text" value="2" />
            </#if>
            </td>
        </tr>
        <tr>
            <th>
                <span class="requiredField">*</span>购买数量:
            </th>
            <td>
                <input name="quantity" type="text" class="text" value="1" maxlength="4" />
            </td>
        </tr>
        <tr>
            <th><span class="requiredField">*</span>联系人手机号码:</th>
            <td>
                <input type="text" name="contactMobile" value="" class="text" />
            </td>
        </tr>
    <#assign x = bookRule.needContactInfo?split(',') />
    <#if x?seq_contains('name') >
        <tr>
            <th><span class="requiredField">*</span>联系人姓名:</th>
            <td>
                <input type="text" name="contactName" value="" class="text required"  />
            </td>
        </tr>
    </#if>
    <#if x?seq_contains('pinyin') >
        <tr>
            <th><span class="requiredField">*</span>联系人姓名拼音:</th>
            <td>
                <input type="text" name="contactPinyin" value="" class="text required"  />
            </td>
        </tr>
    </#if>
    <#if bookRule.passengerInfoType != 'NONE'>
        <tr>
            <th><span class="requiredField">*</span>客人信息</th>
            <td>
					<span class="tips">
						${bookRule.passengerInfoType.getName()}
					<#--<#if dtoType.passengerInfoType == 'ALL'>
					需要每个客人的信息
					<#elseif dtoType.passengerInfoType == 'ONE'>
					仅需要一位客人信息
					<#else>
					 ${dtoType.passengerInfoType}
					</#if>-->
					</span>
                <#if bookRule.passengerInfoType == 'ALL'>
                    <input id="passengerImportBtn" type="button" class="button" value="从Excel导入客人信息"/>
                    <a href="${base}/resources/excel/import_passenger.xlsx">下载Excel模板</a>
                    <script type="text/javascript">
                        $(function(){
                            var token = getCookie("token");
                            var $message;
                            new AjaxUpload("passengerImportBtn", {
                                action : 'passengerImport.jhtml?token='+token,
                                name : 'file',
                                autoSubmit:true,
                                responseType: "json",
                                onChange: function(file, ext){
                                    if (!(ext && /^(xls|xlsx)$/.test(ext))){
                                        alert("文件格式错误");
                                        return false;
                                    }
                                },
                                onSubmit : function(file, ext) {
                                    $message = $.message({
                                        type:"warn",
                                        content:"导入中...",
                                        timeout:-1
                                    });
                                },
                                onComplete : function(file, response) {
                                    $message.hide();
                                    if (response.type == "success") {
                                        var data = response.data;
                                        var html = [];
                                        for(var i=0;i<data.length;i++){
                                            var item = data[i];
                                            var index = 1+i;
                                            <#assign x = bookRule.needPassengerInfo?split(',')>
                                        html.push(
                                            <@compress single_line = true>
                                                    '<tr>
                                                    <td><i class="warn">'+index+'</i></td>
                                                <#if x?seq_contains('name')>
                                                <td><input name="name_'+index+'" type="text" class="text required" value="'+item.name+'" /></td>
                                                </#if>
                                                <#if x?seq_contains('pinyin')>
                                                        <td><input name="pinyin_'+index+'" type="text" class="text required" value="'+item.pinyin+'" /></td>
                                                </#if>
                                                <#if x?seq_contains('mobile')>
                                                        <td><input name="mobile_'+index+'" type="text" class="text required isMobile" value="'+item.mobile+'" /></td>
                                                </#if>
                                                <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                                                        <td>
                                                        <select name="credentialsType_'+index+'" class="required">
                                                    <#if x?seq_contains('Idcard')>
                                                            <option value="Idcard" '+(item.credentialsType=='Idcard'?'selected':'')+'>身份证</option>
                                                    </#if>
                                                    <#if x?seq_contains('Passport')>
                                                    <option value="Passport" '+(item.credentialsType=='Passport'?'selected':'')+'>护照</option>
                                                    </#if>
                                                    <#if x?seq_contains('TaiwanPermit')>
                                                    <option value="TaiwanPermit" '+(item.credentialsType=='TaiwanPermit'?'selected':'')+'>台胞证</option>
                                                    </#if>
                                                    <#if x?seq_contains('HKAndMacauPermit')>
                                                    <option value="HKAndMacauPermit" '+(item.credentialsType=='HKAndMacauPermit'?'selected':'')+'>港澳通行证</option>
                                                    </#if>
                                                </select>
                                                <input name="credentials_'+index+'" type="text" class="text required" value="'+item.credentials+'" />
                                                </#if>
                                                    </td>
                                                    </tr>');
                                            </@compress>
                                        }
                                        $("#passengerInfoTable tr:gt(0)").remove();
                                        $("#passengerInfoTable").append(html.join(''));
                                    } else {
                                        $.message(response);
                                    }
                                }
                            });
                        })
                    </script>
                </#if>
                <hr/>
                <#assign x = bookRule.needPassengerInfo?split(',')>
                <table id="passengerInfoTable" class="input">
                    <tr class="title">
                        <td></td>
                        <#if x?seq_contains('name')>
                            <td>姓名</td>
                        </#if>
                        <#if x?seq_contains('pinyin')>
                            <td>姓名拼音</td>
                        </#if>
                        <#if x?seq_contains('mobile')>
                            <td>手机号码</td>
                        </#if>
                        <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                            <td>证件号码</td>
                        </#if>
                    </tr>
                    <tr>
                        <td><i class="warn">1</i></td>
                        <#if x?seq_contains('name')>
                            <td><input name="name_1" type="text" class="text required" /></td>
                        </#if>
                        <#if x?seq_contains('pinyin')>
                            <td><input name="pinyin_1" type="text" class="text required" /></td>
                        </#if>
                        <#if x?seq_contains('mobile')>
                            <td><input name="mobile_1" type="text" class="text required isMobile" /></td>
                        </#if>
                        <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                        <td>
                            <select name="credentialsType_1" class="required">
                                <#if x?seq_contains('Idcard')>
                                    <option value="Idcard">身份证</option>
                                </#if>
                                <#if x?seq_contains('Passport')>
                                    <option value="Passport">护照</option>
                                </#if>
                                <#if x?seq_contains('TaiwanPermit')>
                                    <option value="TaiwanPermit">台胞证</option>
                                </#if>
                                <#if x?seq_contains('HKAndMacauPermit')>
                                    <option value="HKAndMacauPermit">港澳通行证</option>
                                </#if>
                            </select>
                            <input name="credentials_1" type="text" class="text required" />
                        </#if>
                    </td>
                    </tr>
                </table>
            </td>
        </tr>
    </#if>
    <@shiro.hasAnyRoles name="admin,supplier">
        <tr>
            <th>
                <span class="requiredField">*</span>订单来源:
            </th>
            <td>
                <select name="orderSourceId">
                    <option value="">请选择</option>
                    <#list orderSources as orderSource>
                        <option value="${orderSource.id}">${orderSource.name}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </@shiro.hasAnyRoles>
    <@shiro.hasAnyRoles name="distributor,distributor2">
        <tr>
            <th>
                <span class="requiredField">*</span>支付方式:
            </th>
            <td>
                <#list paymentMethods as paymentMethod>
                    <label><input type="radio" name="paymentMethod" value="${paymentMethod!}"/>${paymentMethod.getName()}</label>
                </#list>
            </td>
        </tr>
    </@shiro.hasAnyRoles>
        <input name="smsTemplateId" type="hidden" value="${dto.smsTemplateId!}"/>
        <tr>
            <th>
                备注:
            </th>
            <td>
                <textarea name="remark" class="text" maxlength="4000"></textarea>
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