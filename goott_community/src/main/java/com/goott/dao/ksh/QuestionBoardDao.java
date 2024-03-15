package com.goott.dao.ksh;

import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

public interface QuestionBoardDao {
	
	int getTotalPostCnt() throws SQLException, NamingException;

	List<QuestionBoardDto> getAllBoard() throws SQLException, NamingException;

	int insertBoard(QuestionBoardDto qBoard) throws SQLException, NamingException;

	int insertUploadFiles(List<UploadFiles> fileList, int no, int ref_board_category) throws SQLException, NamingException;

	QuestionBoardDto getDetailBoard(int no) throws SQLException, NamingException;

	List<UploadFiles> getBoardUploadFile(int no, int ref_category_no) throws SQLException, NamingException;

	List<AnswerDto> getAllAnswers(int no) throws SQLException, NamingException;

	int insertAnswer(AnswerDto answer) throws SQLException, NamingException;

	List<AnswerDto> getBoardUploadFile(List<AnswerDto> answers) throws SQLException, NamingException;

	int getLikeLogs(String member_id, int board_no, int ref_category_no) throws SQLException, NamingException;

	int insertLikeLogs(String member_id, int board_no, int ref_category_no, int like_status) throws SQLException, NamingException;

	int updateLikeLogs(String member_id, int board_no, int ref_category_no, int like_status) throws SQLException, NamingException;

	int updateAnswerLikeCount(String member_id, int board_no, int like_status) throws SQLException, NamingException;

	int deleteLikeLogs(String member_id, int board_no, int ref_category_no, int like_status) throws SQLException, NamingException;

	int deleteBoard(int no) throws SQLException, NamingException;

	int updateBoard(QuestionBoardDto qbDto) throws SQLException, NamingException;





}
