package com.goott.controller.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.goott.service.ksh.QuestionBoardService;
import com.goott.service.ksh.UploadFileService;
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

	@RequestMapping("questionBoard/all")
	public ResponseEntity<Map<String, Object>> questionBoardList(HttpServletRequest request, Model model) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		List<QuestionBoardDto> list = null;
		try {
			list = qbService.getAllBoard();
			if (list != null) {
				map.put("list", list);
				map.put("status", "success");
				System.out.println(map.toString());
				result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
			}

		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "error");
			result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
		}

		return result;
	}

	@RequestMapping("questionBoard/{no}")
	public ResponseEntity<Map<String, Object>> questionBoardDetail(HttpServletRequest request,
			@PathVariable("no") String no) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		return result;

	}

	@RequestMapping("questionBoard/writeBoard")
	public ModelAndView writeQuestionBoard(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("questionBoard/writeBoard");
		return mav;

	}

	@RequestMapping(value = "uploadSummernoteImageFile", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	public ResponseEntity<Map<String, Object>> uploadSummernoteImageFile(@RequestParam("file") MultipartFile uploadFile,
			HttpServletRequest request) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		// 1. 파일이 저장될 경로 확인
		UploadFiles file = null;
		String relativePath = "/resources/summernote/questionBoardUploadFiles";
		String realPath = request.getSession().getServletContext()
				.getRealPath("resources/summernote/questionBoardUploadFiles");
		System.out.println(realPath.toString());
		try {
			// 2. 서비스단에 데이터 전송
			file = ufService.uploadFile(uploadFile.getOriginalFilename(), uploadFile.getSize(),
					uploadFile.getContentType(), uploadFile.getBytes(), realPath);
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (file != null) {
			String imageUrl = request.getContextPath() + relativePath + "/" + file.getNewFileName();
			map.put("fileName", file.getNewFileName());
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

	@RequestMapping(value = "insertBoard", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertQuestionBoard(@ModelAttribute QuestionBoardDto qBoard,
			HttpServletRequest request) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		System.out.println(qBoard.toString());
		map.put("status", "success");
		result = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		return result;

	}

}
