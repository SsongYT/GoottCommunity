package com.goott.service;

import java.io.IOException;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goott.dto.LoginDTO;
import com.goott.dto.MemberDTO;
import com.goott.etc.ResponseData;
import com.goott.etc.ResponseEnum;
import com.goott.mapper.MemberMapper;


@Service
public class MemberService {
	
	private final MemberMapper memberMapper;
	
	@Autowired
	public MemberService(MemberMapper memberMapper) {
		this.memberMapper = memberMapper;
	}
	
	// 아이디 중복검사
	public ResponseData hasMemberId(String checkId) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		if(memberMapper.selectMemberById(checkId) == 0) {
			responseData.setCode(ResponseEnum.basic_true.getCode());
			responseData.setMessages(ResponseEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseEnum.check_false_id.getCode());
			responseData.setMessages(ResponseEnum.check_false_id.getMessages());

		}
		
		return responseData;
	}
	// 회원 가입
	public ResponseData inputMember(MemberDTO memberDTO) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		if(memberMapper.insertMember(memberDTO) == 1) {
			responseData.setCode(ResponseEnum.basic_true.getCode());
			responseData.setMessages(ResponseEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseEnum.basic_false.getCode());
			responseData.setMessages(ResponseEnum.basic_false.getMessages());

		}
		
		return responseData;
	}
	// 회원 탈퇴
	public ResponseData deleteMember(String deleteID) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		if(memberMapper.deleteMember(deleteID) == 1) {
			responseData.setCode(ResponseEnum.basic_true.getCode());
			responseData.setMessages(ResponseEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseEnum.basic_false.getCode());
			responseData.setMessages(ResponseEnum.basic_false.getMessages());

		}
		
		return responseData;
	}
	
	// 로그인
	public ResponseData canLoginMember(LoginDTO loginDTO) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();

		if(memberMapper.selectLoginById(loginDTO) == 1) {
			if(memberMapper.selectLoginMember(loginDTO) == 1) {
				responseData.setCode(ResponseEnum.basic_true.getCode());
				responseData.setMessages(ResponseEnum.basic_true.getMessages());

			} else {
				responseData.setCode(ResponseEnum.login_fasle_password.getCode());
				responseData.setMessages(ResponseEnum.login_fasle_password.getMessages());

			}
		} else {
			responseData.setCode(ResponseEnum.login_fasle_id.getCode());
			responseData.setMessages(ResponseEnum.login_fasle_id.getMessages());

		}
		
		return responseData;
	}

	

}
