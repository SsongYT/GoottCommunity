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
public class AnswerDto {
	private int answer_no;
	private String writer;
	private String content;
	private int ref_category_no;
	private int ref;
	private Timestamp post_date;
	private List<UploadFiles> fileList;
	private int board_category_no = 2;
	private int file_count;
	private int no;
}