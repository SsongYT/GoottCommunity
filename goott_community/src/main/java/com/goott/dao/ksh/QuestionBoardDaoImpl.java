package com.goott.dao.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.goott.vodto.ksh.Answers;
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
	public int insertUploadFiles(QuestionBoardDto qBoard) {
		int count = 0;
		Map<String, Object> map = new HashMap<>();
		map.put("list", qBoard.getFileList());
		map.put("no", qBoard.getNo());
		// 실행 결과 row 갯수를 리턴합니다.
				count += session.insert(ns + ".insertUploadFiles", map);
				System.out.println(count + "개 insert 완료");
		return count;
	}

	@Override
	public QuestionBoardDto getDetailBoard(int no) throws Exception {
		
		return session.selectOne(ns + ".getDetailBoard", no);
	}

	
	@Override
	public List<UploadFiles> getBoardUploadFile(int no) throws Exception {
		
		return session.selectList(ns + ".getBoardUploadFile", no);
	}

	@Override
	public List<Answers> getAllAnswers(int no) throws Exception {
		// TODO Auto-generated method stub
		return session.selectList(ns + ".getAllAnswers", no);

	}

	
}
