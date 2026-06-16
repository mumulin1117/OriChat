import Foundation

enum OriChatBuddyFixtureForge {
    static let currentAngler = OriChatBuddyAngler(
        id: "orichat-current-angler",
        name: "You",
        avatarAssetName: AppAsset.buddyAvatarCurrent,
        location: "Portland",
        brief: "Weekend angler looking for kind, reliable trip mates.",
        rating: 4.9,
        pigeonRate: 2,
        trips: 12,
        isVerified: true
    )

    static func trips() -> [OriChatBuddyTrip] {
        let anglers = [
            angler("leo", "Leo", "Portland", "Bass guide with spare rods.", 4.8, 41),
            angler("lizzie", "Lizzie", "Cannon Beach", "Sea fishing regular and tide watcher.", 4.9, 33),
            angler("mason", "Mason", "Blue Lake", "Patient host for first-time anglers.", 4.7, 28),
            angler("noah", "Noah", "Pine Dock", "Night fly fan with safety-first plans.", 4.6, 19),
            angler("ava", "Ava", "Harbor West", "Pier fishing organizer and gear sharer.", 4.9, 37),
            angler("river", "River", "Willow Creek", "River bass scout.", 4.8, 24),
            angler("callie", "Callie", "Lakeside", "Lure testing buddy.", 4.7, 22),
            angler("finn", "Finn", "North Pier", "Easygoing weekend crew lead.", 4.6, 18)
        ]
        return [
            trip("buddy-001", "Saturday lure trip at Lakeside", .lure, anglers[0], 2, 4, "Sun · Jun 9", "7:30 AM", "10:30 AM", "Lake View Pier", "Meet by the west dock", "3.8 km away", 3.8, "AA", "Split bait and gas", "Bass", "Beginner friendly", ["Beginner", "Gear share", "Lure"], false),
            trip("buddy-002", "Dawn sea fishing off Cannon rocks", .sea, anglers[1], 3, 4, "Sat · Jun 15", "5:50 AM", "9:20 AM", "Cannon Beach rocks", "South trail entrance", "18 km away", 18, "AA", "Share parking", "Rockfish", "Experienced only", ["Sea", "Tide check", "AA"], false),
            trip("buddy-003", "Beginner bass morning — gear shared", .lake, anglers[2], 1, 4, "Sun · Jun 16", "7:30 AM", "10:30 AM", "Blue Lake Park dock", "Meet at Park entrance", "9.1 km away", 9.1, "Free", "Carpool available", "Bass", "Beginner friendly", ["Beginner", "Gear share", "Free", "Carpool"], false),
            trip("buddy-004", "Night fly session near Pine Dock", .night, anglers[3], 4, 4, "Fri · Jun 21", "8:30 PM", "11:00 PM", "Pine River Bend", "Bring headlamp", "11 km away", 11, "Free", "Bring your flies", "Trout", "Experienced only", ["Night", "Fly", "Safety"], false),
            trip("buddy-005", "Calm lake trout practice", .lake, anglers[4], 2, 5, "Sat · Jun 22", "8:00 AM", "11:30 AM", "Harbor West Pier", "Coffee stand meetup", "6.4 km away", 6.4, "Free", "Snacks welcome", "Trout", "Beginner friendly", ["Lake", "Practice", "Free"], false),
            trip("buddy-006", "Weekend pier fishing crew", .sea, anglers[5], 5, 5, "Sun · Jun 23", "6:40 AM", "10:00 AM", "Harbor West Pier", "North rail", "7.2 km away", 7.2, "AA", "Split bait", "Perch", "Beginner friendly", ["Sea", "Pier", "AA"], false),
            trip("buddy-007", "Sunset lure testing group", .lure, anglers[6], 2, 4, "Thu · Jun 27", "6:00 PM", "8:30 PM", "Willow Creek Entry", "Gravel lot", "4.2 km away", 4.2, "Free", "Bring two lures", "Bass", "Beginner friendly", ["Lure", "Sunset", "Bass"], false),
            trip("buddy-008", "Early river bass run", .fly, anglers[7], 3, 4, "Sat · Jun 29", "6:10 AM", "9:00 AM", "Pine River Bend", "East bridge", "12 km away", 12, "AA", "Carpool if needed", "Bass", "Experienced only", ["Fly", "River", "AA"], false)
        ]
    }

    private static func angler(_ id: String, _ name: String, _ location: String, _ brief: String, _ rating: Double, _ trips: Int) -> OriChatBuddyAngler {
        OriChatBuddyAngler(id: id, name: name, avatarAssetName: avatarAsset(for: id), location: location, brief: brief, rating: rating, pigeonRate: max(1, 9 - rating), trips: trips, isVerified: true)
    }

    private static func trip(_ id: String, _ title: String, _ category: OriChatBuddyCategory, _ organizer: OriChatBuddyAngler, _ joined: Int, _ capacity: Int, _ date: String, _ start: String, _ end: String, _ location: String, _ subtitle: String, _ distanceText: String, _ distance: Double, _ cost: String, _ costSubtitle: String, _ target: String, _ skill: String, _ tags: [String], _ saved: Bool) -> OriChatBuddyTrip {
        let attendees = Array(([organizer] + [currentAngler]).prefix(joined))
        return OriChatBuddyTrip(
            id: id,
            title: title,
            category: category,
            status: joined >= capacity ? .full : .recruiting,
            coverAssetName: coverAsset(for: id),
            dateText: date,
            startTimeText: start,
            endTimeText: end,
            locationTitle: location,
            locationSubtitle: subtitle,
            distanceText: distanceText,
            distanceValue: distance,
            startDate: dateValue(for: id),
            createdAt: dateValue(for: id).addingTimeInterval(-Double(abs(id.hashValue % 9) + 1) * 86_400),
            capacity: capacity,
            attendeeIds: attendees.map(\.id),
            waitlistIds: [],
            costTitle: cost,
            costSubtitle: costSubtitle,
            targetFish: target,
            skillText: skill,
            gearNote: "Bring water, a hat, and a small tackle box.",
            aboutText: "A relaxed local fishing plan for anglers who want a reliable buddy and a simple route. We keep the trip friendly, clear, and on time.",
            goodToKnow: ["19°C · Sunny", "Ask the organizer if rods are provided."],
            tags: tags,
            organizer: organizer,
            attendees: attendees,
            isSaved: saved,
            isHidden: false,
            isReported: false
        )
    }

    private static func dateValue(for id: String) -> Date {
        let day = Double(abs(id.hashValue % 21))
        return Date(timeIntervalSince1970: 1_718_000_000 + day * 86_400)
    }

    private static func avatarAsset(for id: String) -> String {
        switch id {
        case "leo": return AppAsset.buddyAvatarLeo
        case "lizzie": return AppAsset.buddyAvatarLizzie
        case "mason": return AppAsset.buddyAvatarMason
        case "noah": return AppAsset.buddyAvatarNoah
        case "ava": return AppAsset.buddyAvatarAva
        case "river": return AppAsset.buddyAvatarRiver
        case "callie": return AppAsset.buddyAvatarCallie
        case "finn": return AppAsset.buddyAvatarFinn
        default: return AppAsset.buddyAvatarGuest01
        }
    }

    private static func coverAsset(for id: String) -> String {
        switch id {
        case "buddy-001": return AppAsset.buddyCoverLakesideLure
        case "buddy-002": return AppAsset.buddyCoverCannonRocks
        case "buddy-003": return AppAsset.buddyCoverBlueLake
        case "buddy-004": return AppAsset.buddyCoverPineNight
        case "buddy-005": return AppAsset.buddyCoverHarborTrout
        case "buddy-006": return AppAsset.buddyCoverPierCrew
        case "buddy-007": return AppAsset.buddyCoverWillowSunset
        case "buddy-008": return AppAsset.buddyCoverRiverBass
        default: return AppAsset.buddyCoverDockMorning
        }
    }
}
