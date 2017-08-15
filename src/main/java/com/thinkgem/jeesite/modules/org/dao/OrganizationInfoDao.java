package com.thinkgem.jeesite.modules.org.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.org.entity.OrganizationInfo;
import com.thinkgem.jeesite.modules.org.entity.Register;
import com.thinkgem.jeesite.modules.sys.entity.User;

@MyBatisDao
public interface OrganizationInfoDao extends CrudDao<OrganizationInfo> {

	List<Map<String, Object>> queryOrganInfo(String orgCode);

	List<Map<String, Object>> queryUserByMobile(String mobile);

	void updateOrgInfo(Register register);

	void updateAdminUser(Register register);

	void updateAdminUserWithMobile(Register register);

	List<User> findUserList(String orgCode);

	int updateUserByDelete(Map<String, Object> paraMap);

	OrganizationInfo findOrgan(String orgCode);

	List<Map<String, Object>> queryOtherUserByMobile(User user);

	User findUser(Map<String, Object> paraMap);

	void updateOrgInfoAdmin(User user);

}
