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
	private int uf_no;
	private String thumbnailFileName;
	private String extension;
	private String original_fileName;
	private String new_fileName;
	private long file_size;
	
	public UploadFiles(String original_fileName, long file_size) {
		this.original_fileName = original_fileName;
		this.file_size = file_size;
	}
}