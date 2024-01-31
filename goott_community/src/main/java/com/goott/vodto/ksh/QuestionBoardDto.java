package com.goott.vodto.ksh;

import java.sql.Timestamp;

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
public class QuestionBoardDto {
	private int no;
	private String writer;
	private Timestamp postDate;
	private String title;
	private String content;
	private int ref;


}
