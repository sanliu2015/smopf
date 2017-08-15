<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>机构注册</title>
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
	<style type="text/css">
		.hide{display: none;}
		#messageBox label{display:inline-block}
	</style>
    <script type="text/javascript">
      var ctx = "${ctx}";
      jQuery.validator.addMethod("isMobile", function(value, element) {
        var length = value.length;
        var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\d{8})$/;
        return this.optional(element) || (length == 11 && mobile.test(value));
       }, "手机号格式有误，请重新输入");//可以自定义默认提示信息
		$(document).ready(function() {
			$("#inputForm").validate({
				rules:{
                    orgCode:{
                        required:true
                    },
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
                        remote: {
                        	type:"POST",
                        	url:"${ctx}/register/checkMobileRegister",
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
                    contactEmail:{
                        email:"邮箱格式有误，请重新输入"
                    },
                    contactMobile:{
                		remote: "手机号已注册，请重新输入"
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
						url : "${ctx}/register/submit",  
						type : "post",  
						dataType : "json", 
						beforeSend : function(XMLHttpRequest) {
							layer.load();	// 遮罩
						},
						success:function(responseText, statusText, xhr, $form){
							layer.closeAll('loading');
							if(responseText.sucFlag == 1){  
								layer.msg('注册成功!', {icon: 1,time: 1000,end : function(){
		                			window.location.href = "${ctx}/login";
		                		}});  
				            }else{
				            	layer.alert(responseText.message, {icon: 0});  
				                //layer.msg(responseText.message, {icon: 0});  
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
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
		
		
		function submit() {
			$("#inputForm").submit();
		}
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
            <div class="mainTitle">机构注册</div>
            <form:form id="inputForm" modelAttribute="register" action="${ctx}/register/submit" method="post" >
            <div class="contentSub pt50">
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>组织机构代码：</div>
                    <div class="cell-right">
                        <input type="text" name="orgCode" id="orgCode" class="yui-input w350" placeholder="请输入组织机构代码">
                    </div>
                    <!-- <div class="errorMsg mt10 fl"><span class="ml15 red">* 机构已被注册，请联系机构管理员添加账号</span><br><span class="ml15 red">[姓名*吉吉，手机123****4567,邮箱123***@howbuy.com]</span></div> -->
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>机构法定名称：</div>
                    <div class="cell-right">
                        <input type="text" name="orgName" id="orgName" class="yui-input w350" placeholder="请输入机构全称">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>公司指定联系人名称：</div>
                    <div class="cell-right">
                        <input type="text" name="contactName" id="contactName" class="yui-input w350" placeholder="请输入联系人姓名">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>公司指定联系人邮箱：</div>
                    <div class="cell-right">
                        <input type="text" name="contactEmail" id="contactEmail" class="yui-input w350" placeholder="请输入联系人常用邮箱">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>公司指定联系人手机号：</div>
                    <div class="cell-right">
                        <input type="text" name="contactMobile" id="contactMobile" class="yui-input w350" placeholder="请输入联系人手机号" maxlength="11">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>验证码：</div>
                    <div class="cell-right validate">
                        <input type="text" name="validateCode" id="validateCode" class="yui-input w350" placeholder="看不清？点击图片刷新验证码">
                        <img id="checkCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="refreshCode();" alt="">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>手机验证码：</div>
                    <div class="cell-right">
                        <input type="text" name="mobileCheckCode" id="mobileCheckCode" class="yui-input w200" maxlength='6' placeholder="6位数字验证码">
                    </div>
                    <a href="javascript:void(0)" class="requestBtn fl w140" id="getCode">获取验证码</a>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>登录密码：</div>
                    <div class="cell-right">
                        <input type="password" name="password" id="password" class="yui-input w350" placeholder="密码需为6-32位字符" maxlength="32" minlength="6">
                    </div>
                </div>
                <div class="yui-form-cell mb30 clear">
                    <div class="cell-left w400"><span class="ml15 red">*</span>确认登录密码：</div>
                    <div class="cell-right">
                        <input type="password" name="confirmPassword" id="confirmPassword" class="yui-input w350" placeholder="密码需为6-32位字符">
                    </div>
                </div>
                <div class="yui-form-cell mt30 clear">
                    <div class="cell-left w400">&nbsp;</div>
                    <div class="cell-right">
                        <a href="javascript:void(0)" class="btn-style-a db w170 fl" onclick="submit();">立即注册</a>
                        <a href="${pageContext.request.contextPath}${fns:getAdminPath()}" class="return ml20 mt10 fl">返回</a>
                    </div>
                </div>
            </div>
            </form:form>
        </div>
    </div>
    
    <script type="text/javascript" src="${ctxStatic}/org/js/foot.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/yui.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/main.js?v201708111100"></script>
	<script type="text/javascript">
		function refreshCode() {
			$("#checkCode").attr("src", "${pageContext.request.contextPath}/servlet/validateCodeServlet?"+new Date().getTime());
		}
	</script>
</body>
</html>