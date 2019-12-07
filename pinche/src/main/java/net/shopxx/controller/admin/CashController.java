/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import net.shopxx.Page;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.entity.Admin;
import net.shopxx.entity.Cash;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.CashService;

import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Controller - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminCashController")
@RequestMapping("/admin/cash")
public class CashController extends BaseController {

	@Inject
	private CashService cashService;

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public String review(Long id, Boolean isPassed, @CurrentUser Admin currentUser, RedirectAttributes redirectAttributes) {
		Cash cash = cashService.find(id);
		if (isPassed == null || cash == null || !Cash.Status.pending.equals(cash.getStatus())) {
			return ERROR_VIEW;
		}
		cashService.review(cash, isPassed);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", cashService.findPage(pageable));
		return "admin/cash/list";
	}

	@RequestMapping("exportCashList")
	public String exportCashList(@RequestParam(name = "searchValue",defaultValue = "") String searchValue,HttpServletResponse response) throws IOException {
		int currentPageNumber = 1;
		Pageable pageable = new Pageable();
		pageable.setSearchProperty("business.name");
		pageable.setPageSize(10);
		pageable.setPageNumber(currentPageNumber);
		if(!StringUtils.isEmpty(searchValue)){
		pageable.setSearchValue(searchValue);
		}
		Page<Cash> pageResult= cashService.findPage(pageable);
		int totalPage = pageResult.getTotalPages();
		StringBuffer result = new StringBuffer("商家名称,申请时间,商家提现金额(元),实际转账(已扣除0.6%手续费)(元),收款银行,开户名称,收款账号,状态\n");
		for (int i = 1; i < totalPage + 1 ; i++) {
			if(i != 1){
				pageable.setPageNumber(i);
				pageResult = cashService.findPage(pageable);
			}
			for (Cash cash:pageResult.getContent()) {
				result.append(cash.getBusiness().getName() + "\t").append(",");
				result.append(cash.getCreatedDate() + "\t").append(",");
				result.append(cash.getAmount()).append(",");
				result.append(cash.getTransferAmount()).append(",");
				result.append(cash.getBank() + "\t").append(",");
				result.append(cash.getAccountName() + "\t").append(",");
				result.append(cash.getAccount() + "\t").append(",");
				if (Cash.Status.pending.equals(cash.getStatus())) {
					result.append("等待审核");
				} else if (Cash.Status.approved.equals(cash.getStatus())) {
					result.append("审核通过");
				} else{
					result.append("审核失败");
				}
				result.append("\n");
			}
		}
		String filename = "exportCashList.csv";
		response.reset();
		response.setHeader("Content-Disposition", "attachment;filename="
				+ filename);
		response.setContentType("application/octet-stream;charset=GBK");
		response.getWriter().write(result.toString());
		return null;
	}

}