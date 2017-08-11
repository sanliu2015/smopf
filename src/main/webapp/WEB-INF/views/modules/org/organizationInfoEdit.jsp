<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构信息</title>
	<meta name="decorator" content="org"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css" />
	<script type="text/javascript" src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"></script>
	<script type="text/javascript" src="${ctxStatic}/jquery-form/jquery.form.min.js"></script>
	<script type="text/javascript">
		var orgMobile = "${organMap.adminMobile}";
		var timesOld = 60;
		var timerOld = null;
		var timesNew = 60;
		var timerNew = null;
		
		jQuery.validator.addMethod("isMobile", function(value, element) {
	        var length = value.length;
	        var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
	        return this.optional(element) || (length == 11 && mobile.test(value));
	    }, "手机号格式有误，请重新输入");
		
		$(document).ready(function() {
			$("#oldMobile").bind("click",function(){
	            var $this = $(this);
	            if (timesOld < 60) {
	            	layer.msg('请' + timesOld + '秒后再试！');
	            	return false;
	            } else {
	            	$.ajax({
	            		url: "${ctxFront}/mobile/getMobileCheckCode?busType=oe",
						type: "post",
						cache: false,
						dataType: "json",
						data:{"mobile":orgMobile},
				        success:function(resp){  
				            if(resp.sucFlag == "1"){  
				            	layer.msg('验证码已发送，请注意查收');
				            	// 计时开始
				                timerOld = setInterval(function () {
				                	timesOld--;
				                    if (timesOld <= 0) {
				                        $this.text('获取原手机验证码');
				                        clearInterval(timerOld);
				                        timesOld = 60;
				                    } else {
				                        $this.text(timesOld + '秒');
				                    }
				                }, 1000);
				            }else{  
				                layer.alert(resp.message, {icon: 0});  
				            }  
				        },  
				        error:function(data) {
							layer.alert(data.responseText, {icon: 5, area: '500px'});  
						}
	            	});
	            }
			});
			
			$("#newMobile").bind("click",function(){
				if ($("#contactMobile").val() == orgMobile) {
					layer.msg("手机号未发送变化，无需获取验证码!");
	        		return false;
				}
				var pattern = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
	        	if (!pattern.test($("#contactMobile").val())) {
	        		layer.alert("请填写正确的手机号码!", {icon: 5,end : function(){$("#contactMobile").focus();}}); 
	        		return false;
	        	}
	            var $this = $(this);
	            if (timesNew < 60) {
	            	layer.msg('请' + timesNew + '秒后再试！');
	            	return false;
	            } else {
	            	$.ajax({
	            		url: "${ctxFront}/mobile/getMobileCheckCode?busType=oe",
						type: "post",
						cache: false,
						dataType: "json",
						data:{"mobile":$("#contactMobile").val()},
				        success:function(resp){  
				            if(resp.sucFlag == "1"){  
				            	layer.msg('验证码已发送，请注意查收');
				            	// 计时开始
				                timerNew = setInterval(function () {
				                    timesNew--;
				                    if (timesNew <= 0) {
				                        $this.text('获取验证码');
				                        clearInterval(timerNew);
				                        timesNew = 60;
				                    } else {
				                        $this.text(timesNew + '秒');
				                    }
				                }, 1000);
				            }else{  
				                layer.alert(resp.message, {icon: 0});  
				            }  
				        },  
				        error:function(data) {
							layer.alert(data.responseText, {icon: 5, area: '500px'});  
						}
	            	});
	            }
			});
			
			
			$("#inputForm").validate({
				onkeyup: function(element) {$(element).valid()},// 开启实时验证
				rules:{
					orgName:{
                        required:true
                    },
                    contactName:{
                        required:true
                    },
                    contactEmail:{
                    	required:true,
                        email:true
                    },
                    contactMobile:{
                        required:true,
                        isMobile:true,
                        remote: "${ctxFront}/organizationInfo/checkMobile?id=$('#adminId').val()"
                    },
                    validateCode:{
                        required:true,
                        remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"
                    },
                    mobileCheckCodeOld:{
                        required:true
                    },
                    password:{
                        required:false,
                        rangelength:[6,32]
                    }                
                },
                messages:{
                	contactEmail:{
                        email:"邮箱格式有误，请重新输入"
                    },
                	contactMobile:{
                		remote: "手机号已被注册"
                	},
                    validateCode:{
                    	remote: "验证码不正确"
                    },
                    password:{
                        rangelength: $.format("密码长度必须介于{0}至{1}字符，请重新输入")
                    }                                 
                },
				submitHandler: function(form){
					$('#inputForm').ajaxSubmit({
						url : "${ctxFront}/organizationInfo/save",  
						type : "post",  
						dataType : "json", 
						beforeSerialize : function($form, options) {
							if ($("#contactMobile").val() != orgMobile) {
								if ($("#mobileCheckCodeNew").val() == "") {
									layer.alert('新手机验证码不能为空!', {icon: 0});
									return false;
								}
							}
						},
						beforeSend : function(XMLHttpRequest) {
							layer.load();	// 遮罩
						},
						success:function(responseText, statusText, xhr, $form){
							layer.closeAll('loading');
							if(responseText.sucFlag == 1){  
				                layer.msg('修改成功!', {icon: 1,time: 1000,end : function(){
				                		window.location.href = "${ctxFront}/organizationInfo/index?module=2";
				                	}
				                });  
				            }else{
				            	layer.alert(responseText.message, {icon: 0});  
				            }  
						},
						error:function(data) {
							layer.closeAll('loading');
							layer.alert(data.responseText, {icon: 5, area: ['600px','500px']});  
						}
					});
				},
				errorPlacement: function(error, element) {
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else if (element.attr("id") == "validateCode" || element.attr("id") == "mobileCheckCodeOld" || element.attr("id") == "mobileCheckCodeNew") {
						error.insertAfter(element.parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
		});
	</script>
</head>
<body>
<form:form id="inputForm" modelAttribute="register" action="${ctxFront}/organizationInfo/save" method="post" >
<input type="hidden" name="orgCode" id="orgCode" value="${organMap.orgCode}"/>
<input type="hidden" name="contactMobileOld" id="contactMobileOld" value="${organMap.adminMobile}"/>
<input type="hidden" name="adminId" id="adminId" value="${organMap.adminId}"/>
	<div class="mainTitle mt30">机构信息修改</div>
    <div class="w1000">
	    <div class="contentSub pt30">
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290">组织机构代码：</div>
                <div class="cell-right ml5">
                    <p class="sectionTxt">${organMap.orgCode}</p>
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>机构法定名称：</div>
                <div class="cell-right">
                    <input type="text" name="orgName" id="orgName" class="yui-input w350" value='${organMap.orgName}' placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>公司指定联系人名称：</div>
                <div class="cell-right">
                    <input type="text" name="contactName" id="contactName" class="yui-input w350" value='${organMap.adminName}' placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>公司指定联系人邮箱：</div>
                <div class="cell-right">
                    <input type="text" name="contactEmail" id="contactEmail" class="yui-input w350" value='${organMap.adminEmail}' placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>验证码：</div>
                <div class="cell-right validate">
                	<input type="text" name="validateCode" id="validateCode" class="yui-input w350" placeholder="看不清？点击图片刷新验证码">
                    <img id="checkCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="refreshCode();" alt="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>原手机验证码：</div>
                <div class="cell-right">
                    <input type="text" name="mobileCheckCodeOld" id="mobileCheckCodeOld" class="yui-input w200" maxlength='6' placeholder="6位数字验证码">
                </div>
                <a href="javascript:void(0)" id="oldMobile" class="requestBtn fl w140">获取原手机验证码</a>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290">公司指定联系人手机号：</div>
                <div class="cell-right">
                    <input type="text" name="contactMobile" id="contactMobile" class="yui-input w350" value='${organMap.adminMobile}' placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290">新手机验证码：</div>
                <div class="cell-right">
                    <input type="text" name="mobileCheckCodeNew" id="mobileCheckCodeNew" class="yui-input w200" maxlength='6' placeholder="6位数字验证码">
                </div>
                <a href="javascript:void(0)" id="newMobile" class="requestBtn fl w140">获取验证码</a>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290">新手机密码：</div>
                <div class="cell-right">
                    <input type="password" name="password" id="password" class="yui-input w350" placeholder="密码需为6-32位字符" maxlength="32" minlength="6">
                </div>
            </div>
            <div class="yui-form-cell mt30 clear">
                <div class="cell-left w290">&nbsp;</div>
                <div class="cell-right">
                    <a href="javascript:void(0)" class="btn-style-a db w170" onclick='$("#inputForm").submit();'>保 存</a>
                </div>
            </div>
        </div>
	</div>
</form:form>	
	<script type="text/javascript">
		function refreshCode() {
			$("#checkCode").attr("src", "${pageContext.request.contextPath}/servlet/validateCodeServlet?"+new Date().getTime());
		}
	</script>
</body>
</html>