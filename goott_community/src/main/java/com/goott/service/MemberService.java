package com.goott.service;

import java.io.IOException;
import java.sql.SQLException;

import org.springframework.stereotype.Service;

import com.goott.dto.LoginDTO;
import com.goott.dto.MemberDTO;
import com.goott.mapper.MemberMapper;


@Service
public class MemberService {
	
	private final MemberMapper memberMapper;
	
	public MemberService(MemberMapper memberMapper) {
		this.memberMapper = memberMapper;
	}
	// 아이디 중복검사
	public ResponseData hasMemberId(String checkId) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		if(memberMapper.selectMemberById(checkId) == 0) {
			responseData.setCode(ResponseDataEnum.basic_true.getCode());
			responseData.setMessages(ResponseDataEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseDataEnum.check_false_id.getCode());
			responseData.setMessages(ResponseDataEnum.check_false_id.getMessages());

		}
		
		return responseData;
	}
	// 회원 가입
	public ResponseData inputMember(MemberDTO memberDTO) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		if(memberMapper.insertMember(memberDTO) == 1) {
			responseData.setCode(ResponseDataEnum.basic_true.getCode());
			responseData.setMessages(ResponseDataEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseDataEnum.basic_false.getCode());
			responseData.setMessages(ResponseDataEnum.basic_false.getMessages());

		}
		
		return responseData;
	}
	// 회원 탈퇴
	public ResponseData deleteMember(String deleteID) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		if(memberMapper.deleteMember(deleteID) == 1) {
			responseData.setCode(ResponseDataEnum.basic_true.getCode());
			responseData.setMessages(ResponseDataEnum.basic_true.getMessages());

		} else {
			responseData.setCode(ResponseDataEnum.basic_false.getCode());
			responseData.setMessages(ResponseDataEnum.basic_false.getMessages());

		}
		
		return responseData;
	}
	
	// 로그인
	public ResponseData canLoginMember(LoginDTO loginDTO) throws SQLException, IOException {
		ResponseData responseData = new ResponseData();

		if(memberMapper.selectLoginById(loginDTO) == 1) {
			if(memberMapper.selectLoginMember(loginDTO) == 1) {
				responseData.setCode(ResponseDataEnum.basic_true.getCode());
				responseData.setMessages(ResponseDataEnum.basic_true.getMessages());

			} else {
				responseData.setCode(ResponseDataEnum.login_fasle_password.getCode());
				responseData.setMessages(ResponseDataEnum.login_fasle_password.getMessages());

			}
		} else {
			responseData.setCode(ResponseDataEnum.login_fasle_id.getCode());
			responseData.setMessages(ResponseDataEnum.login_fasle_id.getMessages());

		}
		
		return responseData;
	}

	

}
