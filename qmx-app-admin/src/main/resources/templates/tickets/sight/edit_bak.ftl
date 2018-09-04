<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>编辑景区</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/ajaxupload.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/image.js"></script>
<link href="${base}/resources/admin/css/ext.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/openMap.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $areaId = $("#areaId");
	
	// 地区选择
	$areaId.lSelect({
        url: "${base}/common/area"
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: {
				required: true
			},
			type: {
				required: true
			},
			areaId: {
				required: true
			},
			principal: {
				required: true
			},
			biz: {
				required: true
			},
			address: {
				required: true
			},
			longitude: {
				required: true
			},
			latitude: {
				required: true
			},
			orderPhone: {
				required: true
			},
			sightType: {
				required: true
			},
			sightLevel: {
				required: true
			},
			image: {
				required: true
			},
			focusimagepath: {
				required: true
			}
		},
		messages: {
			focusimagepath: {
				required: "至少上传一张图片"
			}
		}
	});
	
	$(".uploadImageButton").each(function(){
		var $this = $(this);
		new AjaxUpload($this, {
            action : '${base}/file/upload?fileType=image&token='+getCookie("token"),
			name : 'file', 
			autoSubmit:true,
			responseType: "json",
			onChange: function(file, ext){
				if (!(ext && /^(jpg|png|gif|jpeg|bmp)$/.test(ext))){
					 alert("上传文件格式错误");
					 return false;
				 }
			},
			onSubmit : function(file, ext) {
				$this.text("正在上传...");
				$this.attr("disabled", true);
			},
			onComplete : function(file, response) {
				$this.text("上传");
				$this.attr("disabled", false);
				if(response){
					var filepath = response.url;
					$this.prev().val(filepath);
				}
			}
		});
	});

});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			编辑景区
	    </div>
	</div>
	<form id="inputForm" action="update.jhtml" method="post">
		<input type="hidden" name="id" value="${sightInfo.id}" />
		<input type="hidden" name="code" value="${sightInfo.code!}" />
		<table class="input">
			<tr>
				<th>
					<span class="requiredField">*</span>景区名称:
				</th>
				<td>
					<input type="text" name="sightName" class="text" value="${sightInfo.sightName}" maxlength="300" style="width: 300px;" />
				</td>
			</tr>
			<tr>
				<th>
				<input name="type" type="hidden" value="sight" />
					<span class="requiredField">*</span>地区:
				</th>
				<td>
					<span class="fieldSet">
						<input type="hidden" id="areaId" name="areaId" value="${(sightInfo.areaId)!}" treePath="${(sightInfo.area.treePath)!}" />
					</span>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>详细地址:
				</th>
				<td>
					<input type="text" name="address" class="text" value="${sightInfo.address}" maxlength="200" />
				</td>
			</tr>
			<tr>
				<th>
					景区图片:
				</th>
				<td>
					<div class="productImageArea">
						<div class="example"></div>
						<a class="prev browse" href="javascript:void(0);" hidefocus="true"></a>
						<div class="scrollable">
							<ul class="items">
								<#list sightImages as productImage>
									<li>
										<div class="productImageBox">
											<div class="productImagePreview png">
												<img src="${(productImage)!}" />
											</div>
											<input type="hidden" name="focusimagepath" value="${(productImage)!}" />
											<div class="productImageOperate">
												<a class="left" href="javascript:;" alt="左移" hidefocus="true"></a>
												<a class="right" href="javascript:;" title="右移" hidefocus="true"></a>
												<a class="delete" href="javascript:;" title="删除" hidefocus="true"></a>
											</div>
											<a class="productImageUploadButton" href="javascript:;">
												<div>上传新图片</div>
											</a>
										</div>
									</li>
								</#list>
									<li>
										<div class="productImageBox">
											<div class="productImagePreview png">暂无图片</div>
											<input type="hidden" name="focusimagepath" value="" />
											<div class="productImageOperate">
												<a class="left" href="javascript:;" alt="左移" hidefocus="true"></a>
												<a class="right" href="javascript:;" title="右移" hidefocus="true"></a>
												<a class="delete" href="javascript:;" title="删除" hidefocus="true"></a>
											</div>
											<a class="productImageUploadButton" href="javascript:;">
												<div>上传新图片</div>
											</a>
										</div>
									</li>
							</ul>
						</div>
						<a class="next browse" href="javascript:void(0);" hidefocus="true"></a>
					</div>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>景区级别:
				</th>
				<td>
					<select name="sightLevel">
						<option value="0"/>无</option>
						<option value="1"/>A</option>
						<option value="2"/>AA</option>
						<option value="3"/>AAA</option>
						<option value="4"/>AAAA</option>
						<option value="5"/>AAAAA</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>经度:
				</th>
				<td>
					<input type="text" name="longitude" class="text" value="${sightInfo.longitude}" maxlength="50" />
					<button onclick="lookMap(${sightInfo.longitude!0},${sightInfo.latitude!0})" type="button" class="button">标注</button>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>纬度:
				</th>
				<td>
					<input type="text" name="latitude" class="text" value="${sightInfo.latitude}" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>
					营业时间:
				</th>
				<td>
					<input type="text" name="bizHours" class="text" value="${sightInfo.bizHours}" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>预定电话:
				</th>
				<td>
					<input type="text" name="orderPhone" class="text" value="${sightInfo.orderPhone}" maxlength="30" />
				</td>
			</tr>
			<tr>
				<th>
					咨询电话:
				</th>
				<td>
					<input type="text" name="consultPhone" class="text" value="${sightInfo.consultPhone}" maxlength="30" />
				</td>
			</tr>
			<tr>
				<th>
					描述:
				</th>
				<td>
					<textarea name="description" class="text editor">${sightInfo.description?html}</textarea>
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