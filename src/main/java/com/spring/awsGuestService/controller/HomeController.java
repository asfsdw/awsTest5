package com.spring.awsGuestService.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.awsGuestService.service.MessageService;
import com.spring.awsGuestService.vo.MessageVO;

@Controller
public class HomeController {
	@Autowired
	MessageService messageService;

	@GetMapping("/")
	public String home(Model model,
			@RequestParam(name = "page", defaultValue = "1", required = false) int page) {
		int min = (page - 1) * 10;
		int msgStartNum = messageService.getTotCnt() - min;
		int maxPage = messageService.getTotCnt() % 10 == 0 ? messageService.getTotCnt() / 10 : (messageService.getTotCnt() / 10) + 1;
		int curBlock = ((page - 1) / 5) + 1;
		int startPage = ((curBlock - 1) * 5) + 1;
		int endPage = startPage + 4;
		if(endPage > maxPage) endPage = maxPage;
		
		List<MessageVO> vos = messageService.getMessageList(min, 10);
		
		model.addAttribute("vos", vos);
		model.addAttribute("page", page);
		model.addAttribute("msgStartNum", msgStartNum);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("maxBlock", maxPage % 5 == 0 ? maxPage / 5 : (maxPage / 5) + 1);
		model.addAttribute("curBlock", curBlock);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		return "home";
	}
	
}
