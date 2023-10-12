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
	@State private var hasError: Bool = false
	
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
		.navigationTitle(vm.isNewContact ? "New Contact" : "Update Contact")
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Done") {
					validateUser()
				}
			}
			
			ToolbarItem(placement: .navigationBarLeading) {
				Button("Cancel") {
					dismiss()
				}
			}
		}
		.alert("Missing items", isPresented: $hasError, actions: {}) {
			Text("It looks like your missing a Name or Phone Number")
		}
	}
}

private extension AddContactView {
	
	func validateUser() {
		
		if vm.contact.isValid {
			do {
				try vm.save()
				dismiss()
			} catch {
				print(error)
			}
			dismiss()
		} else {
			hasError = true
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
