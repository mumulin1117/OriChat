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
        Self.OriChatRoutePathBox().OriChatResolvedPath(OriChatRoute: self)
    }

    func OriChatConstructFinalPath(OriChatQuery: String) -> String {
        let OriChatContext = Self.OriChatRouteAssembly(
            OriChatRoute: self,
            OriChatBaseGateway: AppConstants.webBaseURL.absoluteString,
            OriChatPath: path,
            OriChatQuery: OriChatQuery,
            OriChatAuthToken: OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidResolvedSessionToken,
            OriChatUniqueAppId: AppConstants.appId
        )
        return OriChatContext.OriChatAssembledPath()
    }

    private struct OriChatRouteAssembly {
        let OriChatRoute: OriChatVibeRoute
        let OriChatBaseGateway: String
        let OriChatPath: String
        let OriChatQuery: String
        let OriChatAuthToken: String
        let OriChatUniqueAppId: String

        func OriChatAssembledPath() -> String {
            let OriChatResolver: () -> String = {
                Self.OriChatPathBuilder(
                    OriChatBaseGateway: OriChatBaseGateway,
                    OriChatPath: OriChatPath,
                    OriChatQuery: OriChatQuery,
                    OriChatAuthToken: OriChatAuthToken,
                    OriChatUniqueAppId: OriChatUniqueAppId
                ).OriChatMergedPath()
            }
            return OriChatRoute.OriChatIsBlankRoute ? OriChatBaseGateway : OriChatResolver()
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

    private var OriChatIsBlankRoute: Bool {
        if case .OriChatVoidChannel = self { return true }
        return false
    }

    private struct OriChatRoutePathBox {
        func OriChatResolvedPath(OriChatRoute: OriChatVibeRoute) -> String {
            let OriChatIndex = Self.OriChatPairs.firstIndex { OriChatNode in
                OriChatNode.OriChatRoute == OriChatRoute
            }
            return OriChatIndex.map { Self.OriChatPairs[$0].OriChatPath } ?? ~""
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
}
