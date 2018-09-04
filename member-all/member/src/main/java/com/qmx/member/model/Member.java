package com.qmx.member.model;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableName;
import com.qmx.base.core.base.BaseModel;
import com.qmx.member.api.enumerate.MemberSex;
import com.qmx.member.api.enumerate.MemberSource;
import com.qmx.member.api.enumerate.MemberState;

import java.util.Date;

@TableName("member")
public class Member extends BaseModel {
    /**
     * 所属人id
     */
    @TableField("member_id")
    private Long memberId;
    /**
     * 供应商id
     */
    @TableField("supplier_id")
    private Long supplierId;
    /**
     * 集团供应商id
     */
    @TableField("group_supplier_id")
    private Long groupSupplierId;

    /**
     * 会员卡号（实体卡ID）
     */
    @TableField("car_no")
    private String cardNo;
    /**
     * 卡面号码（虚拟卡号码）
     */
    @TableField("card_number")
    private String cardNumber;
    /**
     * 会员姓名
     */
    @TableField("name")
    private String name;
    /**
     * 昵称
     */
    @TableField("nickname")
    private String nickName;
    /**
     * 会员手机号码
     */
    @TableField("mobile")
    private String mobile;
    /**
     * 会员身份证
     */
    @TableField("idcard")
    private String idcard;
    /**
     * 会员性别
     */
    @TableField("sex")
    private MemberSex sex;
    /**
     * 会员生日
     */
    @TableField("birthday")
    private Date birthday;
    /**
     * 会员来源
     */
    @TableField("source")
    private MemberSource source;
    /**
     * 会员等级
     */
    @TableField("level_id")
    private Long levelId;
    /**
     * 会员等级名称
     */
    @TableField("level_name")
    private String levelName;
    /**
     * 会员状态
     */
    @TableField("state")
    private MemberState state;
    /**
     * 过期时间
     */
    @TableField("past_time")
    private Date pastTime;
    /**
     * 当前积分
     */
    @TableField("integral")
    private Double integral;
    /**
     * 总积分
     */
    @TableField("total_integral")
    private Double totalIntegral;
    /**
     * 积分明细ID
     */
    @TableField("integral_id")
    private Long integralId;
    /**
     * 充值消费明细ID
     */
    @TableField("money_id")
    private Long moneyId;
    /**
     * 金额
     */
    @TableField("money")
    private Double money;
    /**
     * 国籍
     */
    @TableField("countries")
    private String countries;
    /**
     * 名族
     */
    @TableField("ethnic")
    private String ethnic;
    /**
     * 籍贯
     */
    @TableField("origin")
    private String origin;
    /**
     * 工作单位
     */
    @TableField("work_unit")
    private String workUnit;
    /**
     * 省--简码(详细地址)
     */
    @TableField("province")
    private String province;
    /**
     *市--简码(详细地址)
     */
    @TableField("city")
    private String city;
    /**
     * 区--简码(详细地址)
     */
    @TableField("county")
    private String county;
    /**
     * 详细地址
     */
    @TableField("address")
    private String address;
    /**
     * 头像图片地址
     */
    @TableField("image")
    private String image;
    /**
     * 客户经理id
     */
    @TableField("user_id")
    private String userId;
    /**
     * 客户经理名字
     */
    @TableField("user_name")
    private String userName;
    /**
     * 微信openId
     */
    @TableField("wx_open_id")
    private String openid;

    public Member() {
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public Double getTotalIntegral() {
        return totalIntegral;
    }

    public void setTotalIntegral(Double totalIntegral) {
        this.totalIntegral = totalIntegral;
    }

    public Long getIntegralId() {
        return integralId;
    }

    public void setIntegralId(Long integralId) {
        this.integralId = integralId;
    }

    public Long getMoneyId() {
        return moneyId;
    }

    public void setMoneyId(Long moneyId) {
        this.moneyId = moneyId;
    }

    public String getCountries() {
        return countries;
    }

    public void setCountries(String countries) {
        this.countries = countries;
    }

    public String getEthnic() {
        return ethnic;
    }

    public void setEthnic(String ethnic) {
        this.ethnic = ethnic;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getWorkUnit() {
        return workUnit;
    }

    public void setWorkUnit(String workUnit) {
        this.workUnit = workUnit;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCounty() {
        return county;
    }

    public void setCounty(String county) {
        this.county = county;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getOpenid() {
        return openid;
    }

    public void setOpenid(String openid) {
        this.openid = openid;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public Long getGroupSupplierId() {
        return groupSupplierId;
    }

    public void setGroupSupplierId(Long groupSupplierId) {
        this.groupSupplierId = groupSupplierId;
    }

    public String getCardNo() {
        return cardNo;
    }

    public void setCardNo(String cardNo) {
        this.cardNo = cardNo;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getIdcard() {
        return idcard;
    }

    public void setIdcard(String idcard) {
        this.idcard = idcard;
    }

    public MemberSex getSex() {
        return sex;
    }

    public void setSex(MemberSex sex) {
        this.sex = sex;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public MemberSource getSource() {
        return source;
    }

    public void setSource(MemberSource source) {
        this.source = source;
    }

    public Long getLevelId() {
        return levelId;
    }

    public void setLevelId(Long levelId) {
        this.levelId = levelId;
    }

    public MemberState getState() {
        return state;
    }

    public void setState(MemberState state) {
        this.state = state;
    }

    public Date getPastTime() {
        return pastTime;
    }

    public void setPastTime(Date pastTime) {
        this.pastTime = pastTime;
    }

    public Double getIntegral() {
        return integral;
    }

    public void setIntegral(Double integral) {
        this.integral = integral;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }
}
