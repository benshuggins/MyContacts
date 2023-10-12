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
	
	var viewContext: NSManagedObjectContext {    // context within current view THE MAIN CONTEXT
		persistentContainer.viewContext
	}
	// Better thread safety  THIS CONTEXT IS FOR EDITING, I MAKE CHANGES AWAY FROM THE MAIN CONTEXT 
	var newContext: NSManagedObjectContext {
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
		return context
	}
	
	//	var newContext: NSManagedObjectContext {			// this context if for editing
	//		persistentContainer.newBackgroundContext()
	//	}
	//
	
	
	private init() {
		persistentContainer = NSPersistentContainer(name: "MyContactsDataModel")
		if EnvironmentValues.isPreview {
			persistentContainer.persistentStoreDescriptions.first?.url = .init(URL(fileURLWithPath: "/dev/null")) // if we are running with previews dont persist this data, just save it to memory elsewhere
		}
		persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
		persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Unable to load peristent store with this error: \(error)")
			}
		}
	}
}

extension EnvironmentValues {
	static var isPreview: Bool {
		return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
	}
	
}
