<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>机构信息</title>
<meta name="decorator" content="org" />
</head>
<body>
	<div class="mainTitle mt30">账号维护</div>
	<div class="w1000">
		<div class="contentSub pt30">
			<table class="yui-table proAccount tac" data-zebra="odd">
				<tr>
					<th>登录用户姓名</th>
					<th width='140px'>账户类型</th>
					<th width='240px'>用户邮箱</th>
					<th>用户手机号</th>
					<th>状态</th>
					<th width='100px'>操作</th>
				</tr>
				<c:forEach items="${userList}" var="user">
				<tr>
					<td>${user.name}</td>
					<td>${fns:getDictLabel(user.userType, 'sys_user_type', '')}</td>
					<td>${user.email}</td>
					<td>${user.mobile}</td>
					<td>${fns:getDictLabel(user.loginFlag, 'login_flag', '')}</td>
					<td>
						<c:choose>
							<c:when test="${user.userType == 'FADM'}">
								-
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${user.loginFlag == '0'}">
										<a href="javascript:void(0)" class="fwb operateBtn" onclick="update('${user.id}',1)">解冻</a>
									</c:when>
									<c:otherwise>
										<a href="javascript:void(0)" class="fwb operateBtn" onclick="update('${user.id}',0)">冻结</a>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>	
				</c:forEach>				
			</table>
			<a href="${ctxFront}/organizationInfo/addUser?module=3" class="btn-style-a db mt50 w340 mgCenter">添加机构账号</a>
		</div>
	</div>
<script type="text/javascript">
	function update(userId,loginFlag) {
		$.ajax({
    		url: "${ctxFront}/organizationInfo/updateUser",
			type: "post",
			cache: false,
			dataType: "json",
			data:{"userId":userId,"loginFlag":loginFlag},
	        success:function(resp){  
	            if(resp.sucFlag == "1"){  
	            	layer.msg('操作成功!', {icon: 1,time: 1000,end: function(){
	                		window.location.href = "${ctxFront}/organizationInfo/userList?module=3";
	                	}
	                });  
	            }else{  
	                layer.alert(resp.message, {icon: 0});  
	            }  
	        },  
	        error:function(data) {
				layer.alert(data.responseText, {icon: 5, area: '500px'});  
			}
    	});
	}
</script>
	
</body>
</html>