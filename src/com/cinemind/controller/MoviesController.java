package com.cinemind.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cinemind.entity.Reminder_list;
import com.cinemind.entity.Users;
import com.cinemind.json.JsonProcess;
import com.cinemind.objects.GenreObj;
import com.cinemind.objects.MovieObj;
import com.cinemind.objects.Notification;

import org.springframework.ui.Model;

@Controller
public class MoviesController {
	
	@Autowired
	private UserController userController;
	
	@GetMapping("/movies")
	public String movies(Model theModel, HttpSession loginSession,@RequestParam(required=false, value="page") String page) throws IOException, JSONException {
		
		List<GenreObj> genreList = JsonProcess.getGenresFromUrl("https://api.themoviedb.org/3/genre/movie/list?api_key=a092bd16da64915723b2521295da3254&language=en-US");
		theModel.addAttribute("genreList", genreList);
		
		if(page !=null) {
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl("https://api.themoviedb.org/3/movie/upcoming?api_key=a092bd16da64915723b2521295da3254&sort_by=release_date.asc&page="+page);
			theModel.addAttribute("movieList", movieList);
		}else {
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl("https://api.themoviedb.org/3/movie/upcoming?api_key=a092bd16da64915723b2521295da3254&sort_by=release_date.asc&page=1");
			theModel.addAttribute("movieList", movieList);
		}
		
		int totalPages = JsonProcess.getTotalPage("https://api.themoviedb.org/3/movie/upcoming?api_key=a092bd16da64915723b2521295da3254&sort_by=release_date.asc");
		theModel.addAttribute("totalPages",totalPages);
		
		if(loginSession.getAttribute("loginedUser") != null) {
			Users loginedUser = (Users)loginSession.getAttribute("loginedUser");
			Users tempUser = userController.userService.getUser(loginedUser.getId());
			
			//REMINDER LIST
			List<MovieObj> tempRemList = new ArrayList<MovieObj>();
			for(Reminder_list list_obj:tempUser.getReminderMovies()) {
				MovieObj movie = JsonProcess.getMovieFromUrl("https://api.themoviedb.org/3/movie/"+list_obj.getShow_id()+"?api_key=a092bd16da64915723b2521295da3254&append_to_response=credits,videos,images");
				if(movie.getDayLeft()>=0) {
					tempRemList.add(movie);
				}
			}
			List<Notification> notifications = userController.pushNotifications(tempRemList);			
			theModel.addAttribute("notifications",notifications);
		}
		
		return "movies";
	}
		
	@GetMapping("movies/genre/{genreName}")
	public String GenreMovies(Model theModel, HttpSession loginSession,
			@PathVariable String genreName, @RequestParam(required=false, value="page") String page) throws JSONException, IOException {
		
		int genreId = 0;
		String genreTitle = "";
		
		List<GenreObj> genreList = JsonProcess.getGenresFromUrl("https://api.themoviedb.org/3/genre/movie/list?api_key=a092bd16da64915723b2521295da3254&language=en-US");
		theModel.addAttribute("genreList", genreList);
		
		for(GenreObj obj: genreList) {
			String tempTitle = obj.getTitle().toLowerCase().replace(" ", "");
			if(tempTitle.equals(genreName)) {
				genreId = obj.getId();
				genreTitle = obj.getTitle();
			}
		}
		
		if(page !=null) {
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl("https://api.themoviedb.org/3/genre/"+genreId+"/movies?api_key=a092bd16da64915723b2521295da3254&page="+page);
			theModel.addAttribute("genreMoviesList", movieList);
		}else {
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl("https://api.themoviedb.org/3/genre/"+genreId+"/movies?api_key=a092bd16da64915723b2521295da3254&page=1");
			theModel.addAttribute("genreMoviesList", movieList);
		}
		
		int totalPages = JsonProcess.getTotalPage("https://api.themoviedb.org/3/genre/"+genreId+"/movies?api_key=a092bd16da64915723b2521295da3254");
		theModel.addAttribute("totalPages",totalPages);		
		theModel.addAttribute("genreTitle",genreTitle);
		
		if(loginSession.getAttribute("loginedUser") != null) {
			Users loginedUser = (Users)loginSession.getAttribute("loginedUser");
			Users tempUser = userController.userService.getUser(loginedUser.getId());
			
			//REMINDER LIST
			List<MovieObj> tempRemList = new ArrayList<MovieObj>();
			for(Reminder_list list_obj:tempUser.getReminderMovies()) {
				MovieObj movie = JsonProcess.getMovieFromUrl("https://api.themoviedb.org/3/movie/"+list_obj.getShow_id()+"?api_key=a092bd16da64915723b2521295da3254&append_to_response=credits,videos,images");
				if(movie.getDayLeft()>=0) {
					tempRemList.add(movie);
				}
			}
			List<Notification> notifications = userController.pushNotifications(tempRemList);			
			theModel.addAttribute("notifications",notifications);
		}
		
		return "genre-movie";
		
	}
	
	@GetMapping("movies/release/{releaseYear}")
	public String releaseYearMovies(Model theModel, HttpSession loginSession,
			@PathVariable String releaseYear, 
			@RequestParam(required=false, value="genreId") String genreId, 
			@RequestParam(required=false, value="page") String page,
			@RequestParam(required=false, value="sortBy") String sortBy) throws JSONException, IOException {
		
		int	totalPages = 1;
		String currentLink = "";
		
		List<GenreObj> genreList = JsonProcess.getGenresFromUrl("https://api.themoviedb.org/3/genre/movie/list?api_key=a092bd16da64915723b2521295da3254&language=en-US");
		theModel.addAttribute("genreList", genreList);
		
		if(page == null ) {
			page = "1";
		}
		
		if(sortBy != null) {
			sortBy = "&sort_by="+sortBy;
		}
				
		if(genreId !=null) {
			currentLink = "http://api.themoviedb.org/3/discover/movie?with_genres="+genreId+"&primary_release_year="+releaseYear+"&api_key=a092bd16da64915723b2521295da3254&page="+page+sortBy;
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl(currentLink);
			theModel.addAttribute("releaseYearMovieList", movieList);
		}
		else{
			currentLink = "http://api.themoviedb.org/3/discover/movie?primary_release_year="+releaseYear+"&api_key=a092bd16da64915723b2521295da3254&page"+page+sortBy;
			List<MovieObj> movieList = JsonProcess.getMoviesFromUrl(currentLink);
			theModel.addAttribute("releaseYearMovieList", movieList);
		}
				
		totalPages = JsonProcess.getTotalPage(currentLink);
		theModel.addAttribute("totalPages",totalPages);
		
		theModel.addAttribute("releaseYear",releaseYear);
		
		if(loginSession.getAttribute("loginedUser") != null) {
			Users loginedUser = (Users)loginSession.getAttribute("loginedUser");
			Users tempUser = userController.userService.getUser(loginedUser.getId());
			
			//REMINDER LIST
			List<MovieObj> tempRemList = new ArrayList<MovieObj>();
			for(Reminder_list list_obj:tempUser.getReminderMovies()) {
				MovieObj movie = JsonProcess.getMovieFromUrl("https://api.themoviedb.org/3/movie/"+list_obj.getShow_id()+"?api_key=a092bd16da64915723b2521295da3254&append_to_response=credits,videos,images");
				if(movie.getDayLeft()>=0) {
					tempRemList.add(movie);
				}
			}
			List<Notification> notifications = userController.pushNotifications(tempRemList);			
			theModel.addAttribute("notifications",notifications);
		}
		
		return "releaseYear-movie";
		
	}
	
	@GetMapping("/search")
	public String searchMovie(Model theModel, HttpSession loginSession,
			@RequestParam(required=false, value="q") String query,
			@RequestParam(required=false, value="page") String page) throws IOException, JSONException {
		
		//https://api.themoviedb.org/3/search/movie?api_key=a092bd16da64915723b2521295da3254&query="+searchViewText+"&page="+page
		String currentLink;
		int totalPages = 0;
		
		List<GenreObj> genreList = JsonProcess.getGenresFromUrl("https://api.themoviedb.org/3/genre/movie/list?api_key=a092bd16da64915723b2521295da3254&language=en-US");
		theModel.addAttribute("genreList", genreList);
		
		if(query != null) {
			query = query.replace(" ", "%2B");
			if(page != null) {
				currentLink = "https://api.themoviedb.org/3/search/movie?api_key=a092bd16da64915723b2521295da3254&query="+query+"&page="+page;
				List<MovieObj> movieList = JsonProcess.getMoviesFromUrl(currentLink);
				theModel.addAttribute("searchResultList", movieList);
			}else {
				currentLink = "https://api.themoviedb.org/3/search/movie?api_key=a092bd16da64915723b2521295da3254&query="+query;
				List<MovieObj> movieList = JsonProcess.getMoviesFromUrl(currentLink);
				theModel.addAttribute("searchResultList", movieList);
			}
			totalPages = JsonProcess.getTotalPage(currentLink);
			theModel.addAttribute("totalPages",totalPages);
		}		
		
		if(loginSession.getAttribute("loginedUser") != null) {
			Users loginedUser = (Users)loginSession.getAttribute("loginedUser");
			Users tempUser = userController.userService.getUser(loginedUser.getId());
			
			//REMINDER LIST
			List<MovieObj> tempRemList = new ArrayList<MovieObj>();
			for(Reminder_list list_obj:tempUser.getReminderMovies()) {
				MovieObj movie = JsonProcess.getMovieFromUrl("https://api.themoviedb.org/3/movie/"+list_obj.getShow_id()+"?api_key=a092bd16da64915723b2521295da3254&append_to_response=credits,videos,images");
				if(movie.getDayLeft()>=0) {
					tempRemList.add(movie);
				}
			}
			List<Notification> notifications = userController.pushNotifications(tempRemList);			
			theModel.addAttribute("notifications",notifications);
		}
		
		return "search";
	}


	
	
}
