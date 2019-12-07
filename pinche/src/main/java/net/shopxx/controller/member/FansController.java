package net.shopxx.controller.member;


import com.fasterxml.jackson.annotation.JsonView;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.FansService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;
import java.math.BigDecimal;


@Controller
@RequestMapping("/member/fans")
public class FansController {
    /**
     * 每页记录数
     */
    private static final int PAGE_SIZE = 10;
    
    @Inject
    private FansService fansService;

    //粉丝页面
    @GetMapping("/fans")
    public String fensi (@CurrentUser Member currentUser, ModelMap model) {
        Long fansCount = fansService.checkFenSiCount(currentUser);
        model.addAttribute("fansCount",fansCount);
        Pageable pageable=new Pageable();
        model.addAttribute("page",new Page(fansService.findFansPage(currentUser,pageable),fansCount,pageable));
        return "member/fans/fans";
    }
    //佣金页面
    @GetMapping("/duiban")
    public String duiban (@CurrentUser Member currentUser, ModelMap model) {
        BigDecimal yongJin = fansService.yongJinSum(currentUser);
        model.addAttribute("yongJin",yongJin);
        //Pageable pageable=new Pageable();
        //model.addAttribute("page",new Page(fansService.findFansPage(currentUser,pageable),fansCount,pageable));
        return "member/fans/duiban";
        
    }
    
    /**
     * 贡献记录
     * @param pageNumber
     * @param currentUser
     * @return
     */
    @GetMapping(path = "/contributionLog", produces = MediaType.APPLICATION_JSON_VALUE)
    @JsonView(BaseEntity.BaseView.class)
    //Member member,Member recommendMember, MemberContributionLog.Type type,BigDecimal memberParentDonationAmount,
    public ResponseEntity<?> saveContributionLog(Integer pageNumber, @CurrentUser Member currentUser) {
        Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
        return ResponseEntity.ok(fansService.findPage(currentUser,pageable).getContent());
    }

    /**
     * 粉丝记录
     */
    @GetMapping(path = "/fansLog", produces = MediaType.APPLICATION_JSON_VALUE)
    @JsonView(BaseEntity.BaseView.class)
    public ResponseEntity<?> yongJinLog(Integer pageNumber, @CurrentUser Member currentUser) {
        Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
        return ResponseEntity.ok(fansService.findFansPage(currentUser, pageable));
    }
}


