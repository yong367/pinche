/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import com.fasterxml.jackson.annotation.JsonView;
import net.shopxx.Filter;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.*;
import net.shopxx.exception.ResourceNotFoundException;
import net.shopxx.service.*;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Controller - 店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopStoreController")
@RequestMapping("/store")
public class StoreController extends BaseController {

	@Inject
	private StoreService storeService;
	@Inject
	private StoreProductCategoryService storeProductCategoryService;
	@Inject
	private StoreProductTagService storeProductTagService;
    @Inject
    private StoreFavoriteService storeFavoriteService;
	@Inject
	private ProductService productService;
	/**
	 * 首页
	 */
	@GetMapping("/{storeId}")
	public String index(@PathVariable Long storeId, ModelMap model) {
		Store store = storeService.find(storeId);
		if (store == null) {
			throw new ResourceNotFoundException();
		}
		
        model.addAttribute("store", store);
		model.addAttribute("storeProductCategoryTree", storeProductCategoryService.findTree(store));
		model.addAttribute("storeProductTags", storeProductTagService.findList(store, true));
		return "shop/store/index";
	}
	/**
	 * 首页
	 */
	@PostMapping("/search")
	public String index(@RequestParam Long storeId, ModelMap model,@RequestParam String keyword) {
		Store store = storeService.find(storeId);
		model.addAttribute("store", store);
		List<Map<String,Object>> list=productService.findProductByName(store,keyword,20);
		List<Product> result=new ArrayList<>();
		for (Map<String,Object> map:list) {
			result.add(productService.find(Long.valueOf(map.get("id").toString())));
		}
		model.addAttribute("products",result);
		return "shop/store/searchStoreProduct";
	}

	/**
	 * 首页
	 */
	@GetMapping("/newProduct/{storeId}")
	public String newProduct(@PathVariable Long storeId, ModelMap model) {
		Store store = storeService.find(storeId);
		if (store == null) {
			throw new ResourceNotFoundException();
		}
		model.addAttribute("store", store);
		return "shop/store/newProductIndex";
	}
	/**
	 * 任务记录
	 */
	@GetMapping(path = "/newProductAjax", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> newProductAjax(Integer pageNumber,Long storeId) {
		Pageable pageable = new Pageable(pageNumber, 10);
		Store store = storeService.find(storeId);
		Page<Product> page=productService.findPage(Product.Type.general,store,null,null,null,null,null,null,
				null,null,null,true,null,null,null,null,null,null, Product.OrderType.dateDesc,pageable);
		return ResponseEntity.ok(page.getContent());
	}

	/**
	 * 首页
	 */
	@GetMapping("/allProduct/{descName}_{orderBy}/{storeId}/{fenLeiId}")
	public String allProduct(@PathVariable Long storeId, @PathVariable String descName,@PathVariable String orderBy,ModelMap model,@PathVariable String fenLeiId) {
		Store store = storeService.find(storeId);
		if (store == null) {
			throw new ResourceNotFoundException();
		}
		model.addAttribute("storeProductCategoryTree", storeProductCategoryService.findTree(store));
		model.addAttribute("store", store);
		model.addAttribute("fenLeiId", fenLeiId);
		if(descName.equals("hot")){
			model.addAttribute("orderName","monthHits");
			return "shop/store/allProductReDuIndex";
		}
		if(descName.equals("sales")){
			if(orderBy.equals("up")){
				model.addAttribute("orderName","salesAsc");
			}else{
				model.addAttribute("orderName","salesDesc");
			}

			return "shop/store/allProductSalesIndex";
		}
		if(descName.equals("price")){
			if(orderBy.equals("up")){
				model.addAttribute("orderName","priceAsc");
			}else{
				model.addAttribute("orderName","priceDesc");
			}
			return "shop/store/allProductPriceIndex";
		}
		return "shop/store/allProductReDuIndex";
	}
	/**
	 * 任务记录
	 */
	@GetMapping(path = "/allProductAjax", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> allProductAjax(Integer pageNumber,Long storeId,String descName,String fenLeiId) {
		Pageable pageable = new Pageable(pageNumber, 10);
		Store store = storeService.find(storeId);
		Product.OrderType orderType =null;
		if(StringUtils.isNotEmpty(descName)){
			orderType= Product.OrderType.valueOf(descName);
		}else{
			orderType = Product.OrderType.monthHits;
		}
		StoreProductCategory storeProductCategory =null;
		if(!fenLeiId.equals("0")){
		storeProductCategory = storeProductCategoryService.find(Long.valueOf(fenLeiId));
		}
		Page<Product> page=productService.findPage(Product.Type.general,store,null,storeProductCategory,null,null,null,null,
				null,null,null,true,null,null,null,null,null,null, orderType,pageable);
		return ResponseEntity.ok(page.getContent());
	}

}