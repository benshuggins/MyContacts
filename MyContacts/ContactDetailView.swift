//
//  ContactDetailView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI

struct ContactDetailView: View {
    var body: some View {
		List {
			
			Section("General") {
				
				LabeledContent {
					Text("Email Here")
				} label: {
					Text("Email")
				}
				
				LabeledContent {
					Text("Phone Number here")
				} label: {
					Text("Phone Number")
				}
				
				LabeledContent {
					Text("Birthdate here")
				} label: {
					Text("Birthday")
				}
				
			}
			
			Section("Notes") {
				Text("Notes here")
			}
		}
		.navigationTitle("Contact Detail")
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			ContactDetailView()
		}
    }
}
