package net.shopxx.controller.member;

import com.google.common.collect.Maps;
import net.shopxx.entity.CashMember;
import net.shopxx.entity.Member;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.bo.RechargeResponse;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.CashMemberService;
import net.shopxx.service.PaymentTransactionService;
import net.shopxx.service.RechargeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 提现
 */
@Controller("cashController")
@RequestMapping("/member/cash")
public class CashController extends BaseController{

    @Inject
    private CashMemberService cashMemberService;

    @GetMapping("/cashApply")
    public String recharge(@CurrentUser Member currentUser, ModelMap model) {
        return "member/cash/cashApply";
    }

    @PostMapping("/saveCashApply")
    public Object saveCashApply(@CurrentUser Member currentUser, CashMember cashMember, RedirectAttributes redirectAttributes) {
        if (!isValid(cashMember)) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }
        if (currentUser.getBalance().compareTo(cashMember.getAmount()) < 0) {
            return UNPROCESSABLE_ENTITY_VIEW;
        }
        cashMemberService.applyCash(cashMember, currentUser);
        addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
        return "redirect:/member/index";
    }


}
