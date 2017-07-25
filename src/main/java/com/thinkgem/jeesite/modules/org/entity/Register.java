package com.thinkgem.jeesite.modules.org.entity;

import java.io.Serializable;

import org.hibernate.validator.constraints.Length;

/**
 * 
 * @author luquan.peng
 *
 */
public class Register implements Serializable {

	private static final long serialVersionUID = 8103258413207608424L;

	@Length(min=1, max=30, message="机构代码长度必须介于 1 和 30 之间")
	private String orgCode;
	
	@Length(min=1, max=100, message="机构名称长度必须介于 1 和 100 之间")
	private String orgName;
	
	@Length(min=1, max=50, message="联系人名称长度必须介于 1 和 50 之间")
	private String contactName;
	
	@Length(min=1, max=100, message="联系人邮箱长度必须介于 1 和 100 之间")
	private String contactEmail;
	
	@Length(min=1, max=20, message="联系人手机号长度必须介于 1 和 20 之间")
	private String contactPhone;
	
	private String validateCode;
	
	private String phoneCheckCode;
	
	@Length(min=6, max=32, message="密码长度必须介于 6 和 32 位之间")
	private String password;

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getContactEmail() {
		return contactEmail;
	}

	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public String getValidateCode() {
		return validateCode;
	}

	public void setValidateCode(String validateCode) {
		this.validateCode = validateCode;
	}

	public String getPhoneCheckCode() {
		return phoneCheckCode;
	}

	public void setPhoneCheckCode(String phoneCheckCode) {
		this.phoneCheckCode = phoneCheckCode;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	
}
