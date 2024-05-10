package com.goott.mapper;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goott.vo.BoardListVO;

@Mapper
public interface BoardMapper {

	List<BoardListVO> selectBoardList() throws SQLException, IOException;;

}
