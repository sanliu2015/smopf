package com.thinkgem.jeesite.modules.org.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.org.service.OrganizationInfoService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 机构信息
 * @since 2017-07-24 18:00:00
 * @author luquan.peng
 *
 */
@Controller
@RequestMapping("${adminPath}/organizationInfo")
public class OrganizationInfoController extends BaseController {

	@Autowired
	private OrganizationInfoService organizationInfoService;
	
	@RequestMapping(value = {"","index"})
	public String index(HttpServletRequest request, HttpServletResponse response) {
		User user = UserUtils.getUser();
		List<Map<String, Object>> organMap = organizationInfoService.queryOrganInfo(user.getOrgCode());
		request.setAttribute("organMap", organMap.get(0));
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/organizationInfo";
	}
	
	
}
