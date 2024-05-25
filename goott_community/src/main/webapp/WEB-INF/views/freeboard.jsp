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
<title>자유게시판</title>

<script type="text/javascript">
	
</script>

<style type="text/css">

</style>

</head>
<body>
	<%@ include file="/WEB-INF/views/comm/header.jsp"%>
	<div>
		<div class="row">
			<div class="col-xxl-3"></div>
			<div class="col-xxl-6">
				<h1>자유게시판</h1>
			</div>
			<div class="col-xxl-3"></div>
		</div>
		<div class="row">
			<div class="col-xxl-3"></div>
			<div class="col-xxl-6">
				<div class="table-responsive">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>글쓴이</th>
								<th>등록일</th>
								<th>조회</th>
								<th>추천</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>John</td>
								<td>Doe</td>
								<td>john@example.com</td>
								<td>john@example.com</td>
								<td>john@example.com</td>
								<td>john@example.com</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="col-xxl-3"></div>
		</div>
		<div class="row">
			<div class="col-xxl-3"></div>
			<div class="col-xxl-6">
				<ul class="pagination justify-content-center">
  					<li class="page-item"><a class="page-link" href="#">Previous</a></li>
  					<li class="page-item"><a class="page-link" href="#">1</a></li>
  					<li class="page-item active"><a class="page-link" href="#">2</a></li>
					<li class="page-item"><a class="page-link" href="#">3</a></li>
  					<li class="page-item"><a class="page-link" href="#">Next</a></li>
				</ul>
			</div>
			<div class="col-xxl-3"></div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/comm/footer.jsp"%>
</body>
</html>