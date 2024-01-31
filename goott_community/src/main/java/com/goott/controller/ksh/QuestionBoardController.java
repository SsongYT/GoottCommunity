package com.goott.controller.ksh;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.goott.service.ksh.QuestionBoardService;
import com.goott.vodto.ksh.QuestionBoardDto;

@RestController
@RequestMapping("/questionBoard/*")
public class QuestionBoardController {

	@Inject private QuestionBoardService qbService;
	
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
				if(list != null) {
					map.put("list", list);
					map.put("status", "success");
					System.out.println(map.toString());
					result = new ResponseEntity<Map<String,Object>>(map, HttpStatus.OK);
				}
						
		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "error");
			result = new ResponseEntity<Map<String,Object>>(map, HttpStatus.BAD_REQUEST);
		}
		
		return result;
	}
	
	@RequestMapping("questionBoard/{no}")
	public ResponseEntity<Map<String, Object>> questionBoardDetail(HttpServletRequest request, @PathVariable("no") String no) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		return result;
	
	}
	
	@RequestMapping("questionBoard/writeBoard")
	public ModelAndView writeQuestionBoard(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("questionBoard/writeBoard");
		return mav;
	
	}
	
}
