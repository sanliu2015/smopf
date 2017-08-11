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
		var times = 60;
		var timer = null;
		
		jQuery.validator.addMethod("isMobile", function(value, element) {
	        var length = value.length;
	        var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
	        return this.optional(element) || (length == 11 && mobile.test(value));
	    }, "手机号格式有误，请重新输入");
		
		$(document).ready(function() {
			$("#getMobileCode").bind("click",function(){
				var pattern = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
	        	if (!pattern.test($("#mobile").val())) {
	        		layer.alert("请填写正确的手机号码!", {icon: 5,end : function(){$("#mobile").focus();}}); 
	        		return false;
	        	}
	            var $this = $(this);
	            if (times < 60) {
	            	layer.msg('请' + times + '秒后再试！');
	            	return false;
	            } else {
	            	$.ajax({
	            		url: "${ctxFront}/mobile/getMobileCheckCode?busType=ad",
						type: "post",
						cache: false,
						dataType: "json",
						data:{"mobile":$("#mobile").val()},
				        success:function(resp){  
				            if(resp.sucFlag == "1"){  
				            	layer.msg('验证码已发送，请注意查收');
				            	// 计时开始
				                timer = setInterval(function () {
				                	times--;
				                    if (times <= 0) {
				                        $this.text('获取手机验证码');
				                        clearInterval(timer);
				                        times = 60;
				                    } else {
				                        $this.text(times + '秒');
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
					name:{
                        required:true
                    },
                    email:{
                    	required:true,
                        email:true
                    },
                    mobile:{
                        required:true,
                        isMobile:true,
                        remote: {
                        	type:"POST",
                        	url:"${ctxFront}/register/checkMobileRegister",
                        	data:{
                                mobile:function(){return $("#mobile").val();}
                            } 
                        }
                    },
                    validateCode:{
                        required:true,
                        remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"
                    },
                    mobileValidateCode:{
                        required:true
                    }            
                },
                messages:{
                	email:{
                        email:"邮箱格式有误，请重新输入"
                    },
                	mobile:{
                		remote: "手机号已被注册"
                	},
                    validateCode:{
                    	remote: "验证码不正确"
                    }                              
                },
				submitHandler: function(form){
					$('#inputForm').ajaxSubmit({
						url : "${ctxFront}/organizationInfo/saveUser",  
						type : "post",  
						dataType : "json", 
						beforeSend : function(XMLHttpRequest) {
							layer.load();	// 遮罩
						},
						success:function(responseText, statusText, xhr, $form){
							layer.closeAll('loading');
							if(responseText.sucFlag == 1){  
				                layer.msg('添加成功!', {icon: 1,time: 1000,end : function(){
				                		window.location.href = "${ctxFront}/organizationInfo/userList?module=3";
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
					} else if (element.attr("id") == "validateCode" || element.attr("id") == "mobileValidateCode") {
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
<form:form id="inputForm" method="post" >
	<div class="mainTitle mt30">账号维护>添加</div>
    <div class="w1000">
        <div class="contentSub pt40">
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>登录用户姓名：</div>
                <div class="cell-right">
                    <input type="text" name="name" id="name" class="yui-input w350" placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>用户邮箱：</div>
                <div class="cell-right">
                    <input type="text" name="email" id="email" class="yui-input w350" placeholder="">
                </div>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290"><span class="ml15 red">*</span>用户手机号：</div>
                <div class="cell-right">
                    <input type="text" name="mobile" id="mobile" class="yui-input w350" maxlength="11">
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
                <div class="cell-left w290"><span class="ml15 red">*</span>手机验证码：</div>
                <div class="cell-right">
                    <input type="text" id="mobileValidateCode" name="mobileValidateCode" class="yui-input w200" maxlength='6' placeholder="6位数字验证码">
                </div>
                <a href="javascript:void(0)" class="requestBtn fl w140" id="getMobileCode">获取手机验证码</a>
            </div>
            <div class="yui-form-cell mb5 clear">
                <div class="cell-left w290">初始密码：</div>
                <div class="cell-right ml5">
                    <p class="sectionTxt">用户手机号后六位，请尽快登录重置</p>
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