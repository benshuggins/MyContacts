//
//  ContentView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI

struct ContentView: View {
	
	@State private var isShowingAddContact = false
	
	var provider = ContactsProvider.shared
	
	var body: some View {
		NavigationStack {
			List {
				ForEach((0...10), id: \.self) { item in
					
					ZStack(alignment: .leading) {
						NavigationLink(destination: ContactDetailView()) {
							
							EmptyView()
						}
						.opacity(0)
						
						ContactRowView()
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
        ContentView()
    }
}
