/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package lgs.admin.view;

import lgs.admin.service.AdminMemberService;
import lgs.admin.service.CodeService;
import lgs.cmmn.Utils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 */

@Controller
@RequestMapping("/admin/code")
public class CodeController {

	@Resource(name = "codeService")
	private CodeService codeService;

	private final static String SUCCESS = "1";

	/**
	 * name : codePage
     * description : 코드관리화면 을 보여준다.
	 */
	@GetMapping
	public String codePage(Model model, HttpServletRequest request) throws Exception {

		return "admin/code/index";
	}

	/**
	 * name : codeList (ajax)
	 * description : 회원리스트을 보여준다.
	 */
	@RequestMapping(value = "/list")
	public @ResponseBody
	ModelAndView codeList(@RequestParam Map<String, Object> param
			, HttpSession session
			, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView("jsonView");

		mv.addObject("codeList", codeService.searchList(param));
		mv.addObject("codeCnt", codeService.countList());

		return mv;
	}

	/**
	 * name : overlapCode (AJAX)
	 * description : 코드를 중복확인 한다.
	 */
	@RequestMapping(value = "/overlapCode")
	public @ResponseBody String overlapCode(@RequestParam Map<String, Object> param
			, HttpSession session
			, HttpServletRequest request) throws Exception {

		return codeService.overlapCode(param);
	}

	/**
	 * name : insertCode (ajax)
	 * description : 코드를 생성한다.
	 */
	@RequestMapping(value = "/insert")
	public @ResponseBody
	String insertCode(@RequestParam Map<String, Object> param
			, HttpSession session
			, HttpServletRequest request) throws Exception {

		codeService.add(param);

		return SUCCESS;
	}

	/**
	 * name : updateCode (ajax)
	 * description : 코드를 수정한다.
	 */
	@RequestMapping(value = "/update")
	public @ResponseBody
	String updateCode(@RequestParam Map<String, Object> param
			, HttpSession session
			, HttpServletRequest request) throws Exception {

		codeService.update(param);

		return SUCCESS;
	}

	/**
	 * name : deleteMember (ajax)
	 * description : 회원을 삭제한다.
	 */
	@RequestMapping(value = "/delete")
	public @ResponseBody
	String deleteMember(@RequestParam Map<String, Object> param
			, HttpSession session
			, HttpServletRequest request) throws Exception {

		codeService.delete(param);

		return SUCCESS;
	}
}
