package net.shopxx.controller.admin;

import net.shopxx.Order;
import net.shopxx.Pageable;
import net.shopxx.entity.Announcement;
import net.shopxx.entity.CarLine;
import net.shopxx.service.AnnouncementService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;

/**
 * 公告管理
 */
@Controller("adminAnnouncementController")
@RequestMapping("/admin/announcement")
public class AnnouncementController extends BaseController{

    @Inject
    private AnnouncementService announcementService;

    /**
     * 列表
     */
    @GetMapping("/list")
    public String list(Pageable pageable, ModelMap model) {
        pageable.setOrderProperty("id");
        pageable.setOrderDirection(Order.Direction.desc);
        model.addAttribute("page",announcementService.findPage(pageable));
        return "admin/announcement/list";
    }


    /**
     * 列表
     */
    @GetMapping("/add")
    public String add(ModelMap model) {
        return "admin/announcement/add";
    }

    /**
     * 保存
     */
    @PostMapping("/save")
    public String save(Announcement announcement, RedirectAttributes redirectAttributes) {
        announcementService.save(announcement);
        addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
        return "redirect:list";
    }
}
