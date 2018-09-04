package com.qmx.admin.enumerate;

public enum FileType {

	/** 图片 */
	image("图片"),

	/** Flash */
	flash("Flash"),

	/** 媒体 */
	media("媒体文件"),

	certificate("证书"),

	/** 文件 */
	file("文件");

	private String name;

	FileType(String name){
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}