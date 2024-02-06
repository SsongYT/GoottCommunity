package com.goott.dao.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

@Repository
public class QuestionBoardDaoImpl implements QuestionBoardDao {

	@Inject
	SqlSession session;
	
	private String ns = "com.goott.mappers.questionBoardMapper";

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
}
