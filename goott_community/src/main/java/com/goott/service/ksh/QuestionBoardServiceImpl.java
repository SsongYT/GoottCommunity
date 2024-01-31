package com.goott.service.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.goott.dao.ksh.QuestionBoardDao;
import com.goott.vodto.ksh.QuestionBoardDto;


@Service
public class QuestionBoardServiceImpl implements QuestionBoardService {
	@Inject
	private QuestionBoardDao qbDao;
	
	@Override
	public List<QuestionBoardDto> getAllBoard() throws Exception {
		List<QuestionBoardDto> list = null;
		list = qbDao.getAllBoard();
		return list;
	}

}
