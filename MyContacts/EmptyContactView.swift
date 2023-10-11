//
//  EmptyContactView.swift
//  MyContacts
//
//  Created by Ben Huggins on 10/10/23.
//

import SwiftUI

struct EmptyContactView: View {
    var body: some View {
		VStack {
			Text("📭 No Contacts")
				.font(.largeTitle.bold())
			Text("Add some Contacts, tap plus button")
				.font(.callout)
		}
    }
}

struct EmptyContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyContactView()
    }
}
