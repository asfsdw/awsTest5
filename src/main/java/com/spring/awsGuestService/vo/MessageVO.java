package com.spring.awsGuestService.vo;

import lombok.Data;

@Data
public class MessageVO {
	private int idx;
	private String id;
	private String pw;
	private String message;
	private String date;
	private String updateYN;
}
