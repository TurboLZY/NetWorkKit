//
//  Constant.h
//  FKSDK
//
//  Created by bcb on 2018/8/3.
//  Copyright © 2018年 bcb. All rights reserved.
//
/*======================= 常量 =======================*/

/*域名*/
extern NSString *const kWS_ServerAddress;
extern NSString *const kWS_WebAddress;

extern NSString *const kWS_Platform;
extern NSString *const kWS_Source;
extern NSString *const kWS_Secret;
extern NSString *const kWS_AccessToken_Default;

#pragma mark - 第三方Key
extern NSString *const kWS_WeChat_Key;
extern NSString *const kWS_WeChat_SecretId;
extern NSString *const kWS_WeChat_LoginRequestState;
extern NSString *const kWS_UM_MobKey;
extern NSString *const kWS_BaiDu_AK;
extern NSString *const kWS_BaiDu_SK;
extern NSString *const kWS_JPUSH_AK;
extern NSString *const kWS_JPUSH_MS;

#pragma mark - APP Key
extern NSString *const APP_User_Info_Key;
extern NSString *const APP_User_Token_Key;


#pragma make - 枚举相关
typedef NS_ENUM(NSInteger, SWEnum_ThirdPartyLoginType) {//第三方登录类型
    WechatType                      = 1,//微信登录
};

typedef NS_ENUM(NSInteger, SWEnum_TissueAddRequestType) {//获取加入申请列表种类
    TeamAddRequestType              = 0,//队伍加入申请列表
    CompanyAddRequestType           = 1,//公司加入申请列表
    PartnerAddRequestType           = 2,//伙伴加入申请列表
};

typedef NS_ENUM(NSInteger, SWEnum_PartnerType) {//获取加入申请列表种类
    CompanyPartnerType              = 1,//企业合作伙伴
    TeamPartnerType                 = 2,//队伍合作伙伴
    PersonalPartnerType             = 3,//个人合作伙伴
};


#pragma mark - 全局通知
//-----------------------------全局通知---------------------------
extern NSString *const kWS_InteriorNotification_User_NeedLogin;
extern NSString *const kWS_InteriorNotification_WeChat_LoginRepSuccess;
extern NSString *const kWS_InteriorNotification_Contacts_Reload;
extern NSString *const kWS_InteriorNotification_identifed;//完成认证
extern NSString *const kWS_InteriorNotification_AVPStop_Pause;//停止或暂停
extern NSString *const kWS_InteriorNotification_AVPFinsh;//
extern NSString *const kWS_InteriorNotification_StartPlay;//开始播放
extern NSString *const kWS_InteriorNotification_PDFFinsh;//PDF文件浏览完成
extern NSString *const kWS_InteriorNotification_CoverImage;
extern NSString *const NSNotification_ChangeInforMation;
extern NSString *const NSNotification_ChangeInforMation_phone;
extern NSString *const kWS_InteriorNotification_UpdateEnterpriseName;
extern NSString *const kWS_InteriorNotification_CloseWebView;
extern NSString *const kWS_InteriorNotification_ReceiveEnterpriseInviteNotice;
extern NSString *const kWS_InteriorNotification_JumpToAllTapeVC;
extern NSString *const kWS_InteriorNotification_RefrshWebView;
extern NSString *const kWS_InteriorNotification_RefrshTaskList;
extern NSString *const KWS_CloseWebView;


#pragma mark - UI相关
extern CGFloat const kWS_LineHeightMultiple_descri;//描述行间距

#pragma mark - Cache
extern NSString *globalByDDBChche;
