<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- jquery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

<!-- summernote 연결 -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<!-- 서머노트를 위해 추가해야할 부분 -->
<script src="/app/resources/summernote/summernote-lite.js"></script>
<script src="/app/resources/summernote/lang/summernote-ko-KR.js"></script>
<!-- highlight code block  -->
<script src="/app/resources/summernote-ext-highlight.js"></script>
<!-- font awesome -->
<script src="https://kit.fontawesome.com/0dda0703cf.js"
	crossorigin="anonymous"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<title>Insert title here</title>
<script>
	$(function() {
		showDetailBoard();
		$('#summernote').summernote({
			height : 300,
			lang : 'ko-KR',
			tabsize: 2,
		    // close prettify Html
		    prettifyHtml:false,
		    toolbar:[
		        // Add highlight plugin
		        ['style', ['style']],
  				['font', ['bold', 'underline', 'clear']],
				['fontname', ['fontname']],
				['color', ['color']],
				['para', ['ul', 'ol', 'paragraph']],
				['table', ['table']],
				['insert', ['link', 'picture', 'video']],
				['view', ['codeview', 'help']],
				['highlight', ['highlight']],	// 코드 블럭 플러그인 적용
		    ],
			callbacks : {
				onImageUpload : function(files, editor, welEditable) {
					// 파일 업로드(다중업로드를 위해 반복문 사용)
					for (let i = files.length - 1; i >= 0; i--) {
						uploadSummernoteImageFile(files[i]);
					}
				}
			}
		});
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
		if(data.detailAnswers != null) {
			let items = data.detailAnswers;
			let outputAnswers = "";
			$.each(items, function(i, item) {
			outputAnswers += `<tr><td class="col-md-3">\${item.writer}</td><td class="col-md-5">\${item.content}</td><td class="col-md-4">\${item.ref}</td></tr>`;
			
			});
			$('.outputAnswers').html(outputAnswers);
			let outputAnswersCount = data.detailBoard.answerCount+" Answer";
			if(items.length > 1) {
				outputAnswersCount += "s";
			} 
			$('#AnswerCount').html(outputAnswersCount);
			$(".outputAnswers").after("<hr>");
		}
	}
	
</script>
</head>
<body>
	<div  class="container mt-3">
	<div class="outputBody"></div>
	<h3 id="AnswerCount"></h3>
	<div class="outputAnswers"></div>
	<h3>Your Answer</h3>
	<textarea id="summernote"></textarea>
	</div>
</body>
</html>