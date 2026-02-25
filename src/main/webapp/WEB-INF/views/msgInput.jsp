<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<title>방명록 작성</title>
	<script>
		'use strict';
		
		let idOK = false;
		let pwOK = false;
		let msgOK = false;
		
		$(() => {
			if('${id}') {
				document.getElementById("id").className = "form-control border-success";
				$("#idInvalid").text("");
				idOK = true;
			}
			if('${pw}') {
				document.getElementById("pw").className = "form-control border-success";
				$("#pwInvalid").text("");
				pwOK = true;
			}
			
			$("#id").on("input", () => {
				let id = $("#id").val();
				
				$.ajax({
					url : "${ctp}/idValidate",
					type: "post",
					data: {"id" : id},
					success : (res) => {
						if(res == 1) {
							document.getElementById("id").className = "form-control border-danger";
							$("#idInvalid").text("이름을 입력해주세요.");
							idOK = false;
						}
						else if(res == 2) {
							document.getElementById("id").className = "form-control border-danger";
							$("#idInvalid").text("이름은 10글자까지 사용할 수 있습니다.");
							idOK = false;
						}
						else {
							document.getElementById("id").className = "form-control border-success";
							$("#idInvalid").text("");
							idOK = true;
						}
					}
				});
			});
			$("#pw").on("input", () => {
				let pw = $("#pw").val();
				
				$.ajax({
					url : "${ctp}/pwValidate",
					type: "post",
					data: {"pw" : pw},
					success : (res) => {
						if(res == 1) {
							document.getElementById("pw").className = "form-control border-danger";
							$("#pwInvalid").text("비밀번호를 입력해주세요.");
							pwOK = false;
						}
						else if(res == 2) {
							document.getElementById("pw").className = "form-control border-danger";
							$("#pwInvalid").text("비밀번호는 10글자까지 사용할 수 있습니다.");
							pwOK = false;
						}
						else {
							document.getElementById("pw").className = "form-control border-success";
							$("#pwInvalid").text("");
							pwOK = true;
						}
					}
				});
			});
			$("#msg").on("input", () => {
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
		});
		
		function fCheck() {
			if(!idOK) {
				alert("이름을 수정해주세요.");
				return false;
			}
			if(!pwOK) {
				alert("비밀번호를 수정해주세요.");
				return false;
			}
			if(!msgOK) {
				alert("내용을 수정해주세요.");
				return false;
			}
			
			myForm.action = "${ctp}/msgInputCheck";
			myForm.submit();
		}
	</script>
	<style>
	</style>
</head>
<body>
	<div class="container text-center">
		<br/>
		<h2>방명록 작성</h2>
		<hr/>
		<form name="myForm" method="post">
			<table class="table table-bordered">
				<tr>
					<th>이름</th>
					<td>
						<input type="text" name="id" id="id" value="${id}" required class="form-control border-danger" />
						<div id="idInvalid" class="mt-1">아이디를 입력해주세요.</div>
					</td>
					<th>비밀번호</th>
					<td>
						<input type="password" name="pw" id="pw" value="${pw}" required class="form-control border-danger" />
						<div id="pwInvalid" class="mt-1">비밀번호를 입력해주세요.</div>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<textarea rows="6" name="message" id="msg" required class="form-control border-danger"></textarea>
						<div id="msgInvalid" class="mt-1">내용을 입력해주세요.</div>
					</td>
				</tr>
			</table>
			<div class="text-center">
				<div class="row">
					<div class="col"><input type="button" value="등록" onclick="fCheck()" class="btn btn-success" /></div>
					<div class="col"><a type="button" href="${ctp}/?page=${page}" class="btn btn-warning">돌아가기</a></div>
				</div>
			</div>
		</form>
		<p><br/></p>
	</div>
</body>
</html>