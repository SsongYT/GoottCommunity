<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	
	<!-- summernote 연결 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	
	<!-- 서머노트를 위해 추가해야할 부분 -->
	<script src="/app/resources/summernote/summernote-lite.js"></script>
	<script src="/app/resources/summernote/lang/summernote-ko-KR.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<title>Insert title here</title>
</head>
<script>
$(function(){
$('#summernote').summernote({
		 height: 300,
		 lang: 'ko-KR',
		 callbacks : { 
         	onImageUpload : function(files, editor, welEditable) {
         // 파일 업로드(다중업로드를 위해 반복문 사용)
         for (var i = files.length - 1; i >= 0; i--) {
         uploadSummernoteImageFile(files[i],
         this);
         		}
         	}
         }
});
});

//id가 겹치므로 삭제 버튼에는 index를 붙여서 구분
function showUploadedFile(data) {
	let name = data.replaceAll("\\", "/");
	console.log(name);
	return name;
} 
function uploadSummernoteImageFile(file, el) {
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
			console.log("!",data);
			
			$('#summernote').summernote('insertImage', data.url);
			
		},
		error : function(data) {
			console.log("업로드 실패", data);
		}
	});
}
</script>
<style>
.box {
	border: solid 1px black;
	padding : 10px 10px;
}
.btn {
	float:right;
	margin-left:10px;
	margin-top : 10px;
}
</style>
<body>
	
	<div class="container">
		<h2>질문 게시글 작성</h2>
		<div class="box">
		<h4>title</h4>
		<select>
		<option>카테고리</option>
		<option>코딩</option>
		<option>취업</option>
		<option>학원</option>
		<option>기타</option>
		</select>
		<input size=130 maxlength=300>
		<h4>content</h4>
	<textarea id="summernote" name="content"></textarea>
	</div>
	
	<button type="button" class="btn btn-primary">작성</button>
	<button type="button" class="btn btn-secondary">취소</button>

	</div>

</body>
</html>