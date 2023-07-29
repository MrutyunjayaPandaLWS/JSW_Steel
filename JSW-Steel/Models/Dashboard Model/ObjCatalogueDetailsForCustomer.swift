
import Foundation
struct ObjCatalogueDetailsForCustomer : Codable {
	let catalogueId : Int?
	let pointsRequired : Int?
	let pointsBalance : Int?
	let pointsRequiredToRedeem : Int?
	let redemptionType : Int?
	let catalogueName : String?
	let catalogueImage : String?

	enum CodingKeys: String, CodingKey {

		case catalogueId = "catalogueId"
		case pointsRequired = "pointsRequired"
		case pointsBalance = "pointsBalance"
		case pointsRequiredToRedeem = "pointsRequiredToRedeem"
		case redemptionType = "redemptionType"
		case catalogueName = "catalogueName"
		case catalogueImage = "catalogueImage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		catalogueId = try values.decodeIfPresent(Int.self, forKey: .catalogueId)
		pointsRequired = try values.decodeIfPresent(Int.self, forKey: .pointsRequired)
		pointsBalance = try values.decodeIfPresent(Int.self, forKey: .pointsBalance)
		pointsRequiredToRedeem = try values.decodeIfPresent(Int.self, forKey: .pointsRequiredToRedeem)
		redemptionType = try values.decodeIfPresent(Int.self, forKey: .redemptionType)
		catalogueName = try values.decodeIfPresent(String.self, forKey: .catalogueName)
		catalogueImage = try values.decodeIfPresent(String.self, forKey: .catalogueImage)
	}

}
