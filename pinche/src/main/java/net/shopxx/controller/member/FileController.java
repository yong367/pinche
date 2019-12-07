/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import net.shopxx.FileType;
import net.shopxx.Results;
import net.shopxx.controller.business.BaseController;
import net.shopxx.service.FileService;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller - 文件
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberFileController")
@RequestMapping("/member/file")
public class FileController extends BaseController {

	@Inject
	private FileService fileService;

	/**
	 * 上传
	 */
	@PostMapping("/upload")
	public ResponseEntity<?> upload(FileType fileType, MultipartFile file) {
		Map<String, Object> data = new HashMap<>();
		String url = fileService.upload(FileType.image, file, false);
		if (StringUtils.isEmpty(url)) {
			return Results.unprocessableEntity("business.upload.error");
		}

		data.put("url", url);
		data.put("code","200");
		return ResponseEntity.ok(data);
	}

}