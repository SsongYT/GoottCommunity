package com.goott.vodto.ksh;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

// 페이징 처리를 하기 위한 객체 
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class PagingInfo {
	// --------------------------------------------------------------------------------------------------
	// 1페이지 당 출력할 데이터를 끊어 내기 위해 필요한 멤버들
	private int totalPostCnt; // 전체 게시판 글의 갯수
	private int viewPostCntPerPage = 10; // 1페이지당 출력할 글의 개수
	private int totalPageCnt; // 총 페이지 수
	private int startRowIndex; // 보여주기 시작할 글의 row index 번호
	private int pageNo; // 유저가 클릭한 현재 페이지 번호
	// --------------------------------------------------------------------------------------------------

	// pagination을 위한 작업
	private int pageCntPerBlock = 3; // 한 개 블럭에 보여줄 페이지 번호의 개수
	private int totalPagingBlockCnt; // 전체 페이징 블럭의 갯수
	private int pageBlockOfCurrentPage; // 현재 페이지가 속한 페이징 블럭 번호
	private int startNumOfCurrentPagingBlock; // 현재 페이징 블럭에서의 출력 시작 페이지 번호
	private int endNumOfCurrentPagingBlock; // 현재 페이징 블럭에서의 출력 끝 페이지 번호

	public PagingInfo(int totalPostCnt, int pageNo) {

		this.totalPostCnt = totalPostCnt;
		this.pageNo = pageNo;
		// 총 페이지 수 = 게시판의 글 수 / 한 페이지 당 보여줄 글의 갯수 ->
		// 나누어 떨어지지 않으면 + 1
		if (totalPostCnt % viewPostCntPerPage == 0) {

			this.totalPageCnt = totalPostCnt / viewPostCntPerPage;
		} else {
			this.totalPageCnt = totalPostCnt / viewPostCntPerPage + 1;
		}
				
//				-- 2) 현재 페이지가 속한 페이징 블럭 번호 : 
//				-- 현재 페이지번호 / pageCntPerBlock -> 나누어 떨어지지 않으면 올림
//				-- ex) 현재 페이지가 2/ 2 = 1번블럭

		if ((this.pageNo % this.pageCntPerBlock) == 0) {
			this.pageBlockOfCurrentPage = this.pageNo / this.pageCntPerBlock;
		} else {
			this.pageBlockOfCurrentPage = (int) (Math.ceil(this.pageNo / (double) this.pageCntPerBlock));
		}		

//				-- (현재 페이지번호 -1) * 1페이지당 보여줄 글의 갯수
		this.startRowIndex = (this.pageNo - 1) * this.viewPostCntPerPage;
		
		// 3) 현재 페이징 블럭 시작 페이지 번호 = ((현재 페이징 블럭 번호 - 1) * pageCntPerBlock) + 1
		this.startNumOfCurrentPagingBlock = ((this.pageBlockOfCurrentPage - 1) * this.pageCntPerBlock) + 1;

		// 전체 페이징 블럭 갯수 = 전체 페이지 수 / pageCntPerBlock -> 나누어 떨어지지 않으면 + 1
		if (this.totalPageCnt % this.pageCntPerBlock == 0) {

			this.totalPagingBlockCnt = this.totalPageCnt / this.pageCntPerBlock;
		} else {
			this.totalPagingBlockCnt = (this.totalPageCnt / this.pageCntPerBlock) + 1;

		}

		
		// -- 4) 현재 페이징 블럭 끝 페이지 번호 = (현재 페이지 블럭번호) * pageCntPerBlock
		this.endNumOfCurrentPagingBlock = this.pageBlockOfCurrentPage * this.pageCntPerBlock;

		if (this.endNumOfCurrentPagingBlock > this.totalPageCnt) {
			this.endNumOfCurrentPagingBlock = this.totalPageCnt;
		}

		


	}

}
