package com.spring.awsGuestService.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.awsGuestService.service.MessageService;
import com.spring.awsGuestService.vo.MessageVO;

@Controller
public class MessageController {
	@Autowired
	MessageService messageService;
	
	@GetMapping("/msgInput")
	public String msgInputGet() {
		return "msgInput";
	}
	
	@PostMapping("/msgInputCheck")
	public String msgInputCheckPost(RedirectAttributes rttr, MessageVO vo) {
		String id = vo.getId().trim();
		id = id.replace("<", "&lt");
		id = id.replace(">", "&gt");
		String msg = vo.getMessage().trim();
		msg = msg.replace("<", "&lt");
		msg = msg.replace(">", "&gt");
		
		vo.setDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
		vo.setId(id);
		vo.setMessage(msg);
		
		int res = 0;
		try {
			res = messageService.setMessage(vo);
		} catch (Exception e) {
			System.out.println("방명록 등록 실패.");
		}
		
		
		if(res != 0) {
			rttr.addFlashAttribute("msg", "ok");
			return "redirect:/";
		}
		else {
			rttr.addFlashAttribute("msg", "no");
			return "redirect:msgInput";
		}
	}
	
	@ResponseBody
	@PostMapping("/msgUpdate")
	public int msgUpdatePost(MessageVO updateVO) {
		MessageVO originVO = messageService.getMessage(updateVO.getIdx());
		if(!originVO.getId().equals(updateVO.getId())) return 0;
		
		int res = 2;
		
		try {
			updateVO.setDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
			updateVO.setUpdateYN("Y");
			System.out.println(updateVO);
			res = messageService.setMsgUpdate(updateVO);
		} catch (Exception e) {
			System.out.println("방명록 수정 실패.");
			System.out.println(e.getMessage());
		}
		return res;
	}
	
	@ResponseBody
	@PostMapping("/msgDelete")
	public int msgDeletePost(int idx) {
		return messageService.setMsgDelete(idx);
	}
}
