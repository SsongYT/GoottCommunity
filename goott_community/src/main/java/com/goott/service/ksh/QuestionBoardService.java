package com.goott.service.ksh;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.LikeLogs;
import com.goott.vodto.ksh.QuestionBoardDto;

public interface QuestionBoardService {
	
	int getTotalPostCnt() throws SQLException, NamingException;

	List<QuestionBoardDto> getAllBoard() throws SQLException, NamingException;

	int insertBoard(QuestionBoardDto qBoard) throws SQLException, NamingException;

	Map<String, Object> getDetailBoard(int no) throws SQLException, NamingException;

	boolean insertAnswer(AnswerDto answer) throws SQLException, NamingException;

	String handleLikeLogs(LikeLogs likeLogs) throws SQLException, NamingException;

	boolean deleteBoard(int no, HttpServletRequest request) throws SQLException, NamingException;

	boolean updateBoard(QuestionBoardDto qbDto) throws SQLException, NamingException;
	

}
