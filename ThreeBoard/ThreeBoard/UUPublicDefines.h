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
#define UU_SELECTED_BLUE      [UIColor colorWithRed:39/255.0f green:156/255.0f blue:231/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_MIDDLE   [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_113      [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_DARK     [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1.0f]

typedef enum{
    ProjectShowAreaBeijing = 0,
    ProjectShowAreaChangjiang = 1,
    ProjectShowAreaZhujiang = 2,
    ProjectShowAreaOther = 3
}ProjectShowArea;

typedef enum{
    AboutSectionJinyuan = 0,
    AboutSectionTeamWeibo,
    AboutSectionContact,
    AboutSectionVersionInfo,
    AboutSectionNumber
}AboutSection;

#define kPageTitleGoodPolicy @"利好政策"
#define kPageTitleNewInfo @"业内资讯"
#define kPageTitleActivity @"活动日历"
#define kPageTitleProjectShow @"项目展示"
#define kPageTitlePartners @"合作伙伴"
#define kPageTitleAbout @"关于我们"




#endif