package com.qmx.admin.utils;

import org.apache.poi.hssf.usermodel.*;

import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;

public class ExcelUtils {
//	private static Log log = LogFactory.getLog(ExcelUtil.class);

    /**
     * 通过给定的Sql导出Excel文件到Response输出流，需要指定Connection
     *
     * @param out         OutputStream out
     * @param conn        Connection 指定的数据库连接
     * @param sqlStr      String 查询的Sql语句
     * @param sheetName   String 导出的Excel Sheet名称
     * @param columnNames String[] 导出的 Excel 列名称
     * @param rowPerPage  int 每一个Sheet页的行数
     * @throws SQLException 48.
     */
    public static void export(Connection conn, String sqlStr, String sheetName, String columnNames[],
                              int rowPerPage, OutputStream out) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        ps = conn.prepareStatement(sqlStr);
        rs = ps.executeQuery();

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFCellStyle style = wb.createCellStyle();

        HSSFSheet sheet = createSheet(wb, rowPerPage, 1, sheetName);
        setSheetColumnTitle(sheet, columnNames);
        int rowCnt = 0;
        int sheetNum = 2;

        while (rs.next()) {
            if (rowCnt == rowPerPage) {
                sheet = createSheet(wb, rowPerPage, sheetNum, sheetName);
                setSheetColumnTitle(sheet, columnNames);
                rowCnt = 0;
                sheetNum++;
            }
            HSSFRow row = sheet.createRow(rowCnt + 1);
            for (int i = 0; i < columnNames.length; i++) {
                HSSFCell cell = row.createCell((short) i);
//				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
                String val = rs.getString(i);
                if (null == val) {
                    val = "";
                }
                cell.setCellValue(val);
            }
            rowCnt++;
        }
        try {
//			OutputStream os = response.getOutputStream();
//			response.reset();
//			response.setContentType("application/vnd.ms-excel");
//			response.setHeader("Content-disposition", "attachment; filename="+getFileName(shtName));
//			wb.write(os);
//			String savePath = "d:\\";
//			OutputStream fos = new FileOutputStream(new File(savePath,sheetName));
//			fos.close();
            wb.write(out);
        } catch (IOException ex) {
            ex.printStackTrace();
//			log.info("Export Excel file error ! " + ex.getMessage());
        }
    }

    public static interface RowMapper<T> {
        public void mapper(HSSFRow row, T t);
    }

    public static <T> void export(Collection<T> collection, String sheetName, String columnNames[], RowMapper<T> mapper,
                                  int rowPerPage, OutputStream out) {

        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        HSSFSheet sheet = createSheet(wb, rowPerPage, 1, sheetName);
        setSheetColumnTitle(sheet, columnNames);
        int rowCnt = 0;
        int sheetNum = 2;

        for (T objs : collection) {
            if (rowCnt == rowPerPage) {
                sheet = createSheet(wb, rowPerPage, sheetNum, sheetName);
                setSheetColumnTitle(sheet, columnNames);
                rowCnt = 0;
                sheetNum++;
            }
            HSSFRow row = sheet.createRow(rowCnt + 1);
//			int cellIndex = 0;
//			for (int i = 0; i < columnNames.length; i++) {
//				if("#".equals(columnNames[i])) {
//					HSSFCell cell = row.createCell((short) i);
//					cell.setCellValue(rowCnt + 1);
//				} else {
//					Object val = objs[columnIndexs[i]];
//					if (null == val) {
//						val = "";
//					}
//					HSSFCell cell = row.createCell((short) i);
//					cell.setCellValue(val.toString());
//				}
//			}
            mapper.mapper(row, objs);
            rowCnt++;
        }
        try {
//			OutputStream os = response.getOutputStream();
//			response.reset();
//			response.setContentType("application/vnd.ms-excel");
//			response.setHeader("Content-disposition", "attachment; filename="+getFileName(shtName));
//			wb.write(os);
//			String savePath = "d:\\";
//			OutputStream fos = new FileOutputStream(new File(savePath,sheetName));
//			fos.close();
            wb.write(out);
        } catch (IOException ex) {
            ex.printStackTrace();
//			log.info("Export Excel file error ! " + ex.getMessage());
        }
    }

    public static void export(Collection<Object[]> collection, String sheetName, String columnNames[], int columnIndexs[],
                              int rowPerPage, OutputStream out) {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        HSSFSheet sheet = createSheet(wb, rowPerPage, 1, sheetName);
        setSheetColumnTitle(sheet, columnNames);
        int rowCnt = 0;
        int sheetNum = 2;

        for (Object[] objs : collection) {
            if (rowCnt == rowPerPage) {
                sheet = createSheet(wb, rowPerPage, sheetNum, sheetName);
                setSheetColumnTitle(sheet, columnNames);
                rowCnt = 0;
                sheetNum++;
            }
            HSSFRow row = sheet.createRow(rowCnt + 1);
            int cellIndex = 0;
            for (int i = 0; i < columnNames.length; i++) {
//				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
                if ("#".equals(columnNames[i])) {
                    HSSFCell cell = row.createCell((short) i);
                    cell.setCellValue(rowCnt + 1);
                } else {
                    Object val = objs[columnIndexs[i]];
                    if (null == val) {
                        val = "";
                    }
                    HSSFCell cell = row.createCell((short) i);
                    cell.setCellValue(val.toString());
                }
            }
            rowCnt++;
        }
        try {
            wb.write(out);
        } catch (IOException ex) {
            ex.printStackTrace();
//			log.info("Export Excel file error ! " + ex.getMessage());
        }
    }

//	public static void export(Session session, String hql, String sheetName, String columnNames[],
//			int rowPerPage, OutputStream out) throws SQLException {
//		Query query = session.createQuery(hql);
//		query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
//		List<Map> list = query.list();
//
//		HSSFWorkbook wb = new HSSFWorkbook();
//		HSSFCellStyle style = wb.createCellStyle();
//		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//
//		HSSFSheet sheet = createSheet(wb, rowPerPage, 1, sheetName);
//		setSheetColumnTitle(sheet, columnNames);
//		int rowCnt = 0;
//		int sheetNum = 2;
//
//		for(Map<String, Object> map : list) {
//			if (rowCnt == rowPerPage) {
//				sheet = createSheet(wb, rowPerPage, sheetNum, sheetName);
//				setSheetColumnTitle(sheet, columnNames);
//				rowCnt = 0;
//				sheetNum++;
//			}
//			HSSFRow row = sheet.createRow(rowCnt + 1);
//			for (int i = 0; i < columnNames.length; i++) {
//				HSSFCell cell = row.createCell((short) i);
////				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
//				Object val = map.get(columnNames[i]);
//				if (null == val) {
//					val = "";
//				}
//				cell.setCellValue(val.toString());
//			}
//			rowCnt++;
//		}
//		try {
////			OutputStream os = response.getOutputStream();
////			response.reset();
////			response.setContentType("application/vnd.ms-excel");
////			response.setHeader("Content-disposition", "attachment; filename="+getFileName(shtName));
////			wb.write(os);
////			String savePath = "d:\\";
////			OutputStream fos = new FileOutputStream(new File(savePath,sheetName));
////			fos.close();
//			wb.write(out);
//		} catch (IOException ex) {
//			ex.printStackTrace();
////			log.info("Export Excel file error ! " + ex.getMessage());
//		}
//	}
//
//	public static <T> void export(Session session, DetachedCriteria detachedCriteria, String sheetName, String columnNames[], RowMapper<T> mapper,
//			int rowPerPage, HttpServletRequest request, HttpServletResponse response) {
////		Number totalCount = (Number) criteria.setProjection(Projections.rowCount()).uniqueResult();
////		if(totalCount.longValue() > 20000) {
////			throw new RuntimeException("超过20000条记录，建议增加查询条件");
////		}
//		detachedCriteria.setProjection(null);
//		detachedCriteria.setResultTransformer(Criteria.ROOT_ENTITY);
//
//		Criteria criteria = detachedCriteria
//				.getExecutableCriteria(session);
//
//		HSSFWorkbook wb = new HSSFWorkbook();
//		HSSFCellStyle style = wb.createCellStyle();
//		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
//
//		HSSFSheet sheet = createSheet(wb, rowPerPage, 1, sheetName);
//		setSheetColumnTitle(sheet, columnNames);
//		int rowCnt = 0;
//		int sheetNum = 2;
//
//		int page = 1;
//		criteria.setFirstResult((page-1)*rowPerPage);
//		criteria.setMaxResults(rowPerPage);
//		List<T> list = criteria.list();
//		while(list.size() <= rowPerPage) {
//			for(T objs : list) {
//				HSSFRow row = sheet.createRow(rowCnt + 1);
//				mapper.mapper(row, objs);
//				rowCnt++;
//			}
//			if(rowCnt >= rowPerPage) {
//				sheet = createSheet(wb, rowPerPage, sheetNum, sheetName);
//				setSheetColumnTitle(sheet, columnNames);
//				rowCnt = 0;
//				sheetNum++;
//				page++;
//			} else {
//				break;
//			}
//			criteria.setFirstResult((page-1)*rowPerPage);
//			list = criteria.list();
//		};
////		String path = "/download/"+System.currentTimeMillis()+".xls";
////		File file = new File(request.getRealPath(path));
////		if(!file.getParentFile().exists()) {
////			file.getParentFile().mkdir();
////		}
//		try {
//			response.setContentType("application/vnd.ms-excel");
//			response.setHeader("Content-disposition", "attachment; filename="+getFileName(sheetName));
//			OutputStream fos = new BufferedOutputStream(response.getOutputStream());
//			wb.write(fos);
//			fos.flush();
//			fos.close();
////			request.getRequestDispatcher(path).forward(request, response);
//		} catch (IOException ex) {
//			ex.printStackTrace();
//		} catch (Throwable e) {
//			e.printStackTrace();
//		} finally {
////			FileUtils.deleteQuietly(file);
//		}
//	}

    /**
     * 设置Sheet页的列属性
     *
     * @param sht HSSFSheet 124.
     */
    private static void setSheetColumnTitle(HSSFSheet sht, String[] cLabels) {
        HSSFRow row = sht.createRow(0);
        for (int i = 0; i < cLabels.length; i++) {
            HSSFCell cell = row.createCell((short) (i));
//			cell.setEncoding(HSSFCell.ENCODING_COMPRESSED_UNICODE);
            cell.setCellValue(cLabels[i]);
//			cell.setCellStyle(style);
        }
    }

    /**
     * 创建一个Sheet页并返回该对象
     *
     * @param wb  HSSFWorkbook
     * @param seq int
     * @return HSSFSheet
     */
    private static HSSFSheet createSheet(HSSFWorkbook wb, int rpp, int seq, String shtName) {
        int sup = seq * rpp;
        int sub = (seq - 1) * rpp + 1;
        if (sub < 1) {
            sub = 1;
        }
        return wb.createSheet(shtName + "(" + sub + "-" + sup + ")");
    }

    private static String getFileName(String fileName) {
        try {
            fileName = URLEncoder.encode(fileName, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return fileName + new java.util.Date().getTime() + ".xls";
    }
}

