package com.goott.service.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goott.dao.ksh.QuestionBoardDao;
import com.goott.vodto.ksh.Answers;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;


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

	@Override
	public boolean insertBoard(QuestionBoardDto qBoard) throws Exception {
		boolean result = false;
		
		if(qbDao.insertBoard(qBoard) > 0) {
			
			// 업로드 파일이 있는지
			if(!qBoard.getFileList().isEmpty()) {
				// 파일 insert 성공 시
				if(qbDao.insertUploadFiles(qBoard) < qBoard.getFileList().size()) {
					System.out.println("qBoard.getFileList().size()"+ qBoard.getFileList().size());
				result = true;
				}
			} else { // 파일이 없는 게시글 insert 성공 시
				result = true;
			}
		};
		return result;
	}

	@Override
	public Map<String, Object> getDetailBoard(int no) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		// 클릭한 게시글 조회
		
		QuestionBoardDto detailBoard = qbDao.getDetailBoard(no);
		if(detailBoard != null) {
			result.put("detailBoard", detailBoard);
			if(detailBoard.getUfNoCount() > 0) {		
				// 파일 조회
				List<UploadFiles> detailFiles = qbDao.getBoardUploadFile(no);
				if(detailFiles != null) {
					result.put("detailFiles", detailFiles);
				}
			}
			if(detailBoard.getAnswerCount() > 0) {
				// 답변 조회
				List<Answers> answers = qbDao.getAllAnswers(no);
				if(answers != null) {
					result.put("detailAnswers", answers);
				}
			}
		}
		
		return result;
	}

}
