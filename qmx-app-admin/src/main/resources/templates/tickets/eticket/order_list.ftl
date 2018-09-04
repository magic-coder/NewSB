<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>订单列表</title>
    <link href="${base}/resources/assets/bootstrap/css/bootstrap-modify.css" rel="stylesheet"/>
    <link href="${base}/resources/module/system/css/bootstrap-tags.css" rel="stylesheet" />
    <!--<link href="css/bootstrap.min.css" rel="stylesheet" />-->
    <link href="${base}/resources/assets/bootstrap-select/css/bootstrap-select.css" rel="stylesheet"/>
    <link href="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.css" rel="stylesheet"/>
    <link href="${base}/resources/common/css/qmx-gds.css" rel="stylesheet"/>
	<#include "/include/common_header_include.ftl">
    <script type="text/javascript" src="${base}/resources/assets/bootstrap/js/bootstrap.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${base}/resources/assets/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
    <!--[if lt IE 9]>
	<script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	<script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="${base}/resources/module/system/js/bootstrap-select.js"></script>
    <script src="${base}/resources/module/system/js/bootstrap-tags.js"></script>
</head>
<body class="gds">
<div class="container-fluid">
    <!--验证-->
    <div class="gds-validate">
        <div class="input-group">
            <input name="eticketNo" type="text" class="form-control" placeholder="输入电子票号/手机号验证">
            <span class="input-group-btn">
		        <button id="doQueryOrder" class="btn btn-default" type="button">验证</button>
            </span>
        </div>
    </div>
    <!--搜索-->
    <form class="form-inline" action="list">
    <#if queryDto.supplierFlag??>
        <input type="hidden" name="supplierFlag" value="${(queryDto.supplierFlag?string("true","false"))!}"/>
    <#else>
        <input type="hidden" name="supplierFlag" />
    </#if>
        <div id="flex" class="gds-search flex-2">
            <div class="row">
                <div class="form-group">
                    <label for="exampleInputName2">电子票号</label>
                    <input type="text" value="${(queryDto.contactMobile)!}" name="contactMobile" class="form-control gds-input" placeholder="电子票号/手机号">
                </div>
                <div class="form-group">
                    <label>产品</label>
                    <input type="text" value="${(snAndName)!}" name="snAndName" class="form-control gds-input" placeholder="门票名称/编码">
                </div>
                <div class="form-group">
                    <label>订单号</label>
                    <input type="text" value="${queryDto.id!}" name="id" class="form-control gds-input" placeholder="输入18位本系统订单号">
                </div>
                <!--折叠-->
            <#if flagCollapsedx?? && flagCollapsedx =='true'>
                <#assign flagCollapsed = true/>
            <#else>
                <#assign flagCollapsed = false/>
            </#if>
                <input type="hidden" name="flagCollapsed" value="${flagCollapsed?string("true","false")}"/>
                <div class="gds-group">
                    <span class="gds-search-more  <#if !flagCollapsed>collapsed</#if>" data-toggle="collapse" data-parent="#flex" href="#searchMore" aria-expanded="<#if flagCollapsed>true<#else>false</#if>"></span>
                </div>
            </div>

            <div id="searchMore" class="collapse <#if flagCollapsed>in</#if>">
                <div class="row">
                    <div class="form-group">
                        <label>游玩日期</label>
                        <input type="text" value="${(queryDto.useDate)!}" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd" name="useDate" class="form-control gds-input" placeholder="游玩日期">
                    </div>
                    <div class="form-group">
                        <label>消费日期起</label>
                        <input type="text" value="${(queryDto.consumeTimeStart)!}" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd" name="consumeTimeStart" class="form-control gds-input" placeholder="消费日期起">
                    </div>
                    <div class="form-group">
                        <label>消费日期止</label>
                        <input type="text" value="${(queryDto.consumeTimeEnd)!}" data-date-format="yyyy-mm-dd" data-link-format="yyyy-mm-dd" name="consumeTimeEnd" class="form-control gds-input" placeholder="消费日期止">
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>游客姓名</label>
                        <input type="text" value="${(queryDto.contactName)!}" name="contactName" class="form-control gds-input" placeholder="游客姓名">
                    </div>
                    <div class="form-group">
                        <label>销售人</label>
                        <input type="text" value="${(queryDto.createAccount)!}" name="createAccount" class="form-control gds-input" placeholder="销售人">
                    </div>
                    <div class="form-group">
                        <label>检票人</label>
                        <input type="text" value="${(queryDto.checkAccount)!}" name="checkAccount" class="form-control gds-input" placeholder="检票人">
                    </div>
                </div>
                <div class="row">
					<#if currentMember.userType == 'admin'>
						<div class="form-group">
							<label>景点</label>
							<select name="sightId" class="selectpicker" data-live-search="true">
								<option value="">请选择</option>
								<#if sightList??>
									<#list sightList as sight>
										<option <#if queryDto??&& queryDto.sightId?? && queryDto.sightId == sight.id>selected</#if> value="${sight.id!}">${sight.sightName!}</option>
									</#list>
								</#if>
							</select>
						</div>
					</#if>
                    <div class="form-group">
                        <label>订单来源</label>
                        <select class="selectpicker" name="orderSourceId">
                            <option value="">请选择</option>
						<#if orderSources??>
							<#list orderSources as os>
                                <option value="${ps!}" value="${ps!}" <#if queryDto.orderSourceId?? && queryDto.orderSourceId=os.id>selected</#if>>${os.name!}</option>
							</#list>
						</#if>
                        </select>
                    </div>
					<div class="form-group">
						<label>外平台订单号</label>
						<input type="text" value="${(queryDto.outSn)!}" name="outSn" class="form-control gds-input" placeholder="外平台订单号">
					</div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>支付状态</label>
                        <select class="selectpicker" name="payStatus">
                            <option value="">选择支付状态</option>
						<#list payStatusList as ps>
                            <option value="${ps!}" <#if queryDto.payStatus?? && queryDto.payStatus =ps >selected</#if>>${ps.getName()!}</option>
						</#list>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>支付方式</label>
                        <select class="selectpicker" name="paymentMethod">
                            <option value="">请选择</option>
						<#list payMethodList as ps>
                            <option value="${ps!}" <#if queryDto.payMethod?? && queryDto.payMethod = ps>selected</#if>>${ps.getName()!}</option>
						</#list>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>退款状态</label>
                        <select class="selectpicker" name="refundStatus">
                            <option value="">请选择</option>
						<#list refundStatusList as ps>
                            <option value="${ps!}" <#if queryDto.refundStatus?? && queryDto.refundStatus = ps>selected</#if>>${ps.getName()!}</option>
						</#list>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>发货状态</label>
                        <select class="selectpicker" name="shippingStatus">
                            <option value="">请选择</option>
						<#list shippingStatusList as ps>
                            <option value="${ps!}" <#if queryDto.shippingStatus?? && queryDto.shippingStatus == ps>selected</#if>>${ps.getName()!}</option>
						</#list>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>交易场景</label>
                        <select class="selectpicker" name="saleChannel">
                            <option value="">请选择</option>
						<#if saleChannels??>
							<#list saleChannels as ps>
                                <option value="${ps!}" <#if queryDto.saleChannel?? && queryDto.saleChannel = ps>selected</#if>>${ps.getName()!}</option>
							</#list>
						</#if>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>部分退款订单</label>
                        <select class="selectpicker" name="partRefundFlag">
                            <option value="">请选择</option>
                            <option value="true" <#if queryDto.partRefundFlag?? && queryDto.partRefundFlag>selected</#if>>是</option>
                            <option value="false" <#if queryDto.partRefundFlag?? && !queryDto.partRefundFlag>selected</#if>>否</option>
                        </select>
                    </div>
                    <div class="gds-group">
                        <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                        <a href="" class="btn btn-default gds-btn-1">重置</a>
                    </div>
                </div>
            </div>
            <#--<div class="row">
                <div class="form-group">
                    <label>快速查询</label>
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn gds-state-btn focus">今日</button>
                        <button type="button" class="btn gds-state-btn">近7日</button>
                        <button type="button" class="btn gds-state-btn">近30日</button>
                    </div>
                </div>
                <div class="gds-group">
                    <button type="submit" class="btn btn-default gds-btn-1">查询</button>
                    <a href="" class="btn btn-default gds-btn-1">重置</a>
                </div>
            </div>-->
        </div>
    <!--选项卡-->
    <div class="gds-container">
        <ul id="myTab" class="nav nav-tabs">
            <li <#if !queryDto.supplierFlag??>class="active"</#if>>
                <a href="#all" data-toggle="tab">全部记录</a>
            </li>
		<#if currentMember.userType != 'distributor'>
            <li <#if queryDto.supplierFlag?? && !queryDto.supplierFlag>class="active"</#if>>
                <a href="#self" data-toggle="tab">自营记录</a>
            </li>
            <li <#if queryDto.supplierFlag?? && queryDto.supplierFlag>class="active"</#if>>
                <a href="#cooperate" data-toggle="tab">合作记录</a>
            </li>
		</#if>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active">
                <table class="table gds-table table-bordered"">
                <tr>
                    <th>姓名 / 手机号</th>
                    <th>订单编号</th>
                    <th>产品编码 / 产品</th>
                    <th>价格*张数=</th>
                    <th>购买时间</th>
                    <th>消费时间</th>
                    <th>订单有效期</th>
                    <th>状态</th>
                    <th>同步状态</th>
                    <th>操作</th>
                </tr>
            <#list page.records as order>
                <tr>
                    <td>${order.contactName!}<br/>${order.contactMobile!}</td>
                    <td>内：${order.id!}<#if order.outSn??><br />外：${order.outSn!}</#if></td>
                    <td>${order.productSn!}<br />${order.productName!}</td>
                    <td>${order.salePrice?string("0.00")} * ${order.quantity!} = ${order.totalAmount?string("0.00")}</td>
                    <td>${order.createTime?date}<br />${order.createTime?time}</td>
                    <td><#if order.consumeDate??>${order.consumeDate?date}</#if><br /><#if order.consumeDate??>${order.consumeDate?time}</#if></td>
                    <td>
                        <#if order.vsdate == order.vedate>
                        ${order.vsdate!}当天
                        <#else>
                        ${order.vsdate!}<br />~<br/>${order.vedate!}
                        </#if>
                    </td>
                    <td>消费${order.consumeQuantity!}张<br/>	退款${order.returnQuantity!}张<br/>申请退款${order.returningQuantity!}张</td>
                    <td>
                        <span class="text-muted"><#if order.offLineStatus == 'No'>线上<#else>线下</#if></span><br />
                        <span class="text-muted">
                            <#if order.offLineStatus != 'No'>
                                <#if order.offLineStatus == 'NotSynchronized'>未同步<#else>已同步</#if>
                            </#if>
                        </span>
                    </td>
                    <td>

                    </td>
                </tr>
            </#list>
                </table>
            </div>
        </div>
        <!--分页-->
    <#include "/include/pagination_new.ftl">
        </form>
    </div>
    <script>
        $(function () {
            //$('#myTab li:eq(0) a').tab('show');
            $('a[href="#all"]').click(function (e) {
                $("input[name=supplierFlag]").val(null);
                $("form").submit();
            });
            $('a[href="#self"]').click(function (e) {
                //e.preventDefault();
                $("input[name=supplierFlag]").val(false);
                $("form").submit();
            });
            $('a[href="#cooperate"]').click(function (e) {
                $("input[name=supplierFlag]").val(true);
                $("form").submit();
            });
            $('span[href="#searchMore"]').click(function () {
                var flag = $(this).attr("aria-expanded");
                if(flag == 'true'){
                    $("input[name=flagCollapsed]").val(false)
                }else{
                    $("input[name=flagCollapsed]").val(true)
                }
            });

            $("#doQueryOrder").click(function () {
                var eticket = $("input[name=eticketNo]");
                if(eticket.val() == null || eticket.val() == ''){
                    alert('电子票号不能为空');
                    eticket.focus();
                    return;
                }
                layer.open({
                    type: 2,
                    title: '电子票列表',
                    area: ['880px', '600px'], //宽高
                    fix: true, //固定
                    content: 'queryUnConsumeList?sn='+eticket.val()
                });
            });

            //使用日期
            $('input[name=useDate]').datetimepicker({
                language:  'zh-CN',
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            });

            //下单起
            $('input[name=consumeTimeStart]').datetimepicker({
                language:  'zh-CN',
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            }).on('change',function(ev){
                var startDate = $('input[name=consumeTimeStart]').val();
                $("input[name=consumeTimeEnd]").datetimepicker('setStartDate',startDate);
                //$("#startDate").datetimepicker('hide');
            });

            //下单止
            $('input[name=consumeTimeEnd]').datetimepicker({
                language:  'zh-CN',
                //startDate: new Date(),
                weekStart: 1,
                todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0
            }).on('change',function(ev){
                var returnDate = $("input[name=consumeTimeEnd]").val();
                $("input[name=consumeTimeStart]").datetimepicker('setEndDate',returnDate);
                //$("#returnDate").datetimepicker('hide');
            });
        });
    </script>
</body>
</html>