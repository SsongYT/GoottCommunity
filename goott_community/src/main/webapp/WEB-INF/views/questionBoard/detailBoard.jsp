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
<!-- moment.js 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- summernote upload 분리-->
<script src="/app/resources/js/summernote-upload.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<title>Insert title here</title>
<script>
	let isValidContent = false;
	let fileList = [];
	let isLogin = true;	// false면 비로그인. 우선 true로 작업.
	$(function() {
		showDetailBoard();
		// loginCheck();	// 로그인했는지 체크하는 함수.		
		let controlSummernote = 'disable';
		if(!isLogin) {
			$('#summernote').summernote({
				height : 150,
				callbacks: {
                    onInit: function() {                    	
                        // notice 클래스를 가진 div 추가
                        let noticeDiv = $(`<div class="notice"><span id="goToLogin" onclick="location.href='/app/login'">로그인</span> 후 작성 가능합니다.</div>`);
                        $('#summernote').summernote('pasteHTML', noticeDiv[0].outerHTML);
                    }
                }
			});
			$('#summernote').summernote('disable');
		} else {
		// 썸머노트 커스텀 설정
			$('#summernote').summernote({
				height : 300,
				lang : 'ko-KR',
				tabsize: 2,
			    // close prettify Html
			    prettifyHtml:false,
			    toolbar:[
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
							uploadSummernoteImageFile(files[i], "answer");
						}
					}
				}
			});
		}
	});
	
	// no번의 글 data 가져오기
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
	
	// 상세 글 띄우기
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
		showImg(data,"question");
		
		// 답변이 있다면
		if(data.detailAnswers != null) {
			let items = data.detailAnswers;
			let outputAnswers = "";
			$.each(items, function(i, item) {
			// 미리보기 test. upAndDownCount 데이터 받아올 예정.
			let formattedDate = moment(item.post_date).format('YYYY-MM-DD HH:mm');
			outputAnswers += `<div class="row">
			<div class="container col-xs-1"><i class="fa-solid fa-circle-chevron-up upAndDown"></i>
			<span class="upAndDownCount">0</span>
			<i class="fa-solid fa-circle-chevron-down upAndDown"></i>
			</div>
			
			<div class="container col-xs-11"><div>\${item.writer} \${formattedDate}</div><div>\${item.content}</div></div></div><hr>`;
			
			});
			$('.outputAnswers').html(outputAnswers);
			let outputAnswersCount = data.detailBoard.answerCount+" Answer";
			if(items.length > 1) {
				outputAnswersCount += "s";
			} else {
				
				$(".outputAnswers").after("<hr>");
			}
			$('#answerCount').html(outputAnswersCount);
			showImg(data, "answer");
		}
	}
	
	function showImg(data, imgPath) {
		console.log(data.detailAnswers);
		console.log(imgPath);
		let imgCount = document.querySelectorAll('.'+imgPath).length;
		if(imgCount > 0) {
			console.log(imgCount)
			let imgUrl = "/app/resources/summernote/questionBoard/"+imgPath+"/"
			let imgElements = document.getElementsByClassName(imgPath);
			if(imgPath == "question") {				
				for(let i = 0; i < imgCount; i++) {
					imgElements[i].src = imgUrl+data.detailFiles[i].new_fileName;
				}
			} else {
				for(let i = 0; i < imgCount; i++) {
					for(let j = 0; j < data.detailAnswers[i].fileList.length; j++) {						
						imgElements[i].src = imgUrl+data.detailAnswers[i].fileList[j].new_fileName;
					}
				}
			}
		}
	}
	
	// 답변 유효성 검사
	function isValidAnswer() {
		if(isLogin) {
			let answerContent = $('#summernote').summernote('code');
			// 내용에 공백만 있는지 확인
			let isEmptyContent = answerContent.replaceAll("&nbsp;","").replaceAll(" ","").replaceAll("<br>", "");
			if(isEmptyContent != '<p></p>') {				
				isValidContent = true;
			}
			if(isValidContent) {
				// 정규표현식을 사용하여 img 태그의 src 속성 삭제.
				let outputString = answerContent.replace(
						/<img\s+([^>]*\s)?src="[^"]*"\s?([^>]*)>/g, '<img $1$2>');
				let addIdString = outputString.replaceAll('<img ', '<img class="answer" '); // id 속성 추가
				insertAnswer(addIdString);							
			}
		} else {
			alert("로그인 후 작성 가능합니다.");
		}
		
	}

	// 답변 등록
	function insertAnswer(content) {
		let sendAnswer = {
				"writer" : "bbiyagi",
				"content" : content,
				fileList,
		}
		
		$.ajax({
			url : "/app/questionBoard/"+"${no}"+"/insertAnswer",
			type : "POST",
			contentType : "application/json",
			data : JSON.stringify(sendAnswer),
			async : false, 
			success : function(data) {
				console.log("업로드성공", data);
				if (data.status == "success") {
					console.log(data);
					showDetailBoard();
				}
			},
			error : function(data) {
				console.log("업로드 실패", data);
			}
		});
	}
</script>
<style>
	.btn {
		float: right;
		margin-top: 10px;
	}
	
	#goToLogin {
		text-decoration: underline;
		font-weight: bold;
		cursor: pointer;
	}
	#answerCount {
		padding-bottom : 10px;
	}
	
	.col-xs-1{
		display: flex;
		flex-direction: column; 
		align-items: center;
	}
	
	.upAndDown {
		font-size : 2em;
	}
	
	.upAndDownCount {
		font-size: 25px;
	}
	
</style>
</head>
<body>
	<div  class="container mt-3">
	<div class="outputBody"></div>
	<!-- 질문 작성자 프로필 구현 예정 -->
	<h3 id="answerCount"></h3>
	<div class="outputAnswers"></div>
	<h3>Your Answer</h3>
	<textarea id="summernote"></textarea>
	<button type="button" class="btn btn-primary"
			onclick="isValidAnswer();">작성</button>
	</div>
</body>
</html>