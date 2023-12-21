<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="root" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Noto+Sans+KR&family=Orbit&display=swap"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
</head>

<script>
    // 전역 변수 설정
    var loginStatus = ${sessionScope.loginok != null};
    var boardFreeUserCode = ${boardFreeDto.usercode};


    // 게시글 상세 페이지 이동
    function goToDetailPage(usercode, freeboardcode) {
        // 로그인하지 않았으면 모달을 표시하고 함수 종료
        if (!loginStatus) {
            showNotLoggedInModal();
            return;
        }

        if (usercode === boardFreeUserCode || loginStatus) {
            window.location.href = "${root}/community/free/detail?usercode=" + usercode + "&freeboardcode=" + freeboardcode;
        } else {
            showNotLoggedInModal();
        }
    }

    // 게시글 삭제 확인
    function deleteItem() {
        var deleteItem = confirm("정말 삭제하시겠습니까?");
        if (deleteItem) {
            // jQuery를 사용하여 POST 요청 보내기
            $.post("${root}/community/free/delete", { freeboardcode: freeboardcode }, function(data) {
                if (data === 'success') {
                    // 삭제 성공 시 페이지 리로드 또는 다른 작업 수행
                    location.reload(); // 예시: 페이지 리로드
                } else {
                    alert("삭제 실패");
                }
            });
        }
    }
</script>

<body>
<h1>상세페이지</h1>
<div>
    <th>${boardFreeDto.title}</th>
    <th>${boardFreeDto.content}</th>
    <th><img src="${boardFreeDto.photo}"></th>
</div>
    <c:if test="${boardFreeDto.usercode == sessionScope.usercode}">
        <button type="button" class="btn btn-outline-secondary btn-sm" style="width: 80px;"
                onclick="location.href='${root}/community/free/updateBoardFree?freeboardcode=${boardFreeDto.freeboardcode}&usercode=${boardFreeDto.usercode}&usercode_str='+${boardFreeDto.usercode.toString()}">
            수정
        </button>
        <button type="button" class="btn btn-danger" onclick="deleteItem(${boardFreeDto.freeboardcode})">삭제</button>
    </c:if>
</body>
