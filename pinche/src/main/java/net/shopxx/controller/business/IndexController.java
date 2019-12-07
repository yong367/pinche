/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import net.shopxx.Setting;
import net.shopxx.component.FansGroupManage;
import net.shopxx.entity.Business;
import net.shopxx.entity.Store;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.StoreCategoryService;
import net.shopxx.service.StoreRankService;
import net.shopxx.util.SystemUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.inject.Inject;

/**
 * Controller - 商家中心
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessIndexController")
@RequestMapping("/business/index")
public class IndexController extends BaseController {

	@Resource
	private FansGroupManage fansGroupManage;
    @Inject
    private StoreRankService storeRankService;
    @Inject
    private StoreCategoryService storeCategoryService;
    @Inject
    private ProductCategoryService productCategoryService;
	/**
	 * 首页
	 */
	@GetMapping
	public String index(@CurrentUser Business currentUser, ModelMap model) {
		Store  store = currentUser.getStore();
		Setting setting = SystemUtils.getSetting();
		if(store != null && store.getStatus().equals(Store.Status.success)){
			model.addAttribute("storeMobileIndexUrl",setting.getSiteUrl()+"/store/"+store.getId());
		}
		//如果还没有注册店铺返回到店铺申请页面
		if (store == null){
			model.addAttribute("storeRanks", storeRankService.findList(true, null, null));
			model.addAttribute("storeCategories", storeCategoryService.findAll());
			model.addAttribute("productCategoryTree", productCategoryService.findTree());
			return "/business/store/register";
		}
		fansGroupManage.initCurrentBusinessFansGroup(currentUser);
		return "/business/index";
	}

}