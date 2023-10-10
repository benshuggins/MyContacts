//
//  Contact .swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import Foundation
import CoreData
import SwiftUI

final class Contact: NSManagedObject, Identifiable {
	
	@NSManaged var dob: Date
	@NSManaged var name: String
	@NSManaged var notes: String
	@NSManaged var phoneNumber: String
	@NSManaged var email: String
	@NSManaged var isFavorite: Bool
	
	override func awakeFromInsert() {
		super.awakeFromInsert()
		setPrimitiveValue(Date.now, forKey: "dob")
		setPrimitiveValue(false, forKey: "isFavorite")
	}
	
	
}
