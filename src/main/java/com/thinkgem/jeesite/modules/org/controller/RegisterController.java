package com.thinkgem.jeesite.modules.org.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.thinkgem.jeesite.common.servlet.ValidateCodeServlet;
import com.thinkgem.jeesite.common.utils.JedisUtils;
import com.thinkgem.jeesite.common.utils.RandomUtil;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;
import com.thinkgem.jeesite.modules.org.entity.Register;
import com.thinkgem.jeesite.modules.org.service.OrganizationInfoService;
import com.thinkgem.jeesite.modules.org.service.RegisterService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.SystemService;

/**
 * 注册机构信息相关
 * @author luquan.peng
 *
 */
@Controller
@RequestMapping("${adminPath}/register")
public class RegisterController extends BaseController {

	@Autowired
	private RegisterService registerService;
	@Autowired
	private OrganizationInfoService organizationInfoService;
	@Autowired
	private SystemService systemService;
	
	@RequestMapping(value = "")
	public String init(HttpServletRequest request, HttpServletResponse response) {
		return "modules/sys/register";
	}
	
	
	@RequestMapping(value = "getPhoneCheckCode")
	@ResponseBody
	public Map<String, Object> getPhoneCheckCode(HttpServletRequest request, HttpServletResponse response) throws InterruptedException {
		Map<String, Object> respMap = new HashMap<String, Object>();
		String phone = request.getParameter("phone");
		if (JedisUtils.getObject(phone) != null) {
			Map<String, Object> checkCodeMap = (Map<String, Object>)JedisUtils.getObject(phone);
			if (System.currentTimeMillis() - ((long)checkCodeMap.get("createTime")) > 1000*60) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "不可重复获取，请稍后再试！");
			}
		} else {
			String phoneCheckCode = RandomUtil.randomNumbers(6);
			System.out.println(phoneCheckCode);
			Map<String, Object> checkCodeMap = new HashMap<String, Object>();
			checkCodeMap.put("code", phoneCheckCode);
			checkCodeMap.put("createTime", System.currentTimeMillis());
			JedisUtils.setObject(phone, checkCodeMap, 180);	// 120秒
			// 预留，调用短信接口发送验证码
			respMap.put("sucFlag", "1");
		}
		return respMap;
	}
	
	
	@RequestMapping(value = "submit", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> submit(Register register, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		List<Map<String, Object>> rs = registerService.queryOrganInfo(register.getOrgCode());
		if (rs != null && rs.size() > 0) {
			respMap.put("sucFlag", "0");		// 失败
			StringBuilder message = new StringBuilder(200);
			message.append("机构已被注册，请联系机构管理人添加账户[姓名：")
				.append(rs.get(0).get("adminName").toString().substring(1))
				.append("，手机：").append(rs.get(0).get("adminPhone").toString().substring(0,3))
				.append("****").append(rs.get(0).get("adminPhone").toString().substring(7));
			int emailFlagIndex = rs.get(0).get("adminEmail").toString().indexOf("@");	// @索引位置
			int halfIndex = emailFlagIndex >> 2;
			message.append("，邮箱：").append(rs.get(0).get("adminEmail").toString().substring(0,halfIndex));
			if (halfIndex == 0) {
				message.append("*");
			} else {
				for (int i=0; i<halfIndex; i++) {
					message.append("*");
				}
			}
			message.append(rs.get(0).get("adminEmail").toString().substring(emailFlagIndex));
			respMap.put("message", message.toString());
		} else {
			String errorStr = beanValidatorRetErrorStr(register);
			if (StringUtils.isBlank(errorStr)) {
				if (!register.getValidateCode().toLowerCase().equals(request.getSession().getAttribute(ValidateCodeServlet.VALIDATE_CODE).toString().toLowerCase())) {
					respMap.put("sucFlag", "0");
					respMap.put("message", "验证码不正确！");
					return respMap;
				} 
				if (JedisUtils.getObject(register.getContactPhone()) == null) {
					respMap.put("sucFlag", "0");
					respMap.put("message", "手机验证码已过期！");
					return respMap;
				}
				if (!register.getPhoneCheckCode().equals(((Map)JedisUtils.getObject(register.getContactPhone())).get("code"))) {
					respMap.put("sucFlag", "0");
					respMap.put("message", "手机验证码不正确！");
					return respMap;
				}
				respMap.put("sucFlag", "1");
				registerService.save(register);
			} else {
				respMap.put("message", errorStr);
				respMap.put("sucFlag", "0");
			}
			
		}
		return respMap;
	}
	
	@RequestMapping(value = "resetPassword")
	public String resetPassword(HttpServletRequest request, HttpServletResponse response) {
		return "modules/sys/resetPassword";
	}
	
	@RequestMapping(value = "resetPasswordSubmit", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> resetPasswordSubmit(Register register, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		if (JedisUtils.getObject(register.getContactPhone()) == null) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码已过期！");
			return respMap;
		}
		if (!register.getPhoneCheckCode().equals(((Map)JedisUtils.getObject(register.getContactPhone())).get("code"))) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码不正确！");
			return respMap;
		}
		List<Map<String, Object>> rs = organizationInfoService.queryUserByPhone(register.getContactPhone());
		String userId = "" + rs.get(0).get("id");
		systemService.updatePasswordById(userId, "", register.getPassword());
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	@RequestMapping(value = "checkPhoneRegister")
	@ResponseBody
	public boolean checkPhoneRegister(HttpServletRequest request, HttpServletResponse response) {
		String phone = request.getParameter("contactPhone");
		List<Map<String, Object>> rs = organizationInfoService.queryUserByPhone(phone);
		if (rs != null && rs.size() > 0) {
			return true;
		} else {
			return false;
		}
		
	}
	
}