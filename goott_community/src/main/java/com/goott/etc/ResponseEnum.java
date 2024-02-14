package com.goott.etc;

public enum ResponseEnum {
	
	basic_true("000", "성공"),
	basic_false("001", "실패"),
	
	check_false_id("002", "아이디 중복"),
	
	login_fasle_id("003", "아이디 없음"),
	login_fasle_password("004", "비밀번호 불일치"),
	
	session_fasle("500", "세션오류");
	
	private String code;
	private String messages;

	ResponseEnum(String code, String messages) {
		this.code = code;
		this.messages = messages;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessages() {
		return messages;
	}

	public void setMessages(String messages) {
		this.messages = messages;
	}
	
}
