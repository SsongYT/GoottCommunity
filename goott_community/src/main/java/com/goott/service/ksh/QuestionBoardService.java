package com.goott.service.ksh;

import java.util.List;

import com.goott.vodto.ksh.QuestionBoardDto;

public interface QuestionBoardService {

	List<QuestionBoardDto> getAllBoard() throws Exception;

	boolean insertBoard(QuestionBoardDto qBoard) throws Exception;
	
	

}
