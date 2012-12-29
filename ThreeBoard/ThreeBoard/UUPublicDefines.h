#ifndef UUPublicDefine_h
#define UUPublicDefine_h

//baidu statistics sdk
#define BaiduStatisticsSDK YES

//log sdk
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_INFO;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


#define UU_CUSTOM_BODY_FONT               @"FZLTHJW--GB1-0"        //方正兰亭黑
#define kCommonHighHeight       60
#define kCommonLowHeight        44
#define kCommonSectionHeight    24

#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define UU_IMAGEVIEW_BORDER_COLOR [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:0.5f]
#define UU_TEXT_BLACK         [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]
#define UU_DEVIDE_LINE_COLOR  [UIColor colorWithRed:0xda/255.0f green:0xda/255.0f blue:0xda/255.0f alpha:1.0f]
#define UU_TEXT_LIGHT_BLACK   [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f]
#define UU_BG_WHITE          [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]
#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define UU_BG_DARK_SLATE_GRAY [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]
#define UU_TEXT_GRAY  [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]
#define UU_TEXT_GRAY_MIDDLE   [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_113      [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_DARK     [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1.0f]
#define UU_SELECTED_BG_COLOR [UIColor colorWithRed:(CGFloat)0xed/255 green:(CGFloat)0xef/255 blue:(CGFloat)0xf2/255 alpha:1]


typedef enum{
    ProjectShowAreaBeijing = 0,
    ProjectShowAreaChangjiang = 1,
    ProjectShowAreaZhujiang = 2,
    ProjectShowAreaOther = 3
}ProjectShowArea;

typedef enum{
    PartnersTypePartnerEnterprise,//企业伙伴
    PartnersTypeInvestmentCompany,//投资公司
    PartnersTypeMembers,//专家会员
    PartnersTypeStrategicPartner//战略伙伴
}PartnersType;

#define kPartnersTypePartnerEnterprise @"qiyehuoban"
#define kPartnersTypeInvestmentCompany @"touzigongsi"
#define kPartnersTypeMembers @"zhuanjiahuiyuan"
#define kPartnersTypeStrategicPartner @"zhanluehuoban"

typedef enum{
    AboutSectionJinyuan = 0,
    AboutSectionTeamWeibo,
    AboutSectionContact,
    AboutSectionVersionInfo,
    ShareSettings,
    AboutSectionNumber
}AboutSection;

#define kPageTitleGoodPolicy @"利好政策"
#define kPageTitleNewInfo @"业内资讯"
#define kPageTitleActivity @"活动日历"
#define kPageTitleProjectShow @"项目展示"
#define kPageTitlePartners @"合作伙伴"
#define kPageTitleAbout @"关于我们"


//#define kBWXSinaWeiboAppKey @"2129806721"
//#define kBWXSinaWeiboAppSecret @"f28ffd032c8c4461222b315675128346"
//#define kBWXSinaWeiboRedirectUrl @"http://"
#define kBWXSinaWeiboAppKey @"1623815163"
#define kBWXSinaWeiboAppSecret @"14ecc37aef18451992187ac3cd49eeda"
#define kBWXSinaWeiboRedirectUrl @"http://"


#define kBWXTencentWeiboAppKey @"801228592"
#define kBWXTencentWeiboAppSecret @"9231f75dead5131755159329ebb23d50"
#define kBWXTencentWeiboRedirectUrl @"http://b.dlkingx.net"

#define kBWXRenrenAppKey @"209894"
#define kBWXRenrenAPIKey @"e37f5a44e1eb4e6f9694ade69fb2c862"
#define kBWXRenrenAppSecret @"7f122148de274c768e33d8085ce6ebb8"


#define kBWXQZoneAppKey @"100266567"
#define kBWXQZoneRedirectUrl @"http://www.qq.com"


#endif