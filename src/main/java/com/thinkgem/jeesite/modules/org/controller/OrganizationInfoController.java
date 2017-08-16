package com.thinkgem.jeesite.modules.org.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.servlet.ValidateCodeServlet;
import com.thinkgem.jeesite.common.utils.JedisUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.org.entity.Register;
import com.thinkgem.jeesite.modules.org.service.OrganizationInfoService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
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
	@Autowired
	private SystemService systemService;
	
	@RequestMapping(value = {"","index"})
	public String index(HttpServletRequest request, HttpServletResponse response) {
		User user = UserUtils.getUser();
		List<Map<String, Object>> organMap = organizationInfoService.queryOrganInfo(user.getOrgCode());
		request.setAttribute("organMap", organMap.get(0));
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/organizationInfo";
	}
	
	@RequestMapping(value = "edit")
	public String edit(HttpServletRequest request, HttpServletResponse response) {
		User user = UserUtils.getUser();
		List<Map<String, Object>> organMap = organizationInfoService.queryOrganInfo(user.getOrgCode());
		request.setAttribute("organMap", organMap.get(0));
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/organizationInfoEdit";
	}
	
	@RequestMapping(value = "checkMobile")
	@ResponseBody
	public boolean checkMobile(HttpServletRequest request, HttpServletResponse response) {
		String mobile = request.getParameter("contactMobile");
		List<Map<String, Object>> rs = organizationInfoService.queryUserByMobile(mobile);
		if (rs == null || rs.size() == 0) {
			return true;
		} else {
			if (rs.get(0).get("id").toString().equals(UserUtils.getUser().getId())) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	/**
	 * 同1个结构下子账号可以不验证
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "checkMobileOnEdit")
	@ResponseBody
	public boolean checkMobileOnEdit(HttpServletRequest request, HttpServletResponse response) {
		String mobile = request.getParameter("contactMobile");
		Map<String, Object> paraMap = Maps.newHashMap();
		paraMap.put("id", UserUtils.getUser().getId());
		paraMap.put("mobile", mobile);
		paraMap.put("orgCode", UserUtils.getUser().getOrgCode());
		User user = organizationInfoService.findUser(paraMap);
		if (user == null || user.getOrgCode().equals(UserUtils.getUser().getOrgCode())) {	// 同一机构下的
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * 前台页面修改机构信息
	 * @param register
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "save")
	@ResponseBody
	public Map<String, Object> save(Register register, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		if (!register.getValidateCode().toLowerCase().equals(request.getSession().getAttribute(ValidateCodeServlet.VALIDATE_CODE).toString().toLowerCase())) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "验证码不正确！");
			return respMap;
		} 
		
		Object cacheMap = JedisUtils.getObject("oe" + register.getContactMobileOld());
		
		if (cacheMap == null) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "原手机验证码已过期！");
			return respMap;
		}
		if (!register.getMobileCheckCodeOld().equals(((Map)cacheMap).get("code"))) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "原手机验证码不正确！");
			return respMap;
		}
		
		// 如果手机号不一致
		if (!register.getContactMobileOld().equals(register.getContactMobile())) {
			Object newMobileMap = JedisUtils.getObject("oe" + register.getContactMobile());
			if (newMobileMap == null) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "新手机号验证码已过期！");
				return respMap;
			}
			if (!register.getMobileCheckCodeNew().equals(((Map)newMobileMap).get("code"))) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "新手机号验证码不正确！");
				return respMap;
			}
			organizationInfoService.updateWithNewMobile(register,respMap);
		} else {
			organizationInfoService.updateWithOldMobile(register);		
		}
		
		// 清除缓存
		User user = systemService.getUser(register.getAdminId());
		user.setOldLoginName(register.getContactMobileOld());
		UserUtils.clearCache(user);
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	@RequiresRoles("orgAdmin")
	@RequestMapping(value = "userList")
	public String userList(HttpServletRequest request, HttpServletResponse response) {
		User user = UserUtils.getUser();
		List<User> userList = organizationInfoService.findUserList(user.getOrgCode());
		request.setAttribute("userList", userList);
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/userList";
	}
	
	@RequiresRoles("orgAdmin")
	@RequestMapping(value = "updateUserByDelete")
	@ResponseBody
	public Map<String, Object> updateUserByDelete(HttpServletRequest request, HttpServletResponse response, @RequestParam String userId, @RequestParam String delFlag) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		Map<String, Object> paraMap = new HashMap<String, Object>();
		User user = systemService.getUser(userId);
		if ("0".equals(delFlag)) {
			List<Map<String, Object>> rsList = organizationInfoService.queryOtherUserByMobile(user);
			if (rsList != null && rsList.size() > 0) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "手机号码已被其它账户使用，请联系管理员!");
				return respMap;
			}
		} 
		
		paraMap.put("userId", userId);
		paraMap.put("delFlag", delFlag);
		int rs = organizationInfoService.updateUserByDelete(paraMap);
		UserUtils.clearCache(user);
		UserUtils.kickOut(user);	// 剔除某用户待完善
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	@RequiresRoles("orgAdmin")
	@RequestMapping(value = "addUser")
	public String addUser(HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("module", request.getParameter("module"));
		return "modules/org/addUser";
	}
	
	/**
	 * 机构添加用户
	 * @param request
	 * @param response
	 * @return
	 */
	@RequiresRoles("orgAdmin")
	@RequestMapping(value = "saveUser")
	@ResponseBody
	public Map<String, Object> saveUser(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		String validateCode = request.getParameter("validateCode");
		String mobile = request.getParameter("mobile");
		String mobileValidateCode = request.getParameter("mobileValidateCode");
		if (!validateCode.toLowerCase().equals(request.getSession().getAttribute(ValidateCodeServlet.VALIDATE_CODE).toString().toLowerCase())) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "验证码不正确！");
			return respMap;
		} 
		
		Object redisMap = JedisUtils.getObject("ad" + mobile);
		if (redisMap == null) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码已过期！");
			return respMap;
		}
		if (!mobileValidateCode.equals(((Map)redisMap).get("code"))) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码不正确！");
			return respMap;
		}
		
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("name", request.getParameter("name"));
		paraMap.put("email", request.getParameter("email"));
		paraMap.put("mobile", mobile);
		organizationInfoService.saveUser(paraMap);
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	
}
