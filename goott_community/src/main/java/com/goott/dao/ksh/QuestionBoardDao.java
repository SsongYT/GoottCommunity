package com.goott.dao.ksh;

import java.util.List;

import com.goott.vodto.ksh.Answers;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

public interface QuestionBoardDao {
	
	int getTotalPostCnt() throws Exception;

	List<QuestionBoardDto> getAllBoard() throws Exception;

	int insertBoard(QuestionBoardDto qBoard) throws Exception;

	int insertUploadFiles(QuestionBoardDto qBoard) throws Exception;

	QuestionBoardDto getDetailBoard(int no) throws Exception;

	List<UploadFiles> getBoardUploadFile(int no) throws Exception;

	List<Answers> getAllAnswers(int no) throws Exception;


}
