package com.goott.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goott.etc.ResponseData;
import com.goott.etc.ResponseEnum;
import com.goott.mapper.BoardMapper;
import com.goott.vo.BoardListVO;

@Service
public class BoardService {
	
	private final BoardMapper boardMapper;
	
	@Autowired
	public BoardService(BoardMapper boardMapper) {
		this.boardMapper = boardMapper;
	}

	public ResponseData getBoardList() throws SQLException, IOException {
		ResponseData responseData = new ResponseData();
		
		List<BoardListVO> boardList = boardMapper.selectBoardList();
		
		if(boardList.size() == 0) {
			responseData.setCode(ResponseEnum.basic_false.getCode());
			responseData.setMessages(ResponseEnum.basic_false.getMessages());
			responseData.setData(boardList);
		} else if(boardList.size() > 0) {
			responseData.setCode(ResponseEnum.basic_true.getCode());
			responseData.setMessages(ResponseEnum.basic_true.getMessages());
			responseData.setData(boardList);
		}
		
		return responseData;
	}

	public ResponseData getBoarddetail() throws SQLException, IOException {
		// TODO Auto-generated method stub
		return null;
	}
	
}
