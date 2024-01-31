package com.goott.dao.ksh;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.goott.vodto.ksh.QuestionBoardDto;

@Repository
public class QuestionBoardDaoImpl implements QuestionBoardDao {

	@Inject
	SqlSession session;
	
	private String ns = "com.goott.mappers.questionBoardMapper";

	@Override
	public List<QuestionBoardDto> getAllBoard() throws Exception {
		
		return session.selectList(ns+".getAllBoard");
	}
}
