/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import net.shopxx.entity.Member;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.LogPrintService;
import net.shopxx.service.MemberService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.inject.Inject;
import java.io.IOException;

/**
 * Controller - 分享控制器
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shareController")
@RequestMapping("/member/share")
public class ShareController extends BaseController {

    @Value("${template.loader_path}")
    private String templateLoaderPath;

    @Inject
    private LogPrintService logger;

	@Inject
	private MemberService memberService;
	/**
	 * 邀请码展示页面
	 */
	@GetMapping("/index")
	public String index(@CurrentUser Member currentUser) throws IOException {
		return "member/share/index";
	}

}