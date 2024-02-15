function createPagingInfo(totalPostCntData, pageNoData) {
	    let viewPostCntPerPage = 2; // 한 페이지당 보여줄 글의 개수
	    let pageCntPerBlock = 3; // 한 블록당 보여줄 페이지의 개수
		let totalPostCnt = totalPostCntData;
	    let pageNo = pageNoData;
	    // 총 페이지 수 계산
	    let totalPageCnt = Math.ceil(totalPostCnt / viewPostCntPerPage);

	    // 현재 페이지가 속한 페이징 블록 번호 계산
	    let pageBlockOfCurrentPage = Math.ceil(pageNo / pageCntPerBlock);

	    // 현재 페이지의 시작 행 인덱스 계산
	    let startRowIndex = (pageNo - 1) * viewPostCntPerPage;

	    // 현재 페이징 블록의 시작 페이지 번호 계산
	    let startNumOfCurrentPagingBlock = (pageBlockOfCurrentPage - 1) * pageCntPerBlock + 1;

	    // 전체 페이징 블록의 개수 계산
	    let totalPagingBlockCnt = Math.ceil(totalPageCnt / pageCntPerBlock);

	    // 현재 페이징 블록의 끝 페이지 번호 계산
	    let endNumOfCurrentPagingBlock = Math.min(pageBlockOfCurrentPage * pageCntPerBlock, totalPageCnt);

	    return {
	    	viewPostCntPerPage: viewPostCntPerPage,
	    	pageCntPerBlock: pageCntPerBlock,
	        totalPostCnt: totalPostCnt,
	        pageNo: pageNo,
	        totalPageCnt: totalPageCnt,
	        pageBlockOfCurrentPage: pageBlockOfCurrentPage,
	        startRowIndex: startRowIndex,
	        startNumOfCurrentPagingBlock: startNumOfCurrentPagingBlock,
	        totalPagingBlockCnt: totalPagingBlockCnt,
	        endNumOfCurrentPagingBlock: endNumOfCurrentPagingBlock
	    };
	}

	// 사용 예시
	function makePi(totalPostCntData, pageNoData) {
	let pageInfo = createPagingInfo(totalPostCntData, pageNoData);
	showBoard(pageInfo);
	}