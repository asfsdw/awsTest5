package com.spring.awsGuestService.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
	public String msgInputGet(Model model, HttpServletRequest request, int page) {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			int cnt = 0;
			for(int i=0; i<cookies.length; i++) {
				if(cnt == 2) break;
				else if(cookies[i].getName().equals("cID")) {
					request.setAttribute("id", cookies[i].getValue());
					cnt++;
				}
				else if(cookies[i].getName().equals("cPW")) {
					request.setAttribute("pw", cookies[i].getValue());
					cnt++;
				}
			}
		}
		
		model.addAttribute("page", page);
		return "msgInput";
	}
	
	@PostMapping("/msgInputCheck")
	public String msgInputCheckPost(RedirectAttributes rttr, HttpServletResponse response,
			MessageVO vo) {
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
			
			Cookie cookieID = new Cookie("cID", vo.getId());
			Cookie cookiePW = new Cookie("cPW", vo.getPw());
			cookieID.setPath("/");
			cookiePW.setPath("/");
			response.addCookie(cookieID);
			response.addCookie(cookiePW);
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
	@PostMapping("/msgPWValidate")
	public int msgPWValidatePost(int idx, String pw) {
		try {
			MessageVO vo = messageService.getMessage(idx);
			if(!vo.getPw().equals(pw)) return 0;
			else return 1;
		} catch (Exception e) {
			return 2;
		}
	}
	
	@ResponseBody
	@PostMapping("/msgUpdate")
	public int msgUpdatePost(MessageVO updateVO) {
		int res = 0;
		
		try {
			MessageVO originVO = messageService.getMessage(updateVO.getIdx());
			updateVO.setId(originVO.getId());
			updateVO.setDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
			updateVO.setUpdateYN("Y");
			
			res = messageService.setMsgUpdate(updateVO);
		} catch (Exception e) {
			System.out.println("방명록 수정 실패.");
		}
		return res;
	}
	
	@ResponseBody
	@PostMapping("/msgDelete")
	public int msgDeletePost(int idx) {
		System.out.println(idx);
		return messageService.setMsgDelete(idx);
	}
}
