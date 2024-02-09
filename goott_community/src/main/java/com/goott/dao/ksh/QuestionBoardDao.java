package com.goott.dao.ksh;

import java.util.List;

import com.goott.vodto.ksh.Comments;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

public interface QuestionBoardDao {

	List<QuestionBoardDto> getAllBoard() throws Exception;

	int insertBoard(QuestionBoardDto qBoard) throws Exception;

	int insertUploadFiles(QuestionBoardDto qBoard) throws Exception;

	QuestionBoardDto getDetailBoard(int no) throws Exception;

	List<UploadFiles> getBoardUploadFile(int no) throws Exception;

	List<Comments> getAllComments(int no) throws Exception;


}
