package com.thinkgem.jeesite.modules.org.entity;

import java.io.Serializable;
import java.util.List;


public class FormVO<T,V> implements Serializable {

	private static final long serialVersionUID = 1916379431204008341L;

	private T hdrObj;
	
	private List<V> dtlList;

	public T getHdrObj() {
		return hdrObj;
	}

	public void setHdrObj(T hdrObj) {
		this.hdrObj = hdrObj;
	}

	public List<V> getDtlList() {
		return dtlList;
	}

	public void setDtlList(List<V> dtlList) {
		this.dtlList = dtlList;
	}
	
	
}
