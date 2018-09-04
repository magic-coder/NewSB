<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>添加订单</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    <script type="text/javascript">

        /**
         * 计算总价
         */
        function calcTotalPrice(price,quantity) {
            var totalPrice = quantity * price;
            $("#salePrice").val(price);
            $("#totalPrice").text(totalPrice.toFixed(2));
        }

        layui.use(['form','table','laydate'], function(){
            var table = layui.table,form = layui.form;
            var pindex = parent.layer.getFrameIndex(window.name); //获取窗口索引

            $("input[name=quantity]").bind("input propertychange change", function (event) {
                var quantity = $(this).val();
                if(quantity <= 0){
                    $(this).val('1')
                }else if(quantity >= 999){
                    $(this).val('999')
                }
                <#if distribution??>
                    var $price = $("#settlePrice").text();
                <#else>
                    var $price = $("input[name=salePrice]").val();
                </#if>
                console.info($price);
                calcTotalPrice($price,quantity);
            });

            <#if distribution??>
            <#-- 分销商-->
                var prices = {<#list distribution.distributionPrices as price>'${price.useDate}':${price.authPrice},</#list>};
                <#if distribution.cannotUseDays??>
                    var disabledDates = [<#list distribution.cannotUseDays?split(",") as price>'${price}',</#list>];
                <#else>
                    var disabledDates = [];
                </#if>
                <#if distribution.specifyDate>
                    <#assign vsDate = distribution.vsdate/>
                    <#if vsDate?date lt .now?date>
                        <#assign vsDate = .now/>
                    </#if>

                    $('input[name=useDate]').datetimepicker({
                        language:  'zh-CN',
                        startDate: '${vsDate!}',
                        endDate:'${distribution.vedate!}',
                        weekStart: 1,
                        datesDisabled:disabledDates,
                        todayBtn:  0,
                        autoclose: 1,
                        todayHighlight: 1,
                        startView: 2,
                        minView: 2,
                        forceParse: 0
                    }).on('change',function(ev){
                        var date = $(this).val();
                        console.info(date);
                        var datePrice = prices[date];
                        var quantity = $("input[name=quantity]").val();
                        if(datePrice == undefined){
                            $("#settlePrice").text("0.00");
                            datePrice = 0;
                        }else{
                            $("#settlePrice").text(datePrice.toFixed(2));
                        }
                        calcTotalPrice(datePrice,quantity);
                    });
                <#else>
                    var datePrice = ${distribution.authPrice!'0'};
                    var quantity = $("input[name=quantity]").val();
                    if(datePrice == undefined){
                        $("#settlePrice").text("0.00");
                        datePrice = 0;
                    }else{
                        $("#settlePrice").text(datePrice.toFixed(2));
                    }
                    calcTotalPrice(datePrice,quantity);
                </#if>
            <#else>
                $('input[name=vsdate]').datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                }).on('change',function(ev){
                    var startDate = $('input[name=vsdate]').val();
                    $("input[name=vedate]").datetimepicker('setStartDate',startDate);
                    //$("#startDate").datetimepicker('hide');
                });

                $('input[name=vedate]').datetimepicker({
                    language:  'zh-CN',
                    startDate: new Date(),
                    weekStart: 1,
                    todayBtn:  1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    minView: 2,
                    forceParse: 0
                }).on('change',function(ev){
                    var returnDate = $("input[name=vedate]").val();
                    $("input[name=vsdate]").datetimepicker('setEndDate',returnDate);
                    //$("#returnDate").datetimepicker('hide');
                });

                $("input[name='salePrice']").change(function () {
                    var quantity = $("input[name=quantity]").val();
                    calcTotalPrice($(this).val(),quantity)
                });
            </#if>

            //监听提交
            form.on('submit(submitAddOrder)', function(data){

                var method = $("select[name='paymentMethod']").val();
                if(method == 'OFFLINE_PAY' || method == 'DEPOSIT' || method == 'DEPOSIT_CREDIT'){
                    var flag = window.confirm("是否发送短信？");
                    if(flag){
                        $("input[name='sendSms']").val('true')
                    }else{
                        $("input[name='sendSms']").val('false')
                    }
                }

                layer.load(2, {time: 16*1000}); //设定最长等待10秒

                var d = {};
                var t = $('form').serializeArray();
                $.each(t, function() {
                    d[this.name] = this.value;
                });
                $("#btnSubmitAddOrder").text("提交中...");
                $("#btnSubmitAddOrder").attr("disabled",true);
                $("form").submit();
                return true;
            });

        <#if bookRule.passengerInfoType == 'ALL'>
            //需要每个顾客信息
            $("input[name=quantity]").bind("input propertychange change", function (event) {
                var quantity = $(this).val();
                if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
                    if ($(".passengerInfo").length > quantity) {
                        $(".passengerInfo:gt(" + (quantity - 1) + ")").remove();
                    } else {
                        var html = [];
                        var index = $(".passengerInfo").length;
                        for (var i = 0; i < quantity - $(".passengerInfo").length; i++) {
                            index = index + 1;
                            <#assign x = bookRule.needPassengerInfo?split(',')>
                            <@compress single_line = true>
                                html.push('<div class="row passengerInfo">' +
                                        '<div class="col-xs-2 col-sm-2"><span class="modal-rank">' + index + '</span></div>' +
                                            <#assign x = bookRule.needPassengerInfo?split(',')>
                                            <#if x?seq_contains('name')>
                                            '<div class="col-xs-4 col-sm-4"><input name="name_' + index + '" type="text" class="form-control" style="width: 100%;"/></div>' +
                                            </#if>
                                            <#if x?seq_contains('mobile')>
                                            '<div class="col-xs-4 col-sm-4"><input name="mobile_' + index + '" type="text" class="form-control" style="width: 100%;"/></div>' +
                                            </#if>
                                            <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                                            '<div class="col-xs-6 col-sm-6" style="width: auto">' +
                                            '<select name="credentialsType_' + index + '" class="form-control" style="width: auto">' +
                                                <#if x?seq_contains('Idcard')>
                                                '<option value="Idcard">身份证</option>' +
                                                </#if>
                                                <#if x?seq_contains('Passport')>
                                                '<option value="Passport">护照</option>' +
                                                </#if>
                                                <#if x?seq_contains('TaiwanPermit')>
                                                '<option value="TaiwanPermit">台胞证</option>' +
                                                </#if>
                                                <#if x?seq_contains('HKAndMacauPermit')>
                                                '<option value="HKAndMacauPermit">港澳通行证</option>' +
                                                </#if>
                                            '</select>' +
                                            '<input maxlength="20" name="credentials_' + index + '" type="text" class="form-control" style="width: auto"/>' +
                                            '</div>' +
                                            </#if>
                                        '</div>');
                            </@compress>
                        }
                        $("#passengerInfoDiv").append(html.join(''));
                    }
                }
            });
        <#elseif bookRule.passengerInfoType == 'ONE'>
            //仅需要一位顾客信息
        </#if>

        });


    </script>
</head>
<body class="gds gds-modal">
<form id="inputForm" action="saveTicketsOrder" method="post">
    <input type="hidden" name="productId" value="${dto.id!?c}">
    <input type="hidden" name="sendSms" value="false">
    <div class="gds-modal-content">
        <div class="reserve-iframe">
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-10">门票名称：<span>${dto.name!}(${dto.sn!})</span></div>
                    <#if distribution??>
                        <#if !distribution.specifyDate>
                            <input type="hidden" name="salePrice" id="salePrice" value="${distribution.authPrice!}"/>
                            <div class="col-sm-10">单价：<span class="text-primary"  id="settlePrice">${distribution.authPrice?string("##.##")}</span>元</div>
                        <#else>
                            <input type="hidden" name="salePrice" id="salePrice" />
                            <div class="col-sm-10">单价：<span class="text-primary" id="settlePrice">0.00</span>元</div>
                        </#if>
                    </#if>
                </div>
                <div class="row">
                    <div class="col-sm-10">预定限制：
                        <span class="text-muted">
                        <#if bookRule.bookLimitType == 'NO_LIMIT'>
                            无需提前预定
                        <#elseif bookRule.bookLimitType == 'ADVANCE_BOOK_TIME'>
                            <#if bookRule.bookAdvanceDay == 0>
                                当天
                            <#else>
                                使用前 ${bookRule.bookAdvanceDay!} 天
                            </#if>
                        ${bookRule.bookAdvanceHour!}:${(bookRule.bookAdvanceMinute!?string('00'))!'00'} 之前预订
                        <#elseif bookRule.bookLimitType == 'DELAY_BOOK_HOURS'>
                            预订后 ${consumeRule.enterSightDelayBookHour} 小时才能使用
                        <#elseif bookRule.bookLimitType == 'BOOK_LIMIT_TIME_RANGE'>
                            只能在${bookRule.bookTimeRangeStart!}-${bookRule.bookTimeRangeEnd!}之间预定
                        </#if>
                       ,每单最少购买${bookRule.minBuyNum}张，最多购买${bookRule.maxBuyNum!0}张
                        <#if bookRule.perPhoneMaxNum != -1>
                            同一手机号<#if bookRule.phoneLimitDays =-1>每${bookRule.phoneLimitDays}天</#if>最多预定
                        ${bookRule.perPhoneMaxNum}张
                        </#if>
                        <#if bookRule.perIdcardMaxNum != -1>
                            同一身份证号<#if bookRule.idcardLimitDays =-1>每${bookRule.idcardLimitDays}天</#if>最多预定
                        ${bookRule.perIdcardMaxNum}张
                        </#if>
                    </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">退款说明：
                        <span class="text-muted">
                            <#if refundRule.canRefund>可退款
                            ${refundRule.partRefund?string("支持部分退款","不支持部分退款")}
                            <#else>
                                不可退款
                            </#if>
                                /${(refundRule.refundNeedAudit?string('需要审核','不需要审核'))!}
                            <#if refundRule.refundInfo??>
                            ${refundRule.refundInfo?replace("\n", "<br/>")}
                            </#if>
                            <#if refundRule.limitRefundAdvance>
                                <#if refundRule.refundAuditType == 'ADVANCE'>
                                    用有效期截止前的${refundRule.refundAdvanceDay!}天${refundRule.refundAdvanceHour!}点前可退款
                                <#elseif refundRule.refundAuditType == 'AFTER'>
                                    用有效期截止后的${refundRule.refundAfterValidEndDay!}天内可退款
                                </#if>
                            </#if>
                    </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10">使用限制：
                        <span class="text-muted">
                            <#if consumeRule.limitUseTimeRange>
                            该产品只能${consumeRule.useTimeRangeStart!}到${consumeRule.useTimeRangeEnd!}期间使用
                            </#if>
                            <#if consumeRule.enterSightDelayBookHour??>
                                ,预定后${consumeRule.enterSightDelayBookHour}小时才能入园
                            </#if>
                            <#if consumeRule.passType== 'VIRTUAL'>
                                ,凭兑换凭证直接入园
                                <#elseif consumeRule.passType== 'VIRTUAL'>
                                    凭兑换凭证在${consumeRule.pickupAddress!}换票入园
                            </#if>
                        </span>
                    </div>
                </div>
                <div class="row">
                    <#if distribution?? && distribution.specifyDate>
                    <div class="col-sm-10">
                        <div class="form-group">
                            游玩日期：<input type="text" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd" readonly name="useDate" class="form-control" placeholder="选择游玩日期"/>
                        </div>
                    </div>
                    </#if>
                    <div class="col-sm-10">
                        <div class="form-group">
                            预定数量：<input name="quantity" value="1" type="number" class="form-control form-input-number"/>张
                        </div>
                    </div>
                </div>
                <#if !distribution??>
                <div class="row">
                    <div class="col-sm-10">
                        <div class="form-group">
                            销售价格：<input type="text" name="salePrice" onkeyup="this.value=this.value.replace(/[^\d.]/g,'')" value="0.00" class="form-control" placeholder="销售价格"/>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10" style="width: auto;">
                        <div class="form-group">
                            使用有效期：
                            <input name="vsdate" readonly class="form-control" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                            &nbsp;—&nbsp;
                            <input name="vedate" readonly class="form-control" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd"/>
                        </div>
                    </div>
                </div>
                </#if>
            </div>
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">订单联系人信息</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            姓名：<input name="contactName" maxlength="6" type="text" class="form-control form-input-number"/>
                        </div>
                    </div>
                    <div class="col-sm-10">
                        <div class="form-group">
                            手机号：<input name="contactMobile" maxlength="11" type="text" class="form-control"/>
                        </div>
                    </div>
                </div>
            </div>
        <#if bookRule.passengerInfoType != 'NONE'>
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">游玩人信息</h4>
            </div>
            <div class="modal-body">
                <div class="modal-table">
                    <div class="row">
                        <div class="col-xs-2 col-sm-2">&nbsp;</div>
                        <#assign x = bookRule.needPassengerInfo?split(',')>
                        <#if x?seq_contains('name')>
                            <div class="col-xs-4 col-sm-4">姓名</div>
                        </#if>
                        <#if x?seq_contains('mobile')>
                            <div class="col-xs-4 col-sm-4">手机号</div>
                        </#if>
                        <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                            <div class="col-xs-6 col-sm-6" style="width: auto">证件号码</div>
                        </#if>
                    </div>
                    <div id="passengerInfoDiv">
                        <div class="row passengerInfo">
                            <div class="col-xs-2 col-sm-2">
                                <span class="modal-rank">1</span>
                            </div>
                            <#assign x = bookRule.needPassengerInfo?split(',')>
                            <#if x?seq_contains('name')>
                                <div class="col-xs-4 col-sm-4">
                                    <input name="name_1" type="text" class="form-control" style="width: 100%;"/>
                                </div>
                            </#if>
                            <#if x?seq_contains('mobile')>
                                <div class="col-xs-4 col-sm-4">
                                    <input name="mobile_1" type="text" class="form-control" style="width: 100%;"/>
                                </div>
                            </#if>
                            <#if x?seq_contains('Idcard') || x?seq_contains('Passport') || x?seq_contains('TaiwanPermit') || x?seq_contains('HKAndMacauPermit')>
                                <div class="col-xs-6 col-sm-6" style="width: auto">
                                    <select name="credentialsType_1" class="form-control" style="width: auto">
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
                                    <input name="credentials_1" maxlength="20" type="text" class="form-control" style="width: auto"/>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>
        </#if>
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">其它</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                <#if orderSources??>
                    <div class="col-sm-10">
                        <div class="form-group">
                            订单来源：
                            <select name="orderSourceId" class="selectpicker">
                                <#list orderSources as orderSource>
                                    <option value="${orderSource.id?c}">${orderSource.name}</option>
                                </#list>
                            </select>
                        </div>
                    </div>
                </#if>
                    <div class="col-sm-10">
                        <div class="form-group">
                            支付方式：
                            <select class="selectpicker" name="paymentMethod">
                            <#list paymentMethods as paymentMethod>
                                <option value="${paymentMethod}">${paymentMethod.getName()}</option>
                            </#list>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-sm-20">
                        备注：<input type="text" name="remark" class="form-control" style="width: 80%;">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <span class="modal-balance">总金额：￥<span id="totalPrice">0.00</span></span>
                <button id="btnSubmitAddOrder" type="button" lay-submit lay-filter="submitAddOrder" class="btn btn-warning">确认下单</button>
            </div>
        </div>
    </div>
</form>
</body>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${base}/resources/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${base}/resources/assets/bootstrap-select/js/bootstrap-select.js"></script>
</html>