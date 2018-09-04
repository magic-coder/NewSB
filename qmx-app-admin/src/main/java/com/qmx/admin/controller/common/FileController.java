package com.qmx.admin.controller.common;

import com.alibaba.fastjson.JSONObject;
import com.qmx.admin.enumerate.FileType;
import com.qmx.base.api.dto.RestResponse;
import com.qmx.base.core.service.FileUploadService;
import com.qmx.base.core.utils.FileNameUtil;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * @Author liubin
 * @Description 文件处理
 * @Date Created on 2017/11/28 15:04.
 * @Modified By
 */
@Controller
@RequestMapping("/file")
public class FileController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(FileController.class);

    //@Value("${com.qmx.app.upload.path.win}")
    //private String uploadBasePath;

    @Autowired
    private FileUploadService fileUploadService;
    @Value("${com.qmx.app.upload.path.linux}")
    private String uploadBasePathLinux;
    @Value("${com.qmx.app.upload.path.win}")
    private String uploadBasePathWin;

    @Value("${com.qmx.app.siteHost}")
    private String siteHost;
    @Value("${com.qmx.app.upload.local:true}")
    private Boolean useLocal;

    private static Map<String,String> mediaMap = new HashMap<>();
    static{
        mediaMap.put(".wav","audio/wav");
        mediaMap.put(".wmv","video/x-ms-wmv");
        mediaMap.put(".mp3","audio/mp3");
        mediaMap.put(".mp4","video/mpeg4");
        mediaMap.put(".rmvb","application/vnd.rn-realmedia-vbr");
        mediaMap.put(".png","image/png");
        mediaMap.put(".jpg","image/jpeg");
        mediaMap.put(".jpeg","image/jpeg");
        mediaMap.put(".wav","audio/wav");
    }

    public Boolean getUseLocal() {
        return useLocal;
    }

    public String getBaseUploadPath(){
        if(isWin()){
            return uploadBasePathWin;
        }else {
            return uploadBasePathLinux;
        }
        //logger.info("uploadBasePath-->>{}",uploadBasePath);
    }

    /**
     * 是否是Windows
     * @return
     */
    private Boolean isWin(){
        String os = System.getProperty("os.name");
        if(os.toLowerCase().startsWith("win")){
            return true;
        }
        return false;
    }

    /**
     * 本地上传
     * @param request
     * @param fileType
     * @param multipartFile
     * @return
     */
    public String uploadLocal(HttpServletRequest request, FileType fileType, MultipartFile multipartFile) {
        if (multipartFile == null) {
            return null;
        }
        String uploadPath = "/file/upload/"+fileType.name()+"/";
        try {
            String suffix = FileNameUtil.getExtension(multipartFile.getOriginalFilename());
            String sn = UUID.randomUUID().toString();
            String destPath = uploadPath + sn + "." + suffix;
            //String filePath = "D://"+destPath;
            String filePath = getBaseUploadPath() + destPath;
            File destFile = new File(filePath);//servletContext.getRealPath(destPath)
            System.out.println("filePath:"+destFile.getAbsolutePath());
            if (!destFile.getParentFile().exists()) {
                destFile.getParentFile().mkdirs();
            }
            multipartFile.transferTo(destFile);
            if("p12".equals(suffix)){
                //如果是证书返回原地址
                return filePath;
            }
            return siteHost+destPath;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 上传，直接返回url
     * @param request
     * @param fileType
     * @param file
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/upload2", method = RequestMethod.POST)
    private JSONObject upload2(HttpServletRequest request, FileType fileType, MultipartFile file){
        String suffix = FileNameUtil.getExtension(file.getOriginalFilename());
        String fileName = UUID.randomUUID().toString() + "." + suffix;
        String bathPath = getBaseUploadPath();
        JSONObject jsonObject = new JSONObject();

        JSONObject jsonResult = new JSONObject();
        jsonResult.put("content","操作成功");
        jsonResult.put("type","success");
        jsonObject.put("message",jsonResult);
        //如果是证书(特殊处理)
        if("p12".equals(suffix)){
            //String key2 = "certificate/"+file.getOriginalFilename();
            fileName = UUID.randomUUID().toString()+"_"+file.getOriginalFilename();
        }

        String key = fileType.name()+"/"+fileName;
        String uploadPath = siteHost+"/file/upload/" + key;
        try{
            if(getUseLocal()){
                //本地上传
                String path = uploadLocal(request,fileType,file);
                jsonObject.put("url",path);
                return jsonObject;
            }

            //执行上传
            fileUploadService.upload("gds-bucket",key,file.getInputStream());
            if("p12".equals(suffix)){
                jsonObject.put("url",bathPath+"/upload/"+key);
                return jsonObject;
            }
            jsonObject.put("url",uploadPath);
            return jsonObject;
        }catch (Exception e){
            e.printStackTrace();
        }
        jsonResult.put("content","上传失败");
        jsonResult.put("type","warn");
        jsonObject.put("message",jsonResult);
        return jsonObject;
    }

    /**
     * 上传,返回封装的url
     */
    @ResponseBody
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public RestResponse<String> upload(HttpServletRequest request, FileType fileType, MultipartFile file) {
        JSONObject result = upload2(request, fileType, file);
        return RestResponse.ok(result.getString("url"));
    }

    /**
     * @return ResponseEntity<?>    返回类型
     * @Title: getFile
     * @Description: TODO(获取图片)
     */
    @GetMapping("/upload/{type}/{name:.+}")
    public void getFile(@PathVariable String name, @PathVariable String type, HttpServletResponse response) {
        try {
            //setBaseUploadPath();
            if(getUseLocal()){
                String  uploadPath = "/file/upload/"+type+"/"+name;
                File file = new File(getBaseUploadPath() + uploadPath);
                String str = name.substring(name.lastIndexOf("."),name.length());
                String contentType = mediaMap.get(str);
                if(contentType == null){
                    response.setContentType("application/octet-stream");
                }else{
                    response.setContentType(contentType);
                }
                byte[] buffer = new byte[1024];
                FileInputStream fis = null; //文件输入流
                BufferedInputStream bis = null;
                OutputStream os = null; //输出流
                try {
                    os = response.getOutputStream();
                    fis = new FileInputStream(file);
                    bis = new BufferedInputStream(fis);
                    int i = bis.read(buffer);
                    while(i != -1){
                        os.write(buffer);
                        i = bis.read(buffer);
                    }
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                System.out.println("----------file download-->" + name);
                try {
                    bis.close();
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }else{
                String filePath = type+"/"+name;
                fileUploadService.getFile("gds-bucket",filePath,response.getOutputStream());
                response.flushBuffer();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}