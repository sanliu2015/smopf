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
	
	
	@RequestMapping(value = "getMobileCheckCode")
	@ResponseBody
	public Map<String, Object> getMobileCheckCode(HttpServletRequest request, HttpServletResponse response) throws InterruptedException {
		Map<String, Object> respMap = new HashMap<String, Object>();
		String mobile = request.getParameter("mobile");
		if (JedisUtils.getObject(mobile) != null) {
			Map<String, Object> checkCodeMap = (Map<String, Object>)JedisUtils.getObject(mobile);
			if (System.currentTimeMillis() - ((long)checkCodeMap.get("createTime")) > 1000*60) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "不可重复获取，请稍后再试！");
			}
		} else {
			String mobileCheckCode = RandomUtil.randomNumbers(6);
			System.out.println(mobileCheckCode);
			Map<String, Object> checkCodeMap = new HashMap<String, Object>();
			checkCodeMap.put("code", mobileCheckCode);
			checkCodeMap.put("createTime", System.currentTimeMillis());
			JedisUtils.setObject(mobile, checkCodeMap, 180);	// 120秒
			// 预留，调用短信接口发送验证码
			respMap.put("sucFlag", "1");
		}
		return respMap;
	}
	
	@RequestMapping(value = "checkOrganExists", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkOrganExists(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		validOrgan(respMap, request.getParameter("orgCode"));
		return respMap;
	}
	
	
	private void validOrgan(Map<String, Object> respMap, String orgCode) {
		List<Map<String, Object>> rs = registerService.queryOrganInfo(orgCode); 
		if (rs != null && rs.size() > 0) {
			respMap.put("validResult", false);
			StringBuilder message = new StringBuilder(200);
			message.append("机构已被注册，请联系机构管理人添加账户[姓名*")
				.append(rs.get(0).get("adminName").toString().substring(1))
				.append("，手机").append(rs.get(0).get("adminMobile").toString().substring(0,3))
				.append("****").append(rs.get(0).get("adminMobile").toString().substring(7));
			int emailFlagIndex = rs.get(0).get("adminEmail").toString().indexOf("@");	// @索引位置
			int halfIndex = emailFlagIndex/2;
			if (emailFlagIndex%2 == 0) {	// @前面是偶数个字符
				message.append("，邮箱").append(rs.get(0).get("adminEmail").toString().substring(0,halfIndex));
				for (int i=0; i<halfIndex; i++) {
					message.append("*");
				}
			} else {
				message.append("，邮箱").append(rs.get(0).get("adminEmail").toString().substring(0,halfIndex+1));
				for (int i=0; i<halfIndex; i++) {
					message.append("*");
				}
			}
			message.append(rs.get(0).get("adminEmail").toString().substring(emailFlagIndex)).append("]");
			respMap.put("message", message.toString());
		} else {
			respMap.put("validResult", true);
		}
	}


	@RequestMapping(value = "submit", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> submit(Register register, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		validOrgan(respMap, request.getParameter("orgCode"));
		if ("false".equals(respMap.get("validResult").toString())) {
			respMap.put("sucFlag", "0");	
		} else {
			String errorStr = beanValidatorRetErrorStr(register);
			if (StringUtils.isBlank(errorStr)) {
				if (!register.getValidateCode().toLowerCase().equals(request.getSession().getAttribute(ValidateCodeServlet.VALIDATE_CODE).toString().toLowerCase())) {
					respMap.put("sucFlag", "0");
					respMap.put("message", "验证码不正确！");
					return respMap;
				} 
				if (JedisUtils.getObject(register.getContactMobile()) == null) {
					respMap.put("sucFlag", "0");
					respMap.put("message", "手机验证码已过期！");
					return respMap;
				}
				if (!register.getMobileCheckCode().equals(((Map)JedisUtils.getObject(register.getContactMobile())).get("code"))) {
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
		if (JedisUtils.getObject(register.getContactMobile()) == null) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码已过期！");
			return respMap;
		}
		if (!register.getMobileCheckCode().equals(((Map)JedisUtils.getObject(register.getContactMobile())).get("code"))) {
			respMap.put("sucFlag", "0");
			respMap.put("message", "手机验证码不正确！");
			return respMap;
		}
		List<Map<String, Object>> rs = organizationInfoService.queryUserByMobile(register.getContactMobile());
		String userId = "" + rs.get(0).get("id");
		systemService.updatePasswordById(userId, "", register.getPassword());
		respMap.put("sucFlag", "1");
		return respMap;
	}
	
	/**
	 * 注册时验证，手机号不能重复
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "checkMobileRegister")
	@ResponseBody
	public boolean checkMobileRegister(HttpServletRequest request, HttpServletResponse response) {
		String mobile = request.getParameter("mobile");
		List<Map<String, Object>> rs = organizationInfoService.queryUserByMobile(mobile);
		if (rs == null || rs.size() == 0) {
			return true;
		} else {
			return false;
		}
		
	}
	
	/**
	 * 忘记密码必须填写手机号
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "checkMobileExists")
	@ResponseBody
	public boolean checkMobileExists(HttpServletRequest request, HttpServletResponse response) {
		String mobile = request.getParameter("mobile");
		List<Map<String, Object>> rs = organizationInfoService.queryUserByMobile(mobile);
		if (rs == null || rs.size() == 0) {
			return false;
		} else {
			return true;
		}
		
	}
	
}
