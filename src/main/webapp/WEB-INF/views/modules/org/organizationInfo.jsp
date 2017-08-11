<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构信息</title>
	<meta name="decorator" content="org"/>
</head>
<body>
	<div class="mainTitle mt30">机构信息</div>
    <div class="w1000">
	   <div class="contentSub pt30">
	       <div class="yui-form-cell clear">
	            <div class="cell-left w400">组织机构代码：</div>
	            <div class="cell-right ml10">
	                <p class="sectionTxt fwb">${organMap.orgCode}</p>
	            </div>
	        </div>
	        <div class="yui-form-cell clear">
	            <div class="cell-left w400">机构法定名称：</div>
	            <div class="cell-right ml10">
	                <p class="sectionTxt fwb">${organMap.orgName}</p>
	            </div>
	        </div>
	        <div class="yui-form-cell clear">
	            <div class="cell-left w400">公司指定联系人名称：</div>
	            <div class="cell-right ml10">
	                <p class="sectionTxt fwb">${organMap.adminName}</p>
	            </div>
	        </div>
	        <div class="yui-form-cell clear">
	            <div class="cell-left w400">公司指定联系人邮箱：</div>
	            <div class="cell-right ml10">
	                <p class="sectionTxt fwb">${organMap.adminEmail}</p>
	            </div>
	        </div>
	        <div class="yui-form-cell clear">
	            <div class="cell-left w400">公司指定联系人手机：</div>
	            <div class="cell-right ml10">
	                <p class="sectionTxt fwb">${organMap.adminMobile}</p>
	            </div>
	        </div>
	        
	        <a href="${ctxFront}/organizationInfo/edit?module=2" class="btn-style-a db w350 mt20 ml250">修 改</a>
	    </div>
	</div>
</body>
</html>