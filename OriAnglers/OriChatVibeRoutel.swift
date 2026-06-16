enum OriChatVibeRoute {


    case OriChatSparkAI
    case OriChatGuideVault
    case OriChatGuideDetail
    case OriChatMomentDetail
   
    case OriChatPostArticle
    case OriChatPostVisual
    case OriChatUserCore
    case OriChatReportNode
    case OriChatAuthVerify
    case OriChatProfileModify
    
    case OriChatFollowGroup
    case OriChatFanGroup
    case OriChatBalanceVault
    case OriChatMasterConfig
    case OriChatLegalTerms
    case OriChatLegalPrivacy
    case OriChatLegalTchat
    case OriChatVoidChannel

    private var path: String {
        Self.OriChatRoutePathBox(OriChatRoute: self).OriChatResolvedPath
    }
  
    func OriChatConstructFinalPath(OriChatQuery: String) -> String {
        let OriChatBuilder = Self.OriChatPathBuilder(
            OriChatBaseGateway: AppConstants.webBaseURL.absoluteString,
            OriChatPath: path,
            OriChatQuery: OriChatQuery,
            OriChatAuthToken: OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidResolvedSessionToken,
            OriChatUniqueAppId: AppConstants.appId
        )
        switch self {
        case .OriChatVoidChannel:
            return OriChatBuilder.OriChatBaseGateway
        default:
            return OriChatBuilder.OriChatMergedPath()
        }
    }
   
    private struct OriChatRoutePathBox {
        let OriChatRoute: OriChatVibeRoute

        var OriChatResolvedPath: String {
            let OriChatPair = Self.OriChatPairs.first { $0.OriChatRoute == OriChatRoute }
            return OriChatPair?.OriChatPath ?? ~""
        }

        private static let OriChatPairs: [(OriChatRoute: OriChatVibeRoute, OriChatPath: String)] = [
            (.OriChatSparkAI, ~"pEDatAgHCeQHszl/DNAlpIBwekGxCSpYLeuarJZtrO/ZdiornkVdPdeaPxlA?bc"),
            (.OriChatGuideVault, ~"poUawuguheSossJ/NwrdNerUpZNoirsKZiPYtTUotprNFyBo/AQiitnqAdcjewOxuP?tycbSuOirCsrlVemLnYotWw=Kh"),
            (.OriChatGuideDetail, ~"pEqaPrgoBewNsia/IkAMqrruokKmBvabJtIDhrpeymrMAaAIpiwyssDlTeCutCvahgiunlNWsdH/FyiaDnmidfiehBxXX?NjdpoycJnzraLdmFMimJcjBIUfdhy=Ic"),
            (.OriChatMomentDetail, ~"pjyacngKdekIsRo/vLDGfyZRnqxatXmjziWAcIADfzeWBtxdaLmihklJFsrX/RBieHnfpdfoelDxwe?mXdEYyuUnuYaLhmXpisecMKIVcdDi=wj"),
            (.OriChatPostArticle, ~"puyaiTgqIeePsdI/ZiVDOimDdBJeWIoBTDnfePetXLalNiKQliBsty/MnizRncNdXGenCxes?qxdwEygVnPZaOAmpAibpcPZIAUdnj=Rb"),
            (.OriChatPostVisual, ~"pRVaAugmwebnsoq/kRirNsensXPulYeiN/jIifJnGMdeoeoTxcb?no"),
            (.OriChatUserCore, ~"pCXaSJgCgeobsmQ/EvpQhozEsRetAcVRJiLtdeuewsoOosPi/RRiFfnbCdlHeAlxJs?hz"),
            (.OriChatReportNode, ~"pDFaGUgxNevyswv/DuhuvoogmkhelkpKLaRMgfkexK/tTiQRnuhdRheSnxmk?ebuVpsFtetirJfImhdWP=Oo"),
            (.OriChatAuthVerify, ~"pDOaRygPheSAsoU/yOrZeeBlpTEoHqrOitSn/dSirCnVxdIXexexMC?sD"),
            (.OriChatProfileModify, ~"pSsaLBgbceeksup/yxiZrnnsfDZovTrCFmMZaiDtJUizNoZfnjD/CaikrnzXdZKeEzxiB?zy"),
            (.OriChatFollowGroup, ~"pQtaREgYRebksMa/OREtxdkHiGvtAgDREasAtVPaHB/gdivCnHoduneBTxzZ?OW"),
            (.OriChatFanGroup, ~"pbkafTgFIehHsDG/XeaxHtxztEAeZInbMtVZijkoWqnEjLZIitsspVtXh/mciIDnbodhHehOxGe?RKtOlyglpMteRG=Wm"),
            (.OriChatBalanceVault, ~"pveaIjgjgeTSsmq/pSwjGahllmolfseAWtNh/kViuGnQsddNedVxSg?AR"),
            (.OriChatMasterConfig, ~"pDgaPegchesusga/DUSVgerWtXBUPgpOT/nKiAqnHZdyueTzxrw?LN"),
            (.OriChatLegalTerms, ~"pUqaohghMeetsjN/juAUsgTyrQseoOeIEmXUeTNnmBtSI/gDiIJnZrdhbeUixMK?EotCayOJpcueFF=VJ1mQ"),
            (.OriChatLegalPrivacy, ~"plSaMvgyzezjsHa/ZGAwpgOUrXQeNoeKImIceqhnRrtKU/kDisvngZdQleGgxNr?FwtLHyPfpkoeEt=rr2Fv"),
            (.OriChatLegalTchat, ~"piQacBgzxeOgsmW/UJpzNrtVivovxDaZutbTeekCoHheeaiOteV/MYiWunewdpvetjxTi?IyufasVbeDIrjqIZedYb=cc"),
            (.OriChatVoidChannel, ~"")
        ]
    }

    private struct OriChatPathBuilder {
        let OriChatBaseGateway: String
        let OriChatPath: String
        let OriChatQuery: String
        let OriChatAuthToken: String
        let OriChatUniqueAppId: String

        func OriChatMergedPath() -> String {
            String(
                format: ~"%qC@JH%Wo@YD%VX@ie&OgtwvoOBkaLeXynVY=nX%id@hb&BPaugpdmpFrISiDcF=HD%Tr@Gf",
                OriChatBaseGateway,
                OriChatPath,
                OriChatQuery,
                OriChatAuthToken,
                OriChatUniqueAppId
            )
        }
    }

}
