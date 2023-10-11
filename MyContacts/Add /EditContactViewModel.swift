//
//  EditContactViewModel.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import Foundation
import CoreData

final class EditContactViewModel: ObservableObject {
	
	@Published var contact: Contact  // @published allows updated changes
	
	private let context: NSManagedObjectContext    // this is a separate context away from the main context that can be committed if we want to keep said changes
	
	init(provider: ContactsProvider, contact: Contact? = nil) {  // if contact object doesn't exist then create a new one 
		self.context = provider.newContext
		self.contact = Contact(context: self.context)
	}
	
	func save() throws {
		if context.hasChanges {    // are there any uncommitted changes?, prevents unnecessary commits
			try context.save()
		}
		
	}
	
}
