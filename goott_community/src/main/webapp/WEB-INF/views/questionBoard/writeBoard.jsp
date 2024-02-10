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
</head>
<script>
	let isValidCategory = false;
	let isValidTitle = false;
	let isValidContent = false;
	let fileList = [];
	
	$(function() {
		$('#summernote').summernote({
			height : 300,
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
		fileList[i] = data.file;
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
		
		let sendBoard = {
				"title" :  $('#boardTitle').val(),
				"content" : content,
				"category" : $('#boardCategory').val(),
				fileList,
		}
		
		$.ajax({
			url : "/app/questionBoard/insertBoard",
			type : "POST",
			contentType : "application/json",
			data : JSON.stringify(sendBoard),
			async : false, 
			success : function(data) {
				console.log("업로드성공", data);
				if (data.status == "success") {
					console.log(data);
					location.href="boardList";
				}
			},
			error : function(data) {
				console.log("업로드 실패", data);
			}
		});
	}

	// questionBoard 유효성 검사
	function isValidBoard() {
		let boardTitle = $('#boardTitle').val();
		let boardContent = $('#summernote').summernote('code');
		if ($('#boardCategory').val() != '카테고리') {
			isValidCategory = true;
		}

		if (boardTitle == '') {
			alert("제목을 입력해주세요.");
		} else if(boardTitle.length < 2) {
			alert("제목은 2자 이상이어야 합니다.");
		} else {
			isValidTitle = true;
		}

		if (boardContent != '<p><br></p>') {
			isValidContent = true;
		}

		// 유효성 통과 시
		if (isValidCategory && isValidTitle && isValidContent) {

			// 정규표현식을 사용하여 img 태그의 src 속성 삭제.
			let outputString = boardContent.replace(
					/<img\s+([^>]*\s)?src="[^"]*"\s?([^>]*)>/g, '<img $1$2>');
			console.log(typeof(outputString));
			insertBoard(outputString);
		} else if(isValidTitle && !isValidContent) {
			$('#summernote').summernote('focus', true);
		} else if(!isValidTitle) {
			$('#boardTitle').focus();
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
		<h2>질문 게시글 작성</h2>
		<div class="box">
			<h4>title</h4>
			<select name="category" id="boardCategory">
				<option>카테고리</option>
				<option>코딩</option>
				<option>취업</option>
				<option>학원</option>
				<option>기타</option>
			</select> <input size=120 maxlength=300 name="title" id="boardTitle">
			<h4>content</h4>
			<textarea id="summernote"></textarea>
		</div>

		<button type="button" class="btn btn-primary"
			onclick="isValidBoard();">작성</button>
		<button type="button" class="btn btn-secondary"
			onclick="location.href='boardList'">취소</button>
	</div>

</body>
</html>