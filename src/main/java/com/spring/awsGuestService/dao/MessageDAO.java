package com.spring.awsGuestService.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.awsGuestService.vo.MessageVO;

public interface MessageDAO {

	int setMessage(@Param("vo") MessageVO vo);

	List<MessageVO> getMessageList(@Param("min") int min, @Param("max") int max);

	int setMsgUpdate(@Param("vo") MessageVO vo);

	MessageVO getMessage(@Param("idx") int idx);

	int setMsgDelete(@Param("idx") int idx);

	int getTotCnt();

}
