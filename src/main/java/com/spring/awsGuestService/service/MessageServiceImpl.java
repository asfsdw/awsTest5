package com.spring.awsGuestService.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.awsGuestService.dao.MessageDAO;
import com.spring.awsGuestService.vo.MessageVO;

@Service
public class MessageServiceImpl implements MessageService {
	@Autowired
	MessageDAO messageDAO;
	
	@Override
	public int setMessage(MessageVO vo) {
		return messageDAO.setMessage(vo);
	}

	@Override
	public List<MessageVO> getMessageList() {
		return messageDAO.getMessageList();
	}

	@Override
	public int setMsgUpdate(MessageVO vo) {
		return messageDAO.setMsgUpdate(vo);
	}

	@Override
	public MessageVO getMessage(int idx) {
		return messageDAO.getMessage(idx);
	}

	@Override
	public int setMsgDelete(int idx) {
		return messageDAO.setMsgDelete(idx);
	}

}
