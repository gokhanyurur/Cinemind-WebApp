<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html lang="en-US">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <title>Login</title>
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css\navbar.css">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css\signup.css">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css\texts.css">
	    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.1/css/font-awesome.min.css">
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
	    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	    
	    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/starRating.css">
	    
	</head>
	<body background="${pageContext.request.contextPath}/resources/img/bg/signup_bg.jpg">
        <div class="row">
            <nav class="navbar navbar-inverse navbar-static-top">
                <div class="container">
                    <div class="navbar-header"> 
                        <a class="navbar-brand" href="/cinemind" style="color: #ff4d4d; font-weight: bold; font-size: 20px;">
                            <img src="${pageContext.request.contextPath}/resources/img/logo.png" style="width: 30px; height: 30px; margin-top: -5px; display: inline-block;">
                            <span style="display: inline-block;">CINEMIND</span>
                        </a>     
                    </div>
                    <ul class="nav navbar-nav">
                        <li><a href="/cinemind">Home</a></li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Genres <span class="caret"></span></a>
							<ul class="dropdown-menu" role="menu">
								<c:forEach var="genre" items="${genreList}">
				    				<li><a href="/cinemind/movies/genre/${fn:replace(fn:toLowerCase(genre.title),' ', '')}">${genre.title}</a></li>
				    			</c:forEach>
							</ul>
						</li>
                        <li><a href="/cinemind/movies">Movies</a></li>  
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li style="padding-left: 5px; padding-right: 5px;">
                            <form:form action="/cinemind/search" modelAttribute="q" method="GET" class="navbar-form" role="search">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search" name="q" required>
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger" type="submit" style="height: 34px; background: #ff4d4d"><i class="glyphicon glyphicon-search"></i></button>
                                    </div>
                                </div>
                            </form:form>
                        </li>
                        <c:if test = "${loginedUser.username == null}">
         					<li><a href="/cinemind/signup"><span class="glyphicon glyphicon-user" style="color: #ff4d4d"></span> Sign up</a></li>
                        	<li class="active"><a href="/cinemind/login"><span class="glyphicon glyphicon-log-in" style="color: #ff4d4d"></span> Login</a></li>
     					</c:if>
                        <c:if test = "${loginedUser.username != null}">
                        	<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-fw fa-bell-o"></i> Notifications <span class="badge">${fn:length(notifications)}</span></a>
								<ul class="dropdown-menu" role="menu">
									<c:if test="${fn:length(notifications)>0}">
										<c:forEach var="notification" items="${notifications}">
											<li><a href="/cinemind/movies/viewMovie?movieId=${notification.movieId}"><i class="far fa-calendar-check"></i> <span class="badge">${notification.movieTitle}</span>${notification.bodyText}<span class="badge">${notification.dayLeft}</span></a></li>
										</c:forEach>
									</c:if>
									<c:if test="${fn:length(notifications)<1}">
										<li><a href="#">There is no notification.</a></li>
									</c:if>
								</ul>
							</li>
         					<li><a href="/cinemind/profile"><span class="glyphicon glyphicon-user" style="color: #ff4d4d"></span> <c:out value = "${loginedUser.username}"/></a></li>
                        	<li><a href="/cinemind/logout"><span class="glyphicon glyphicon-log-out" style="color: #ff4d4d"></span> Logout</a></li>
     					</c:if>
                    </ul>
                </div>
            </nav>
        </div>
        <div class="row" style="margin-top: 20px">
            <div class="container transparent-white" style="padding-top: 50px; padding-bottom: 75px;" >
                <form:form action="loginUser" modelAttribute="user" method="POST">
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-6">
                            <h2 class="primaryColor">Login to Cinemind</h2>
                            <hr>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 field-label-responsive">
                            <label for="email">E-Mail Address</label>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <div class="input-group mb-2 mr-sm-2 mb-sm-0">
                                    <div class="input-group-addon" style="width: 2.6rem"><i class="fa fa-at"></i></div>
                                    <form:input path="email" cssClass="form-control" cssStyle="width: 600px;" required="required"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 field-label-responsive">
                            <label for="password">Password</label>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group has-danger">
                                <div class="input-group mb-2 mr-sm-2 mb-sm-0">
                                    <div class="input-group-addon" style="width: 2.6rem"><i class="fa fa-key"></i></div>
                                    <form:password path="password" cssClass="form-control" cssStyle="width: 600px;" required="required"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class ="row">
                    	<div class="col-md-3 field-label-responsive"></div>
                        <div class="col-md-6">
                        	<label for="password">${loginMessage}</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-danger"><i class="fa fa-sign-in"></i> Login</button>
                        </div>
                    </div>
                </form:form>
            </div>
        </div>
    </body>
</html>