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
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<!-- 서머노트를 위해 추가해야할 부분 -->
<script src="/app/resources/summernote/summernote-lite.js"></script>
<script src="/app/resources/summernote/lang/summernote-ko-KR.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<title>Insert title here</title>
</head>
<script>
	let isValidCategory = false;
	let isValidTitle = false;
	let isValidContent = false;
	let fileList = [];
	
	$(function() {
		$('#summernote').summernote({
			height : 300,
			lang : 'ko-KR',
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

	function addFileList(data) {
		let i = fileList.length;
		fileList[i] = data.fileName;
		console.log(fileList);
	}

	// summernote에서 이미지 업로드 시 실행할 함수
	function uploadSummernoteImageFile(file) {
		data = new FormData();
		data.append("file", file);
		$.ajax({
			data : data,
			dataType : "json",
			type : "POST",
			url : "/app/questionBoard/uploadSummernoteImageFile",
			contentType : false,
			processData : false,
			success : function(data) {
				$('#summernote').summernote('insertImage', data.url);
				addFileList(data);
			},
			error : function(data) {
				console.log("업로드 실패", data);
			}
		});
	}
	
	function insertBoard(content) {		
		// 변수의 값이 HTML 형식인 경우 jQuery 객체를 사용
		let sendContent = $("<input>", {
			  type: "hidden",
			  value: content,
			  name: "content",
			  id: "boardContent",
			  readonly: true
			});
		$('#insertBoard').append(sendContent);
		console.log($('#boardContent').val());
		
		if(fileList.length > 0) {
			fileList.forEach((file,i) => {
				let sendFile = $("<input type='hidden' value=" + file + " name='fileList' readonly>");
				$('#insertBoard').append(sendFile);
			});
		}
		
		$('#insertBoard').submit();	
	}

	// questionBoard 유효성 검사
	function isValidBoard() {
		
		if ($('#boardCategory').val() != '카테고리') {
			isValidCategory = true;
		}

		if ($('#boardTitle').val() != '') {
			isValidTitle = true;
		}

		if ($('#summernote').summernote('code') != '<p><br></p>') {
			isValidContent = true;
		}

		// 유효성 통과 시
		if (isValidCategory && isValidTitle && isValidContent) {

			// 정규표현식을 사용하여 img 태그의 src 속성 삭제.
			let outputString = $('#summernote').summernote('code').replace(
					/<img\s+([^>]*\s)?src="[^"]*"\s?([^>]*)>/g, '<img $1$2>');
			console.log(typeof(outputString));
			insertBoard(outputString);
		}

	}
</script>
<style>
.box {
	border: solid 1px black;
	padding: 10px 10px;
}

.btn {
	float: right;
	margin-left: 10px;
	margin-top: 10px;
}
</style>
<body>

	<div class="container">
		<form action="/app/questionBoard/insertBoard" id="insertBoard"
			method="POST">
			<h2>질문 게시글 작성</h2>
			<div class="box">
				<h4>title</h4>
				<select name="category" id="boardCategory">
					<option>카테고리</option>
					<option>코딩</option>
					<option>취업</option>
					<option>학원</option>
					<option>기타</option>
				</select> <input size=130 maxlength=300 name="title" id="boardTitle">
				<h4>content</h4>
				<textarea id="summernote"></textarea>
			</div>

			<button type="button" class="btn btn-primary"
				onclick="isValidBoard();">작성</button>
			<button type="button" class="btn btn-secondary">취소</button>
		</form>
	</div>

</body>
</html>