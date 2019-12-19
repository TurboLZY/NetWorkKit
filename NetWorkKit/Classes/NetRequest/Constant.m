//
//  Constant.m
//  FKSDK
//
//  Created by bcb on 2018/8/3.
//  Copyright © 2018年 bcb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*域名*/
#ifdef DEBUG
NSString *const kWS_ServerAddress = @"http://code.eteamlink.com:54789/";
NSString *const kWS_WebAddress = @"http://code.eteamlink.com:8087";
//NSString *const kWS_ServerAddress = @"http://code.eteamlink.com:64789/";
//NSString *const kWS_WebAddress = @"http://code.eteamlink.com:9087";
//NSString *const kWS_WebAddress = @"http://192.168.90.247:8080";
#else
NSString *const kWS_ServerAddress = @"http://code.eteamlink.com:64789/";
NSString *const kWS_WebAddress = @"http://code.eteamlink.com:9087";
#endif

//标识相关
NSString *const kWS_Platform = @"49f279abb17d454798bfc8e02d253939";
NSString *const kWS_Source = @"";
NSString *const kWS_Secret = @"ETeamLink.SCS";
NSString *const kWS_AccessToken_Default = @"eyJhbGciOiJSUzI1NiIsImtpZCI6IjA5YjM5MDE4NDM1ZjcyNmU5NDkyMzE3Y2IwZDlhMDg2IiwidHlwIjoiSldUIn0.eyJuYmYiOjE1NTg1ODE2MDksImV4cCI6MTU1ODU4ODgwOSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAxIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAxL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjdiZDdmMDk4ZThlMjQ2NDFiZjI3ZDAxMmRjNjdhZWFlIiwic3ViIjoiNjhjYWNmZDctNDE5Ny00MmRhLWJkMDktOWY4OWRmOTUxYjIyIiwiYXV0aF90aW1lIjoxNTU4NTgxNjA5LCJpZHAiOiJsb2NhbCIsImlkIjoiNjhjYWNmZDctNDE5Ny00MmRhLWJkMDktOWY4OWRmOTUxYjIyIiwibmFtZSI6Iua4uOWuoiIsIlRlbmFudElkIjoiIiwiSXNIb3N0IjoiMCIsIkVtcGxveWVlSWQiOiIiLCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImFtciI6WyJwd2QiXX0.XR2oMAWqziixrrRKLcnfGcQibPjG646WPMCDdtUs5Ctcdy6Pf6wvQcOl8m2ca3_rrpjRvzSx2GzC0Ew2S639Ec2CeeNRn1uqc5MnLU01XmHOwoUC9rWyf1vRkU1zSVPpZa-jY9k28xJrCBDTYd1KcNewy3UdNVvU4hTDeEdP_USZg_uJ5TOv9RHYAKhoiF3VNmXCMQ6076wWl5h2IxHrcf495qOdPy-T4FvXIjKCb-nacHG3PPRgv_e1XW4Y2igsMXt_yDOan9Ntb7pN4ETrkM8wBoDc9t5PLUm_aFttg6U0RBJ_VRwXnqstwrwVeem1agAiWksk9oDkmHbugjHr0A";
#pragma maek - 第三方key
/*第三方key*/
NSString *const kWS_WeChat_Key = @"wx35294819b9ba37bf";
NSString *const kWS_WeChat_SecretId = @"237aef8345ca1f4c172c33ded307b32c";
NSString *const kWS_WeChat_LoginRequestState = @"wx_loginReqState";
NSString *const kWS_UM_MobKey = @"5d809efc570df347a8000c06";// @"5d70da534ca357510c0006d8";
NSString *const kWS_BaiDu_AK = @"676KM9Bi8Oy8RLjPFl68SyH4";
NSString *const kWS_BaiDu_SK = @"Z7shNdlG5chmGiC6HA5OWCQy9aUxoeO2";
NSString *const kWS_JPUSH_AK = @"ea43e49def18d0999f1ee275";
NSString *const kWS_JPUSH_MS = @"b0c6384842c3e5163db6782a";

#pragma mark - APP Key
NSString *const APP_User_Info_Key = @"User_Info";
NSString *const APP_User_Token_Key = @"User_Token";

#pragma maek - 通知相关
/*通知相关*/
NSString *const kWS_InteriorNotification_User_NeedLogin = @"InteriorNotification_NeedLogin";
NSString *const kWS_InteriorNotification_WeChat_LoginRepSuccess = @"InteriorNotification_WeChat_LoginRepSuccess";
NSString *const kWS_InteriorNotification_Contacts_Reload = @"InteriorNotification_Contacts_Reload";
NSString *const kWS_InteriorNotification_identifed = @"InteriorNotification_identifed";
NSString *const NSNotification_ChangeInforMation = @"ChangeInforMation";
NSString *const NSNotification_ChangeInforMation_phone = @"ChangeInforMation_phone";
NSString *const kWS_InteriorNotification_AVPStop_Pause = @"AVPStop_Pause";
NSString *const kWS_InteriorNotification_StartPlay = @"StartPlay";
NSString *const kWS_InteriorNotification_AVPFinsh = @"AVPFinsh";
NSString *const kWS_InteriorNotification_PDFFinsh = @"PDFFinsh";
NSString *const kWS_InteriorNotification_CoverImage = @"CoverImage";
NSString *const kWS_InteriorNotification_UpdateEnterpriseName = @"UpdateEnterpriseName";
NSString *const kWS_InteriorNotification_CloseWebView = @"CloseWebView";
NSString *const kWS_InteriorNotification_Refresh_info = @"Refresh_info";
NSString *const kWS_InteriorNotification_ReceiveEnterpriseInviteNotice = @"ReceiveEnterpriseInviteNotice";
NSString *const KWS_CloseWebView = @"KWS_CloseWebView";
NSString *const kWS_InteriorNotification_JumpToAllTapeVC = @"JumpToAllTapeVC";
NSString *const kWS_InteriorNotification_RefrshWebView = @"RefrshWebView";
NSString *const kWS_InteriorNotification_RefrshTaskList = @"RefrshTaskList";

#pragma make - ui相关
CGFloat const kWS_LineHeightMultiple_descri = 1.5;

#pragma make - Cache
NSString *globalByDDBChche;

