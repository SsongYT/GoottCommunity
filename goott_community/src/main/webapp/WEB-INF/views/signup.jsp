<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<!-- 아이콘 -->
<script src="https://kit.fontawesome.com/5970d3684d.js"></script>
<title>RMSOFT_회원가입</title>

<script type="text/javascript">
	let isIdValid = false;
	
	$(document).ready(function(){
		
		// 아이디 유효성검사
		$('#userId').blur(function() { 
			validUserId();
		});
		
		// 비밀번호 보이기/감추기
		 $('.password-control i').on('click',function(){
		 	$('input').toggleClass('active');
		    if($('input').hasClass('active')){
		    	$(this).attr('class',"fa-solid fa-eye fa-lg").next('input').attr('type',"text");
		    } else {
		        $(this).attr('class',"fa-solid fa-eye-slash fa-lg").next('input').attr('type','password');
		    }
		 });
		
		// 도메인 선택
		$('#domain-list').change(function() {
			$('#userEmailDomain').val($(this).val());
		});
	});

	//아이디 유효성 검사
	function validUserId() {
		const regId = /^[a-z]{1}[a-z0-9]{4,9}$/g;
		let checkId = $('#userId').val();
		if (regId.test(checkId)) {
			$.ajax({
	    	   	  url: 'signup/id/'+ checkId,
	        	  type: 'get',
	        	  headers : {"content-type":"application/json"},
	        	  dataType: 'json',
	        	  async : false,
	        	  success: function(data) {
	        		  if(data.code == "000") {
	        			isIdValid = true;
        			  	printMessages('userId', "사용 가능한 아이디 입니다.", 'succesMsg');
	        		  } 
	        	  },
	        	  error: function(error) {
	        		  console.log(error);
	        		  if(error.responseJSON.code == "C01") {
	        			  printMessages('userId', "사용 불가능한 아이디 입니다.", 'errorMsg');
	        		  }
	        		  isIdValid = false;
	        	  }
			});
			
		} else {
			printMessages('userId', '소문자으로 시작하는 5 ~ 10자 소문자 또는 숫자만 가능합니다.', 'errorMsg');
			isIdValid = false;
		}

	}
	
	// 회원가입
	function register() {
		let isValid = false;
		//아이디 중복검사 통과
		if(isIdValid) {
			//비밀번호 유효성검사
			const regPassword = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,12}$/;
			let checkPassword = $('#userPassword').val();
			if (regPassword.test(checkPassword)) {
				//이름 유효성검사
				const regName =  /^[가-힣]{2,10}$/;
				let checkName = $('#userName').val();
				if (regName.test(checkName)) {
					//휴대전화 유효성검사
					const regPhoneNum = /^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/;
					let checkPhoneNum = $('#userPhoneNum').val();
					let chagePhoneNum = checkPhoneNum.replace(/[^0-9]/g, '').replace(/^(\d{3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
					if (regPhoneNum.test(chagePhoneNum)) {
						$('#userPhoneNum').val(chagePhoneNum);
						//이메일 유효성 검사
						const regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
						let checkEmail = $('#userEmail').val() + "@" + $('#userEmailDomain').val();
						if (regEmail.test(checkEmail)) {
							isValid = true;
							
						} else {
							$("#userEmail").focus();
							printMessages('email-control', '정상적인 이메일을 입력해주세요.', 'errorMsg');
						}
						
					} else {
						$("#userPhoneNum").focus();
						printMessages('userPhoneNum', '정상적인 휴대전화번호를 입력해주세요.', 'errorMsg');	
					}
					
				} else {
					$("#userName").focus();
					printMessages('userName', '2 ~ 10자의 한글을 입력해주세요.', 'errorMsg');
				}
				
			} else {
				$("#userPassword").focus();
				printMessages('userPassword', '문자,숫자,특수문자가 포함된 8 ~ 12자로 입력하세요.', 'errorMsg');
			}
			
		} else {
			$("#userId").focus();
			printMessages('userId', '소문자으로 시작하는 5 ~ 10자 소문자 또는 숫자만 가능합니다.', 'errorMsg');
		}
		
		// 5가지 유효성 검사 통과하면 isValid = true;
		if(isValid) {
			
			let data = {
				userId: $('#userId').val(),
				userPassword : $('#userPassword').val(),
				userName : $('#userName').val(),
				userPhoneNo : $('#userPhoneNum').val(),
				userEmail : $('#userEmail').val() + "@" + $('#userEmailDomain').val()
			}
			
			$.ajax({
	    	   	  url : 'signup',
	        	  type : 'post',
	        	  headers : {"content-type":"application/json"},
	        	  data : JSON.stringify(data),
	        	  dataType : 'json',
	        	  async : false,
	        	  success: function(data) {
	        		if(data.code == "000") {
		        		alert("회원가입에 성공하였습니다.");
		        		location.replace("/login");
		        	}
	        	  },
	        	  error: function(error) {
        		  	  console.log(error.responseJSON.code == "001");
	        		  alert("회원가입에 실패하였습니다.");
	        	  }
			});
			
		}
	}
	
	// 메시지 출력
	function printMessages(id, msg, type) {
		$('.errorMsg').remove();
		$('.succesMsg').remove();
		let messages = `<div class="\${type}">\${msg}</div>`;
		
		$(messages).insertAfter(`#\${id}`);
	}
	
	
</script>

<style>
.errorMsg {
	color: red;
	font-weight: 10px;
	font-size: 15px;
}
.succesMsg {
	color: blue;
	font-weight: 10px;
	font-size: 15px;
}

.main {
	width: 100%;
	height: 100vh;
	display: -webkit-box;
	display: -moz-box;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-moz-box-align: center;
	-ms-flex-align: center;
	 align-items: center;  /* 수직 정렬 */
	-webkit-box-pack: center;
	-moz-box-pack: center;
	-ms-flex-pack: center;
	justify-content: center; /* 수평 정렬 */
}

.email-control {
	display: flex;
}

.password-control {
	position: relative;
}

.password-control i {
	position: absolute;
    right: 10px;
    top: 18px;
}

</style>

</head>
<body>
	<%@ include file="/WEB-INF/views/comm/header.jsp"%>

	<div class="container main">
		<div class="col-xl-6">
			<h1>회원가입</h1>

			<div class="mb-3 mt-3">
				<label for="userId" class="form-label">아이디</label> <input
					type="text" class="form-control" id="userId" placeholder="아이디를 입력하세요." />
			</div>

			<div class="mb-3 mt-3">
				<label for="userPassword" class="form-label">비밀번호(문자,숫자,특수문자 포함 / 8~12자)</label>
				<div class="password-control">
					<i class="fa-solid fa-eye-slash fa-lg"></i>
					<input type="password" class="form-control" id="userPassword" placeholder="비밀번호를 입력하세요."/>
				</div>
			</div>

			<div class="mb-3 mt-3">
				<label for="userName" class="form-label">이름</label> <input
					type="text" class="form-control" id="userName" placeholder="이름을 입력하세요."/>
			</div>

			<div class="mb-3 mt-3">
				<label for="userPhoneNum" class="form-label">휴대폰번호</label>
				<input type="text" class="form-control" id="userPhoneNum" placeholder="휴대폰번호를 입력하세요."/>
			</div>

			<div class="mb-3 mt-3">
				<div class="email-control" >
					<label for="userEmail" class="form-label">이메일</label>
					<!-- <button type="button" class="btn btn-primary btn-sm" onclick="validUserEmail()">확인</button> -->
				</div>
				<div class="email-control input-group" id="email-control">
					<input type="text" class="form-control" id="userEmail" />
					<span class="input-group-text">@</span>
					<input type="text" class="form-control" id="userEmailDomain" />
					<select class="form-select" id="domain-list">
						<option value="">직접 입력</option>
						<option value="naver.com">네이버</option>
						<option value="gmail.com">구글</option>
						<option value="hanmail.net">다음</option>
						<option value="kakao.com">카카오</option>
						<option value="nate.com">네이트</option>
					</select>
				</div>
			</div>

			<div class="mb-3 mt-3">
				<button type="button" class="btn btn-primary" onclick="register()">회원가입</button>
				<button type="button" class="btn btn-secondary" onClick="location.href='/'">취소</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/comm/footer.jsp"%>
</body>
</html>