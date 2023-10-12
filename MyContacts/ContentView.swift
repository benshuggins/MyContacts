//
//  ContentView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

// https://www.youtube.com/watch?v=rTXkGCg58w0&ab_channel=tundsdev

import SwiftUI
import CoreData

struct ContentView: View {
	
	//@State private var isShowingAddContact = false  // can only add
	
	@State private var contactToEdit: Contact? // this is a contact that I might want to edit
	 
	@FetchRequest(fetchRequest: Contact.all()) private var contacts // not using fetchedresults here ??? // this is a property wrapper cont
	 
	var provider = ContactsProvider.shared
	
	var body: some View {
		NavigationStack {
			ZStack {
				if contacts.isEmpty {
					EmptyContactView()
				} else {
					List {
						ForEach(contacts) { contact in
							
							ZStack(alignment: .leading) {
								NavigationLink(destination: ContactDetailView(contact: contact)) {
									EmptyView()
								}
								.opacity(0)
								
								ContactRowView(contact: contact)
									.swipeActions(allowsFullSwipe: true) {
										// DELETE
										Button(role: .destructive) {
											do {
												try delete(contact)
											} catch {
												print(error)
											}
										} label: {
											Label("Delete", systemImage: "trash")
										}
										.tint(.red)

										
										 // EDIT
										Button {
										contactToEdit = contact // current contact is the contact that we want to edit

										} label: {
											Label("Edit", systemImage: "pencil")
										}
										.tint(.orange)
								}
							}
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						contactToEdit = .empty(context: provider.newContext)
					} label: {
						Image(systemName: "plus")
							.font(.title3)
					}
				}
			}
			.sheet(item: $contactToEdit,
				   onDismiss: { contactToEdit = nil
				
			}, content: { contact in
				NavigationStack {
					AddContactView(vm: .init(provider: provider, contact: contact))  // pass provider into the view
				}
			})
			.navigationTitle("Contacts")
		}
	}
}

private extension ContentView {
	
	func delete(_ contact: Contact) throws {
		let context = provider.viewContext
		let currentContact = try context.existingObject(with: contact.objectID)
		context.delete(currentContact)
		Task(priority: .background) {  // program crashes without deletion performed on background thread 
			try await context.perform {
				try context.save()
			}
		}
		
	}
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let preview = ContactsProvider.shared
        ContentView(provider: preview)
			.environment(\.managedObjectContext, preview.viewContext)
			.previewDisplayName("Contacts with Data")
			.onAppear { Contact.makePreview(count: 10, in: preview.viewContext)
				
			}
		
			// This is a preview for when there is no data 
		let emptyPreview = ContactsProvider.shared
		ContentView(provider: preview)
			.environment(\.managedObjectContext, emptyPreview.viewContext)
			.previewDisplayName("Contacts with NO Data")
//			.onAppear { Contact.makePreview(count: 10, in: emptyPreview.viewContext)
//
//			}
    }
}
