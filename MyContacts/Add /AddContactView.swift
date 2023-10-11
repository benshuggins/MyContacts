//
//  AddContactView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI
import CoreData

struct AddContactView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@ObservedObject var vm: EditContactViewModel    //> new instance of vm
	
    var body: some View {
		List {
			
			Section("General") {
			   
				TextField("Name", text: $vm.contact.name)         // binded to vm
									.keyboardType(.namePhonePad)

				TextField("Email", text: $vm.contact.email)
					.keyboardType(.emailAddress)

				TextField("Phone Number", text: $vm.contact.phoneNumber)
					.keyboardType(.phonePad)

				DatePicker("Birthday",
						   selection: $vm.contact.dob,
						   displayedComponents: [.date])
				.datePickerStyle(.compact)
				
				Toggle("Favourite", isOn: $vm.contact.isFavorite)
				
			}
			
			Section("Notes") {
				TextField("Notes", text: $vm.contact.notes)
			}
		}
		.navigationTitle("New Contact")
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Done") {
					
					do {
						try vm.save()
						dismiss()
					} catch {
						print(error)
					}
					dismiss()
				}
			}
			
			ToolbarItem(placement: .navigationBarLeading) {
				Button("Cancel") {
					dismiss()
				}
			}
		}
	}
}


struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			let preview = ContactsProvider.shared
			
			AddContactView(vm: .init(provider: preview))
				.environment(\.managedObjectContext, preview.viewContext)
		}
    }
}
