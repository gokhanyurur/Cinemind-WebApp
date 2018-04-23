<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>${releaseYear} Movies</title>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css" />
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/texts.css" />
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/buttons.css" />
	
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/slider.css" />
	<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
	
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/verticalmovie.css" />
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
	
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/recommendedmovies.css" />
	<script src="${pageContext.request.contextPath}/resources/js/recommendedmovies.jsp"></script>
	
	<script>
	     $(document).ready(function(){
	        $('.dropdown-toggle').dropdown()
	    });
	</script>
</head>
<body>
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
					    			<!-- 
					    			<c:url var="genreLink" value="/movies/genre">
					                 	<c:param name="genreId" value="${genre.id}" />
					                </c:url>
				    				<li><a href="${genreLink}">${genre.title}</a></li>
				    				-->
				    				<li><a href="/cinemind/movies/genre/${fn:replace(fn:toLowerCase(genre.title),' ', '')}">${genre.title}</a></li>
				    			</c:forEach>
							</ul>
						</li>
                        <li class="active"><a href="/cinemind/movies">Movies</a></li>  
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li style="padding-left: 5px; padding-right: 5px;">
                            <form class="navbar-form" role="search">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search" name="q">
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger" type="submit" style="height: 34px; background: #ff4d4d"><i class="glyphicon glyphicon-search"></i></button>
                                    </div>
                                </div>
                            </form>
                        </li>
                        <c:if test = "${loginedUser.username == null}">
         					<li><a href="/cinemind/signup"><span class="glyphicon glyphicon-user" style="color: #ff4d4d"></span> Sign up</a></li>
                        	<li><a href="/cinemind/login"><span class="glyphicon glyphicon-log-in" style="color: #ff4d4d"></span> Login</a></li>
     					</c:if>
                        <c:if test = "${loginedUser.username != null}">
                        	<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-fw fa-bell-o"></i> Notifications <span class="badge">15</span></a>
								<ul class="dropdown-menu" role="menu">
									<li><a href="#"><i class="fa fa-fw fa-tag"></i> <span class="badge">Music</span> page <span class="badge">Video</span> sayfasinda etiketlendi.</a></li>
									<li><a href="#"><i class="fa fa-fw fa-thumbs-o-up"></i> <span class="badge">Music</span> sayfasinda iletiniz begenildi.</a></li>
								</ul>
							</li>
         					<li><a href="#" onclick="window.location.href='profile'; return false;"><span class="glyphicon glyphicon-user" style="color: #ff4d4d"></span> <c:out value = "${loginedUser.username}"/></a></li>
                        	<li><a href="#" onclick="window.location.href='logout'; return false;"><span class="glyphicon glyphicon-log-out" style="color: #ff4d4d"></span> Logout</a></li>
     					</c:if>
                    </ul>
                </div>
            </nav>
	</div>
	<div class="row" style="margin-top: -40px; background-color: #e5e5e5"">
		<div class="container" style="padding: 30px; background-color: white">
        	<div class="row">
            	<div class="col-md-12" style="margin-top: -20px;">
            		<div class="col-md-12">
            			<div class="page-header" style="padding-bottom: 0px;">
							<h3 style="color: #FF4D4D; font-weight: normal;">${releaseYear}</h3>
						</div>
            		</div>
            		<div class="col-md-9 hidden-xs hidden-sm">
            			<ul class="thumbnails" style="margin-left: -50px;"> 
	            			<c:forEach var="tempMovie" items="${releaseYearMovieList}">
			                	<c:url var="movieLink" value="/movies/viewMovie">
			                    	<c:param name="movieId" value="${tempMovie.id}" />
			                    </c:url>
								<li class="col-sm-3" style="height: 320px;">
									<div class="fff">
										<a class="rec-image" href="${movieLink}"><img src="${tempMovie.poster_path}" alt=""></a>
								    	<h5 style="text-align: center; width: 100%;">${tempMovie.title}</h5>
									</div>
								</li>
			                </c:forEach>
			        	</ul>
            		</div>
            		<div class="col-xs-12 col-sm-12 hidden-md hidden-lg">
            			<c:forEach var="tempMovie" items="${releaseYearMovieList}">
		                	<c:url var="movieLink" value="/movies/viewMovie">
		                    	<c:param name="movieId" value="${tempMovie.id}" />
		                    </c:url>
							<div class="col-md-3" style="padding-bottom: 0px;">
								<a href="${movieLink}">
									<img src="${tempMovie.poster_path}" alt="${tempMovie.title}" class="img-responsive">			
								</a>
								<div class="ss-item-text" style="text-align: center;">
									<h5>${tempMovie.title}</h5>
								</div>		    
							</div>
		                </c:forEach>
            		</div>
	                <div class="col-md-3 col-xs-12" style="height: 100%; margin-top: -10px;">
	                	<div class="col-md-12">
				    		<h5 class="filterTitle">Filter: Genres</h5>
				    	</div>
	                	<div class="col-md-12">
	                		<c:forEach var="genre" items="${genreList}">
								<div class="col-md-12" style="padding-bottom: 5px;">
									<a class="filterText" href="/cinemind/movies/release/${releaseYear}?genreId=${genre.id}">${genre.title}</a>
								</div>
						   	</c:forEach>
	                	</div>
	                </div>
            	</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12" align="center">
			<!-- pages without genreids -->
			<c:if test="${param.genreId == null}">
				<a href="/cinemind/movies/release/${releaseYear}?page=1" class="pageText" style="margin-right: 5px;">1</a>
				<c:if test="${param.page > 5}">
					<label class="pageTextNoLink" style="margin-right: 5px;">...</label>
				</c:if>
			    <c:forEach var="i" begin="2" end="${totalPages}" step="1">
					<c:url var="pageLink" value="/movies/release/${releaseYear}">
				        <c:param name="page" value="${i}"></c:param>
				    </c:url>
					<c:if test="${(i>param.page-3) and (i < param.page+3)}">
						<c:if test="${i == param.page}">
							<a href="${pageLink}" class="pageText-active" style="margin-right: 5px;">${i}</a>
						</c:if>
						<c:if test="${(i != param.page) and (i != totalPages)}">
							<a href="${pageLink}" class="pageText" style="margin-right: 5px;">${i}</a>
						</c:if>
					</c:if>
					<c:if test="${i == param.page+5}">
						<label class="pageTextNoLink" style="margin-right: 5px;">...</label>
					</c:if>
				</c:forEach>
				<c:if test="${param.page != totalPages}">
					<a href="/cinemind/movies/release/${releaseYear}?page=${totalPages}" class="pageText" style="margin-right: 5px;">${totalPages}</a>
				</c:if>		
			</c:if>
			<!-- pages with genreids -->
			<c:if test="${param.genreId != null}">
				<a href="/cinemind/movies/release/${releaseYear}?page=1&genreId=${param.genreId}" class="pageText" style="margin-right: 5px;">1</a>
				<c:if test="${param.page > 5}">
					<label class="pageTextNoLink" style="margin-right: 5px;">...</label>
				</c:if>
			    <c:forEach var="i" begin="2" end="${totalPages}" step="1">
					<c:url var="pageLink" value="/movies/release/${releaseYear}?genreId=${param.genreId}">
				        <c:param name="page" value="${i}"></c:param>
				    </c:url>
					<c:if test="${(i>param.page-3) and (i < param.page+3)}">
						<c:if test="${i == param.page}">
							<a href="${pageLink}" class="pageText-active" style="margin-right: 5px;">${i}</a>
						</c:if>
						<c:if test="${(i != param.page) and (i != totalPages)}">
							<a href="${pageLink}" class="pageText" style="margin-right: 5px;">${i}</a>
						</c:if>
					</c:if>
					<c:if test="${i == param.page+5}">
						<label class="pageTextNoLink" style="margin-right: 5px;">...</label>
					</c:if>
				</c:forEach>
				<c:if test="${param.page != totalPages}">
					<a href="/cinemind/movies/release/${releaseYear}?page=${totalPages}&genreId=${param.genreId}" class="pageText" style="margin-right: 5px;">${totalPages}</a>	
				</c:if>	
			</c:if>
		</div>
	</div>
</body>
</html>