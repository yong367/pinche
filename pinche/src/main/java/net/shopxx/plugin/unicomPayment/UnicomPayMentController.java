package net.shopxx.plugin.unicomPayment;

import net.shopxx.Message;
import net.shopxx.controller.admin.BaseController;
import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.tenpayEscowPayment.TenpayEscowPaymentPlugin;
import net.shopxx.service.PluginConfigService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@Controller("adminUnicomPayMentController")
@RequestMapping("/admin/payment_plugin/unicomPayMent")
public class UnicomPayMentController extends BaseController {
    @Inject
    private UnicomPayMentPlugin unicomPayMentPlugin;
    @Inject
    private PluginConfigService pluginConfigService;
    /**
     * 安装
     */
    @PostMapping("/install")
    public @ResponseBody
    Message install() {
        if (!unicomPayMentPlugin.getIsInstalled()) {
            PluginConfig pluginConfig = new PluginConfig();
            pluginConfig.setPluginId(unicomPayMentPlugin.getId());
            pluginConfig.setIsEnabled(false);
            pluginConfig.setAttributes(null);
            pluginConfigService.save(pluginConfig);
        }
        return SUCCESS_MESSAGE;
    }

    /**
     * 卸载
     */
    @PostMapping("/uninstall")
    public @ResponseBody Message uninstall() {
        if (unicomPayMentPlugin.getIsInstalled()) {
            pluginConfigService.deleteByPluginId(unicomPayMentPlugin.getId());
        }
        return SUCCESS_MESSAGE;
    }

    /**
     * 设置
     */
    @GetMapping("/setting")
    public String setting(ModelMap model) {
        PluginConfig pluginConfig = unicomPayMentPlugin.getPluginConfig();
        model.addAttribute("feeTypes", PaymentPlugin.FeeType.values());
        model.addAttribute("pluginConfig", pluginConfig);
        return "/net/shopxx/plugin/unicomPayment/setting";
    }

    /**
     * 更新
     */
    @PostMapping("/update")
    public String update(String paymentName, String partner, String key, PaymentPlugin.FeeType feeType, BigDecimal fee, String logo, String description, @RequestParam(defaultValue = "false") Boolean isEnabled, Integer order, RedirectAttributes redirectAttributes) {
        PluginConfig pluginConfig = unicomPayMentPlugin.getPluginConfig();
        Map<String, String> attributes = new HashMap<>();
        attributes.put(PaymentPlugin.PAYMENT_NAME_ATTRIBUTE_NAME, paymentName);
        attributes.put("partner", partner);
        attributes.put("key", key);
        attributes.put(PaymentPlugin.FEE_TYPE_ATTRIBUTE_NAME, feeType.toString());
        attributes.put(PaymentPlugin.FEE_ATTRIBUTE_NAME, fee.toString());
        attributes.put(PaymentPlugin.LOGO_ATTRIBUTE_NAME, logo);
        pluginConfig.setAttributes(attributes);
        pluginConfig.setIsEnabled(isEnabled);
        pluginConfig.setOrder(order);
        pluginConfigService.update(pluginConfig);
        addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
        return "redirect:/admin/payment_plugin/list";
    }
}
