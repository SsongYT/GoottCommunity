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
	$(function() {
		showBoard();
	});
	function getAllBoard() {
		let result = null;
		$.ajax({
			url : "/app/questionBoard/all",
			type : "GET",
			dataType : "json",
			async : false,
			success : function(data) {
				result = data;
			},
			error : function(data) {
				console.log(data);
			}
		});
		return result;
	}
	function showBoard() {
		console.log("글목록 띄우기");
		let data = getAllBoard();
		console.log(data);
		let output = "";
		if(data.status == "success") {
			let items = data.list;
			$.each(items, function(i, item) {
			output += `<tr onclick="location.href='/app/questionBoard/\${item.no}'"><td class="col-md-3">\${item.no}</td><td class="col-md-5">\${item.title}</td><td class="col-md-4">\${item.writer}</td></tr>`;
			
			});
		}
		$('.tbody').html(output);
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
	</div>
</body>
</html>