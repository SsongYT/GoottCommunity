package com.goott.etc;

public class ResponseData {
	private String code;
	private String messages;

	private Object data;

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

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	@Override
	public String toString() {
		return "ResponseData [code=" + code + ", messages=" + messages + ", data=" + data + "]";
	}
	
	
}
