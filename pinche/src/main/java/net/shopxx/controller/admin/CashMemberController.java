/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Admin;
import net.shopxx.entity.AppliCash;
import net.shopxx.entity.CashMember;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AppliCashService;
import net.shopxx.service.CashMemberService;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller - 提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminCashMemberController")
@RequestMapping("/admin/memberCash")
public class CashMemberController extends BaseController {

	@Inject
	private CashMemberService cashMemberService;
	@Inject
	private AppliCashService appliCashService;
	/**
	 * 审核
	 */
	@PostMapping("/review")
	public String review(Long id, Boolean isPassed, @CurrentUser Admin currentUser, RedirectAttributes redirectAttributes) {
		CashMember cash = cashMemberService.find(id);
		if (isPassed == null || cash == null || !CashMember.Status.pending.equals(cash.getStatus())) {
			return ERROR_VIEW;
		}
		cashMemberService.review(cash, isPassed);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", cashMemberService.findPage(pageable));
		return "admin/cashMember/list";
	}
	//提现列表
	@GetMapping("/appliCashList")
	public String wxCashlist(Pageable pageable, ModelMap model) {
		model.addAttribute("page", appliCashService.findPage(pageable));
		return "admin/cashMember/appliCashList";
	}
	
	
	@RequestMapping("exportCashList")
	public String exportCashList(@RequestParam(name = "searchValue",defaultValue = "") String searchValue,HttpServletResponse response) throws IOException {
		int currentPageNumber = 1;
		Pageable pageable = new Pageable();
		pageable.setSearchProperty("member.username");
		pageable.setPageSize(10);
		pageable.setPageNumber(currentPageNumber);
		if(!StringUtils.isEmpty(searchValue)){
		pageable.setSearchValue(searchValue);
		}
		Page<CashMember> pageResult= cashMemberService.findPage(pageable);
		int totalPage = pageResult.getTotalPages();
		StringBuffer result = new StringBuffer("会员名称,申请时间,金额(元),收款银行,开户名称,收款账号,状态\n");
		for (int i = 1; i < totalPage + 1 ; i++) {
			if(i != 1){
				pageable.setPageNumber(i);
				pageResult = cashMemberService.findPage(pageable);
			}
			for (CashMember cashMember:pageResult.getContent()) {
				result.append(cashMember.getMember().getUsername() + "\t").append(",");
				result.append(cashMember.getCreatedDate() + "\t").append(",");
				result.append(cashMember.getAmount()).append(",");
				result.append(cashMember.getBank() + "\t").append(",");
				result.append(cashMember.getAccountName() + "\t").append(",");
				result.append(cashMember.getAccount() + "\t").append(",");
				if (CashMember.Status.pending.equals(cashMember.getStatus())) {
					result.append("等待审核");
				} else if (CashMember.Status.approved.equals(cashMember.getStatus())) {
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

    /**
     * admin
     * @param id
     * @param redirectAttributes
     * @return
     */
	@GetMapping("/firmCash")
	public String firmCash( Long id, RedirectAttributes redirectAttributes) {

        AppliCash appliCash = appliCashService.find(id);
        
        //点击确定向微信支付宝发起提现申请
        appliCashService.applyCashTransfer(appliCash);
        //返回错误信息
        addFlashMsg(redirectAttributes,  appliCash.getReturnMsg());       
        
	    return "redirect:/admin/memberCash/appliCashList";
    }
}