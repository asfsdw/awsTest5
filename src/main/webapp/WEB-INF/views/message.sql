show tables;
select * from message;

CREATE TABLE message (
	idx INT PRIMARY KEY AUTO_INCREMENT,
	id VARCHAR(10) NOT NULL,
	pw VARCHAR(10) NOT NULL,
	message TEXT,
	date VARCHAR(16),
	updateYN CHAR(1) DEFAULT 'N'
);