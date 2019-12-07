/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreClerk;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.StoreClerkService;
import net.shopxx.service.StoreService;
import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;

/**
 * Controller - 店铺店员
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessStoreClerkController")
@RequestMapping("/business/store_clerk")
public class StoreClerkController extends BaseController {

	@Inject
	private StoreClerkService storeClerkService;

	@Inject
	private StoreService storeService;
	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(long storeClerkId, ModelMap model) {
		model.addAttribute("storeClerk", storeClerkService.find(storeClerkId));
		return "business/store_clerk/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("storeClerkForm") StoreClerk storeClerkForm,@CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(storeClerkForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeClerkService.update(storeClerkForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", storeClerkService.findPage(currentStore, pageable));
		return "business/store_clerk/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			StoreClerk storeClerk = storeClerkService.find(id);
			if (storeClerk == null || !currentStore.equals(storeClerk.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			storeClerkService.delete(id);
		}
		return Results.OK;
	}

}