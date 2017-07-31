<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>登录页</title>
    <%-- <link rel="stylesheet" type="text/css" href="${fns:getConfig('web.staticFile.urlName')}/css/reset.css" /> --%>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/common.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/yui.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/font/iconfont.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/org/css/style.css" />
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css" />
    <script type="text/javascript" src="${ctxStatic}/org/js/jquery.min.js"></script>
	<script type="text/javascript" src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"></script>
	<style type="text/css">
		.hide{display: none;}
		#messageBox label{display:inline-block}
		label.error{background:none;width:180px;padding-left:50px;text-align:center;font-weight:normal;color:#C00;margin:0;}
	</style>
    <script type="text/javascript">
		$(document).ready(function() {
			$("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},
					password: {required: "请填写密码."},
					validateCode: {required: "请填写验证码.", remote: "验证码不正确."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
		});
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
		
		function JqValidate() {  
		    return $("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},
					password: {required: "请填写密码."},
					validateCode: {required: "请填写验证码.", remote: "验证码不正确."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
		}  
		
		function login() {
			if(JqValidate()){    
				$("#loginForm").submit();
		    }  
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
    
    <div class="adver">
        <div class="w1190 mgCenter clear">
            <div class="fl adverL">
                <dl>
                    <dt>申<br>报<br>须<br>知</dt>
                    <dd>1、公司必须在基金业协会备案；</dd>
                    <dd>2、每个账号只允许申报一个公司的产品和人员；</dd>
                    <dd>3、账号内的注册信息需要修改时 ，必须发邮件给hdb@howbuy.com ，经好买审核通过后才可继续进行产品的录入和修改；</dd>
                    <dd>4、成功申报后的产品只可清算处理，不能做隐藏；</dd>
                    <dd>5、产品进行申报，产品管理人必须知情，否则，请勿申报！</dd>
                </dl>
                <dl class="sblc">
                    <dt>申<br>报<br>流<br>程</dt>
                    <dd>1、登录好买私募首页（http://simu.howbuy.com），查询有无相应的公司和产品，若有请只进行数据的修改，无论是数据修改和录入都需要先注册账号；</dd>
                    <dd>2、阅读登录界面相应的要求说明，若有异议，请勿注册！</dd>
                    <dd>3、按照流程填写公司、人物、基金产品等基本信息；</dd>
                    <dd>4、净值不允许修改历史数据，如需要修改历史数据，请发邮件给hdb@howbuy.com 邮箱，经好买审核确实需要修改后由好买进行修改。</dd>
                    <dd>5、填写完毕后将自动进入待审核状态，一般会在1-2个工作日之内进行审核；</dd>
                </dl>
            </div>
            <form class="fr adverLogin mt40" id="loginForm" action="${ctx}/login" method="post">
                <h4>好买机构数据申报平台</h4>
                <div class="yui-form-cell mt30 mb20 clear">
                    <label class="cell-left f14 w50 tar pr10" for="username">用户名</label>
                    <div class="cell-right">
                        <input id="username" name="username" type="text" class="yui-input w230 required" placeholder="请输入手机号码" value="${username}">
                    </div>
			    </div>
               <div class="yui-form-cell mb20 clear">
                    <label class="cell-left f14 w50 tar pr10" for="password">密码</label>
                    <div class="cell-right">
                        <input id="password" name="password" type="password" class="yui-input w230 required" placeholder="请输入密码">
                    </div>
			    </div>
               <div class="yui-form-cell mb20 clear">
                    <label class="cell-left f14 w50 tar pr10" for="validateCode">验证码</label>
                    <div class="cell-right validate">
                        <input type="text" name="validateCode" id="validateCode" class="yui-input w230 required" placeholder="看不清？点击图片刷新">
                        <img id="checkCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="refreshCode();" alt="">
                        <div class="bcInfo w240 clear">
                            <div class="yui-checkbox mt6 fl">
                                <label><i class="iconfont">&#xe606;</i></label><input type="checkbox" name="" hidden=""><span>记住密码</span>
                            </div>
                            <div class="yui-checkbox mt6 fr bcInfo">
                                <a href="${pageContext.request.contextPath}${fns:getAdminPath()}/register/resetPassword" target="_blank">忘记密码/修改密码？</a>
                            </div>
                        </div>
                    </div>
			    </div>
                <div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}" >
                	<label id="loginError" class="error">${message}</label>
                </div>
                <a href="javascript:void(0)" onclick="login();" class="btn-style-a mt20 db">登 录</a>
                <div class="bcInfo tac mt15">没有账户 去<a href="${pageContext.request.contextPath}${fns:getAdminPath()}/register" target="_blank">注册</a></div>
            </form>
        </div>
    </div>
    
    <script src="${ctxStatic}/org/js/foot.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/yui.js"></script>
    <script type="text/javascript" src="${ctxStatic}/org/js/main.js"></script>
	<script type="text/javascript">
		function refreshCode() {
			$("#checkCode").attr("src", "${pageContext.request.contextPath}/servlet/validateCodeServlet?"+new Date().getTime());
		}
	</script>
</body>
</html>