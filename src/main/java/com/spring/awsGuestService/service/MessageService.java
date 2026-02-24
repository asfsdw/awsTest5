package com.spring.awsGuestService.service;

import java.util.List;

import com.spring.awsGuestService.vo.MessageVO;

public interface MessageService {

	int setMessage(MessageVO vo);

	List<MessageVO> getMessageList();

	int setMsgUpdate(MessageVO vo);

	MessageVO getMessage(int idx);

	int setMsgDelete(int idx);

}
