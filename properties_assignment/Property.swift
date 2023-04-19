import Foundation

struct PropertiesContainer: Codable {
    let items: [Property]
}

struct Property: Codable, Identifiable {
    let type: PropertyType
    let id: String
    let askingPrice: Double?
    let municipality: String?
    let area: String
    let daysSincePublish: Int?
    let livingArea: Int?
    let numberOfRooms: Int?
    let streetAddress: String?
    let ratingFormatted: String?
    let image: URL
    let description: String?
    let patio: Bool?
}

enum PropertyType: String, Codable {
    case highlightedProperty = "HighlightedProperty"
    case property = "Property"
    case area = "Area"
}
