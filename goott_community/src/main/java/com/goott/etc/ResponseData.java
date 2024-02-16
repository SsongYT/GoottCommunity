package com.goott.etc;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResponseData {
	private String code;
	private String messages;

	private Object data;
	
}
