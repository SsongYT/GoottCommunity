package com.goott.dao.ksh;

import java.util.List;

import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

public interface QuestionBoardDao {

	List<QuestionBoardDto> getAllBoard() throws Exception;

	int insertBoard(QuestionBoardDto qBoard) throws Exception;

	int insertUploadFiles(QuestionBoardDto qBoard) throws Exception;


}
