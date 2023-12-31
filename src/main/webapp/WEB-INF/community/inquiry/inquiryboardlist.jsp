<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="root" value="<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Noto+Sans+KR&family=Orbit&display=swap"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <link rel="stylesheet" type="text/css" href="../../res/board_inquiry/board_inquiry.css">
    <link rel="stylesheet" type="text/css" href="../../res/board_inquiry_page/board_inquiry_page.css">
    <style>
    body * {
        font-family: 'Orbit';
    }
    </style>
</head>
<script>
    function showNotLoggedInModal() {
        // 모달창을 표시합니다.
        $("#agreeModal").show();
    }

    function hideModal() {
        $("#agreeModal").hide();
    }

    $(document).ready(function () {
        $(".loginCheck").click(function () {
            // 버튼에서 로그인 상태 정보 가져오기
            var loginStatus = $(this).find("input[name='loginStatus']").val();

            if (loginStatus == "0") {
                // 로그인하지 않았을 경우 알림
                /*                alert("로그인해라")*/
                showNotLoggedInModal();
            } else {
                const formData = new FormData(document.getElementById('inquiryBoardListForm'));
                document.getElementById('inquiryBoardListForm').action = './write';
                document.getElementById('inquiryBoardListForm').method = 'POST';
                // 폼을 제출
                document.getElementById('inquiryBoardListForm').submit();
            }
        });
    })

    function showLoginRequiredModal() {
        $("#loginRequiredModal").show();
    }

    function hideLoginRequiredModal() {
        $("#loginRequiredModal").hide();
    }
</script>

<body>

<section class="notice">
    <div class="page-title">
        <div class="container">
            <h3>1:1 문의</h3>
        </div>
    </div>
    <!-- board seach area -->
    <div id="board-search">
        <div class="container">
            <div class="search-window">
                <form action="${root}/community/inquiry/list" id="inquiryBoardListForm"
                      style="">

                   <!--  <div class="search-wrap search-wrap--with-write">
                        <label for="search" class="blind">1대1문의 검색</label>
                        <input id="search" type="search" name="searchWord" placeholder="검색어를 입력해주세요." value="">
                        <button type="submit" id="searchButton" class="board_inquiry_btn board_inquiry_btn-dark">검색</button>
                    </div> -->
                    <!-- '글쓰기' 아이콘 링크를 form 안으로 이동 -->

                    <c:if test="${sessionScope.loginok==null}">
                        <button type="button" class="board_inquiry_btn board_inquiry_btn-write loginCheck">
                            <i class="bi bi-pencil-fill"></i>
                            <input type="hidden" name="loginStatus" value="0"/>
                        </button>
                    </c:if>
                    <c:if test="${sessionScope.loginok!=null}">
                        <button type="button" class="board_inquiry_btn board_inquiry_btn-write loginCheck">
                            <i class="bi bi-pencil-fill"></i>
                            <input type="hidden" name="loginStatus" value="1"/>
                        </button>
                    </c:if>
                </form>
            </div>
        </div>
    </div>
    <!-- board list area -->
    <div id="board-list">
        <div class="container">
            <table class="All-board-table board-table">
                <thead>
                <tr>
                    <th scope="col" class="th-num">번호</th>
                    <th scope="col" class="th-title">제목</th>
                    
                    <th scope="col" class="th-usercode">작성자</th>
                    <th scope="col" class="th-date">등록일</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${inquiryList}">
                    <tr>
                        <td>${item.questioncode}</td>
                        <c:choose>
                            <c:when test="${sessionScope.loginok != null}">
                                <th>
                                    <a href="${root}/community/inquiry/detail?usercode=${item.usercode}&questioncode=${item.questioncode}">${item.title}</a>
                                </th>
                            </c:when>
                            <c:otherwise>
                                <th><a href="javascript:void(0);" onclick="showLoginRequiredModal()">${item.title}</a>
                                </th>
                            </c:otherwise>
                        </c:choose>
                        
                        <th>${item.nickname}</th>
                        <th><fmt:formatDate pattern="yyyy-MM-dd" value="${item.registereddate}"/></th>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <%-- <div class="pagination-container" data-wow-duration="0.5s">
        <ul class="pagination">
            <li class="pagination-item--wide first">
                <c:if test="${currentPage > 1}">
                    <a class="pagination-link--wide first"
                       href="${'./list?currentPage=' += currentPage - 1}">Previous</a>
                </c:if>
            </li>
            <c:forEach var="i" begin="1" end="${totalPage}">
                <li class="pagination-item ${currentPage == i ? 'is-active' : ''}">
                    <a class="pagination-link"
                       href="${root}/community/inquiry/list?currentPage=${i}&searchType=${searchType}&searchWord=${searchWord}">${i}</a>
                </li>
            </c:forEach>
            <li class="pagination-item--wide last">
                <c:if test="${currentPage < totalPage}">
                    <a class="pagination-link--wide first"
                       href="${'./list?currentPage=' += currentPage + 1}">Next</a>
                </c:if>
            </li>
        </ul>
    </div> --%>
</section>


<!-- 필수 항목 미동의 모달 창 -->
<div class="modal" id="agreeModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">글작성을 하려면 로그인이 필요합니다.</h5>
            </div>
            <div class="modal-footer">
                <button type="button" id="okButton1" class="btn btn-primary" onclick="hideModal()">OK</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>

<div class="modal" id="loginRequiredModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">게시물을 보기 위해선 로그인을 해주세요!</h5>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="hideLoginRequiredModal()">OK</button>
            </div>
        </div>
    </div>
</div>