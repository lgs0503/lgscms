<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">

    document.addEventListener("DOMContentLoaded", function(){
        /* 세션값 읽어들이는 시간을 주기위해 0.5초뒤 조회*/
        setTimeout(function(){
            loadMypage(document.getElementById("sessionId").value);
        },500);
    });

    /* 레이어 로드 이벤트 대용 */
    function loadMypage(param = null){

        const btnLoaction = document.getElementById("btn-loaction");
        const btnSave = document.getElementById("btn-save");
        const btnDelete = document.getElementById("btn-delete");
        const iptImage = document.getElementById("image");
        const iptBirthday = document.getElementById("birthday");
        const iptId = document.getElementById("id");
        const userImg = document.getElementById('preview-image');
        const iptLocation = document.getElementById("location");

        const eleId = [ "id", "passwd", "passwdchk"
            , "name", "email"
            , "birthday", "hidden-birthday"
            , "phonenum"
            , "location", "locationDtl"
            , "memberImageNo","gender"
            , "quiz", "pwfind"];

        iptImage.value = "";
        iptLocation.disabled = true;
        userImg.src = "/images/lgs/noimg.png"

        /* 상세정보 일 경우 */
        iptId.disabled = true;

        btnDelete.style.display = "inline-block";

        let data = {id: param};
        let url = '/admin/member/read';

        ajaxLoad(url, data, "json", function(result){

            const sessionId = document.getElementById("sessionId").value;

            /* 자기자신 삭제 방지 */
            if(sessionId == result.member[0].MEMBER_ID){
                btnDelete.style.display = "none";
            }

            if(!nullChk(result.member[0].FILE_PATH)){
                userImg.src = base64Img(result.member[0].FILE_PATH);
            }

            const resultData = [ result.member[0].MEMBER_ID
                , result.member[0].MEMBER_PW
                , result.member[0].MEMBER_PW
                , result.member[0].MEMBER_NAME
                , result.member[0].MEMBER_EMAIL
                , castToYMD(result.member[0].MEMBER_BRITHDAY)
                , result.member[0].MEMBER_BRITHDAY
                , result.member[0].MEMBER_PHONENUM
                , result.member[0].MEMBER_LOCATION
                , result.member[0].MEMBER_LOCATION_DTL
                , result.member[0].MEMBER_IMAGE_NO
                , result.member[0].MEMBER_GENDER
                , result.member[0].MEMBER_PW_QUESTION
                , result.member[0].MEMBER_PW_ANSWER];

            eleId.forEach(function (value, index) {
                if(!nullChk(resultData[index])){
                    document.getElementById(value).value = resultData[index];
                }
            });

            setTimeout(function(){
                selectOption("combo-gender-layer", result.member[0].MEMBER_GENDER, "value");
                selectOption("combo-quiz-layer", result.member[0].MEMBER_PW_QUESTION, "value");
            }, 200);
        });

        comboLoad("combo-gender-layer", "G001", "SELECT");
        comboLoad("combo-quiz-layer", "PW001", "SELECT");

        /* 주소 찾기 버튼 클릭 */
        btnLoaction.onclick = function(){
            //카카오 주소
            new daum.Postcode({
                oncomplete: function(data) { //선택시 입력값 세팅
                    document.getElementById("location").value = data.address; // 주소 넣기
                    document.querySelector("input[name=locationDtl]").focus(); //상세입력 포커싱
                }
            }).open();
        }

        /* 저장 버튼 클릭 */
        btnSave.onclick = function () {

            /* input 글자 길이 유효성 체크 */
            lengthMaxMinValidate("id", 15, 5, "아이디");
            lengthMaxMinValidate("passwd", 15, 6, "비밀번호");

            gfnConfirm("저장하시겠습니까?", function (result) {
                if(result){
                    /*유효성 체크 결과값 이 실패면 종료*/
                    if (validate() == -1) {
                        return;
                    }

                    const iptImage = document.getElementById("image");

                    iptLocation.disabled = false;
                    iptId.disabled = false;

                    /* promise를 이용한 비동기 통신 */
                    new Promise(function(resolve, reject){

                        if(!nullChk(iptImage.value)){
                            /* 프로필 사진 업로드*/
                            let url = '/fileUpload';
                            let data = new FormData();
                            data.append("file", iptImage.files[0]);

                            ajaxLoad(url, data, "text", function(result){
                                resolve(result);
                            }, false, false);
                        } else {
                            resolve();
                        }

                    }).then(function(resolve){
                        if(!nullChk(iptImage.value)){
                            document.getElementById("memberImageNo").value = resolve;
                        }

                        let url = '/admin/member/update';

                        let data = $("#regi-form").serialize();

                        ajaxLoad(url, data, "text", function(){
                            gfnAlert("저장완료", function () {
                                iptLocation.disabled = true;
                                iptId.disabled = true;
                            });
                        });
                    });
                }
            });
        }

        /* 데이터 피커 값 (-) 하이푼 제거후 히든 인풋에 저장 */
        iptBirthday.onchange = function(){
            let hiddenVal = document.getElementById("hidden-birthday");
            hiddenVal.value = fncDateToStr(iptBirthday.value);
        }

        /* 삭제 버튼 클릭 */
        btnDelete.onclick = function () {
            gfnConfirm("정말 회원 탈퇴 하시겠습니까?", function(result){
                if(result){
                    let data = {id: param};
                    let url = '/admin/member/delete';

                    ajaxLoad(url, data, "text", function(result){
                        gfnAlert("탈퇴되었습니다.", function(){
                            location.href="/admin";
                        });
                    });
                }
            })
        }

        /* 프로필 사진 데이터 체인지 될 경우 섬네일 화면 수정*/
        iptImage.onchange = function(e){
            readImage(e.target, "preview-image");
        }
    };


    /*유효성 체크*/
    function validate(){

        // input 태그
        const validationInputChkId = ["id", "passwd", "pwfind", "name", "birthday", "phonenum", "location", "locationDtl", "email"];
        const validationInputChkIdText = ["아이디", "비밀번호", "비밀번호 답변", "이름", "생년월일", "연락처", "주소", "상세주소", "이메일"];

        // select 태그
        const validationComboChkId = ["combo-quiz-layer", "combo-gender-layer"];
        const validationComboChkIdText = ["비밀번호 질문", "성별"];

        /* 필수값 체크 */
        for(let i = 0 ; i < validationInputChkId.length ; i++){
            let ele = document.getElementById(validationInputChkId[i]);
            let inputVal =  ele.value;

            if(nullChk(inputVal)){
                gfnAlert("("+validationInputChkIdText[i]+ ")는 필수 입력 값 입니다.",function () {
                    ele.focus();
                    return -1;
                });
            }
        }

        for(let i = 0 ; i < validationComboChkId.length ; i++){
            let ele = document.getElementById(validationComboChkId[i]);
            let inputVal =  ele.value;

            if(nullChk(inputVal)){
                gfnAlert("("+validationComboChkIdText[i]+ ")는 필수 선택 값 입니다.",function () {
                    ele.focus();
                });
                return -1;
            }
        }

        /* 비밀번호 같은지 체크 */
        const passwd = document.getElementById("passwd").value;
        const passwdChk = document.getElementById("passwdchk").value;

        if(passwd != null){
            if(passwd != passwdChk){
                gfnAlert("비밀번호 가 일치 하지 않습니다.");
                return -1;
            }
        }
    }

    /* input 태그 최대 최소 length 유효성 체크 */
    function lengthMaxMinValidate(inputId, max, min, name){
        const ipt = document.getElementById(inputId);

        ipt.onchange = function(){

            const len = ipt.value.length;
            if(len > max){
                gfnAlert("("+name+")은 "+max+": 길이를 초과 할 수 없습니다.", function(){
                    ipt.value = "";
                });
            }
            if(len < min){
                gfnAlert("("+name+")은 "+min+"글자 이상 입력 하세요.", function(){
                    ipt.value = "";
                });
            }
            ipt.focus();
        }
    }
</script>
<div class="content">
    <div class="content-title">
        <i class="fas fa-caret-right"></i>
        <h2>마이페이지</h2>
        <div class="title-info">
            <h2>마이페이지</h2>
        </div>
    </div>
</div>
<form id="regi-form">
    <input type="hidden" id="memberImageNo" name="memberImageNo">
    <div class="mypage-member">
        <div class="layer-work">
            <div class="picture-form">
                <img class="picture" id="preview-image" src="/images/lgs/noimg.jpg">
                <div class="layer-tr">
                    <form id="fileForm" enctype="multipart/form-data">
                        <input type="file" name="image" id="image" accept="image/png, image/jpeg">
                    </form>
                </div>
            </div>
            <div class="layer-col">
                <div class="layer-tr">
                    <label>아이디</label>
                    <input type="text" name="id" id="id" placeholder="아이디" maxlength="15">
                </div>
                <div class="layer-tr">
                    <label>비밀번호</label>
                    <input type="password" name="passwd" id="passwd" placeholder="비밀번호" maxlength="15">
                </div>
                <div class="layer-tr">
                    <label>비밀번호 확인</label>
                    <input type="password" name="passwdchk" id="passwdchk" placeholder="비밀번호 확인" maxlength="15">
                </div>
                <div class="layer-tr">
                    <input type="hidden" name="quiz" id="quiz">
                    <label>비밀번호 질문</label>
                    <select id="combo-quiz-layer">
                    </select>
                </div>
                <div class="layer-tr">
                    <label>답변</label>
                    <input type="pwfind" name="pwfind" id="pwfind" placeholder="비밀번호 찾기 답변" maxlength="50">
                </div>
                <div class="layer-tr">
                    <label>성명</label>
                    <input type="text" name="name" id="name" placeholder="성명">
                </div>
            </div>
            <div class="layer-col">
                <div class="layer-tr">
                    <input type="hidden" name="gender" id="gender">
                    <label>성별</label>
                    <select id="combo-gender-layer">
                    </select>
                </div>
                <div class="layer-tr">
                    <label>생년월일</label>
                    <input type="hidden" name="birthday" id="hidden-birthday">
                    <input type="date" id="birthday" placeholder="생년월일">
                </div>
                <div class="layer-tr">
                    <label>연락처</label>
                    <input type="text" name="phonenum" id="phonenum" placeholder="연락처 (-) 제외 입력">
                </div>
                <div class="layer-tr">
                    <label>주소</label>
                    <input type="text" name="location" id="location" placeholder="주소">
                </div>
                <div class="layer-tr item-right">
                    <input class="btn-cmmn btn-size" id="btn-loaction" type="button" value="주소찾기">
                </div>
                <div class="layer-tr">
                    <label>상세 주소</label>
                    <input type="text" name="locationDtl" id="locationDtl" placeholder="상세 주소">
                </div>
                <div class="layer-tr">
                    <label>이메일</label>
                    <input type="text" name="email" id="email" placeholder="이메일">
                </div>
            </div>
        </div>
        <div class="layer-btn">
            <input id="btn-save" class="btn-cmmn" type="button" value="저장">
            <input id="btn-delete" class="btn-cmmn" type="button" value="탈퇴">
        </div>
    </div>
</form>