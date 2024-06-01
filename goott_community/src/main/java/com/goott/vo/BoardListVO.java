package com.goott.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class BoardListVO {
	private int no;
	private String writer;
	private String title;
	private Timestamp post_date;
	private String content;
	private int read_count;
	private int like_count;
	private int ref;
	private int step;
	private int reforder;
}
