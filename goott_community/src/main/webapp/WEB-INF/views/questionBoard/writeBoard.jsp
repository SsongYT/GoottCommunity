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
<script src="/app/resources/js/summernote-ext-highlight.js"></script>
<!-- font awesome -->
<script src="https://kit.fontawesome.com/0dda0703cf.js"
	crossorigin="anonymous"></script>
<!-- summernote upload 분리-->
<script src="/app/resources/js/summernote-upload.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<title>Insert title here</title>
</head>
<script>	
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
						uploadSummernoteImageFile(files[i], "question");
					}
				}
			}
		});		
		checkPurpose();		
	});
	
	let isValidCategory = false;
	let isValidTitle = false;
	let isValidContent = false;
	let fileList = [];
	let deleteFileList = [];
	
	// 작성인지 수정인지
	function checkPurpose() {
		if(${no} != 0) {
			let data = getDetailBoard();
			processData(data);	
		}
	}
	
	// 데이터 가공해서 기존 게시글 삽입
	function processData(data) {
		let imgUrl = "/app/resources/summernote/questionBoard/question/";
		let boardContent = data.detailBoard.content;
		let indexString = '<img class="question" st';
		let addImgContent ="";
		if(data.detailFiles != null) {
			fileList = data.detailFiles;
			data.detailFiles.forEach(function(item) {
				addImgContent = 
				boardContent.replace(indexString, indexString.slice(0, -1)+'rc='+imgUrl+item.new_fileName+' st'); // src 속성 추가
				boardContent = addImgContent;
			});				
		}		

		document.getElementById('boardCategory').value = data.detailBoard.category;
		document.getElementById('boardTitle').value = data.detailBoard.title;		
		document.getElementById('purposeBtn').innerText = "수정";
		
		$('#summernote').summernote('code', ''); // 에디터 비우기
		$('#summernote').summernote('pasteHTML', boardContent);	// 불러온 컨텐트 삽입
	
	}
	
	function checkFileList() {
		let boardContent = $('#summernote').summernote('code');
		console.log(boardContent);
		// HTML 문자열을 jQuery 객체로 변환하여 이미지 태그를 선택
		let $images = $(boardContent).find('img');
		console.log($images);

		// 이미지 태그의 src 속성 값을 추출하여 배열에 저장
		let srcValues = [];
		$images.each(function() {
			let srcValue = $(this).attr('src');
			let index = srcValue.indexOf('\\');
			let imgValue = srcValue.substring(index);
		    srcValues.push(imgValue);
		});
		
		// srcValues 배열에 포함되지 않는 객체를 필터링하여 변수에 넣고 deleteFileList에 할당
		deleteFileList = fileList.filter(file => !srcValues.includes(file.new_fileName));
		
		// srcValues 배열에 포함되는 객체들을 필터링하여 fileList에 할당
		fileList = fileList.filter(file => srcValues.includes(file.new_fileName));
		console.log(fileList);
		console.log(deleteFileList);
	}
	
	// 새로 삽입한 이미지 서버에서 삭제
	function refreshBoard() {
		$.ajax({
			url : "/app/questionBoard/updateBoard/${no}/refresh",
			type : "POST",
			async : true,
			contentType : "application/json",
			data : JSON.stringify(fileList), 
			success : function(data) {
				console.log("refresh 성공", data);				
			},
			error : function(data) {
				console.log("refresh 실패", data);
			}
		});
	}
	
	// 페이지 나갈 시
	window.onbeforeunload = function (e) {
		refreshBoard();
	};
	
	// 수정하는 경우 no번의 글 data 가져오기
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
	
	// no값에 따라 수정 또는 작성 동작
	function insertBoard(content) {
		console.log(${no});
		let selectedUrl = "/app/questionBoard";
		let sendBoard = {
				"title" :  $('#boardTitle').val(),
				"content" : content,
				"category" : $('#boardCategory').val(),
				fileList,
				deleteFileList,
		}
		${no} != 0 ? selectedUrl += "/updateBoard/${no}" : selectedUrl += "/insertBoard";
		$.ajax({
			url : selectedUrl,
			type : "POST",
			contentType : "application/json",
			data : JSON.stringify(sendBoard),
			async : false, 
			success : function(data) {
				console.log("업로드성공", data);
				if (data.status == "success") {
					console.log(data);
					location.href="/app/questionBoard/"+data.destination;
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
		let isEmptyContent = boardContent.replaceAll("&nbsp;","").replaceAll(" ","").replaceAll("<br>", "");
		
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

		if (isEmptyContent != '<p></p>') {
			isValidContent = true;
		}

		// 유효성 통과 시
		if (isValidCategory && isValidTitle && isValidContent) {
			checkFileList();
			// 정규표현식을 사용하여 img 태그의 src 속성 삭제.
			let outputString = boardContent.replace(
					/<img\s+([^>]*\s)?src="[^"]*"\s?([^>]*)>/g, '<img $1$2>');				
			let addString = outputString.replaceAll('<img s', '<img class="question" s'); // class 속성 추가			
			insertBoard(addString);
		} else if(isValidTitle && !isValidContent) {
			$('#summernote').summernote('focus', true);
		} else if(!isValidTitle) {
			$('#boardTitle').focus();
		}

	}
</script>
<style>

.btn {
	float: right;
	margin-left: 10px;
	margin-top: 10px;
}
</style>
<body>

	<div class="container">
		<h2>질문 게시글 작성</h2>
		<hr>
		<div class="box">
		<div>
			<h4>title</h4>
			<select name="category" id="boardCategory">
				<option>카테고리</option>
				<option>코딩</option>
				<option>취업</option>
				<option>학원</option>
				<option>기타</option>
			</select> <input size=120 maxlength=300 name="title" id="boardTitle">
		</div>
		<div style="padding-top:10px;">
			<h4>content</h4>
			<textarea id="summernote"></textarea>
		</div>
		</div>

		<button type="button" class="btn btn-primary"
			onclick="isValidBoard();" id="purposeBtn">작성</button>
		<button type="button" class="btn btn-secondary"
			onclick="location.href='boardList'">취소</button>
	</div>
</body>
</html>