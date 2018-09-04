package com.qmx.admin.exception;

import com.netflix.hystrix.exception.HystrixBadRequestException;
import com.netflix.hystrix.exception.HystrixRuntimeException;
import com.qmx.base.core.exception.BaseException;
import com.qmx.base.core.exception.BusinessException;
import com.qmx.base.core.exception.LoginException;
import com.qmx.base.core.exception.ValidationException;
import com.qmx.base.core.utils.SpringUtil;
import feign.RetryableException;
import org.apache.shiro.authc.AuthenticationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletRequest;

/**
 * Spring mvc controller类异常处理扩展点,对于系统controller中会抛出的一次的统一处理
 * 
 * @author liubin
 *
 */
@ControllerAdvice
public class ExceptionController {

    private Logger logger = LoggerFactory.getLogger(ExceptionController.class);

    /**
     * mvc框架进行数据验证失败抛出的异常处理
     * 
     * @param ex
     * @return
     */
    //@ResponseBody
    @ExceptionHandler(BindException.class)
    public String hanldFrameworkValidationException(HttpServletRequest request,BindException ex) {
        String data = null;
        BindingResult bindingResult = ex.getBindingResult();
        for (FieldError fieldError : bindingResult.getFieldErrors()) {
            String field = fieldError.getField();
            String errorMesssage = fieldError.getDefaultMessage();
            String code = fieldError.getCode();
            Object[] arguments = fieldError.getArguments();
            data += "field:"+field+",errorMesssage:"+errorMesssage+"code:"+code+",arguments:"+arguments+"\r\n";
        }
        logger.warn("catch ValidationException: {}, errors: {}", ex, data);
        request.setAttribute("content","数据绑定异常，请检查。");
        return "/common/error";
    }

    /**
     * 自定义数据验证异常处理类
     * 
     * @param ex
     * @return
     */
    //@ResponseBody
    @ExceptionHandler(ValidationException.class)
    public String handleValidationException(HttpServletRequest request,ValidationException ex) {
        logger.debug("catch ValidationException: {}", ex);
        request.setAttribute("content",ex.getMessage());
        return "/common/error";
    }

    /**
     * 自定义BusinessException异常处理类
     *
     * @param ex
     * @return
     */
    //@ResponseBody
    @ExceptionHandler(BusinessException.class)
    public String handleBusinessException(HttpServletRequest request,BusinessException ex) {
        logger.debug("catch ValidationException: {}, errors: {}", ex, ex.getMessage());
        request.setAttribute("content",ex.getMessage());
        return "/common/error";
    }


    @ExceptionHandler({LoginException.class, AuthenticationException.class})
    public String handleLoginException(HttpServletRequest request,BaseException ex){
        request.setAttribute("content",ex.getMessage());
        logger.warn(ex.getMessage(),ex);
        return "/common/error";
    }

    /**
     * http请求方法不匹配
     * @param ex
     * @return
     */
    //@ResponseBody
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public String handleHttpRequestMethodNotSupportedException(HttpServletRequest request,HttpRequestMethodNotSupportedException ex){
        request.setAttribute("content",ex.getMessage());
        return "/common/error";
    }

    /**
     * 捕捉类型错误Assert.notNull(password,"password不能为空");
     * @param ex
     * @return
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgumentException(HttpServletRequest request, IllegalArgumentException ex){
        request.setAttribute("content",ex.getMessage());
        logger.warn(ex.getMessage(),ex);
        return "/common/error";
    }

    /**
     * NumberFormatException
     * @param request
     * @param ex
     * @return
     */
    @ExceptionHandler(NumberFormatException.class)
    public String handleNumberFormatException(HttpServletRequest request, NumberFormatException ex){
        request.setAttribute("content",ex.getMessage());
        logger.warn(ex.getMessage(),ex);
        return "/common/error";
    }

    //@ResponseBody
    @ExceptionHandler(HystrixBadRequestException.class)
    public String handleHystrixBadRequestException(HttpServletRequest request,HystrixBadRequestException ex){
        request.setAttribute("content",ex.getMessage());
        logger.warn(ex.getMessage(),ex);
        return "/common/error";
    }

    @ExceptionHandler(HystrixRuntimeException.class)
    public String handleHystrixRuntimeException(HttpServletRequest request,HystrixRuntimeException ex){
        request.setAttribute("content","请求超时，请稍后重试");
        logger.warn(ex.getMessage(),ex);
        return "/common/error";
    }

    /**
     * 服务调用超时
     * @param request
     * @param ex
     * @return
     */
    @ExceptionHandler(RetryableException.class)
    public String handleRetryableException(HttpServletRequest request, RetryableException ex){
        request.setAttribute("content","服务调用超时，请稍后重试");
        logger.error("服务调用超时",ex);
        return "/common/error";
    }

    @ExceptionHandler(RuntimeException.class)
    public String handleRuntimeException(HttpServletRequest request,RuntimeException ex){
        String message = ex.getMessage();
        if(StringUtils.hasText(message)){
            if(message.contains("com.netflix.client.ClientException")){
                //message content: com.netflix.client.ClientException: Load balancer does not have available server for client:xxx
                request.setAttribute("content","服务不可用，请稍后重试");
            }else{
                request.setAttribute("content","系统异常，请稍后重试");
            }
        }else{
            request.setAttribute("content","系统异常，请稍后重试");
        }
        /*System.out.println("ex.getClass():"+ex.getClass());
        System.out.println("ex.getClass():"+ex.getClass().getTypeName());
        System.out.println("ex.getClass():"+ex.getMessage());*/
        logger.error(ex.getMessage(),ex);
        return "/common/error";
    }

    /**
     * 其他所有抛出异常处理类
     * 
     * @param ex
     * @return
     */
    //@ResponseBody
    @ExceptionHandler(Throwable.class)
    public String hanldSystemException(HttpServletRequest request,Throwable ex) {
        logger.error("System error happen: (classType:"+ex.getClass().getName()+") " + ex.getMessage(), ex);
        String errorMsg = null;
        String currentModule = SpringUtil.getApplicationContext().getEnvironment()
                .getProperty("spring.application.name");
        if (logger.isDebugEnabled()) {
            StackTraceElement[] stackTraceElements = ex.getStackTrace();
            if (stackTraceElements != null) {
                StringBuffer sb = new StringBuffer();
                for (int i = 0; i < stackTraceElements.length; i++) {
                    if (i > 5) {
                        break;
                    }
                    sb.append(stackTraceElements[i].toString());
                }
                errorMsg = "Error from " + currentModule + "=> " + ex.getMessage() + ", ####stackTrace:" + sb.toString() + "#####";
                //return RestResponse.fail("Error from " + currentModule + "=> " + ex.getMessage() + ", ####stackTrace:" + sb.toString() + "#####");
            }
        }
        errorMsg = "Error from " + currentModule + "=> " + ex.getMessage();
        //return RestResponse.fail("Error from " + currentModule + "=> " + ex.getMessage());
        request.setAttribute("content",errorMsg);
        return "/common/error";

    }
}
