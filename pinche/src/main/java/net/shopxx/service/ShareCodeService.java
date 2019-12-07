package net.shopxx.service;

import net.shopxx.entity.Member;

public interface ShareCodeService {

    /**
     * 判断和生成邀请码
     *
     * @return 唯一的邀请码
     */
    String generateShareCode();

    /**
     * 分享码图片
     * @param member
     * @return
     */
    String generateShareCodeImgUrl(Member member);
    /**
     * 异步更新模板
     */
    void generateUpdateImgUrl(Member member);
}
