<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><sitemesh:title/></title>
	<%@ include file="/WEB-INF/views/layouts/org/header.jsp"%>
	<sitemesh:head/>
</head>
<body>
	<!--topNav begin-->
    <div class="head">
        <div class="clear w1240">
           <a href="javascript:void(0)" class="adv ml25 fl">好买机构数据申报平台</a>
           <div class="fr headBoxR f20">
                <a href="${ctx}/logout" class="backSystem"><i class="iconfont">&#xe610;</i><span>退出系统</span></a>
                <a href="javascript:void(0)" class="manager"><small></small>${fns:getUser().userType == 'FADM' ? '管理员-':''}${fns:getUser().name}</a>
           </div>
        </div>
    </div>
    <div class="wrapper">
        <dl class="w220 navSlide">
           <dt><i class="iconfont f20">&#xe62e;</i>申报系统</dt>
           <dd class="hide"></dd>
           <dt><i class="iconfont f16">&#xe605;</i>账户管理</dt>
           <dd>
               <a href="${ctx}/orgAuditLog/list?module=1" ${module == 1 ? 'class="active"' : ''}><i class="iconfont f12">&#xe604;</i>审核状态</a>
               <a href="${ctx}/organizationInfo/index?module=2" ${module == 2 ? 'class="active"' : ''}><i class="iconfont f12">&#xe604;</i>机构信息</a>
               <a href="${ctx}/organizationInfo/userList?module=3" ${module == 3 ? 'class="active"' : ''}><i class="iconfont f12">&#xe604;</i>账号维护</a>
           </dd>
        </dl>
		
        <div class="contentR">
        	<sitemesh:body/>
        </div>
    </div>
	
	<%@ include file="/WEB-INF/views/layouts/org/footer.jsp"%>
</body>
</html>