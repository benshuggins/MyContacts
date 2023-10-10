//
//  ContactsProvider.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import Foundation
import CoreData
import SwiftUI

final class ContactsProvider {
	
	static let shared = ContactsProvider()
	
	private let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {    // context within current view
		persistentContainer.viewContext
	}
	
	private init() {
		
		persistentContainer = NSPersistentContainer(name: "MyContactsDataModel")
		persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
		persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Unable to load peristent store with this error: \(error)")
			}
		}
		
		
	}
}
