package com.goott.dao.ksh;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.naming.NamingException;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.LikeLogs;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

@Repository
public class QuestionBoardDaoImpl implements QuestionBoardDao {

	@Inject
	SqlSession session;

	private String ns = "com.goott.mappers.questionBoardMapper";

	@Override
	public int getTotalPostCnt() throws SQLException, NamingException {
		// 총 게시글 개수
		return session.selectOne(ns + ".getTotalPostCnt");
	}

	@Override
	public List<QuestionBoardDto> getAllBoard() throws SQLException, NamingException {

		return session.selectList(ns + ".getAllBoard");
	}

	@Override
	public int insertBoard(QuestionBoardDto qBoard) throws SQLException, NamingException {

		return session.insert(ns + ".insertBoard", qBoard);
	}

	@Override
	public QuestionBoardDto getDetailBoard(int no) throws SQLException, NamingException {

		return session.selectOne(ns + ".getDetailBoard", no);
	}

	@Override
	public List<UploadFiles> getBoardUploadFile(int no, int ref_category_no) throws SQLException, NamingException {
		Map<String, Object> map = new HashMap<>();
		map.put("ref_category_no", ref_category_no);
		map.put("no", no);
		return session.selectList(ns + ".getBoardUploadFile", map);
	}

	@Override
	public List<AnswerDto> getAllAnswers(int no) throws SQLException, NamingException {

		return session.selectList(ns + ".getAllAnswers", no);

	}

	@Override
	public int insertAnswer(AnswerDto answer) throws SQLException, NamingException {
		return session.insert(ns + ".insertAnswer", answer);
	}

	@Override
	public int insertUploadFiles(List<UploadFiles> fileList, int no, int ref_board_category) throws SQLException, NamingException {
		int count = 0;
		Map<String, Object> map = new HashMap<>();
		map.put("list", fileList);
		map.put("no", no);
		map.put("ref_category_no", ref_board_category);
		count = session.insert(ns + ".insertUploadFiles", map);
		System.out.println(count + "개 insert 완료");

		return count;
	}

	@Override
	public List<AnswerDto> getBoardUploadFile(List<AnswerDto> answers) throws SQLException, NamingException {
		for (AnswerDto answer : answers) {
			if (answer.getFile_status() > 0) {
				answer.setFileList(session.selectList(ns + ".getAnswerUploadFile", answer));
			}
		}
		return answers;

	}

	@Override
	public int getLikeLogs(String member_id, int board_no, int ref_category_no) {
		Map<String, Object> map = new HashMap<>();
		map.put("member_id", member_id);
		map.put("board_no", board_no);
		map.put("ref_category_no", ref_category_no);

		Integer result = session.selectOne(ns+".getLikeLogs", map);		
		return result != null ? result : 0;
	}

	@Override
	public int insertLikeLogs(String member_id, int board_no, int ref_category_no, int like_status) throws SQLException, NamingException {
		Map<String, Object> map = new HashMap<>();
		map.put("member_id", member_id);
		map.put("board_no", board_no);
		map.put("ref_category_no", ref_category_no);
		map.put("like_status", like_status);		
		return session.insert(ns+".insertLikeLogs", map);
	}

	@Override
	public int updateLikeLogs(String member_id, int board_no, int ref_category_no, int like_status) throws SQLException, NamingException {
		Map<String, Object> map = new HashMap<>();
		map.put("member_id", member_id);
		map.put("board_no", board_no);
		map.put("ref_category_no", ref_category_no);
		map.put("like_status", like_status);		
		return session.insert(ns+".updateLikeLogs", map);
	}

	@Override
	public int updateAnswerLikeCount(String member_id, int board_no, int like_status)
			throws SQLException, NamingException {
		Map<String, Object> map = new HashMap<>();
		map.put("member_id", member_id);
		map.put("board_no", board_no);
		map.put("like_status", like_status);		
		return session.update(ns+".updateAnswerLikeCount", map);
	}

	@Override
	public int deleteLikeLogs(String member_id, int board_no, int ref_category_no, int like_status)
			throws SQLException, NamingException {
		Map<String, Object> map = new HashMap<>();
		map.put("member_id", member_id);
		map.put("board_no", board_no);
		map.put("ref_category_no", ref_category_no);
		map.put("like_status", like_status);		
		return session.delete(ns+".deleteLikeLogs", map);
	}

	@Override
	public int deleteBoard(int no) throws SQLException, NamingException {
		return session.delete(ns+".deleteBoard", no) ;
	}

	@Override
	public int updateBoard(QuestionBoardDto qbDto) throws SQLException, NamingException {
		return session.update(ns+".updateBoard", qbDto);
	}

}
