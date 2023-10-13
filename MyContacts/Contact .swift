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
	
	var isBirthday: Bool {
		Calendar.current.isDateInToday(dob)
	}
	
	var isValid: Bool {
		!name.isEmpty &&
		!phoneNumber.isEmpty
	}
	
	var formattedName: String {
		"\(isBirthday ? "🎈" : "")\(name)"
	}
	
	override func awakeFromInsert() {
		super.awakeFromInsert()
		setPrimitiveValue(Date.now, forKey: "dob")
		setPrimitiveValue(false, forKey: "isFavorite")
	}
}

extension Contact {
	
	private static var contactsFetchRequest: NSFetchRequest<Contact> {
		NSFetchRequest(entityName: "Contact")
	}
	
	// this way I can call from here
	static func all() -> NSFetchRequest<Contact> {							// fetches all of the contacts
		let request: NSFetchRequest<Contact> = contactsFetchRequest
		request.sortDescriptors = [NSSortDescriptor(keyPath: \Contact.name, ascending: true)]
		return request
	}
	
	static func filter(with config: SearchConfig) -> NSPredicate {
		switch config.filter {
			case .all:
				return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
				
				// If the query is empty return all results that have isFav checked, else return all favorites with the correct name and isFav checked
			case .fave:
				return config.query.isEmpty ? NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) :
				NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
		}
	}
}
// This is to create previews this is all dummy data
extension Contact {
	
	@discardableResult
	static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
		var contacts = [Contact]()
		for i in 0..<count {
			let contact = Contact(context: context)
			contact.name = "item \(i)"
			contact.email = "test_\(i)@mail.com"
			contact.isFavorite = Bool.random()
			contact.phoneNumber = "0700000000\(i)"
			contact.dob = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now
			contact.notes = "This is a preview for item \(i)"
			contacts.append(contact)
		}
		return contacts
	}
		// this is to get a single contact
	static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
		return makePreview(count: 1, in: context)[0]
	}
	
	// This is for an empty contact without any data entered // This allows us to run DUMMY DATA Inside XCODE == IT is stupid that we have to do this
	static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
		return Contact(context: context)
	}
}
