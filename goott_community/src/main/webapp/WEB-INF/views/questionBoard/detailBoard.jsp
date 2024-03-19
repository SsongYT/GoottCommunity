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
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<!-- 서머노트를 위해 추가해야할 부분 -->
<script src="/app/resources/summernote/summernote-lite.js"></script>
<script src="/app/resources/summernote/lang/summernote-ko-KR.js"></script>
<!-- highlight code block  -->
<script src="/app/resources/js/summernote-ext-highlight.js"></script>
<!-- font awesome -->
<script src="https://kit.fontawesome.com/0dda0703cf.js"
	crossorigin="anonymous"></script>
<!-- moment.js 라이브러리 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- summernote upload 분리-->
<script src="/app/resources/js/summernote-upload.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
	rel="stylesheet">
<title>Insert title here</title>
<script>
	let isValidContent = false;
	let boardFiles = [];	// 게시글 이미지 파일
	let fileList = [];		// 답변 이미지 파일
	let deleteFileList = []; // 삭제할 답변 이미지 파일
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
		$("button[aria-label='사진 삭제']").on('click', function() {
	        // 이 버튼이 클릭되었을 때 수행할 동작
	        checkFileList();
	    });
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
			output += `<button type="button" class="btn btn-primary"
				onclick="showModal('delete');">삭제</button>`
			output += `<button type="button" class="btn btn-primary"
				onclick="showModal('update');">수정</button>`;
		}

		$('.outputBody').html(output);
		if(data.detailFiles != null) {
			boardFiles = data.detailFiles;
			showImg(data,"question");
		}
		
		// 답변이 있다면
		if(data.detailAnswers != null) {
			let items = data.detailAnswers;
			let outputAnswers = "";
			$.each(items, function(i, item) {
			let formattedDate = moment(item.post_date).format('YYYY-MM-DD HH:mm');
			outputAnswers += `<div class="row">
			<div class="container col-xs-1"><i class="fa-solid fa-circle-chevron-up up" onclick="likeThisAnswer(\${item.answer_no}, 1)"></i>
			<span class="likeCount">\${item.like_count}</span>
			<i class="fa-solid fa-circle-chevron-down down" onclick="likeThisAnswer(\${item.answer_no}, -1)"></i>
			</div>
			
			<div class="container col-xs-11"><div>\${item.writer} \${formattedDate}</div><div>\${item.content}</div></div></div><hr>`;
			
			});
			$('.outputAnswers').html(outputAnswers);
			let outputAnswersCount = data.detailBoard.answerCount+" Answer";
			if(items.length > 1) {
				outputAnswersCount += "s";
			} 
				
			$('#answerCount').html(outputAnswersCount);
			showImg(data, "answer");
		}
	}
	
	// 게시글 수정, 삭제 확인 모달
	function showModal(purpose) {
		if(purpose == "delete") {
			$(".modalContent").text("삭제하시겠습니까?");
			$(".confirm").attr("onclick","deleteBoard();");
		} else {
			$(".modalContent").text("수정하시겠습니까?");
			$(".confirm").attr("onclick","location.href='/app/questionBoard/updateBoard/${no}'");
		}		
		$('#myModal').modal('show');
	}
	
	// 게시글 삭제
	function deleteBoard() {
		$.ajax({
			url : "/app/questionBoard/deleteBoard/${no}",
			type : "GET",
			async : false, 
			success : function(data) {
				location.href="/app/questionBoard/boardList";
			},
			error : function(data) {
				console.log(data);
				alert("오류로 인해 삭제 실패했습니다. 잠시 후에 다시 시도해주세요.");
			}
		});
	}
	
	function likeThisAnswer(answerNo, likeStatus) {
		let sendLikeStatus = {
				"member_id" : "bbiyagi",
				"like_status" : likeStatus,
				"board_no" : answerNo,
				"ref_category_no" : 2,
		}	
		$.ajax({
			url : "/app/questionBoard/likeAnswer",
			type : "POST",
			contentType : "application/json",
			data : JSON.stringify(sendLikeStatus),
			async : false, 
			success : function(data) {
				if (data.status == "success") {
					alert(data.informMessage);
					showDetailBoard();
				}
			},
			error : function(data) {
				console.log(data);
				alert("오류로 인해 추천 실패했습니다. 잠시 후에 다시 시도해주세요.");
			}
		});
	}
	
	function showImg(data, imgPath) {
		console.log(data.detailAnswers);
		console.log(imgPath);
		let imgCount = document.querySelectorAll('.'+imgPath).length;
		if(imgCount > 0) {
			console.log(imgCount);
			let imgUrl = "/app/resources/summernote/questionBoard/"+imgPath+"/";
			let imgElements = document.getElementsByClassName(imgPath);
			console.log(imgElements);
			if(imgPath == "question") {				
				for(let i = 0; i < imgCount; i++) {
					imgElements[i].src = imgUrl+data.detailFiles[i].new_fileName;
				}
			} else {				
				for(let i = 0; i < data.detailAnswers.length; i++) {	// 답변 개수만큼 반복
					if(data.detailAnswers[i].fileList != null) {	// 파일이 있는 답변인지
						for(let j = 0; j < data.detailAnswers[i].fileList.length; j++) {						
							imgElements[j].src = imgUrl+data.detailAnswers[i].fileList[j].new_fileName;
						}
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
				deleteFileList,
		}		
		$.ajax({
			url : "/app/questionBoard/"+"${no}"+"/insertAnswer",
			type : "POST",
			contentType : "application/json",
			data : JSON.stringify(sendAnswer),
			async : false, 
			success : function(data) {
				if (data.status == "success") {
					 $('#summernote').summernote('code', ''); // 에디터 비우기
					showDetailBoard();
				}
			},
			error : function(data) {
				console.log(data);
				alert("오류로 인한 답변 등록 실패");
			}
		});
	}
</script>
<style>
.btn {
	float: right;
	margin-top: 10px;
	margin-left: 10px;
}

#goToLogin {
	text-decoration: underline;
	font-weight: bold;
	cursor: pointer;
}

#answerCount {
	padding-bottom: 10px;
}

.col-xs-1 {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.fa-solid {
	font-size: 2em;
	cursor: pointer;
}

.likeCount {
	font-size: 25px;
}
</style>
</head>
<body>
	<div class="container mt-3">
		<div class="outputBody"></div>
		<!-- 질문 작성자 프로필 구현 예정 -->
		<h3 id="answerCount">0 Answer</h3>
		<div class="outputAnswers"></div>
		<h3>Your Answer</h3>
		<textarea id="summernote"></textarea>
		<button type="button" class="btn btn-primary"
			onclick="isValidAnswer();">작성</button>
	</div>
	<!-- Modal -->
	<div id="myModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Modal Header</h4>
				</div>
				<div class="modal-body">
					<p class="modalContent"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default confirm">확인</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
				</div>
			</div>

		</div>
	</div>
</body>
</html>