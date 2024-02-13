<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
  <!-- 아이콘 -->
  <script src="https://kit.fontawesome.com/5970d3684d.js"></script>
  
<title>로그인</title>

<script type="text/javascript">
	$(document).ready(function(){
		// 비밀번호 보이기/감추기
		 $('.password-control i').on('click',function(){
		 	$('input').toggleClass('active');
		    if($('input').hasClass('active')){
		    	$(this).attr('class',"fa-solid fa-eye fa-lg").next('input').attr('type',"text");
		    } else {
		        $(this).attr('class',"fa-solid fa-eye-slash fa-lg").next('input').attr('type','password');
		    }
		 });
	});
	
	function login() {
		
		let data = {
				userId: $('#userId').val(),
				userPassword : $('#userPassword').val(),
		}
		
		$.ajax({
	       	  url: 'login',
	       	  type: 'post',
	       	  headers : {"content-type":"application/json"},
	       	  data : JSON.stringify(data),
	       	  dataType: 'json',
	       	  async : false,
	       	  success: function(data) {
	       		  if(data.code == "000") {
	       			alert("로그인에 성공하였습니다.");
	       			location.replace("/");
	       		  }
	       	  },
	       	  error: function(error) {
	       		if(error.responseJSON.code == "L01") {
	       			alert("아이디를 확인하여주세요.");
	       		} else if(error.responseJSON.code == "L02") {
	       			alert("비밀번호를 확인하여주세요." );
	       		}
	       	  }
		});

	}
</script>

<style type="text/css">

.password-control {
	position: relative;
}

.password-control i {
	position: absolute;
    right: 10px;
    top: 18px;
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

</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/comm/header.jsp" %>
	
	<div class="container main">
		<div class="col-xl-6">
			<h1>로그인</h1>
			<div class="mb-3 mt-3">
				<label for="userId" class="form-label">아이디</label>
				<input type="text" class="form-control" id="userId" placeholder="2 ~ 9자의 아이디를 입력하세요."/>
			</div>
		
			<div class="mb-3 mt-3">
				<label for="userPassword" class="form-label">비밀번호(문자,숫자,특수문자 포함)</label>
				<div class="password-control">
					<i class="fa-solid fa-eye-slash fa-lg"></i>
					<input type="password" class="form-control" id="userPassword" placeholder="8 ~ 12자의 비밀번호를 입력하세요."/>
				</div>
			</div>
			
			<div class="form-check mb-3">
   				<label class="form-check-label" for="remember">
      				<input class="form-check-input" type="checkbox" /> 아이디 저장
    			</label>
  			</div>

			<div class="mb-3 mt-3">
				<button type="submit" class="btn btn-primary" onclick="login()" >로그인</button>
				<button type="reset" class="btn btn-secondary" onClick="location.href='/'">취소</button>
			</div>
		</div>
	</div>
	
	<%@ include file="/WEB-INF/views/comm/footer.jsp" %>
</body>
</html>