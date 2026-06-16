import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = ColorResource(name: "AccentColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "oriangler_auth_fishing_sunset_background" asset catalog image resource.
    static let orianglerAuthFishingSunsetBackground = ImageResource(name: "oriangler_auth_fishing_sunset_background", bundle: resourceBundle)

    /// The "oriangler_auth_login_fish_decoration" asset catalog image resource.
    static let orianglerAuthLoginFishDecoration = ImageResource(name: "oriangler_auth_login_fish_decoration", bundle: resourceBundle)

    /// The "oriangler_auth_terms_check_active" asset catalog image resource.
    static let orianglerAuthTermsCheckActive = ImageResource(name: "oriangler_auth_terms_check_active", bundle: resourceBundle)

    /// The "oriangler_auth_terms_check_idle" asset catalog image resource.
    static let orianglerAuthTermsCheckIdle = ImageResource(name: "oriangler_auth_terms_check_idle", bundle: resourceBundle)

    /// The "oriangler_brand_app_logo" asset catalog image resource.
    static let orianglerBrandAppLogo = ImageResource(name: "oriangler_brand_app_logo", bundle: resourceBundle)

    /// The "oriangler_brand_mark" asset catalog image resource.
    static let orianglerBrandMark = ImageResource(name: "oriangler_brand_mark", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_ava" asset catalog image resource.
    static let orianglerBuddyAvatarAva = ImageResource(name: "oriangler_buddy_avatar_ava", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_callie" asset catalog image resource.
    static let orianglerBuddyAvatarCallie = ImageResource(name: "oriangler_buddy_avatar_callie", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_current" asset catalog image resource.
    static let orianglerBuddyAvatarCurrent = ImageResource(name: "oriangler_buddy_avatar_current", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_finn" asset catalog image resource.
    static let orianglerBuddyAvatarFinn = ImageResource(name: "oriangler_buddy_avatar_finn", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_01" asset catalog image resource.
    static let orianglerBuddyAvatarGuest01 = ImageResource(name: "oriangler_buddy_avatar_guest_01", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_02" asset catalog image resource.
    static let orianglerBuddyAvatarGuest02 = ImageResource(name: "oriangler_buddy_avatar_guest_02", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_03" asset catalog image resource.
    static let orianglerBuddyAvatarGuest03 = ImageResource(name: "oriangler_buddy_avatar_guest_03", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_04" asset catalog image resource.
    static let orianglerBuddyAvatarGuest04 = ImageResource(name: "oriangler_buddy_avatar_guest_04", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_05" asset catalog image resource.
    static let orianglerBuddyAvatarGuest05 = ImageResource(name: "oriangler_buddy_avatar_guest_05", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_06" asset catalog image resource.
    static let orianglerBuddyAvatarGuest06 = ImageResource(name: "oriangler_buddy_avatar_guest_06", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_guest_07" asset catalog image resource.
    static let orianglerBuddyAvatarGuest07 = ImageResource(name: "oriangler_buddy_avatar_guest_07", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_leo" asset catalog image resource.
    static let orianglerBuddyAvatarLeo = ImageResource(name: "oriangler_buddy_avatar_leo", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_lizzie" asset catalog image resource.
    static let orianglerBuddyAvatarLizzie = ImageResource(name: "oriangler_buddy_avatar_lizzie", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_mason" asset catalog image resource.
    static let orianglerBuddyAvatarMason = ImageResource(name: "oriangler_buddy_avatar_mason", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_noah" asset catalog image resource.
    static let orianglerBuddyAvatarNoah = ImageResource(name: "oriangler_buddy_avatar_noah", bundle: resourceBundle)

    /// The "oriangler_buddy_avatar_river" asset catalog image resource.
    static let orianglerBuddyAvatarRiver = ImageResource(name: "oriangler_buddy_avatar_river", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_blue_lake" asset catalog image resource.
    static let orianglerBuddyCoverBlueLake = ImageResource(name: "oriangler_buddy_cover_blue_lake", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_cannon_rocks" asset catalog image resource.
    static let orianglerBuddyCoverCannonRocks = ImageResource(name: "oriangler_buddy_cover_cannon_rocks", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_dock_morning" asset catalog image resource.
    static let orianglerBuddyCoverDockMorning = ImageResource(name: "oriangler_buddy_cover_dock_morning", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_harbor_trout" asset catalog image resource.
    static let orianglerBuddyCoverHarborTrout = ImageResource(name: "oriangler_buddy_cover_harbor_trout", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_lakeside_lure" asset catalog image resource.
    static let orianglerBuddyCoverLakesideLure = ImageResource(name: "oriangler_buddy_cover_lakeside_lure", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_pier_crew" asset catalog image resource.
    static let orianglerBuddyCoverPierCrew = ImageResource(name: "oriangler_buddy_cover_pier_crew", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_pine_night" asset catalog image resource.
    static let orianglerBuddyCoverPineNight = ImageResource(name: "oriangler_buddy_cover_pine_night", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_river_bass" asset catalog image resource.
    static let orianglerBuddyCoverRiverBass = ImageResource(name: "oriangler_buddy_cover_river_bass", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_tide_scout" asset catalog image resource.
    static let orianglerBuddyCoverTideScout = ImageResource(name: "oriangler_buddy_cover_tide_scout", bundle: resourceBundle)

    /// The "oriangler_buddy_cover_willow_sunset" asset catalog image resource.
    static let orianglerBuddyCoverWillowSunset = ImageResource(name: "oriangler_buddy_cover_willow_sunset", bundle: resourceBundle)

    /// The "oriangler_home_brand_wordmark" asset catalog image resource.
    static let orianglerHomeBrandWordmark = ImageResource(name: "oriangler_home_brand_wordmark", bundle: resourceBundle)

    /// The "oriangler_home_card_arrow" asset catalog image resource.
    static let orianglerHomeCardArrow = ImageResource(name: "oriangler_home_card_arrow", bundle: resourceBundle)

    /// The "oriangler_home_notification_button" asset catalog image resource.
    static let orianglerHomeNotificationButton = ImageResource(name: "oriangler_home_notification_button", bundle: resourceBundle)

    /// The "oriangler_profile_wallet_gem" asset catalog image resource.
    static let orianglerProfileWalletGem = ImageResource(name: "oriangler_profile_wallet_gem", bundle: resourceBundle)

    /// The "oriangler_tab_buddy_active" asset catalog image resource.
    static let orianglerTabBuddyActive = ImageResource(name: "oriangler_tab_buddy_active", bundle: resourceBundle)

    /// The "oriangler_tab_buddy_idle" asset catalog image resource.
    static let orianglerTabBuddyIdle = ImageResource(name: "oriangler_tab_buddy_idle", bundle: resourceBundle)

    /// The "oriangler_tab_home_active" asset catalog image resource.
    static let orianglerTabHomeActive = ImageResource(name: "oriangler_tab_home_active", bundle: resourceBundle)

    /// The "oriangler_tab_home_idle" asset catalog image resource.
    static let orianglerTabHomeIdle = ImageResource(name: "oriangler_tab_home_idle", bundle: resourceBundle)

    /// The "oriangler_tab_profile_active" asset catalog image resource.
    static let orianglerTabProfileActive = ImageResource(name: "oriangler_tab_profile_active", bundle: resourceBundle)

    /// The "oriangler_tab_profile_idle" asset catalog image resource.
    static let orianglerTabProfileIdle = ImageResource(name: "oriangler_tab_profile_idle", bundle: resourceBundle)

    /// The "oriangler_tab_video_active" asset catalog image resource.
    static let orianglerTabVideoActive = ImageResource(name: "oriangler_tab_video_active", bundle: resourceBundle)

    /// The "oriangler_tab_video_idle" asset catalog image resource.
    static let orianglerTabVideoIdle = ImageResource(name: "oriangler_tab_video_idle", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif