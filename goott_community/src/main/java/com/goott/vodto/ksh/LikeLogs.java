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
public class LikeLogs {
	private int like_no;
	private String memberId;
	private Timestamp date;
	private int likeStatus;
	private int board_no;
	private int ref_category_no;
}
