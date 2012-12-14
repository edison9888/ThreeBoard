#ifndef UUPublicDefine_h
#define UUPublicDefine_h

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_INFO;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


#define UU_CUSTOM_BODY_FONT               @"FZLTHJW--GB1-0"        //方正兰亭黑

typedef enum{
    ProjectShowAreaBeijing = 0,
    ProjectShowAreaChangjiang = 1,
    ProjectShowAreaZhujiang = 2,
    ProjectShowAreaOther = 3
}ProjectShowArea;


#endif