package com.goott.dao.ksh;

import java.util.List;

import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

public interface QuestionBoardDao {
	
	int getTotalPostCnt() throws Exception;

	List<QuestionBoardDto> getAllBoard() throws Exception;

	int insertBoard(QuestionBoardDto qBoard) throws Exception;

	int insertUploadFiles(List<UploadFiles> fileList, int no, int ref_board_category) throws Exception;

	QuestionBoardDto getDetailBoard(int no) throws Exception;

	List<UploadFiles> getBoardUploadFile(int no, int ref_category_no) throws Exception;

	List<AnswerDto> getAllAnswers(int no) throws Exception;

	int insertAnswer(AnswerDto answer) throws Exception;

	List<AnswerDto> getBoardUploadFile(List<AnswerDto> answers);




}
