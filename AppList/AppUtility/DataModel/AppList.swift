//
//  AppList.swift
//  AppList
//
//  Created by iOS on 13/01/23.
//

import Foundation

// MARK: - AppList
struct AppList: Codable {
    let feed: Feed?
}

// MARK: - Feed
struct Feed: Codable {
    let author: Author?
    let entry: [Entry]?
    let updated, rights, title, icon: Icon?
    let link: [FeedLink]?
    let id: Icon?
}

// MARK: - Author
struct Author: Codable {
    let name, uri: Icon?
}

// MARK: - Icon
struct Icon: Codable {
    let label: String?
}

// MARK: - Entry
struct Entry: Codable {
    let imName: Icon?
    let imImage: [IMImage]?
    let summary: Icon?
    let imPrice: IMPrice?
    let imContentType: IMContentType?
    let rights, title: Icon?
    let link: LinkUnion?
    let id: ID?
    let imArtist: IMArtist?
    let category: Category?
    let imReleaseDate: IMReleaseDate?

    enum CodingKeys: String, CodingKey {
        case imName = "im:name"
        case imImage = "im:image"
        case summary
        case imPrice = "im:price"
        case imContentType = "im:contentType"
        case rights, title, link, id
        case imArtist = "im:artist"
        case category
        case imReleaseDate = "im:releaseDate"
    }
}

// MARK: - Category
struct Category: Codable {
    let attributes: CategoryAttributes?
}

// MARK: - CategoryAttributes
struct CategoryAttributes: Codable {
    let imID, term: String?
    let scheme: String?
    let label: String?

    enum CodingKeys: String, CodingKey {
        case imID = "im:id"
        case term, scheme, label
    }
}

// MARK: - ID
struct ID: Codable {
    let label: String?
    let attributes: IDAttributes?
}

// MARK: - IDAttributes
struct IDAttributes: Codable {
    let imID, imBundleID: String?

    enum CodingKeys: String, CodingKey {
        case imID = "im:id"
        case imBundleID = "im:bundleID"
    }
}

// MARK: - IMArtist
struct IMArtist: Codable {
    let label: String?
    let attributes: IMArtistAttributes?
}

// MARK: - IMArtistAttributes
struct IMArtistAttributes: Codable {
    let href: String?
}

// MARK: - IMContentType
struct IMContentType: Codable {
    let attributes: IMContentTypeAttributes?
}

// MARK: - IMContentTypeAttributes
struct IMContentTypeAttributes: Codable {
    let term, label: Label?
}

enum Label: String, Codable {
    case application = "Application"
}

// MARK: - IMImage
struct IMImage: Codable {
    let label: String?
    let attributes: IMImageAttributes?
}

// MARK: - IMImageAttributes
struct IMImageAttributes: Codable {
    let height: String?
}

// MARK: - IMPrice
struct IMPrice: Codable {
    let label: String?
    let attributes: IMPriceAttributes?
}

// MARK: - IMPriceAttributes
struct IMPriceAttributes: Codable {
    let amount: String?
    let currency: Currency?
}

enum Currency: String, Codable {
    case usd = "USD"
}

// MARK: - IMReleaseDate
struct IMReleaseDate: Codable {
    let label: String?
    let attributes: Icon?
}

enum LinkUnion: Codable {
    case feedLink(FeedLink)
    case purpleLinkArray([PurpleLink])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PurpleLink].self) {
            self = .purpleLinkArray(x)
            return
        }
        if let x = try? container.decode(FeedLink.self) {
            self = .feedLink(x)
            return
        }
        throw DecodingError.typeMismatch(LinkUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LinkUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .feedLink(let x):
            try container.encode(x)
        case .purpleLinkArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - PurpleLink
struct PurpleLink: Codable {
    let attributes: PurpleAttributes?
    let imDuration: Icon?

    enum CodingKeys: String, CodingKey {
        case attributes
        case imDuration
    }
}

// MARK: - PurpleAttributes
struct PurpleAttributes: Codable {
    let rel: Rel?
    let type: TypeEnum?
    let href: String?
    let title: Title?
    let imAssetType: IMAssetType?

    enum CodingKeys: String, CodingKey {
        case rel, type, href, title
        case imAssetType
    }
}

enum IMAssetType: String, Codable {
    case preview = "preview"
}

enum Rel: String, Codable {
    case alternate = "alternate"
    case enclosure = "enclosure"
}

enum Title: String, Codable {
    case preview = "Preview"
}

enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
    case textHTML = "text/html"
}

// MARK: - FeedLink
struct FeedLink: Codable {
    let attributes: FluffyAttributes?
}

// MARK: - FluffyAttributes
struct FluffyAttributes: Codable {
    let rel: String?
    let type: TypeEnum?
    let href: String?
}
