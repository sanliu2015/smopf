package com.thinkgem.jeesite.modules.org.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.org.dao.OrganizationInfoDao;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;

@Service
@Transactional(readOnly = true)
public class OrganizationInfoService extends CrudService<OrganizationInfoDao, OrganizationInfo> {

	public List<Map<String, Object>> queryOrganInfo(String orgCode) {
		return dao.queryOrganInfo(orgCode);
	}

	public List<Map<String, Object>> queryUserByPhone(String phone) {
		return dao.queryUserByPhone(phone);
	}

}
