//
//  ContentView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@State private var isShowingAddContact = false
	@FetchRequest(fetchRequest: Contact.all()) private var contacts // not using fetchedresults here ??? // this is a property wrapper cont
	 
	var provider = ContactsProvider.shared
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(contacts) { contact in
					
					ZStack(alignment: .leading) {
						NavigationLink(destination: ContactDetailView(contact: contact)) {
							EmptyView()
						}
						.opacity(0)
						
						ContactRowView(contact: contact)  
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
