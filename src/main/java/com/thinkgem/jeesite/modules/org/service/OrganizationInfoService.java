package com.thinkgem.jeesite.modules.org.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.org.dao.OrganizationInfoDao;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;
import com.thinkgem.jeesite.modules.org.entity.Register;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.Role;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Service
@Transactional(readOnly = true)
public class OrganizationInfoService extends CrudService<OrganizationInfoDao, OrganizationInfo> {
	
	@Autowired
	private SystemService systemService;

	@Transactional(readOnly = true)
	public List<Map<String, Object>> queryOrganInfo(String orgCode) {
		return dao.queryOrganInfo(orgCode);
	}

	@Transactional(readOnly = true)
	public List<Map<String, Object>> queryUserByMobile(String mobile) {
		return dao.queryUserByMobile(mobile);
	}
	
	@Transactional(readOnly = true)
	public List<Map<String, Object>> queryOtherUserByMobile(User user) {
		return dao.queryOtherUserByMobile(user);
	}

	@SuppressWarnings("static-access")
	@Transactional(readOnly = false)
	public void updateWithNewMobile(Register register, Map<String, Object> respMap) {
		Map<String, Object> paraMap = Maps.newHashMap();
		paraMap.put("id", UserUtils.getUser().getId());
		paraMap.put("mobile", register.getContactMobile());
		paraMap.put("orgCode", UserUtils.getUser().getOrgCode());
		User user = dao.findUser(paraMap);
		if (user == null) {	// 表示新手机号
			dao.updateOrgInfo(register);
			register.setPassword(systemService.entryptPassword(register.getPassword()));
			dao.updateAdminUserWithMobile(register);
		} else {
			if (!user.getOrgCode().equals(paraMap.get("orgCode"))) {
				respMap.put("sucFlag", "0");
				respMap.put("message", "此手机号已经被其他机构注册使用");
				return ;
			}
			paraMap.put("delFlag", "1");
			paraMap.put("userId", UserUtils.getUser().getId());
			dao.updateUserByDelete(paraMap);		// 当前账号置为删除
			
			Role role = systemService.getRoleByEnname("orgAdmin");
			List<Role> roleList = new ArrayList<Role>(1);
			roleList.add(role);
			user.setRoleList(roleList);
			user.setUserType("FADM");
			systemService.updateUserRole(user);
			systemService.updatePasswordById(user.getId(), register.getContactMobile(), register.getPassword());
			dao.updateOrgInfoAdmin(user);
			
			//UserUtils.clearCache(user);
		}
		
		UserUtils.clearCache(UserUtils.getUser());		
		UserUtils.getSubject().logout();// 当前用户退出
		
	}

	public List<User> findUserList(String orgCode) {
		return dao.findUserList(orgCode);
	}

	public int updateUserByDelete(Map<String, Object> paraMap) {
		return dao.updateUserByDelete(paraMap);
	}

	public void saveUser(Map<String, String> paraMap) {
		User currentUser = UserUtils.getUser();
		User user = new User();
		user.setUserType("FOPR");
		user.setName(paraMap.get("name"));
		user.setEmail(paraMap.get("email"));
		user.setMobile(paraMap.get("mobile"));
		user.setOrgCode(currentUser.getOrgCode());
		user.setLoginName(paraMap.get("mobile"));
		user.setPassword(SystemService.entryptPassword(user.getMobile().substring(user.getMobile().length()-6)));
		// 其他相关参数初始化
		Office company = new Office();
		company.setId("1");
		Office office = new Office();
		office.setId("2");
		user.setCompany(company);
		user.setOffice(office);
		user.setCreateBy(currentUser);
		user.setUpdateBy(currentUser);
		Date currentDate = new Date();
		user.setCreateDate(currentDate);
		user.setUpdateDate(currentDate);
		Role role = systemService.getRoleByEnname("orgFOPR");
		List<Role> roleList = new ArrayList<Role>(1);
		roleList.add(role);
		user.setRoleList(roleList);
		systemService.saveUser(user);
		
		
	}

	public OrganizationInfo findOrgan(String orgCode) {
		return dao.findOrgan(orgCode);
	}

	public void updateWithOldMobile(Register register) {
		dao.updateOrgInfo(register);
		dao.updateAdminUser(register);
	}

	public User findUser(Map<String, Object> paraMap) {
		return dao.findUser(paraMap);
	}


}
