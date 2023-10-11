//
//  ContactRowView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI

struct ContactRowView: View {
	
	@Environment(\.managedObjectContext) private var moc
	
	@ObservedObject var contact: Contact     // @observedObject this is here because contact is a class and we want to use it inside an innerview and have the data update				// this was sent in 
	
    var body: some View {
		VStack(alignment: .leading,
			   spacing: 8) {
			
			Text(contact.formattedName)
				.font(.system(size: 26, design: .rounded).bold())
			
			Text(contact.email)
				.font(.callout.bold())
			
			Text(contact.phoneNumber)
				.font(.callout.bold())
			
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.overlay(alignment: .topTrailing) {
			Button {
				toggleFave()
			} label: {
				Image(systemName: "star")
					.font(.title3)
					.symbolVariant(.fill)
					.foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
			}
			.buttonStyle(.plain)
		}
    }
}

extension ContactRowView {
	
	func toggleFave() {
		contact.isFavorite.toggle()
		do {
			if moc.hasChanges {
				try moc.save()
			}
			
		} catch {
				print(error)
		}
	}
	
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
		ContactRowView(contact: .preview())
    }
}
