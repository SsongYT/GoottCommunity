package com.goott.vodto.ksh;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Comments {
	private int comment_no;
	private String writer;
	private String content;
	private int board_category_no;
	private int ref;
}
