<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
	<title>Home</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/comm/header.jsp" %>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
	${sessionScope.loginMember}

	<%@ include file="/WEB-INF/views/comm/footer.jsp" %>
</body>
</html>
