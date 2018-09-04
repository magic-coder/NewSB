<form id="refundAmnoutForm" action="" method="post">
	<input type="hidden" name="token" value="${token}" />
	<input type="hidden" name="orderId" value="${orderId!}" />
	<div style="height: 110px;">
		<table class="input" style="margin-bottom: 30px;">
			<tr>
				<th>&nbsp;</th>
				<td>&nbsp;</td>
				<th>&nbsp;</th>
			</tr>
			<tr>
				<th align="left">退款金额:</th>
				<td align="left"><input id="refundAmnout" type="text" style="width:100px;" name="amount" class="text"
					 /></td>
					<th>&nbsp;</th>
			</tr>
		</table>
	</div>
</form>