<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="tiles"%>
<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function(){
		/* 로그인 계정정보 조회 (프로필사진, 아이디) */
		let url = '/selectLoginUserInfo.do';
		ajaxLoad(url, null, "json", function(result){
			document.getElementById("mova-user-name").innerText = result.userList[0].MEMBER_NAME;
			document.getElementById("user-name").innerText = result.userList[0].MEMBER_NAME;

			if(nullChk(result.userList[0].FILE_PATH)){
				let userImg = document.getElementsByClassName('info-btn');

				for(let i = 0 ; i<userImg.length ; i++) {
					userImg[i].style.background = "url(\"" + base64Img(result.userList[0].FILE_PATH) + "\") no-repeat left center";
					userImg[i].style.backgroundSize = "50px 50px";
				}
			}
		});

		let mainNav = document.getElementsByClassName('nav-main');

		for(let i = 0 ; i<mainNav.length ; i++) {
			mainNav[i].onclick = function(){
				if(!$(".nav-sub").is(":visible")){
					window.setTimeout(() => {
						$('.nav-sub').off().slideDown(100);
						$('.header' ).animate({height: '240px'}, 100, 'swing');
					}, 100);
				}
			}
		}

		$(".header").mouseleave(function(){
			if($(".nav-sub").is(":visible")){
				window.setTimeout(() => {
					$('.nav-sub').off().slideUp(100);
					$('.header' ).animate({height: '60px'}, 100, 'swing');
				}, 100);
			}
		});

		const movaNav = document.getElementById("moba-nav");
		const movaCloseBtn = document.getElementById("mova-close-btn");
		const movaList = document.getElementById("moba-nav-list");
		const userCard = document.getElementById("user-card");
		const userInfoBtn = document.getElementById("user-info");
		const mypageBtn = document.getElementById("btn-mypage");
		const logoutBtn = document.getElementById("btn-logout");

		/* 모바일 메뉴 버튼 클릭*/
		movaNav.onclick = function() {
			movaList.style.display = 'block';
		}

		/* 모바일 메뉴 닫기 버튼*/
		movaCloseBtn.onclick = function() {
			movaList.style.display = 'none';
		}

		/* 데스크탑 유저 프로필 클릭 */
		userInfoBtn.onclick = function(){
			if(nullChk(userCard.style.display)){
				userCard.style.display = 'block';
			} else {
				userCard.style.display = 'none';
			}
		}

		/* 모바일 메뉴 화면사이즈가 늘어나면 비활성화 처리 */
		window.onresize = function(){
			let winWidth = window.innerWidth;
			if(winWidth >= 950){
				movaList.style.display = 'none';
			} else {
				userCard.style.display = 'none';
			}
		}

		/* 마이페이지 클릭 */
		mypageBtn.onclick = function() {
			location.href="/mypage.do";
		}

		/* 로그아웃 클릭 */
		logoutBtn.onclick = function(){
			location.href="/logoutProcess.do";
		}
	});
</script>
<div class="header" id="header">
	<div class="header-title">
		<h1 class="header-title-main font50"><a href="/admin/main.do">CMS</a></h1>
	</div>
	<div class="nav">
		<ul>
			<li class="nav-main"><a href="#">시스템관리</a>
				<ul class="nav-sub">
					<li><a href="/admin/member">회원관리</a></li>
					<li><a href="#">메뉴관리</a></li>
				</ul>
			</li>
			<li class="nav-main"><a href="#">쇼핑몰관리</a>
				<ul class="nav-sub">
					<li><a href="#">물품관리</a></li>
					<li><a href="#">통합구매관리</a></li>
					<li><a href="#">통합물품관리</a></li>
				</ul>
			</li>
			<li class="nav-main"><a href="#">컨텐츠관리</a>
				<ul class="nav-sub">
					<li><a href="#">게시글관리</a></li>
					<li><a href="#">베너관리</a></li>
				</ul>
			</li>
			<li class="nav-main"><a href="#">통계관리</a>
				<ul class="nav-sub">
					<li><a href="#">경영통계</a></li>
				</ul>
			</li>
		</ul>
	</div>
	<div class="user-info" id="user-info">
		<div class="info-btn">
		</div>
	</div>
	<div class="moba-nav" id="moba-nav">
		<i class="fas fa-bars"></i>
	</div>
</div>
<!--모바일메뉴-->
<div class="moba-nav-list" id="moba-nav-list">
	<div class="user-info">
		<div class="info-btn">
		</div>
		<div class="info-description">
			<div class="info-desc-text">
				(<strong id="mova-user-name">초롱이</strong>)님 어서오세요
			</div>
			<div class="info-desc-btn">
				<input type="button" value="마이페이지"/>
				<input type="button" value="로그아웃"/>
			</div>
		</div>
		<i class="fas fa-times" id="mova-close-btn"></i>
	</div>
	<ul>
		<li class="moba-nav-main"><a href="#">시스템관리</a>
			<ul class="moba-nav-sub">
				<li><a href="/admin/member">회원관리</a></li>
				<li><a href="#">메뉴관리</a></li>
			</ul>
		</li>
		<li class="moba-nav-main"><a href="#">쇼핑몰관리</a>
			<ul class="moba-nav-sub">
				<li><a href="#">물품관리</a></li>
				<li><a href="#">통합구매관리</a></li>
				<li><a href="#">통합물품관리</a></li>
			</ul>
		</li>
		<li class="moba-nav-main"><a href="#">컨텐츠관리</a>
			<ul class="moba-nav-sub">
				<li><a href="#">게시글관리</a></li>
				<li><a href="#">베너관리</a></li>
			</ul>
		</li>
		<li class="moba-nav-main"><a href="#">통계관리</a>
			<ul class="moba-nav-sub">
				<li><a href="#">경영통계</a></li>
			</ul>
		</li>
	</ul>
</div>
<div class="user-info-layer" id="user-card">
	<div class="info-layer-text">
		(<strong id="user-name"></strong>)님 어서오세요
	</div>
	<div class="info-layer-btn">
		<input class="btn-cmmn" id="btn-mypage" type="button" value="마이페이지">
		<input class="btn-cmmn" id="btn-logout" type="button" value="로그아웃">
	</div>
</div>