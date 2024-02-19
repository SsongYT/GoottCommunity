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
	private String member_id;
	private Timestamp date;
	private int like_status;
	private int board_no;
	private int ref_category_no;
}
