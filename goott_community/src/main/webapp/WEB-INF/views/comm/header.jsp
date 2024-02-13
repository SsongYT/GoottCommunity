<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<title>Header</title>
</head>
<body>
	<c:set var="contextPath" value="<%=request.getContextPath()%>" />
	<nav class="navbar navbar-expand-sm navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="${contextPath}/">
				<img
				src=""
				alt="#"
				style="width: 90px; height: 60px; object-fit: cover" width="90"
				height="60">
			</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#mynavbar">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="mynavbar">

				<ul class="navbar-nav me-auto">
					<c:choose>
						<c:when test="${sessionScope.loginMember != null}">
							<li class="nav-item"><a class="nav-link" href="/freedom">자유게시판</a></li>
							<li class="nav-item"><a class="nav-link" href="/question">질문게시판</a></li>
						</c:when>
					</c:choose>
				</ul>
				
				<div class="d-flex">
					<ul class="navbar-nav me-auto">
					<c:choose>
						<c:when test="${sessionScope.loginMember == null}">
							<li class="nav-item">
								<a class="nav-link" href="${contextPath}/signup">회원가입</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="${contextPath}/login">로그인</a>
							</li>
						</c:when>
						<c:otherwise>
							<li class="nav-item">
								<a class="nav-link">${sessionScope.loginMember}님 환영합니다.</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="${contextPath}/logout">로그아웃</a>
							</li>
						</c:otherwise>
					</c:choose>
					</ul>
				</div>

			</div>
		</div>
	</nav>
</body>
</html>