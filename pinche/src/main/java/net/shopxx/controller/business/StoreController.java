/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import net.shopxx.Results;
import net.shopxx.entity.*;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.*;
import net.shopxx.util.WebUtils;
import net.shopxx.weixin.service.WeixinService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

/**
 * Controller - 店铺
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessStoreController")
@RequestMapping("/business/store")
public class StoreController extends BaseController {

	@Inject
	private StoreService storeService;
	@Inject
	private StoreRankService storeRankService;
	@Inject
	private StoreCategoryService storeCategoryService;
	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private PluginService pluginService;
	@Inject
	private SvcService svcService;
	@Inject
	private WeixinService weixinService;
	@Inject
	private BusinessService businessService;
	@Inject
	private AreaService areaService;
    /**
     * 添加属性
     */
    @ModelAttribute
    public void populateModel( @CurrentUser Business currentUser, ModelMap model) {
        if(currentUser!=null){
            Store store = new Store();
            model.addAttribute("store", store);
        }
    }

	/**
	 * 检查名称是否唯一
	 */
	@GetMapping("/check_name")
	public @ResponseBody boolean checkName(String name, Store store) {
		return StringUtils.isNotEmpty(name) && storeService.nameUnique(store.getId(), name);
	}

	/**
	 * 店铺状态
	 */
	@GetMapping("/store_status")
	public @ResponseBody Map<String, Object> storeStatus(@CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		data.put("status", currentStore.getStatus());
		return data;
	}

	/**
	 * 到期日期
	 */
	@GetMapping("/end_date")
	public @ResponseBody Map<String, Object> endDate(@CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		data.put("endDate", currentStore.getEndDate());
		return data;
	}

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(String paymentPluginId, Integer years, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		if (paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (years == null || years < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		BigDecimal amount = currentStore.getStoreRank().getServiceFee().multiply(new BigDecimal(years));
		if (Store.Status.approved.equals(currentStore.getStatus())) {
			amount = amount.add(currentStore.getBailPayable());
		}
		data.put("fee", paymentPlugin.calculateFee(amount));
		data.put("amount", paymentPlugin.calculateAmount(amount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 申请
	 */
	@GetMapping("/register")
	public String register(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore != null) {
			return "redirect:/business/index";
		}

		model.addAttribute("storeRanks", storeRankService.findList(true, null, null));
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "business/store/register";
	}

	/**
	 * 申请
	 */
	@PostMapping("/register")
	public ResponseEntity<?> register(@ModelAttribute Store storeForm, Long[] productCategoryIds,Long storeRankId,Long storeCategoryId, Long areaId,@CurrentUser Business currentUser) {
		if (currentUser == null) {
			return Results.unprocessableEntity("common.message.unauthorized");
		}
		if (storeService.nameExists(storeForm.getName())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		StoreRank storeRank = storeRankService.find(storeRankId);
		if (!storeRank.getIsAllowRegister()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Business businessForm = storeForm.getBusiness();
		/**
		 * 保存店铺信息
		 */
		//Store store = new Store();
		//storeForm.setName(name);
        storeForm.setType(Store.Type.general);
        storeForm.setStatus(Store.Status.pending);
		//store.setEmail(email);
		//store.setMobile(mobile);
		storeForm.setArea(areaService.find(areaId));
        storeForm.setEndDate(new Date());
        storeForm.setIsEnabled(true);
        storeForm.setBailPaid(BigDecimal.ZERO);
        storeForm.setBusiness(currentUser);
        storeForm.setStoreRank(storeRank);
        storeForm.setStoreCategory(storeCategoryService.find(storeCategoryId));
        storeForm.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		if (!isValid(storeForm, BaseEntity.Save.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		storeService.save(storeForm);
		/**
		 * 保存商家信息
		 */
		Business business = businessService.find(currentUser.getId());
		//如果选择的是商户,企业
		if (Business.ChooseIdEntityInformation.merchant.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.company.equals(businessForm.getChooseCompanyOrPerson())){
            business.setChooseIdEntityInformation(Business.ChooseIdEntityInformation.merchant);
            processSelectCompany(businessForm, business);
		}
		//如果选择的是商户,个人
        if (Business.ChooseIdEntityInformation.merchant.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.person.equals(businessForm.getChooseCompanyOrPerson())){
            business.setChooseIdEntityInformation(Business.ChooseIdEntityInformation.merchant);
            processSelectPerson(businessForm, business);
		}
		//如果选择的是渠道,企业
        if (Business.ChooseIdEntityInformation.channel.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.company.equals(businessForm.getChooseCompanyOrPerson())){
            business.setChooseIdEntityInformation(Business.ChooseIdEntityInformation.channel);
            processSelectCompany(businessForm, business);
        }
        //如果选择的是渠道,个人
        if (Business.ChooseIdEntityInformation.channel.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.person.equals(businessForm.getChooseCompanyOrPerson())){
            business.setChooseIdEntityInformation(Business.ChooseIdEntityInformation.channel);
            processSelectPerson(businessForm, business);
        }
        //如果不是长期的,营业开始期限和结束期限有值
        if (businessForm.getLongTime()) {
            business.setStartDate(null);//营业开始期限
            business.setEndDate(null);//营业结束期限
        } else {
            business.setStartDate(businessForm.getStartDate());//营业开始期限
            business.setEndDate(businessForm.getEndDate());//营业结束期限
            business.setIdCardStartDate(businessForm.getIdCardStartDate());
            business.setIdCardEndDate(businessForm.getIdCardEndDate());
        }

        businessService.update(business);
		return Results.OK;
	}

    public void processSelectPerson(Business businessForm, Business business) {
        business.setChooseCompanyOrPerson(Business.ChooseCompanyOrPerson.person);
        business.setStoreName(businessForm.getStoreName());
        business.setIdCard(businessForm.getIdCard());
        business.setIdCardImage(businessForm.getIdCardImage());
        business.setReverseIdCardImage(businessForm.getReverseIdCardImage());
    }

    public void processSelectCompany(Business businessForm, Business business) {
        business.setChooseCompanyOrPerson(Business.ChooseCompanyOrPerson.company);
        business.setCompanyName(businessForm.getCompanyName());//设置企业名称
        business.setOrganizationCode(businessForm.getOrganizationCode());//统一社会信用代码
        business.setLegalPerson(businessForm.getLegalPerson());//法人姓名
        business.setLicenseImage(businessForm.getLicenseImage());
    }

    /**
	 * 重新申请
	 */
	@GetMapping("/reapply")
	public String reapply(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Store.Status.failed.equals(currentStore.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("storeRanks", storeRankService.findList(true, null, null));
		model.addAttribute("storeCategories", storeCategoryService.findAll());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "business/store/reapply";
	}

	/**
	 * 重新申请
	 */
	@PostMapping("/reapply")
	public ResponseEntity<?> reapply(@ModelAttribute Store storeForm, Long[] productCategoryIds,Long storeRankId,Long storeCategoryId, Long areaId,@CurrentStore Store currentStore) {
		if (currentStore == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Store.Status.failed.equals(currentStore.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		StoreRank storeRank = storeRankService.find(storeRankId);
		if (!storeRank.getIsAllowRegister()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Business businessForm = storeForm.getBusiness();
		storeForm.setType(Store.Type.general);
		storeForm.setStatus(Store.Status.pending);
		storeForm.setArea(areaService.find(areaId));
		storeForm.setEndDate(new Date());
		storeForm.setIsEnabled(true);
		storeForm.setBailPaid(BigDecimal.ZERO);
		storeForm.setBusiness(currentStore.getBusiness());
		storeForm.setStoreRank(storeRank);
		storeForm.setStoreCategory(storeCategoryService.find(storeCategoryId));
		storeForm.setProductCategories(new HashSet<>(productCategoryService.findList(productCategoryIds)));
		if (!isValid(storeForm, BaseEntity.Update.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		storeService.update(storeForm);
		/**
		 * 保存商家信息
		 */
		Business business = businessService.find(currentStore.getBusiness().getId());
		//如果选择的是商户,企业
		if (Business.ChooseIdEntityInformation.merchant.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.company.equals(businessForm.getChooseCompanyOrPerson())){
			processSelectCompany(businessForm, business);
		}
		//如果选择的是商户,个人
		if (Business.ChooseIdEntityInformation.merchant.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.person.equals(businessForm.getChooseCompanyOrPerson())){
			processSelectPerson(businessForm, business);
		}
		//如果选择的是渠道,企业
		if (Business.ChooseIdEntityInformation.channel.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.company.equals(businessForm.getChooseCompanyOrPerson())){
			processSelectCompany(businessForm, business);
		}
		if (Business.ChooseIdEntityInformation.channel.equals(businessForm.getChooseIdEntityInformation()) && Business.ChooseCompanyOrPerson.person.equals(businessForm.getChooseCompanyOrPerson())){
			processSelectPerson(businessForm, business);
		}
		//如果选择的是渠道,个人
		//如果不是长期的,营业开始期限和结束期限有值
		if (businessForm.getLongTime()) {
			business.setStartDate(null);//营业开始期限
			business.setEndDate(null);//营业结束期限
		} else {
			business.setStartDate(businessForm.getStartDate());//营业开始期限
			business.setEndDate(businessForm.getEndDate());//营业结束期限
		}
		businessService.update(business);
		return Results.OK;
	}

	/**
	 * 缴费
	 */
	@GetMapping("/payment")
	public String payment(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Store.Status.approved.equals(currentStore.getStatus()) && !Store.Status.success.equals(currentStore.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		if (CollectionUtils.isNotEmpty(paymentPlugins)) {
			model.addAttribute("defaultPaymentPlugin", paymentPlugins.get(0));
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		return "business/store/payment";
	}

	/**
	 * 缴费
	 */
	@PostMapping("/payment")
	public ResponseEntity<?> payment(Integer years, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		if (years == null || years < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Store.Status.approved.equals(currentStore.getStatus()) && !Store.Status.success.equals(currentStore.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		int days = years * 365;
		BigDecimal serviceFee = currentStore.getStoreRank().getServiceFee().multiply(new BigDecimal(years));
		BigDecimal bail = Store.Status.approved.equals(currentStore.getStatus()) ? currentStore.getBailPayable() : BigDecimal.ZERO;
		if (serviceFee.compareTo(BigDecimal.ZERO) > 0) {
			PlatformSvc platformSvc = new PlatformSvc();
			platformSvc.setAmount(serviceFee);
			platformSvc.setDurationDays(days);
			platformSvc.setStore(currentStore);
			platformSvc.setPaymentTransactions(null);
			svcService.save(platformSvc);

			data.put("platformSvcSn", platformSvc.getSn());
		} else {
			storeService.addEndDays(currentStore, days);
			if (bail.compareTo(BigDecimal.ZERO) <= 0) {
				currentStore.setStatus(Store.Status.success);
				storeService.update(currentStore);
			}
		}

		if (bail.compareTo(BigDecimal.ZERO) > 0) {
			data.put("bail", bail);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 设置
	 */
	@GetMapping("/setting")
	public String setting() {
		return "business/store/setting";
	}

	/**
	 * 设置
	 */
	@PostMapping("/setting")
	public String setting(Store store, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (store == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!storeService.nameUnique(currentStore.getId(), store.getName())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		currentStore.setName(store.getName());
		currentStore.setLogo(store.getLogo());
		currentStore.setEmail(store.getEmail());
		currentStore.setMobile(store.getMobile());
		currentStore.setPhone(store.getPhone());
		currentStore.setDetailAddress(store.getDetailAddress());
		currentStore.setZipCode(store.getZipCode());
		currentStore.setIntroduction(store.getIntroduction());
		currentStore.setKeyword(store.getKeyword());
		currentStore.setBusinessHours(store.getBusinessHours());
		if (!isValid(currentStore, BaseEntity.Update.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeService.update(currentStore);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:setting";
	}

	/**
	 * 生成店铺二维码
	 * @param model
	 * @param currentStore
	 * @return
	 * @throws IOException
	 */
	@GetMapping("/getQR")
	public String getQR(Model model, @CurrentStore Store currentStore) throws IOException {
		model.addAttribute("qrCodeUrl", weixinService.getQr(currentStore.getId(),120));
		return "business/store_qr_code/index";
	}

}