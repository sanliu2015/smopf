<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>重置密码</title>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/common.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/yui.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/font/iconfont.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/js/keyboard/keyboard.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/style.css" />
    
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css" />
    <script type="text/javascript" src="${ctxStatic}/jquery/jquery-2.2.4.min.js"></script>
    <script type="text/javascript" src="${ctxStatic}/jquery-form/jquery.form.min.js"></script>
    <script type="text/javascript" src="${ctxStatic}/layer/3.0.3/layer.js"></script>
	<script type="text/javascript" src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"></script>
    <script type="text/javascript">
      var ctx = "${ctx}";
      var ctxFront = "${ctxFront}";
      jQuery.validator.addMethod("isMobile", function(value, element) {
        var length = value.length;
        var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        return this.optional(element) || (length == 11 && mobile.test(value));
       }, "手机号格式有误，请重新输入");//可以自定义默认提示信息
		$(document).ready(function() {
			
			$("#inputForm").validate({
				onkeyup: function(element) {$(element).valid()},// 开启实时验证
				rules:{
                    contactMobile:{
                        required:true,
                        isMobile:true,
                        remote: {
                        	type:"POST",
                        	url:"${ctxFront}/register/checkMobileExists",
                        	data:{
                                mobile:function(){return $("#contactMobile").val();}
                            } 
                        }
                    },
                    validateCode:{
                        required:true,
                        remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"
                    },
                    
                    mobileCheckCode:{
                        required:true
                    },
                    password:{
                        required:true,
                        rangelength:[6,32]
                    },
                    confirmPassword:{
                    	required:true,
                        equalTo:"#password"
                    }                    
                },
                messages:{
                	contactMobile:{
                		remote: "手机号未注册，请重新输入"
                	},
                    validateCode:{
                    	remote: "验证码不正确"
                    },
                    password:{
                        rangelength: $.format("密码长度必须介于{0}至{1}字符，请重新输入")
                    },
                    confirmPassword:{
                        equalTo:"两次输入密码不一致，请重新输入"
                    }                                    
                },
				submitHandler: function(form){
					$('#inputForm').ajaxSubmit({
						url : "${ctxFront}/register/resetPasswordSubmit",  
						type : "post",  
						dataType : "json", 
						beforeSend : function(XMLHttpRequest) {
							layer.load();	// 遮罩
						},
						success:function(responseText, statusText, xhr, $form){
							layer.closeAll('loading');
							if(responseText.sucFlag == 1){  
				                layer.msg('重置成功!', {icon: 1}); 
				                $('#inputForm').clearForm();
				            }else{
				            	layer.alert(data.responseText, {icon: 0});  
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
					} else if (element.attr("id") == "validateCode" || element.attr("id") == "mobileCheckCode") {
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
    <!--topNav begin-->
    <div class="head">
        <div class="clear mgCenter w1190">
           <a href="javascript:void(0)" class="adv fl">好买机构数据申报平台</a>
           <div class="fr headBoxR f20">
              好产品，就选<span class="red">好买</span>！ <span class="red pl10 pr10">400-700-9665</span>
    7×24免费导购热线</div>
        </div>
    </div>
    
    <div class="bg">
        <div class="w1130 mgCenter mainBox">
            <div class="mainTitle">重置密码</div>
            <form:form id="inputForm" modelAttribute="register" action="${ctxFront}/register/resetPasswordSubmit" method="post" >
            <div class="contentSub pt50">
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400">注册手机号：</div>
                    <div class="cell-right">
                        <input type="text" name="contactMobile" id="contactMobile" class="yui-input w350" placeholder="请输入注册时预留的手机号">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400">验证码：</div>
                    <div class="cell-right validate">
                        <input type="text" name="validateCode" id="validateCode" class="yui-input w350" placeholder="看不清？点击图片刷新验证码">
                        <img id="checkCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="refreshCode();" alt="">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400">手机验证码：</div>
                    <div class="cell-right">
                        <input type="text" name="mobileCheckCode" id="mobileCheckCode" class="yui-input w200" maxlength='6' placeholder="6位数字验证码">
                    </div>
                    <a href="javascript:void(0)" class="requestBtn fl w140" id="getCode">获取验证码</a>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400">设置新密码：</div>
                    <div class="cell-right">
                        <input type="password" name="password" id="password" class="yui-input w350" placeholder="密码需为6-32位字符" maxlength="32" minlength="6">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400">再次输入新密码：</div>
                    <div class="cell-right">
                        <input type="password" name="confirmPassword" id="confirmPassword" class="yui-input w350" placeholder="密码需为6-32位字符">
                    </div>
                </div>
                <div class="yui-form-cell mt30 clear">
                    <div class="cell-left w400">&nbsp;</div>
                    <div class="cell-right">
                        <a href="javascript:void(0)" class="btn-style-a db w360" onclick='$("#inputForm").submit();'>提 交</a>
                    </div>
                </div>
            </div>
            </form:form>
        </div>
    </div>
    
    <script src="${ctxStatic}/org/js/foot.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/yui.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/main.js?v201707251350"></script>
	<script type="text/javascript">
		function refreshCode() {
			$("#checkCode").attr("src", "${pageContext.request.contextPath}/servlet/validateCodeServlet?"+new Date().getTime());
		}
	</script>
</body>
</html>