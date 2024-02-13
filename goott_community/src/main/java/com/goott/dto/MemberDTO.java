package com.goott.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDTO {
	private String userId;
	private String userPassword;
	private String userName;
	private String userPhoneNo;
	private String userEmail;
	
}
