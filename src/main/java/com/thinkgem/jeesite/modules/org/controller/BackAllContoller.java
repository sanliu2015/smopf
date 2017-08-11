package com.thinkgem.jeesite.modules.org.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.servlet.ValidateCodeServlet;
import com.thinkgem.jeesite.common.utils.JedisUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.org.entity.FormVO;
import com.thinkgem.jeesite.modules.org.entity.OrgAuditLog;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;
import com.thinkgem.jeesite.modules.org.entity.Register;
import com.thinkgem.jeesite.modules.org.service.OrgAuditLogService;
import com.thinkgem.jeesite.modules.org.service.OrganizationInfoService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}")
public class BackAllContoller extends BaseController {

	@Autowired
	private OrgAuditLogService orgAuditLogService;
	@Autowired
	private OrganizationInfoService organizationInfoService;
	
	
	@RequiresPermissions("org:audit:view")
	@RequestMapping(value = "/orgAuditLog/auditList")
	public String OrgAuditLogAuditList(OrgAuditLog orgAuditLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OrgAuditLog> page = orgAuditLogService.findPage(new Page<OrgAuditLog>(request, response), orgAuditLog); 
		model.addAttribute("page", page);
		return "modules/org/auditList";
	}
	
	@RequiresPermissions("org:audit:view")
	@RequestMapping(value = "/orgAuditLog/view")
	public String orgAuditView(OrgAuditLog orgAuditLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		OrgAuditLog auditLog = orgAuditLogService.get(request.getParameter("id"));
		List<Map<String, Object>> organMap = organizationInfoService.queryOrganInfo(auditLog.getOrgCode());
		request.setAttribute("organMap", organMap.get(0));
		List<Map<String, Object>> auditLogList = orgAuditLogService.queryAuditLog(auditLog);
		model.addAttribute("auditLogList", auditLogList);
		return "modules/org/auditView";
	}
	
	
	@RequiresPermissions("org:audit:edit")
	@RequestMapping(value = "/orgAuditLog/audit")
	public String orgAuditAudit(OrgAuditLog orgAuditLog, HttpServletRequest request, HttpServletResponse response, Model model) {
		OrgAuditLog auditLog = orgAuditLogService.get(request.getParameter("id"));
		List<Map<String, Object>> organMap = organizationInfoService.queryOrganInfo(auditLog.getOrgCode());
		request.setAttribute("organMap", organMap.get(0));
		List<Map<String, Object>> auditLogList = orgAuditLogService.queryAuditLog(auditLog);
		model.addAttribute("auditLogList", auditLogList);
		return "modules/org/auditSubmit";
	}
	
	@RequiresPermissions("org:audit:edit")
	@RequestMapping(value = "/orgAuditLog/auditSubmit")
	@ResponseBody
	public <T> Map<String, Object> orgAuditSubmit(@RequestBody  List<OrgAuditLog> dtlList, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		if (dtlList != null && dtlList.size() > 0) {
			OrgAuditLog organAuditLog = orgAuditLogService.getOrganAuditLog(dtlList.get(0));
			if (!"0".equals(organAuditLog.getStatus())) {
				respMap.put("sucFlag", "0");
				respMap.put("msg", "已经审核过了，不能重复审核！");
				return respMap;
			} else {
				boolean passFlag = true;
				StringBuilder noPassMsg = new StringBuilder(100);
				Date currentDate = new Date();
				User currentUser = UserUtils.getUser();
				
				for (OrgAuditLog orgAuditLog : dtlList) {
					if ("2".equals(orgAuditLog.getStatus())) {
						passFlag = false;
						noPassMsg.append(DictUtils.getDictLabel(orgAuditLog.getItemCode(), "audit_status", "")).append("审核不通过");
						if (StringUtils.isNotBlank(orgAuditLog.getMsg())) {
							noPassMsg.append(",原因:").append(orgAuditLog.getMsg());
						}
						noPassMsg.append("|");
					}
					orgAuditLog.setUpdateDate(currentDate);
					orgAuditLog.setOperator(currentUser);
					orgAuditLogService.auditLog(orgAuditLog);
				}
				
				if (passFlag) {
					organAuditLog.setStatus("1");
				} else {
					organAuditLog.setStatus("2");
				}
				organAuditLog.setMsg(noPassMsg.toString());
				organAuditLog.setUpdateDate(currentDate);
				organAuditLog.setOperator(currentUser);
				orgAuditLogService.auditLog(organAuditLog);
				respMap.put("sucFlag", "1");
				
			}
		}
		
		return respMap;
	}
	
	
	
	
}
