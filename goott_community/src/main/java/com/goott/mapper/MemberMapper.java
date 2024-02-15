package com.goott.mapper;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.ibatis.annotations.Mapper;

import com.goott.dto.LoginDTO;
import com.goott.dto.MemberDTO;

@Mapper
public interface MemberMapper {
	// 회원가입
	int insertMember(MemberDTO memberDTO) throws SQLException, IOException;
	// 회원탈퇴
	int deleteMember(String memberId) throws SQLException, IOException;
	//ID 중복체크
	int selectMemberById(String checkId) throws SQLException, IOException;
	//아이디 존재유무확인
	int selectLoginById(LoginDTO loginDTO) throws SQLException, IOException;
	//로그인 시도
	int selectLoginMember(LoginDTO loginDTO) throws SQLException, IOException;
	// 세션정보를 통해 PK번호 가져오기
	int selectMemberPkByUserId(String userId) throws SQLException, IOException;
	
}
