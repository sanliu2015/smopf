package com.thinkgem.jeesite.modules.org.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.org.entity.OrgAttachment;
import com.thinkgem.jeesite.modules.org.entity.OrgAuditLog;

@MyBatisDao
public interface OrgAuditLogDao extends CrudDao<OrgAuditLog> {

	List<Map<String, Object>> queryList(String orgCode);

	void updateFileStatus(OrgAttachment attachment);

}
