package com.thinkgem.jeesite.modules.org.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;

@MyBatisDao
public interface OrganizationInfoDao extends CrudDao<OrganizationInfo> {

	List<Map<String, Object>> queryOrganInfo(String orgCode);

	List<Map<String, Object>> queryUserByPhone(String phone);

}
