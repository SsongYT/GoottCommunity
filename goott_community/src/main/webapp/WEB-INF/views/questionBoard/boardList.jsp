<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<title>질문게시판</title>
</head>
<script>
	let data = new Object();
	let pageNo = 0;
	let pageInfo = new Object();
	$(function() {
		getAllBoard(pageNo);
		showBoard();	
	});
	function getAllBoard(pageNo) {
		pageNo = pageNo || 1; // 매개변수가 없으면 0을 사용하도록 수정
		console.log(pageNo);
		let result = null;
		$.ajax({
			url : "/app/questionBoard/boardList/"+pageNo,
			type : "POST",
			dataType : "json",
			async : false,
			success : function(result) {
				data = result;
				console.log(data);
			},
			error : function(result) {
				console.log(data);
			}
		});
	
	}
	function showBoard(piData) {
		console.log("글목록 띄우기");
		let pi = piData || data.pagingInfo;	
		console.log(pi);
		let output = "";
		let piOutput = "";
		if(data.status == "success") {
			let items = data.list;
			console.log(items);
			console.log(pi.startRowIndex);
			for(let j = pi.startRowIndex; j < Math.min(items.length, pi.startRowIndex + pi.viewPostCntPerPage); j++){
				output += `<tr onclick="location.href='/app/questionBoard/\${items[j].no}'">
				<td class="col-md-3">\${items[j].no}</td>
				<td class="col-md-5">\${items[j].title}</td>
				<td class="col-md-4">\${items[j].writer}</td></tr>`;
			}
			
			
		}
		$('.tbody').html(output);
		$('.piOutput').html(piOutput);		
	}
	
	
	function createPagingInfo(totalPostCntData, pageNoData) {
	    let viewPostCntPerPage = 10; // 한 페이지당 보여줄 글의 갯수
	    let pageCntPerBlock = 3; // 한 블록당 보여줄 페이지의 갯수
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

	    // 전체 페이징 블록의 갯수 계산
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
	function makePi(a, b) {
	console.log(a);
	console.log(b);
	pageInfo = createPagingInfo(a, b); 
	console.log(pageInfo); // 총 페이지 수 출력
	showBoard(pageInfo);
	}

	
	
</script>
<body>
	<div class="container mt-3">
		<h2>질문게시판</h2>
		<p>코드, 학원, 취업 등 자유롭게 질문하고 답하세요!</p>
		<table class="table table-hover">
			<thead>
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>작성자</th>
				</tr>
			</thead>
			<tbody class="tbody">
			
			</tbody>
		</table>
		<button type="button" class="btn btn-primary" style="float:right;" onclick="location.href='/app/questionBoard/writeBoard'">글쓰기</button>
		<ul class="pagination piOutput"></ul>
	</div>
</body>
</html>