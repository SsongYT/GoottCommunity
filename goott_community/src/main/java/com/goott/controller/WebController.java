package com.goott.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {
	
	
	//회원가입 페이지 이동
	@GetMapping("/signup")
	public String signupPage() {
		return "signup";
	}
	
	//로그인 페이지 이동
	@GetMapping("/login")
	public String loginPage() {
		return "login";
	}
	
	// 로그아웃후 인덱스로 이동
	@GetMapping("/logout")
	public String doLogout(HttpSession session) {
		
		session.invalidate();
		
		return "home";
	}
	
	// 자유게시판 페이지 이동
	@GetMapping("/freeboard")
	public String openPageFreeBoard() {
		return "freeboard";
	}
}
