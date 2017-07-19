<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <title>登录页</title>
    <link rel="stylesheet" type="text/css" href="${fns:getConfig('web.staticFile.urlName')}/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="${fns:getConfig('web.staticFile.urlName')}/css/common.css" />
    <link rel="stylesheet" href="${fns:getConfig('web.staticFile.urlName')}/css/yui.css">
    <link rel="stylesheet" href="${fns:getConfig('web.staticFile.urlName')}/font/iconfont.css">
    <link rel="stylesheet" type="text/css" href='${fns:getConfig('web.staticFile.urlName')}/css/style.css' />
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
            <form class="fr adverLogin mt40">
                <h4>好买机构数据申报平台</h4>
                <div class="yui-form-cell mt30 mb20 clear">
                    <div class="cell-left f14 w50 tar pr10">用户名</div>
                    <div class="cell-right">
                        <input type="text" class="yui-input w230" placeholder="请输入手机号码">
                    </div>
			    </div>
               <div class="yui-form-cell mb20 clear">
                    <div class="cell-left f14 w50 tar pr10">密码</div>
                    <div class="cell-right">
                        <input type="text" class="yui-input w230" placeholder="请输入密码">
                    </div>
			    </div>
               <div class="yui-form-cell mb20 clear">
                    <div class="cell-left f14 w50 tar pr10">验证码</div>
                    <div class="cell-right validate">
                        <input type="text" class="yui-input w230" placeholder="看不清？点击图片刷新">
                        <img id="checkCode" src="${pageContext.request.contextPath}/servlet/validateCodeServlet" onclick="refreshCode();" alt="">
                        <div class="bcInfo w240 clear">
                            <div class="yui-checkbox mt6 fl">
                                <label><i class="iconfont">&#xe606;</i></label><input type="checkbox" name="" hidden=""><span>记住密码</span>
                            </div>
                            <div class="yui-checkbox mt6 fr bcInfo">
                                <a href="">忘记密码/修改密码？</a>
                            </div>
                        </div>
                    </div>
			    </div>
               <div class="errorMsg tac red">* 用户名或密码错误，请重新输入</div>
               <a href="javascript:void(0)" class="btn-style-a mt20 db">登 录</a>
               <div class="bcInfo tac mt15">没有账户 去<a href="机构注册.html">注册</a></div>
            </form>
        </div>
    </div>
    <script type="text/javascript" src="${fns:getConfig('web.staticFile.urlName')}/js/jquery.min.js"></script>
    <script src="${fns:getConfig('web.staticFile.urlName')}/js/foot.js"></script>
    <script type="text/javascript" src="${fns:getConfig('web.staticFile.urlName')}/js/yui.js"></script>
    <script type="text/javascript" src="${fns:getConfig('web.staticFile.urlName')}/js/main.js"></script>
<script type="text/javascript">
function refreshCode() {
	$("#checkCode").attr("src", "${pageContext.request.contextPath}/servlet/validateCodeServlet?"+new Date().getTime());
}
</script>
</body>
</html>