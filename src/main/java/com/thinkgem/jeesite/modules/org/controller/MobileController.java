package com.thinkgem.jeesite.modules.org.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.thinkgem.jeesite.common.utils.JedisUtils;
import com.thinkgem.jeesite.common.utils.RandomUtil;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 手机验证码
 * @author luquan.peng
 *
 */
@Controller
@RequestMapping("${frontPath}/mobile")
public class MobileController extends BaseController {

	@RequestMapping(value = "getMobileCheckCode")
	@ResponseBody
	public Map<String, Object> getMobileCheckCode(HttpServletRequest request, HttpServletResponse response) throws InterruptedException {
		Map<String, Object> respMap = new HashMap<String, Object>();
		String mobile = request.getParameter("mobile");
		String busType = request.getParameter("busType");
		String mobileRedisKey = "";
		if (StringUtils.isBlank(busType)) {
			mobileRedisKey = "nb" + mobile;		// nb no businessType 没有指明短信验证码业务含义
		} else {
			mobileRedisKey = busType + mobile;
		}
		
		Object cacheMap = JedisUtils.getObject(mobileRedisKey);
		if (cacheMap != null) {
			Map<String, Object> checkCodeMap = (Map<String, Object>)cacheMap;
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
			JedisUtils.setObject(mobileRedisKey, checkCodeMap, 180);	// 120秒
			// 预留，调用短信接口发送验证码
			respMap.put("sucFlag", "1");
		}
		return respMap;
	}
}
