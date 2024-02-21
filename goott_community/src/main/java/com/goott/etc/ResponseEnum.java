package com.goott.etc;

import lombok.Getter;

@Getter
public enum ResponseEnum {
	
	basic_true("000", "성공"),
	basic_false("001", "실패"),
	
	check_false_id("C01", "아이디 중복"),
	
	login_fasle_id("L01", "아이디 없음"),
	login_fasle_password("L02", "비밀번호 불일치"),
	
	session_fasle("500", "세션오류");
	
	private String code;
	private String messages;

	ResponseEnum(String code, String messages) {
		this.code = code;
		this.messages = messages;
	}
	
}
