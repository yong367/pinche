package net.shopxx.controller;

import net.shopxx.util.DateCollect;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;
import java.util.Date;

/**
 * 公开匿名访问类
 */
@Controller("publicController")
@RequestMapping("/public")
public class PublicController{

}
