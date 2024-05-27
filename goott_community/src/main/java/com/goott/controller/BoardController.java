package com.goott.controller;

import java.io.IOException;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goott.etc.ResponseData;
import com.goott.service.BoardService;

@RestController
public class BoardController {
	
	private final BoardService boardService;
	
	@Autowired
	public BoardController(BoardService boardService) {
		this.boardService = boardService;
	}
	
	@GetMapping("boardList")
	public ResponseEntity<ResponseData> boardList() {
		ResponseData responseData = new ResponseData();
		HttpStatus httpStatus = null;
		
		try {
			
			responseData = boardService.getBoardList();
			if(responseData.getCode().equals("000")){
				httpStatus = HttpStatus.OK;
			} else {
				httpStatus = HttpStatus.BAD_REQUEST;
			}
			
		} catch (SQLException | IOException e) {
			
			e.printStackTrace();
			// 통신에러 예외처리
		}
		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}

	@GetMapping("boarddetail")
	public ResponseEntity<ResponseData> boarddetail() {
		ResponseData responseData = new ResponseData();
		HttpStatus httpStatus = null;
		
		try {
			
			responseData = boardService.getBoarddetail();
			if(responseData.getCode().equals("000")){
				httpStatus = HttpStatus.OK;
			} else {
				httpStatus = HttpStatus.BAD_REQUEST;
			}
			
		} catch (SQLException | IOException e) {
			
			e.printStackTrace();
			// 통신에러 예외처리
		}
		

		return new ResponseEntity<ResponseData>(responseData, httpStatus);
	}

	
	
}
