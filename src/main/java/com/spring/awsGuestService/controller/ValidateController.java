package com.spring.awsGuestService.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ValidateController {
	@PostMapping("/idValidate")
	public int idValidatePost(String id) {
		int res = 0;
		id = id.trim();
		
		if(id == null || id.isEmpty() || id.equals("")) res = 1;
		else if(id.length() > 10) res = 2;
		
		return res;
	}
	@PostMapping("/pwValidate")
	public int pwValidatePost(String pw) {
		int res = 0;
		pw = pw.trim();
		
		if(pw == null || pw.isEmpty() || pw.equals("")) res = 1;
		else if(pw.length() > 10) res = 2;
		
		return res;
	}
	@PostMapping("/msgValidate")
	public int msgValidatePost(String msg) {
		int res = 0;
		msg = msg.trim();
		
		if(msg == null || msg.isEmpty() || msg.equals("")) res = 1;
		else if(msg.length() > 20000) res = 2;
		
		return res;
	}
}
