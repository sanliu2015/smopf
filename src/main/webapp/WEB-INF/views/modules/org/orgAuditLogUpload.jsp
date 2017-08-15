<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构信息</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/org/css/reset.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/org/css/common.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/org/css/yui.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/org/font/iconfont.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/org/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/layui/css/layui.css" />
	<!-- js -->
	<script type="text/javascript" src="${ctxStatic}/jquery/jquery-2.2.4.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/org/js/yui.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/org/js/main.js?v201707251300"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
	<script type="text/javascript">
		function submitAudit() {
			$.ajax({
        		url: "${ctx}/orgAuditLog/submitAudit",
				type: "post",
				cache: false,
				dataType: "json",
		        success:function(resp){  
		            if(resp.sucFlag == "1"){  
		            	layer.msg('审核资料提交成功!', {icon: 1,time: 1000,end : function(){
	                			window.location.href = "${ctx}/orgAuditLog/list?module=1";
	                		}
	                	});  
		            }else{  
		                layer.alert(resp.msg, {icon: 0});  
		            }  
		        },  
		        error:function(data) {
					layer.alert(data.responseText, {icon: 5, area: '500px'});  
				}
        	});
		}
	</script>
</head>
<body>
<form:form id="inputForm" method="post" >
	<!--topNav begin-->
    <div class="head">
        <div class="clear mgCenter w1190">
           <a href="javascript:void(0)" class="adv fl">好买机构数据申报平台</a>
           <div class="fr headBoxR f20">
           		<a href="${ctx}/logout" class="backSystem"><i class="iconfont">&#xe610;</i><span>退出系统</span></a>
                <a href="javascript:void(0)" class="manager"><small></small>${fns:getUser().userType == 'FADM' ? '管理员-':''}${fns:getUser().name}</a>
           </div>
        </div>
    </div>
    <div class="bg">
        <div class="w1130 mgCenter mainBox">
            <div class="mainTitle">资质审核</div>
            <div class="downloadBox tac">
                <ul class="clear">
                    <li><a href="${ctx}/downloadNative?fileName=产品净值保证函模板.jpg&filePath=/static/templateDownload/产品净值保证函模板.jpg"><span>产品净值保证函模板下载</span></a></li>
                    <li><a href="${ctx}/downloadNative?fileName=产品净值保证函模板.jpg&filePath=/static/templateDownload/产品披露授权函模板.jpg"><span>产品披露授权函模板下载</span></a></li>
                </ul>
            </div>
            
            <div class="upload tac">
                <ul class="clear">
                	<c:if test="${not empty organ and (organ.licenceStatus ne '3')}">
                    <li>
                    	<%-- <img src="${ctxStatic}/org/images/pdf.jpg" alt="" style="width:182px;height:130px;"> --%>
                    	<i class="iconfont">&#xe615;</i><span>上传营业执照<small class="gray9">(正面)</small></span>
                    	<p class="clear mt10"><b style="text-align:center;color:#FF6347">${fns:getDictLabel(organ.licenceStatus, 'licence_status','')}</b></p>
                    	<input class="layui-upload-file" type="file" name="file" id="1">
                    	<input type="hidden" name="itemStatus" value="${organ.licenceStatus}" />
                    </li>
                    </c:if>
                    <c:if test="${not empty organ and organ.logStatus ne '3'}">
                    <li><i class="iconfont">&#xe615;</i><span>产品净值保证函上传成功<small class="gray9">(须加盖公章)</small></span>
                    <p class="clear mt10"><b style="text-align:center;color:#FF6347">${fns:getDictLabel(organ.logStatus, 'licence_status','')}</b></p>
                    	<input class="layui-upload-file" type="file" name="file" id="2" >
                    	<input type="hidden" name="itemStatus" value="${organ.logStatus}" />
                    </li>
                    </c:if>
                    <c:if test="${not empty organ and organ.loaStatus ne '3'}">
                    <li><i class="iconfont">&#xe615;</i><span>产品披露授权函<small class="gray9">(须加盖公章)</small></span>
                    <p class="clear mt10"><b style="text-align:center;color:#FF6347">${fns:getDictLabel(organ.loaStatus, 'licence_status','')}</b></p>
                    	<input class="layui-upload-file" type="file" name="file" id="3">
                    	<input type="hidden" name="itemStatus" value="${organ.loaStatus}" />
                    </li>
                    </c:if>
                </ul>
                <div class="notice tac">注意：上传文件为图片或PDF格式，请务必限制在5MB以内</div>
                <a href="javascript:void(0)" class="btn-style-a db w350 mt50 mgCenter" onclick="submitAudit();">提 交</a>
            </div>
            
        </div>
    </div>
</form:form>	
<script type="text/javascript" src="${pageContext.request.contextPath}/static/org/js/foot.js"></script>
<script type="text/javascript">

layui.use(['layer', 'upload'], function(){
	  var layer = layui.layer;
	  layui.upload({
	    	url: '${ctx}/orgAuditLog/upload',
	    	elem: '.layui-upload-file', //指定原始元素，默认直接查找class="layui-upload-file"
	    	ext: 'jpg|png|pdf',
	    	method: 'post', //上传接口的http类型
	    	unwrap: true,	//不该变原来样式
	    	before: function(input) {
	    		/* debugger;
	    		if ($(input).parent().parent().find("input[name='itemStatus']").val() == "3") {
	    			layer.alert("审核通过的不允许上传", {icon: 0});  
	    			return false;
	    		} */
	    		layer.load();	// 遮罩
	    		$(input).after("<input type='hidden' name='itemCode' value='" + $(input).attr("id") + "' />");
	    	},
	    	success: function(res, input){
	    		layer.closeAll('loading');
	    		if (res.sucFlag == "1") {
	    			$(input).parent().parent().find("p").remove();
	    			//$(input).parent().find("p").remove();
	    			layer.msg('上传成功!', {icon: 1,time: 1000,end: function(){
	    					//$(input).parent().prev()
	    					$(input).before('<p class="clear mt10"><b style="text-align:center;color:#FF6347">上传成功</b></p>');
            			}
	    			}); 
	    			//$(input).parent().parent().find("span").text();
	    		} else {
	    			layer.alert(res.msg, {icon: 0});  
	    			//$(input).remove();
	    			//$(input).parent().parent().find("span").text();
	    		}
	    	}
		});
});
</script>
</body>
</html>