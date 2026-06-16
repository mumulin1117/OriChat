import Foundation

enum OriChatBuddyCategory: String, Codable, CaseIterable, Hashable {
    case nearby = "Nearby"
    case lure = "Lure"
    case sea = "Sea"
    case night = "Night"
    case fly = "Fly"
    case lake = "Lake"
}

enum OriChatBuddyTripStatus: String, Codable, Hashable {
    case recruiting
    case joined
    case full
    case waitlist
    case canceled
    case draft
}

enum OriChatBuddySort: String, CaseIterable {
    case soonest = "Soonest"
    case openSpots = "Most open spots"
    case beginner = "Beginner friendly"
    case rating = "Highest rated organizer"
}

struct OriChatBuddyFilter: Equatable {
    var skill: String?
    var status: OriChatBuddyTripStatus?
    var cost: String?
    var openOnly = false
    var nearbyFirst = false

    var isActive: Bool {
        skill != nil || status != nil || cost != nil || openOnly || nearbyFirst
    }
}

struct OriChatBuddyAngler: Codable, Hashable {
    let id: String
    var name: String
    var avatarAssetName: String
    var location: String
    var brief: String
    var rating: Double
    var pigeonRate: Double
    var trips: Int
    var isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarAssetName
        case location
        case brief
        case rating
        case pigeonRate
        case trips
        case isVerified
    }

    init(id: String, name: String, avatarAssetName: String, location: String, brief: String, rating: Double, pigeonRate: Double, trips: Int, isVerified: Bool) {
        self.id = id
        self.name = name
        self.avatarAssetName = avatarAssetName
        self.location = location
        self.brief = brief
        self.rating = rating
        self.pigeonRate = pigeonRate
        self.trips = trips
        self.isVerified = isVerified
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        avatarAssetName = try container.decode(String.self, forKey: .avatarAssetName)
        location = try container.decode(String.self, forKey: .location)
        brief = try container.decode(String.self, forKey: .brief)
        rating = try container.decode(Double.self, forKey: .rating)
        pigeonRate = try container.decodeIfPresent(Double.self, forKey: .pigeonRate) ?? max(1, 8 - rating)
        trips = try container.decode(Int.self, forKey: .trips)
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
    }
}

struct OriChatBuddyTrip: Codable, Hashable {
    let id: String
    var title: String
    var category: OriChatBuddyCategory
    var status: OriChatBuddyTripStatus
    var coverAssetName: String
    var dateText: String
    var startTimeText: String
    var endTimeText: String
    var locationTitle: String
    var locationSubtitle: String
    var distanceText: String
    var distanceValue: Double
    var startDate: Date
    var createdAt: Date
    var capacity: Int
    var attendeeIds: [String]
    var waitlistIds: [String]
    var costTitle: String
    var costSubtitle: String
    var targetFish: String
    var skillText: String
    var gearNote: String
    var aboutText: String
    var goodToKnow: [String]
    var tags: [String]
    var organizer: OriChatBuddyAngler
    var attendees: [OriChatBuddyAngler]
    var isSaved: Bool
    var isHidden: Bool
    var isReported: Bool
    var isCreatedByCurrentUser: Bool
    var cancelReason: String?
    var canceledAt: Date?
    var isCarpoolAvailable: Bool
    var opensTemporaryChat: Bool
    var verifiedOnly: Bool
    var applicantIds: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category
        case status
        case coverAssetName
        case dateText
        case startTimeText
        case endTimeText
        case locationTitle
        case locationSubtitle
        case distanceText
        case distanceValue
        case startDate
        case createdAt
        case capacity
        case attendeeIds
        case waitlistIds
        case costTitle
        case costSubtitle
        case targetFish
        case skillText
        case gearNote
        case aboutText
        case goodToKnow
        case tags
        case organizer
        case attendees
        case isSaved
        case isHidden
        case isReported
        case isCreatedByCurrentUser
        case cancelReason
        case canceledAt
        case isCarpoolAvailable
        case opensTemporaryChat
        case verifiedOnly
        case applicantIds
    }

    init(id: String,
         title: String,
         category: OriChatBuddyCategory,
         status: OriChatBuddyTripStatus,
         coverAssetName: String,
         dateText: String,
         startTimeText: String,
         endTimeText: String,
         locationTitle: String,
         locationSubtitle: String,
         distanceText: String,
         distanceValue: Double,
         startDate: Date,
         createdAt: Date,
         capacity: Int,
         attendeeIds: [String],
         waitlistIds: [String],
         costTitle: String,
         costSubtitle: String,
         targetFish: String,
         skillText: String,
         gearNote: String,
         aboutText: String,
         goodToKnow: [String],
         tags: [String],
         organizer: OriChatBuddyAngler,
         attendees: [OriChatBuddyAngler],
         isSaved: Bool,
         isHidden: Bool,
         isReported: Bool,
         isCreatedByCurrentUser: Bool = false,
         cancelReason: String? = nil,
         canceledAt: Date? = nil,
         isCarpoolAvailable: Bool = true,
         opensTemporaryChat: Bool = true,
         verifiedOnly: Bool = false,
         applicantIds: [String] = []) {
        self.id = id
        self.title = title
        self.category = category
        self.status = status
        self.coverAssetName = coverAssetName
        self.dateText = dateText
        self.startTimeText = startTimeText
        self.endTimeText = endTimeText
        self.locationTitle = locationTitle
        self.locationSubtitle = locationSubtitle
        self.distanceText = distanceText
        self.distanceValue = distanceValue
        self.startDate = startDate
        self.createdAt = createdAt
        self.capacity = capacity
        self.attendeeIds = attendeeIds
        self.waitlistIds = waitlistIds
        self.costTitle = costTitle
        self.costSubtitle = costSubtitle
        self.targetFish = targetFish
        self.skillText = skillText
        self.gearNote = gearNote
        self.aboutText = aboutText
        self.goodToKnow = goodToKnow
        self.tags = tags
        self.organizer = organizer
        self.attendees = attendees
        self.isSaved = isSaved
        self.isHidden = isHidden
        self.isReported = isReported
        self.isCreatedByCurrentUser = isCreatedByCurrentUser
        self.cancelReason = cancelReason
        self.canceledAt = canceledAt
        self.isCarpoolAvailable = isCarpoolAvailable
        self.opensTemporaryChat = opensTemporaryChat
        self.verifiedOnly = verifiedOnly
        self.applicantIds = applicantIds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(OriChatBuddyCategory.self, forKey: .category)
        status = try container.decode(OriChatBuddyTripStatus.self, forKey: .status)
        coverAssetName = try container.decode(String.self, forKey: .coverAssetName)
        dateText = try container.decode(String.self, forKey: .dateText)
        startTimeText = try container.decode(String.self, forKey: .startTimeText)
        endTimeText = try container.decode(String.self, forKey: .endTimeText)
        locationTitle = try container.decode(String.self, forKey: .locationTitle)
        locationSubtitle = try container.decode(String.self, forKey: .locationSubtitle)
        distanceText = try container.decode(String.self, forKey: .distanceText)
        distanceValue = try container.decode(Double.self, forKey: .distanceValue)
        startDate = try container.decodeIfPresent(Date.self, forKey: .startDate) ?? Date(timeIntervalSince1970: 1_718_000_000)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? startDate.addingTimeInterval(-86_400)
        capacity = try container.decode(Int.self, forKey: .capacity)
        attendeeIds = try container.decode([String].self, forKey: .attendeeIds)
        waitlistIds = try container.decode([String].self, forKey: .waitlistIds)
        costTitle = try container.decode(String.self, forKey: .costTitle)
        costSubtitle = try container.decode(String.self, forKey: .costSubtitle)
        targetFish = try container.decode(String.self, forKey: .targetFish)
        skillText = try container.decode(String.self, forKey: .skillText)
        gearNote = try container.decode(String.self, forKey: .gearNote)
        aboutText = try container.decode(String.self, forKey: .aboutText)
        goodToKnow = try container.decode([String].self, forKey: .goodToKnow)
        tags = try container.decode([String].self, forKey: .tags)
        organizer = try container.decode(OriChatBuddyAngler.self, forKey: .organizer)
        attendees = try container.decode([OriChatBuddyAngler].self, forKey: .attendees)
        isSaved = try container.decode(Bool.self, forKey: .isSaved)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        isReported = try container.decode(Bool.self, forKey: .isReported)
        isCreatedByCurrentUser = try container.decodeIfPresent(Bool.self, forKey: .isCreatedByCurrentUser) ?? (organizer.id == OriChatBuddyFixtureForge.currentAngler.id)
        cancelReason = try container.decodeIfPresent(String.self, forKey: .cancelReason)
        canceledAt = try container.decodeIfPresent(Date.self, forKey: .canceledAt)
        isCarpoolAvailable = try container.decodeIfPresent(Bool.self, forKey: .isCarpoolAvailable) ?? tags.contains("Carpool")
        opensTemporaryChat = try container.decodeIfPresent(Bool.self, forKey: .opensTemporaryChat) ?? true
        verifiedOnly = try container.decodeIfPresent(Bool.self, forKey: .verifiedOnly) ?? false
        applicantIds = try container.decodeIfPresent([String].self, forKey: .applicantIds) ?? []
    }

    var joinedCount: Int { attendeeIds.count }
    var openSpots: Int { max(0, capacity - joinedCount) }
    var isFull: Bool { openSpots == 0 }

    func contains(_ text: String) -> Bool {
        let haystack = ([title, locationTitle, locationSubtitle, targetFish, category.rawValue, organizer.name, aboutText] + tags).joined(separator: " ").lowercased()
        return haystack.contains(text.lowercased())
    }
}
