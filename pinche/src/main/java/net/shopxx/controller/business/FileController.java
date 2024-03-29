/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import net.shopxx.FileType;
import net.shopxx.Results;
import net.shopxx.service.FileService;
import net.shopxx.service.LogPrintService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
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
@Controller("businessFileController")
@RequestMapping("/business/file")
public class FileController extends BaseController {

	@Inject
	private FileService fileService;
	@Autowired
	private LogPrintService logPrintService;
	/**
	 * 上传
	 */
	@PostMapping("/upload")
	public ResponseEntity<?> upload(FileType fileType, MultipartFile file) {
		Map<String, Object> data = new HashMap<>();
		if (fileType == null || file == null || file.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!fileService.isValid(fileType, file)) {
			return Results.unprocessableEntity("business.upload.invalid");
		}
		String url = fileService.upload(fileType, file, false);
		if (StringUtils.isEmpty(url)) {
			return Results.unprocessableEntity("business.upload.error");
		}
		logPrintService.printServerLog(url);
		data.put("url", url);
		return ResponseEntity.ok(data);
	}

}