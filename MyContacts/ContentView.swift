//
//  ContentView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI
import CoreData

struct SearchConfig: Equatable {
	enum Filter {
		case all, fave
	}

	var query: String = ""
	var filter: Filter = .all
	var sort: Sort = .ascending
}

enum Sort {
	case ascending, descending
}


struct ContentView: View {
	
	//@State private var isShowingAddContact = false  // can only add, cant update
	
	@State private var contactToEdit: Contact? // this is a contact that I might want to edit
	@FetchRequest(fetchRequest: Contact.all()) private var contacts // not using fetchedresults here ??? // this is a property wrapper cont
	
	// we are actually changing this contacts fetchRequest when we filter and sort using functions in the contact model
	
	@State private var searchConfig: SearchConfig = .init()
	@State private var sort: Sort = .ascending
	
//	var filteredContacts: [Contact] {
//		guard !filteredContacts.isEmpty else { return contacts }
//		return contacts.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
//	}
	 
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
			.searchable(text: $searchConfig.query)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						contactToEdit = .empty(context: provider.newContext)
					} label: {
						Image(systemName: "plus")
							.font(.title3)
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					
					Menu {
						Section {
							Text("Filter")
							Picker(selection: $searchConfig.filter) {
								
								Text("All").tag(SearchConfig.Filter.all)
								Text("Faves").tag(SearchConfig.Filter.fave)
								
							} label: {
								Text("Filter Favorites")
							}
						}
						
						Section {
							Text("Sort")
							Picker(selection: $sort) {
								
								Text("A to Z").tag(Sort.ascending)
								Text("Z to A").tag(Sort.descending)
								
							} label: {
								Text("Sort")
							}
						}
					} label: {
						Image(systemName: "ellipsis")
							.symbolVariant(.circle)
							.font(.title3)
					}
				}
			}
			.sheet(item: $contactToEdit, onDismiss: { contactToEdit = nil
			
		}, content: { contact in
				NavigationStack {
					AddContactView(vm: .init(provider: provider, contact: contact))  // pass provider into the view
				}
			})
			.navigationTitle("Customers")
			.onChange(of: searchConfig) { newConfig in
				contacts.nsPredicate = Contact.filter(with: newConfig)
			}
			.onChange(of: sort) { newSort in
				contacts.nsSortDescriptors = Contact.sort(order: newSort)
			}
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
