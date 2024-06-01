<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
<title>자유게시판 쓰기</title>

<script type="text/javascript">
	$(document).ready(function(){
	
		
	});
	
</script>

<style type="text/css">

</style>

</head>
<body>
	<%@ include file="/WEB-INF/views/comm/header.jsp"%>
	
	<div class="container" style="margin-top:30px">
		<h1>게시판 글 작성</h1>
		<form action="writeBoard" method="post">		
			<div class="mb-3 mt-3">
				<label for="writer" class="form-label">작성자 :</label>
				<input type="text" class="form-control" id="writer" name="writer" value="${sessionScope.loginMember}" readonly />
			</div>
		
			<div class="mb-3 mt-3">
				<label for="title" class="form-label">제목:</label>
				<input type="text" class="form-control" id="title" name="title" />
			</div>

			<div class="mb-3 mt-3">
				<label for="content" class="form-label">내용: <span class="textCount"></span></label>
				<textarea rows="40" class="form-control" style="height: 400px; resize: none; overflow-y:scroll;" maxlength="1000" id="summernote" name="content"></textarea>
			</div>
		
			<div class="mb-3 mt-3">
				<label for="upFile" class="form-label">첨부파일:</label>
				<div class= "upFileArea">업로드할 파일을 드래그앤 드랍 하세요.</div>
				<div class="uploadFiles"></div>
			</div>
			
			<!-- 
			 <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
			 -->

			<div class="mb-3 mt-3">
				<button type="submit" class="btn btn-success" >저장</button>
				<button type="button" class="btn btn-secondary" onclick="btnCancel();">취소</button>
			</div>
		</form>
	</div>
	
	<%@ include file="/WEB-INF/views/comm/footer.jsp"%>
</body>
</html>
