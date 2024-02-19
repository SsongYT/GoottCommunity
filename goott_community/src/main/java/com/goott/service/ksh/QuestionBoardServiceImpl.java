package com.goott.service.ksh;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.naming.NamingException;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goott.dao.ksh.QuestionBoardDao;
import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.LikeLogs;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

@Service
public class QuestionBoardServiceImpl implements QuestionBoardService {
	@Inject
	private QuestionBoardDao qbDao;

	@Override
	public int getTotalPostCnt() throws SQLException, NamingException {
		// 총 게시글 개수
		return qbDao.getTotalPostCnt();
	}

	@Override
	public List<QuestionBoardDto> getAllBoard() throws SQLException, NamingException {
		List<QuestionBoardDto> list = null;
		list = qbDao.getAllBoard();
		return list;
	}

	// 질문 게시글 등록
	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean insertBoard(QuestionBoardDto qBoard) throws SQLException, NamingException {
		boolean result = false;
		if (qbDao.insertBoard(qBoard) > 0) {
			result = insertFiles(qBoard.getFileList(), qBoard.getNo(), 1);
		}
		return result;
	}

	// 질문에 대한 답변 등록
	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean insertAnswer(AnswerDto answer) throws SQLException, NamingException {
		boolean result = false;
		if (qbDao.insertAnswer(answer) > 0) {
			result = insertFiles(answer.getFileList(), answer.getAnswer_no(), 2);
		}
		return result;
	}

	// 파일 insert
	private boolean insertFiles(List<UploadFiles> fileList, int no, int ref_board_category)
			throws SQLException, NamingException {
		if (fileList.isEmpty()) {
			return true; // 파일이 없는 경우 바로 true 반환
		}
		int successCount = qbDao.insertUploadFiles(fileList, no, ref_board_category);
		System.out.println("파일 insert 완료 개수: " + successCount);
		return successCount == fileList.size();
	}

	@Override
	public Map<String, Object> getDetailBoard(int no) throws SQLException, NamingException {
		Map<String, Object> result = new HashMap<String, Object>();
		// 클릭한 게시글 조회

		QuestionBoardDto detailBoard = qbDao.getDetailBoard(no);
		if (detailBoard != null) {
			result.put("detailBoard", detailBoard);
			if (detailBoard.getUfNoCount() > 0) {
				// 파일 조회
				List<UploadFiles> detailFiles = qbDao.getBoardUploadFile(no, 1);
				if (detailFiles != null) {
					result.put("detailFiles", detailFiles);
				}
			}
			if (detailBoard.getAnswerCount() > 0) {
				// 답변 조회
				List<AnswerDto> answers = qbDao.getAllAnswers(no);
				if (answers != null) {
					boolean fileExist = false;
					for (AnswerDto answer : answers) {
						if (answer.getFile_status() > 0) {
							fileExist = true;
						}
					}
					if (fileExist) {
						answers = qbDao.getBoardUploadFile(answers);
					}
					result.put("detailAnswers", answers);
				}
			}
		}
		return result;
	}

	@Override
	public boolean insertLikeLogs(LikeLogs likeLogs) {
		boolean result = false;
		// 좋아요 한 적이 있는지
		int likeStatus = qbDao.getLikeLogs(likeLogs.getMember_id(), likeLogs.getBoard_no(),
				likeLogs.getRef_category_no());
		
		// 좋아요 한 이력이 없을 땐 새로 insert
		if(likeStatus == 0) {
			qbDao.insertLikeLogs();
			
		// 좋아요 한 이력이 있고 likeStatus가 같은 값일 때 true 반환
		} else if (likeStatus == likeLogs.getLike_status()) {
			result = true;
			
		// 좋아요 한 이력이 있고 likeStatus가 다른 값일 때 update
		} else {
			qbDao.updateLikeLogs();
		}
		return result;
	}

}
