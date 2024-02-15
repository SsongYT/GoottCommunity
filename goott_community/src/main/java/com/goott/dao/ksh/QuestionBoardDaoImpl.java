package com.goott.dao.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

@Repository
public class QuestionBoardDaoImpl implements QuestionBoardDao {

	@Inject
	SqlSession session;
	
	private String ns = "com.goott.mappers.questionBoardMapper";
	
	@Override
	public int getTotalPostCnt() throws Exception {
		// 총 게시글 개수
		return session.selectOne(ns+".getTotalPostCnt");
	}

	@Override
	public List<QuestionBoardDto> getAllBoard() throws Exception {

		return session.selectList(ns+".getAllBoard");
	}

	@Override
	public int insertBoard(QuestionBoardDto qBoard) throws Exception {
		
		return session.insert(ns+".insertBoard", qBoard);
	}

	@Override
	public QuestionBoardDto getDetailBoard(int no) throws Exception {
		
		return session.selectOne(ns + ".getDetailBoard", no);
	}

	
	@Override
	public List<UploadFiles> getBoardUploadFile(int no, int ref_category_no) throws Exception {
		 Map<String, Object> map = new HashMap<>();
		    map.put("ref_category_no", ref_category_no);
		    map.put("no", no);
		return session.selectList(ns + ".getBoardUploadFile", map);
	}

	@Override
	public List<AnswerDto> getAllAnswers(int no) throws Exception {
		// TODO Auto-generated method stub
		return session.selectList(ns + ".getAllAnswers", no);

	}

	@Override
	public int insertAnswer(AnswerDto answer) throws Exception {
		return session.insert(ns+".insertAnswer", answer);
	}


	@Override
	public int insertUploadFiles(List<UploadFiles> fileList, int no, int ref_board_category) throws Exception {
		 int count = 0;
		    Map<String, Object> map = new HashMap<>();
		    map.put("list", fileList);
		    map.put("no", no);
		    map.put("ref_board_category", ref_board_category);		    
		    try {
		        // 실행 결과 row 갯수를 리턴합니다.
		        count = session.insert(ns + ".insertUploadFiles", map);
		        System.out.println(count + "개 insert 완료");
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return count;
	}

	@Override
	public List<AnswerDto> getBoardUploadFile(List<AnswerDto> answers) {
		for (AnswerDto answer : answers) {
	        if(answer.getFile_count()>0) {
	        	answer.setFileList(session.selectList(ns+".getAnswerUploadFile", answer));
	        }
	    }
	    return answers;

	}

	
}
