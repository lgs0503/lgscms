<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<meta name="viewport" content="width=device-width,initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="admin.main.title" /></title>
    <jsp:include page="../cmmn/import.jsp"></jsp:include>
	<link rel="stylesheet" href="/css/lgs/cmmn.css">
	<link rel="stylesheet" href="/css/lgs/layout.css">
	<link rel="stylesheet" href="/css/lgs/admin.css">
</head>
<body>
	<tiles:insertAttribute name="header" /> 
	<div class="work">
		<tiles:insertAttribute name="content" />
	</div>
	<tiles:insertAttribute name="footer" /> 
</body>
</html>
