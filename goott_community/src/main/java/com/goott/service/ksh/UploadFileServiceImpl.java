package com.goott.service.ksh;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.naming.NamingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import com.goott.controller.HomeController;
import com.goott.dao.ksh.UploadDAO;
import com.goott.vodto.ksh.UploadFiles;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UploadFileServiceImpl implements UploadFileService {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Inject
	private UploadDAO uDao;
	
	@Override
	public UploadFiles uploadFile(String originalFileName, long size, String contentType, byte[] data,
			String realPath) throws IOException {
		UploadFiles uf = null;
		
		// 새 파일 업로드.
		uf = uploadNewFile(originalFileName, size, contentType, data, realPath);
		
		return uf;
	}
	

	
//	@Override
	public UploadFiles uploadNewFile(String originalFileName, long size, String contentType, byte[] data,
			String realPath) throws IOException {
		String completePath = makeCalculatePath(realPath);	// 물리적 경로 + /년/월/일
		System.out.println("completePath : " + completePath);
		UploadFiles uf = new UploadFiles();
		
		if (size > 0) {
			uf.setOriginal_fileName(originalFileName);
			uf.setFile_size(size);
			uf.setNew_fileName(getNewFileName(originalFileName, realPath, completePath)); 
			uf.setExtension(originalFileName.substring(originalFileName.lastIndexOf(".") + 1));
			
			// 실제 파일을 저장시키는 문장
			FileCopyUtils.copy(data, new File(realPath + uf.getNew_fileName()));
	
		}
		return uf;
	}
	

	
	public static String makeCalculatePath(String realPath) {
		Calendar cal = Calendar.getInstance();
		String year = File.separator + cal.get(Calendar.YEAR);	// "\2023"
		String monthStr = "0" + (cal.get(Calendar.MONTH) + 1);
		String month = year + File.separator + monthStr.substring(monthStr.length() - 2);
		String date = month + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		
		makeDirectroy(realPath, year, month, date);
		
		return realPath + date;
	}
	
	private static void makeDirectroy(String realPath, String...strings) {
		// realPath 경로 + /년/월/일 폴더가 모두 존재하지 않는다면
		if (!new File(realPath + strings[strings.length - 1]).exists()) {
			for (String path : strings) {
				File tmp = new File(realPath + path);
				if (!tmp.exists()) {
					tmp.mkdirs();
				}
			}
		}
	}
	
	private static String getNewFileName(String originalFilename, String realPath, String completePath) {
		String uuid = UUID.randomUUID().toString();
		
		// 파일 이름이 중복되지 않게 처리하기
		// ex) "userId_UUID.확장자";
		String newFileName = uuid + "_" + originalFilename;
		
		return completePath.substring(realPath.length()) + File.separator + newFileName;
	}

	@Override
	public int deleteFile(String newFileName, String realPath) {
		int result = -1;
		String contentType = newFileName.substring(newFileName.lastIndexOf(".") + 1);
		File file = new File(realPath + newFileName);
		if (file.exists()) {			
			file.delete();
			result = 1;
		} else {
			result = 0;
		}
		
		return result;
	}

	@Override
	public void deleteUploadedFile(List<String> deleteFileList, String realPath) throws IOException {
		for (String deleteFile : deleteFileList) {
			deleteFile = deleteFile.replace("thumb_", "");
			deleteFile(deleteFile, realPath);
		}
	}

	@Override
	public boolean isExist(String newFileName) throws SQLException, NamingException {
		boolean result = false;
		
		if (uDao.selectUploadFile(newFileName) != null) {
			result = true;
		}
		
		return result;
	}
	
}