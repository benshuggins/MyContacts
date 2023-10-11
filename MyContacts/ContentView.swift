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
	
	@State private var isShowingAddContact = false
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
										Button(role: .destructive) {

										} label: {
											Label("Delete", systemImage: "trash")
										}
										.tint(.red)

										Button {


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
						isShowingAddContact.toggle()
					} label: {
						Image(systemName: "plus")
							.font(.title3)
					}
				}
			}
			.navigationTitle("Contacts")
			.sheet(isPresented: $isShowingAddContact) {
				NavigationStack {
					AddContactView(vm: .init(provider: provider))  // pass provider into the view
				}
				
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
