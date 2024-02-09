package com.goott.vodto.ksh;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class UploadFiles {
	private int uploadFilesSeq;
	private String thumbnailFileName;
	private String extension;
	private String original_fileName;
	private String new_fileName;
	private long file_size;
	private int board_no;
	private int board_category_no;
	
	public UploadFiles(String original_fileName, long file_size) {
		this.original_fileName = original_fileName;
		this.file_size = file_size;
	}
}