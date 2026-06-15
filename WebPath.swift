// OriChat web route paths

enum OriChatVibeRoute: String {


    case OriChatSparkAI = "pages/AIexpert/index?"
    case OriChatGuideVault = "pages/repository/index?current="
    case OriChatGuideDetail = "pages/AromatherapyDetails/index?dynamicId="
    case OriChatMomentDetail = "pages/DynamicDetails/index?dynamicId="
   
    case OriChatPostArticle = "pages/VideoDetails/index?dynamicId="
    case OriChatPostVisual = "pages/issue/index?" // 发布动态
    case OriChatUserCore = "pages/postVideos/index?"// 发布视频
    case OriChatReportNode = "pages/homepage/index?userId=" // 他人主页  用户ID
    case OriChatAuthVerify = "pages/report/index?"// 用户举报
    case OriChatProfileModify = "pages/information/index?"// 消息列表
    
    case OriChatFollowGroup = "pages/EditData/index?"// 编辑资料
    case OriChatFanGroup = "pages/attentionList/index?type="/// 关注/粉丝列表  1关注 2 粉丝
    case OriChatBalanceVault = "pages/wallet/index?"//充值页面
    case OriChatMasterConfig = "pages/SetUp/index?"// 设置
    case OriChatLegalTerms = "pages/Agreement/index?type=1"//用户协议
    case OriChatLegalPrivacy = "pages/Agreement/index?type=2" //隐私政策
    case OriChatLegalTchat = "pages/privateChat/index?userId="//私聊 用户ID (拨打视频时增加参数 CallVideo=1 )
    case OriChatVoidChannel = ""
  
    func OriChatConstructFinalPath(OriChatQuery: String) -> String {
        let OriChatBaseGateway = AppConstants.webBaseURL.absoluteString
        
        if self != .OriChatVoidChannel {
            let OriChatAuthToken = AuthStore.shared.sessionToken ?? Network.OriChatSessionToken ?? ""
            let OriChatUniqueAppId = AppConstants.appId
            
            let OriChatMergedPath = String(
                format: "%@%@%@&token=%@&appID=%@",
                OriChatBaseGateway,
                self.rawValue,
                OriChatQuery,
                OriChatAuthToken,
                OriChatUniqueAppId
            )
            
            return OriChatMergedPath
        }
        
        return OriChatBaseGateway
    }
   

}
