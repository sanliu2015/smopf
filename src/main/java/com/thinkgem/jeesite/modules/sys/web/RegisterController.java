package com.thinkgem.jeesite.modules.sys.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 注册相关
 * @author luquan.peng
 *
 */
@Controller
@RequestMapping("${adminPath}/register")
public class RegisterController extends BaseController {

	@RequestMapping(value = "/init")
	public String init(HttpServletRequest request, HttpServletResponse response) {
		return "modules/sys/register";
	}
	
	@RequestMapping(value = "submit", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> submit(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> respMap = new HashMap<String, Object>();
		
		return respMap;
	}
	
}
