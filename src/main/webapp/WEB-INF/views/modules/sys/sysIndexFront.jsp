<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
	<title>划款指令管理</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link href="${pageContext.request.contextPath}/static/layui/css/layui.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/static/jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
<script type="text/javascript">
$(function(){
	

});

</script>
</head>
<body>
前台机构用户首页<br>
<a href="${pageContext.request.contextPath}/a/logout" title="退出登录">退出</a>

<script>
	layui.use('layer', function(){
		var layer = layui.layer;
		layer.open({
			  type: 1
			  ,title: false //不显示标题栏
			  ,closeBtn: false
			  ,area: '300px;'
			  ,shade: 0.8
			  ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
			  ,resize: false
			  ,btn: ['火速围观', '残忍拒绝']
			  ,btnAlign: 'c'
			  ,moveType: 1 //拖拽模式，0或者1
			  ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">请上传资料审核，谢谢<br></div>'
			  ,success: function(layero){
			    var btn = layero.find('.layui-layer-btn');
			    btn.find('.layui-layer-btn0').attr({
			      href: 'http://www.layui.com/'
			      ,target: '_blank'
			    });
			  }
			});
	});
</script>	
</body>
</html>