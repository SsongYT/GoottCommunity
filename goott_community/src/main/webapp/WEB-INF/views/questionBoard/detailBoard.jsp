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
<title>Insert title here</title>
<script>
	$(function() {
		showDetailBoard();
	});
	function getDetailBoard() {
		let result = null;
		$.ajax({
			url : "/app/questionBoard/" + "${no}",
			type : "POST",
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
	function showDetailBoard() {
		console.log("상세 글 띄우기");
		let data = getDetailBoard();
		console.log(data);
		let output = "";
		if (data.status == "success") {
			output += `<h2>\${data.detailBoard.title}</h2><hr>`;
			output += `<div>\${data.detailBoard.content}</div><hr>`;
		}
		
		$('.outputBody').html(output);
		
		if($('img').length > 0) {
			let imgUrl = "/app/resources/summernote/questionBoardUploadFiles/"
			let imgElements = document.getElementsByTagName("img");
			for(let i = 0; i < $('img').length; i++) {
				imgElements[i].src = imgUrl+data.detailFiles[i].new_fileName;
			}
		}
		if(data.detailComments != null) {
			let items = data.detailComments;
			let outputComments = "";
			$.each(items, function(i, item) {
			outputComments += `<tr><td class="col-md-3">\${item.writer}</td><td class="col-md-5">\${item.content}</td><td class="col-md-4">\${item.ref}</td></tr>`;
			
			});
			$('.outputComments').html(outputComments);
		}
	}
	
</script>
</head>
<body>
	<div class="outputBody container mt-3"></div>
	<div class="outputComments container mt-3"></div>
</body>
</html>