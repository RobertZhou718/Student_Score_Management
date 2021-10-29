<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Student Management System</title>
    <link rel="shortcut icon" href="favicon.ico"/>
	<link rel="bookmark" href="favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="easyui/css/default.css" />
    <link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="easyui/themes/icon.css" />
    <script type="text/javascript" src="easyui/jquery.min.js"></script>
    <script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src='easyui/js/outlook2.js'> </script>
    <script type="text/javascript">
	 var _menus = {"menus":[
						
						{"menuid":"1","icon":"","menuname":"Student Management",
							"menus":[
									{"menuid":"21","menuname":"Student List","icon":"icon-user-student","url":"StudentServlet?method=toStudentListView"},
								]
						},
						<c:if test="${userType == 1}">
						{"menuid":"3","icon":"","menuname":"Department Management",
							"menus":[
									{"menuid":"42","menuname":"Department List","icon":"icon-house","url":"DeptServlet?method=toClazzListView"}
								]
						},
						</c:if>
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"2","icon":"","menuname":"Teacher Management",
							"menus":[
									{"menuid":"31","menuname":"Teacher List","icon":"icon-user-teacher","url":"TeacherServlet?method=toTeacherListView"},
								]
						},
						</c:if>
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"4","icon":"","menuname":"Course Management",
							"menus":[
									{"menuid":"61","menuname":"Course List","icon":"icon-book-open","url":"CourseServlet?method=toCourseListView"},
								]
						},
						</c:if>
						{"menuid":"5","icon":"","menuname":"Course selection management",
							"menus":[
									{"menuid":"71","menuname":"Course selection list","icon":"icon-book-open","url":"SelectedCourseServlet?method=toSelectedCourseListView"},
								]
						},
						
						{"menuid":"6","icon":"","menuname":"Score management",
							"menus":[
									{"menuid":"101","menuname":"Score List","icon":"icon-book-open","url":"ScoreServlet?method=toScoreListView"},
									<c:if test="${userType == 1 || userType == 3}">
									{"menuid":"101","menuname":"Score statistics","icon":"icon-book-open","url":"ScoreServlet?method=toScoreStatsView"},
									</c:if>
								]
						},
						{"menuid":"7","icon":"","menuname":"System Management",
							"menus":[
							        {"menuid":"51","menuname":"Change Password","icon":"icon-set","url":"SystemServlet?method=toPersonalView"},
								]
						}
				]};


    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
	<noscript>
		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
		</div>
	</noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background: url(images/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, Verdana, Verdana">
        <span style="float:right; padding-right:20px;" class="head"><span style="color:red; font-weight:bold;">${user.name}&nbsp;</span>Welcome&nbsp;&nbsp;&nbsp;<a href="LoginServlet?method=logout" id="loginOut">Quit</a></span>
        <span style="padding-left:10px; font-size: 16px; ">Student Management System</span>
    </div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
       
    </div>
    <div region="west" hide="true" split="true" title="Navigation menu" style="width:300px;" id="west">
	<div id="nav" class="easyui-accordion" fit="true" border="false" >
		<!--  navigation -->
	</div>
	
    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
			<jsp:include page="welcome.jsp" />
		</div>
    </div>	
</body>
</html>