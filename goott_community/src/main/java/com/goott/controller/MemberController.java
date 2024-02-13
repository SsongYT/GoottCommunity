package com.goott.controller;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.goott.dto.LoginDTO;
import com.goott.dto.MemberDTO;
import com.goott.service.MemberService;

@RestController
public class MemberController {
	
	private final MemberService memberService;
	
	public MemberController(MemberService memberService) {
		this.memberService = memberService;
	}
	
	//아이디 중복검사
	@GetMapping("signup/id/{checkId}")
	public ResponseEntity<ResponseData> hasCheckId(@PathVariable("checkId") String checkId) {
		ResponseData responseData = new ResponseData();
		HttpStatus httpStatus = null;
		
		try {
			responseData = memberService.hasMemberId(checkId);
			
			if(responseData.getCode().equals("000")){
				httpStatus = HttpStatus.OK;
			} else {
				httpStatus = HttpStatus.BAD_REQUEST;
			}
			
		} catch (SQLException | IOException e) {
			responseData = new ResponseData();
			httpStatus = ExceptionEnum.SQLException.getHttpStatus();
			responseData.setCode(ExceptionEnum.SQLException.getCode());
			responseData.setMessages(ExceptionEnum.SQLException.getMessages());
		}
		
		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}
	
	//회원가입
	@PostMapping("signup")
	public ResponseEntity<ResponseData> inputSignupData(@RequestBody MemberDTO memberDTO) {
		ResponseData responseData = new ResponseData();
		HttpStatus httpStatus = null;
		
		try {
			responseData = memberService.inputMember(memberDTO);
			if(responseData.getCode().equals("000")){
				httpStatus = HttpStatus.OK;
			} else {
				httpStatus = HttpStatus.BAD_REQUEST;
			}
			
		} catch (SQLException | IOException e) {
			responseData = new ResponseData();
			httpStatus = ExceptionEnum.SQLException.getHttpStatus();
			responseData.setCode(ExceptionEnum.SQLException.getCode());
			responseData.setMessages(ExceptionEnum.SQLException.getMessages());
		}

		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}
	
	//회원 탈퇴
	@DeleteMapping("signup/{deleteID}")
	public ResponseEntity<ResponseData> deleteMember(@PathVariable("deleteID") String deleteID, HttpSession session) {
		String userId= (String)session.getAttribute("loginMember");
		ResponseData responseData = null;
		HttpStatus httpStatus = null;
		
		if(userId.equals(deleteID)) {
			try {
				responseData = memberService.deleteMember(deleteID);
				if(responseData.getCode().equals("000")){
					httpStatus = HttpStatus.OK;
				} else {
					httpStatus = HttpStatus.BAD_REQUEST;
				}
				
			} catch (SQLException | IOException e) {
				responseData = new ResponseData();
				httpStatus = ExceptionEnum.SQLException.getHttpStatus();
				responseData.setCode(ExceptionEnum.SQLException.getCode());
				responseData.setMessages(ExceptionEnum.SQLException.getMessages());
			}
		} else {
			responseData = new ResponseData();
			httpStatus = HttpStatus.BAD_REQUEST;
			responseData.setCode(ResponseDataEnum.session_fasle.getCode());
			responseData.setMessages(ResponseDataEnum.session_fasle.getMessages());
		}
		
		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}
	
	//로그인
	@PostMapping("login")
	public ResponseEntity<ResponseData> canLogin(@RequestBody LoginDTO loginDTO, HttpSession session) {
		ResponseData responseData = null;
		HttpStatus httpStatus = null;
		
		try {
			responseData = memberService.canLoginMember(loginDTO);
			if(responseData.getCode().equals("000")){
				session.setAttribute("loginMember", loginDTO.getUserId());
				httpStatus = HttpStatus.OK;
			} else {
				httpStatus = HttpStatus.BAD_REQUEST;
			}
			
		} catch (SQLException | IOException e) {
			responseData = new ResponseData();
			httpStatus = ExceptionEnum.SQLException.getHttpStatus();
			responseData.setCode(ExceptionEnum.SQLException.getCode());
			responseData.setMessages(ExceptionEnum.SQLException.getMessages());
		}

		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}
}
