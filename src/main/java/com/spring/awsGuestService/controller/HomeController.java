package com.spring.awsGuestService.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.awsGuestService.service.MessageService;
import com.spring.awsGuestService.vo.MessageVO;

@Controller
public class HomeController {
	@Autowired
	MessageService messageService;

	@GetMapping("/")
	public String home(Model model) {
		List<MessageVO> vos = messageService.getMessageList();
		
		model.addAttribute("vos", vos);
		return "home";
	}
	
}
