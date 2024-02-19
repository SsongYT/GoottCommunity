package com.goott.controller.ksh;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.goott.service.ksh.QuestionBoardService;
import com.goott.service.ksh.UploadFileService;
import com.goott.vodto.ksh.AnswerDto;
import com.goott.vodto.ksh.LikeLogs;
import com.goott.vodto.ksh.QuestionBoardDto;
import com.goott.vodto.ksh.UploadFiles;

@RestController
@RequestMapping("/questionBoard/*")
public class QuestionBoardController {

	@Inject
	private QuestionBoardService qbService;

	@Inject
	private UploadFileService ufService;

	@RequestMapping("boardList")
	public ModelAndView boardList() {
		ModelAndView mav = new ModelAndView("questionBoard/boardList");

		return mav;
	}

	// 질문 게시판 모든 게시글 가져오기.
	@RequestMapping(value = "boardList/{pageNo}", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> questionBoardList(HttpServletRequest request, @PathVariable int pageNo) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		List<QuestionBoardDto> list = null;
		try {
			int totalPostCnt = qbService.getTotalPostCnt();
			list = qbService.getAllBoard();
			if (list != null) {
				map.put("totalPostCnt", totalPostCnt);
				map.put("pageNo", pageNo);
				map.put("list", list);
				map.put("status", "success");
				result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
			}
		} catch (SQLException | NamingException e) {
			map.put("status", "error");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
			e.printStackTrace();
		}
		return result;
	}

	// 질문 게시판 상세 글 페이지 이동
	@RequestMapping("questionBoard/{no}")
	public ModelAndView detailBoard(@PathVariable("no") int no) {
		ModelAndView mav = new ModelAndView("questionBoard/detailBoard");
		mav.addObject("no", no);
		return mav;
	}

	// 질문 게시판 상세 글 데이터 가져오기
	@RequestMapping(value = "questionBoard/{no}", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> questionBoardDetail(HttpServletRequest request,
			@PathVariable("no") int no) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = null;
		try {
			map = qbService.getDetailBoard(no);
			if (map != null) {
				map.put("status", "success");
				result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
			} else {
				map.put("status", "error");
				result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
			}
		} catch (SQLException | NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("status", "error");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
		}

		return result;

	}

	// 질문 게시글 작성 페이지로 이동
	@RequestMapping("questionBoard/writeBoard")
	public ModelAndView writeQuestionBoard(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("questionBoard/writeBoard");
		return mav;

	}

	// Summernote 이미지 업로드
	@RequestMapping(value = "uploadSummernoteImageFile/{savePath}", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public ResponseEntity<Map<String, Object>> uploadSummernoteImageFile(@RequestParam("file") MultipartFile uploadFile,
			HttpServletRequest request, @PathVariable String savePath) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		// 1. 파일이 저장될 경로 확인
		UploadFiles file = null;
		String paths[];
		if (savePath.equals("question")) {
			paths = getRealPath(request, "question");
		} else {
			paths = getRealPath(request, "answer");
		}
		String relativePath = paths[0];
		String realPath = paths[1];
		try {
			// 2. 서비스단에 데이터 전송
			file = ufService.uploadFile(uploadFile.getOriginalFilename(), uploadFile.getSize(),
					uploadFile.getContentType(), uploadFile.getBytes(), realPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (file != null) {
			String imageUrl = request.getContextPath() + "/" + relativePath + "/" + file.getNew_fileName();
			map.put("file", file);
			map.put("url", imageUrl);
			map.put("status", "success");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		} else {
			map.put("status", "fail");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
		}
		System.out.println(result.toString());
		return result;

	}

	// 파일 저장 경로 얻기
	public String[] getRealPath(HttpServletRequest request, String subPath) {
		String relativePath = "resources/summernote/questionBoard/" + subPath;
		String realPath = request.getSession().getServletContext().getRealPath(relativePath);
		return new String[] { relativePath, realPath };
	}

	// 질문 게시글 작성
	@RequestMapping(value = "insertBoard", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertQuestionBoard(@RequestBody QuestionBoardDto qBoard,
			HttpServletRequest request) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		System.out.println(qBoard.toString());
		try {
			// insert 성공 시
			if (qbService.insertBoard(qBoard)) {
				System.out.println("게시글 업로드 완료");
			}
		} catch (SQLException | NamingException e) {
			// insert 실패 시 업로드 파일이 있었다면 사용자 기기에서 파일 삭제
			deleteFile("question", qBoard.getFileList(), request);
			map.put("status", "fail");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
			e.printStackTrace();
		}
		map.put("status", "success");
		result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		return result;

	}

	// 질문 게시글에 대한 답변 등록
	@RequestMapping(value = "{no}/insertAnswer", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertAnswer(@RequestBody AnswerDto answer, HttpServletRequest request,
			@PathVariable int no) {
		Map<String, Object> map = new HashMap<String, Object>();
		ResponseEntity<Map<String, Object>> result = null;
		answer.setRef(no);
		try {
			if(qbService.insertAnswer(answer)) {				
				map.put("status", "success");
				result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
			}
		} catch (SQLException | NamingException e) {
			// insert 실패 시 업로드 파일이 있었다면 사용자 기기에서 파일 삭제
			deleteFile("answer", answer.getFileList(), request);
			map.put("status", "fail");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
			e.printStackTrace();
		}
		return result;
	}

	// 사용자 기기에서 파일 삭제
	public void deleteFile(String subPath, List<UploadFiles> fileList, HttpServletRequest request) {
		// 파일이 있다면
		if (!fileList.isEmpty()) {
			String relativePath = "resources/summernote/questionBoard/" + subPath;
			String realPath = request.getSession().getServletContext().getRealPath(relativePath);
			for (UploadFiles file : fileList) {
				ufService.deleteFile(file.getNew_fileName(), realPath);
			}
		}
	}
	
	// 질문 게시글에 대한 답변 등록
		@RequestMapping(value = "likeAnswer", method = RequestMethod.POST)
		public ResponseEntity<Map<String, Object>> likeAnswer(@RequestBody LikeLogs likeLogs, HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			ResponseEntity<Map<String, Object>> result = null;
			System.out.println(likeLogs.toString());			
			if(likeLogs != null) {				
				qbService.insertLikeLogs(likeLogs);
			}
			
			return result;
		}
}
