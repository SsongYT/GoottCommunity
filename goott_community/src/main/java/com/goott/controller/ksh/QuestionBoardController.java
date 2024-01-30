package com.goott.controller.ksh;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goott.service.ksh.QuestionBoardService;

@RestController
@RequestMapping("/questionBoard/*")
public class QuestionBoardController {

	@Inject private QuestionBoardService qbService;
	
	@RequestMapping("questionBoard/all")
	public ResponseEntity<Map<String, Object>> questionBoardList(HttpServletRequest request, Model model) {
		ResponseEntity<Map<String, Object>> result = null;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> list = null;
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
}
