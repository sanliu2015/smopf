package com.thinkgem.jeesite.modules.org.controller;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;
import com.thinkgem.jeesite.modules.org.service.OrgAuditLogService;
import com.thinkgem.jeesite.modules.org.service.OrganizationInfoService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 资质审核日志
 * @author luquan.peng
 *
 */

@Controller
@RequestMapping("${frontPath}/orgAuditLog")
public class OrgAuditLogController extends BaseController {
	
	@Autowired
	private OrgAuditLogService orgAuditLogService;
	@Autowired
	private OrganizationInfoService organizationInfoService;

	@RequestMapping(value = {"","list"})
	public String list(HttpServletRequest request, HttpServletResponse response) {
		User currentUser = UserUtils.getUser();
		List<Map<String, Object>> list = orgAuditLogService.queryList(currentUser.getOrgCode());
		request.setAttribute("list", list);
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/orgAuditLogList";
	}
	
	@RequestMapping(value = "uploadInit")
	public String uploadInit(HttpServletRequest request, HttpServletResponse response) {
		OrganizationInfo organizationInfo = organizationInfoService.findObject(UserUtils.getUser().getOrgCode());
		request.setAttribute("organ", organizationInfo);
		return "modules/org/orgAuditLogUpload";
	}
	
	@RequestMapping(value = "upload")
	@ResponseBody
	public Map<String, Object> upload(@RequestParam(value = "file", required = false) MultipartFile multipartFile, HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException {
		Map<String, Object> respMap = new HashMap<String, Object>();
		if (multipartFile != null) {
			if (multipartFile.getSize() > 5*1024*1024) {
				respMap.put("sucFlag", "0");
				respMap.put("msg", "文件过大，请调整后再上传");
			} else {
				orgAuditLogService.saveFile(multipartFile, request);
			}
		}
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	@RequestMapping(value = "submitAudit")
	@ResponseBody
	public Map<String, Object> submitAudit(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		OrganizationInfo organizationInfo = organizationInfoService.findObject(UserUtils.getUser().getOrgCode());
		if ("1".equals(organizationInfo.getStatus())) {
			respMap.put("sucFlag", "0");
			respMap.put("msg", "资质审核已通过，不需要再次提交！");
			return respMap;
		} else {
			StringBuilder msg = new StringBuilder();
			boolean errorFlag = false;
			if ("0".equals(organizationInfo.getLicenceStatus()) || "2".equals(organizationInfo.getLicenceStatus())) {
				errorFlag = true;
				msg.append("<br>").append("请上传营业执照！");
			}
			if ("0".equals(organizationInfo.getLogStatus()) || "2".equals(organizationInfo.getLogStatus())) {
				errorFlag = true;
				msg.append("<br>").append("请上传产品净值保证函！");
			}
			if ("0".equals(organizationInfo.getLoaStatus()) || "2".equals(organizationInfo.getLoaStatus())) {
				errorFlag = true;
				msg.append("<br>").append("请上传产品披露授权函！");
			}
			
			if (errorFlag) {
				respMap.put("sucFlag", "0");
				respMap.put("msg", msg.toString());
				return respMap;
			} else {
				orgAuditLogService.submitAudit(organizationInfo);
				respMap.put("sucFlag", "1");
			}
			
			
		}

		return respMap;
	}
	
	
}
