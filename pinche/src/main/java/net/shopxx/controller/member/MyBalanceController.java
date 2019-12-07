package net.shopxx.controller.member;

import net.shopxx.entity.Member;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberDepositLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("myDuiBanController")
@RequestMapping("/member/myDuiBan")
public class MyBalanceController {

    @Autowired
    MemberDepositLogService memberDepositLogService;

    @GetMapping("/balance")
    public String setting (@CurrentUser Member currentUser, ModelMap model) throws Exception {
        return "member/my_duiban/myDuiBan";
    }
}
