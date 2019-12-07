/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import net.shopxx.Order;
import net.shopxx.Pageable;
import net.shopxx.entity.CarLine;
import net.shopxx.service.PublishJourneyService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;

/**
 * Controller - 线路控制管理
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminCarLineController")
@RequestMapping("/admin/carLine")
public class PublishJourneyController extends BaseController {

	@Inject
	private PublishJourneyService publishJourneyService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		pageable.setOrderProperty("id");
		pageable.setOrderDirection(Order.Direction.desc);
		model.addAttribute("page", publishJourneyService.findPage(pageable));
		return "admin/carline/list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		return "admin/carline/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(CarLine carLine,RedirectAttributes redirectAttributes) {
		if(publishJourneyService.checkExist(carLine)){
			addFlashMsg(redirectAttributes, "操作失败！该线路已经存在");
		}else{
			addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
			publishJourneyService.save(carLine);
		}
		return "redirect:list";
	}

	/**
	 * 删除
	 */
	/*@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids != null) {
			for (Long id : ids) {
				Member member = memberService.find(id);
				if (member != null && member.getBalance().compareTo(BigDecimal.ZERO) > 0) {
					return Message.error("admin.member.deleteExistDepositNotAllowed", member.getUsername());
				}
			}
			memberService.delete(ids);
		}
		return SUCCESS_MESSAGE;
	}*/

}