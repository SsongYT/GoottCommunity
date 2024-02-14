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
	<script src="/app/resources/js/pagingInfo.js"></script>
<title>질문게시판</title>
</head>
<script>
	let data = new Object();
	let pageNoData = 0;
	$(function() {
		getAllBoard(pageNoData);
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
				makePi(data.totalPostCnt, data.pageNo);
			},
			error : function(result) {
				console.log(data);
			}
		});
	
	}
	function showBoard(pageInfo) {
		console.log("글목록과 페이지 블럭 띄우기");
		let pi = pageInfo;	
		console.log(pi);
		let output = "";
		let piOutput = "";
		if(data.status == "success") {
			let items = data.list;
			for(let j = pi.startRowIndex; j < Math.min(items.length, pi.startRowIndex + pi.viewPostCntPerPage); j++){
				output += `<tr onclick="location.href='/app/questionBoard/\${items[j].no}'">
				<td class="col-md-3">\${items[j].no}</td>
				<td class="col-md-5">\${items[j].title}</td>
				<td class="col-md-4">\${items[j].writer}</td></tr>`;
			}			
			if(pi.pageBlockOfCurrentPage != 1) {
				piOutput += `<li class="page-item"><a class="page-link" onclick="makePi(\${pi.totalPostCnt},1)">처음</a></li>`;
				piOutput += `<li class="page-item"><a class="page-link" onclick="makePi(\${pi.totalPostCnt},\${pi.startNumOfCurrentPagingBlock-1})">이전</a></li>`

			}
			for(let i = pi.startNumOfCurrentPagingBlock; i <= pi.endNumOfCurrentPagingBlock; i++) {
				piOutput += `<li class="page-item"><a class="page-link" onclick="makePi(\${pi.totalPostCnt},\${i})">\${i}</a></li>`;
			}
			if (pi.pageBlockOfCurrentPage != pi.totalPagingBlockCnt) {				
				piOutput += `<li class="page-item"><a class="page-link" onclick="makePi(\${pi.totalPostCnt},\${pi.endNumOfCurrentPagingBlock+1})">다음</a></li>`
				piOutput += `<li class="page-item"><a class="page-link" onclick="makePi(\${pi.totalPostCnt},\${pi.totalPageCnt})">끝</a></li>`;

			}
		}		
		$('.tbody').html(output);
		$('.piOutput').html(piOutput);		
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