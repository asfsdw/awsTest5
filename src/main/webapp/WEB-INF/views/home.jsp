<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%pageContext.setAttribute("CRLF","\r\n");%>
<%pageContext.setAttribute("LF","\n");%>
<c:set var="ctp" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<title>간단 방명록</title>
	<script>
		'use strict';
		let msg = "${msg}";
		if(msg == "ok") alert("방명록이 등록되었습니다.");
		
		$(function(){
			let msgOK = true;
			let updateOK = false;
			
			$(document).on("click", ".updateBtn", function() {
				if(!updateOK) {
					updateOK = true;
					
					let idx = $(this).data("idx");
					let msg = $(this).data("message");
					
					let inputPW = prompt("비밀번호를 입력해주세요.");
					$.ajax({
						url : "${ctp}/msgPWValidate",
						type: "post",
						data : {
							"idx" : idx,
							"pw" : inputPW
						},
						success : (res) => {
							if(res == 0) {
								alert("비밀번호가 일치하지 않습니다.");
								updateOK = false;
								return false;
							}
							else if(res == 2) {
								alert("잘못된 접근입니다.");
								updateOK = false;
								return false;
							}
							
							let txt = '<textarea rows="6" name="message" id="msg" required class="form-control border-success">'+msg+'</textarea>';
							txt += '<div id="msgInvalid" class="mt-1"></div>';
							$("#"+idx+"msg").html(txt);
							
							let btn = $(this).closest(".btnSet");
							btn.find(".updateBtn").hide();
							btn.find(".confirmBtn").show();
							btn.find(".deleteBtn").hide();
							btn.find(".cancelBtn").show();
						}
					});
				}
				else {
					alert("현재 방명록을 수정 중입니다.\n수정은 한 번에 한 개만 가능합니다.");
					return false;
				}
			});
			
			$(document).on("input", "#msg", function() {
				let msg = $("#msg").val();
				
				$.ajax({
					url : "${ctp}/msgValidate",
					type: "post",
					data: {"msg" : msg},
					success : (res) => {
						if(res == 1) {
							document.getElementById("msg").className = "form-control border-danger";
							$("#msgInvalid").text("내용을 입력해주세요.");
							msgOK = false;
						}
						else if(res == 2) {
							document.getElementById("msg").className = "form-control border-danger";
							$("#msgInvalid").text("내용이 너무 깁니다.");
							msgOK = false;
						}
						else {
							document.getElementById("msg").className = "form-control border-success";
							$("#msgInvalid").text("");
							msgOK = true;
						}
					}
				});
			});
			
			$(document).on("click", ".confirmBtn", function() {
				if(msgOK) {
					let idx = $(this).data("idx");
					let msg = $("#msg").val();
					
					$.ajax({
						url : "${ctp}/msgUpdate",
						type: "post",
						data: {
							"idx" : idx,
							"message" : msg
						},
						success : (res) => {
							if(res == 0) {
								alert("방명록 수정에 실패했습니다.")
								return false;
							}
							else if(res == 1){
								alert("방명록이 수정되었습니다.");
								updateOK = false;
								location.reload();
							}
						}
					});
				}
				else {
					alert("내용을 입력해주세요.");
					return false;
				}
			});
			
			$(document).on("click", ".deleteBtn", function() {
				if(updateOK) {
					alert("수정 중에는 삭제하실 수 없습니다.");
					return false;
				}
				
				let idx = $(this).data("idx");
				let inputPW = prompt("비밀번호를 입력해주세요.");
				$.ajax({
					url : "${ctp}/msgPWValidate",
					type: "post",
					data : {
						"idx" : idx,
						"pw" : inputPW
					},
					success : (res) => {
						if(res == 0) {
							alert("비밀번호가 일치하지 않습니다.");
							updateOK = false;
							return false;
						}
						else if(res == 2) {
							alert("잘못된 접근입니다.");
							updateOK = false;
							return false;
						}
						
						if(confirm("방명록을 삭제하시겠습니까?")) {
							$.ajax({
								url : "${ctp}/msgDelete",
								type: "post",
								data: {"idx" : idx},
								success : (res) => {
									if(res == 1){
										alert("방명록이 삭제되었습니다.");
										location.reload();
									}
									else {
										alert("방명록 삭제에 실패했습니다.")
										return false;
									}
								}
							});
						}
					}
				});
			});
		});
		
		function msgCancel() {
			location.reload();
		}

	</script>
	<style>
	</style>
</head>
<body>
	<div class="container text-center">
		<br/>
		<h2><b>간단 방명록</b></h2>
		<hr/>
		<p class="text-end">
			<a href="${ctp}/msgInput/?page=${page}" class="btn btn-success">글쓰기</a>
		</p>
		<hr/>
		<c:if test="${empty vos}">
			<h4>등록된 방명록이 없습니다.</h4>
		</c:if>
		<c:if test="${!empty vos}">
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<c:if test="${vo.updateYN == 'N'}">
								<div class="col text-end">등록일 : ${vo.date}</div>
							</c:if>
							<c:if test="${vo.updateYN == 'Y'}">
								<div class="col text-end">수정일 : ${vo.date}</div>
							</c:if>
						</div>
						<div class="row text-center">
							<div id="${vo.idx}msg">${fn:replace(fn:replace(vo.message,CRLF,'<br/>'),LF,'<br/>')}</div>
						</div>
						<div class="row mt-2" style="padding-left:200px">
							<div>작성자 : <span id="${vo.idx}id">${vo.id}</span></div>
						</div>
					</div>
				</div>
				<div class="row mt-2">
					<div class="col"></div>
					<div class="col text-center ms-4">${msgStartNum-st.index}</div>
					<div class="col text-end me-4 mb-4 btnSet">
						<input type="button" value="수정" class="updateBtn btn btn-success btn-sm"
							data-idx="${vo.idx}" data-message="${vo.message}" />
						<input type="button" value="확인" style="display:none" class="confirmBtn btn btn-outline-success btn-sm"
							data-idx="${vo.idx}" data-message="${vo.message}" />
						<input type="button" value="삭제" class="deleteBtn btn btn-danger btn-sm"
							data-idx="${vo.idx}"" />
						<input type="button" value="취소" onclick="msgCancel()" style="display:none" class="cancelBtn btn btn-warning btn-sm" />
					</div>
				</div>
			</c:forEach>
		</c:if>
		<hr/>
		<ul class="pagination justify-content-center">
			<c:if test="${page > 1}"><li class="page-item"><a href="${ctp}/?page=1" class="page-link text-dark">《</a></li></c:if>
			<c:if test="${curBlock > 1}"><li class="page-item"><a href="${ctp}/?page=${startPage - 1}" class="page-link text-dark">＜</a></li></c:if>
			<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<c:if test="${i == page}"><li class="page-item active page-link bg-secondary border-secondary">${i}</li></c:if>
				<c:if test="${i != page}"><li class="page-item"><a href="${ctp}/?page=${i}" class="page-link text-dark">${i}</a></li></c:if>
			</c:forEach>
			<c:if test="${curBlock < maxBlock}"><li class="page-item"><a href="${ctp}?page=${endPage + 1}" class="page-link text-dark">＞</a></li></c:if>
			<c:if test="${page < maxPage}"><li class="page-item"><a href="${ctp}/?page=${maxPage}" class="page-link text-dark">》</a></li></c:if>
		</ul>
		<p><br/></p>
	</div>
</body>
</html>