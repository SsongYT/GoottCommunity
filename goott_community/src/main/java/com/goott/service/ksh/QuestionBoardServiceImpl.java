package com.goott.service.ksh;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.goott.dao.ksh.QuestionBoardDao;
import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.Answers;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;


@Service
public class QuestionBoardServiceImpl implements QuestionBoardService {
	@Inject
	private QuestionBoardDao qbDao;
	
	@Override
	public int getTotalPostCnt() throws Exception {
		// 총 게시글 개수
		return qbDao.getTotalPostCnt();
	}
	
	@Override
	public List<QuestionBoardDto> getAllBoard() throws Exception {
		List<QuestionBoardDto> list = null;
		list = qbDao.getAllBoard();
		return list;
	}

	// 질문 게시글 등록
	@Override
	public boolean insertBoard(QuestionBoardDto qBoard) throws Exception {		
		 boolean result = false;

		    if (qbDao.insertBoard(qBoard) > 0) {
		        result = insertFiles(qBoard.getFileList(), qBoard.getNo(), 1);
		    }
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
				List<UploadFiles> detailFiles = qbDao.getBoardUploadFile(no, 1);
				if(detailFiles != null) {
					result.put("detailFiles", detailFiles);
				}
			}
			if(detailBoard.getAnswerCount() > 0) {
				// 답변 조회
				List<AnswerDto> answers = qbDao.getAllAnswers(no);
				if(answers != null) {
					boolean fileExist = false;
					for (AnswerDto answer : answers) {
				        if(answer.getFile_count() > 0) {
				        	fileExist = true;
				        }					
				    }
					if(fileExist) {
						answers = qbDao.getBoardUploadFile(answers);
					}
					result.put("detailAnswers", answers);
				}
			}
		}
		
		return result;
	}

	// 질문 게시글에 대한 답변 등록
	@Override
	public boolean insertAnswer(AnswerDto answer) throws Exception {		
		boolean result = false;
		
		if (qbDao.insertAnswer(answer) > 0) {
	        result = insertFiles(answer.getFileList(), answer.getNo(), 2);
	    }
	    return result;
	}

	// 파일 insert 메서드
	private boolean insertFiles(List<UploadFiles> fileList, int no, int ref_board_category) throws Exception {
	    if (fileList.isEmpty()) {
	        return true; // 파일이 없는 경우 바로 true 반환
	    }

	    int successCount = qbDao.insertUploadFiles(fileList, no, ref_board_category);
	    System.out.println("파일 insert 완료 갯수: " + successCount);

	    return successCount == fileList.size();
	}
	

}
