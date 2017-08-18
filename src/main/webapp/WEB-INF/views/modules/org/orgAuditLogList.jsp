<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>机构信息</title>
<meta name="decorator" content="org" />
</head>
<body>
	<div class="mainTitle mt30">审核状态</div>
    <div class="w1000">
        <div class="contentSub pt30">
        	<c:if test="${empty list}">
        		<a href="${ctx}/orgAuditLog/uploadInit" class="btn-style-a db w350 mt20 ml250">资质上传</a>
        	</c:if>
        	<c:if test="${not empty list}">
            <table class="yui-table tac" data-zebra="odd">
                <tr>
                    <th width='220px'>机构名称</th>
                    <th width='140px'>提交日期</th>
                    <th width='140px'>审核状态</th>
                    <th width='360px'>描述</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${list}" var="obj" varStatus="status">
                <tr>
                    <td>${obj.orgName}</td>
                    <td>${obj.credt}</td>
                    <c:choose>
                    <c:when test="${obj.status eq '1'}">
	                    <td><span class="green">${fns:getDictLabel(obj.status, 'audit_status', '')}</span></td>
	                    <td>-</td>
	                    <td>
	                    	<c:choose>
		                    	<c:when test="${status.index == 0}">
	                    		<a href="${ctx}/orgAuditLog/view?id=${obj.id}&module=1" class="reUpload fwb">详情</a>
	                    		</c:when>
	                    		<c:otherwise>
	                    		-
	                    		</c:otherwise>
	                    	</c:choose>	
	                    </td>
                    </c:when>
                    <c:when test="${obj.status eq '2'}">
                    	<td><span class="red">${fns:getDictLabel(obj.status, 'audit_status', '')}</span></td>
	                    <td>${obj.msg}</td>
	                    <td>
	                    	<c:choose>
		                    	<c:when test="${status.index == 0}">
	                    		<a href="${ctx}/orgAuditLog/view?id=${obj.id}&module=1" class="reUpload fwb">详情</a>
		                    	<a href="${ctx}/orgAuditLog/uploadInit" class="reUpload fwb">重新上传</a>
		                    	</c:when>
		                    	<c:otherwise>
		                    	-
		                    	</c:otherwise>
	                    	</c:choose>
	                    </td>
                    </c:when>	
                    <c:otherwise>
                    	<td>${fns:getDictLabel(obj.status, 'audit_status', '')}</td>
	                    <td>-</td>
	                    <td>
	                    	<c:choose>
		                    	<c:when test="${status.index == 0}">
	                    		<a href="${ctx}/orgAuditLog/view?id=${obj.id}&module=1" class="reUpload fwb">详情</a>
	                    		</c:when>
	                    		<c:otherwise>
	                    		-
	                    		</c:otherwise>
	                    	</c:choose>	
	                    </td>
                    </c:otherwise>
                    </c:choose>
                </tr>
                </c:forEach>
            </table>
            <div class="txt f12 mt15 gray9">尊敬的管理人，您的审核资料提交审核后，我们将在两个工作日内审核完毕，请关注您的审核状态</div>
            </c:if>
        </div>
    </div>
<script type="text/javascript">
</script>
</body>
</html>