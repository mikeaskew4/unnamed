//
//  AccordionView.swift
//  unnamed
//
//  Created by Mike Askew on 1/17/24.
//

import Foundation
import SwiftUI

struct AccordionItem: Identifiable {
    let id = UUID()
    var title: String
    var isExpanded: Bool = false
}

struct AccordionView: View {
    @Binding var items: [AccordionItem]
    let contentForItem: (Int) -> AnyView
    @Binding var expandedItemIndex: Int?

    var body: some View {
        VStack {
            ForEach(items.indices, id: \.self) { index in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedItemIndex == index },
                        set: { isExpanded in
                            if isExpanded {
                                expandedItemIndex = index
                            } else {
                                expandedItemIndex = nil
                            }
                        }
                    )
                ) {
                    if expandedItemIndex == index {
                        contentForItem(index)
                    }
                } label: {
//                    HStack {
                        Text(items[index].title)
                            .textCase(.uppercase)
                            .font(.headline) // Customize font here
                            .foregroundColor(.white) // Customize text color here

//                        Spacer()
//                        Image(systemName: expandedItemIndex == index ? "chevron.up" : "chevron.down") // Custom caret
//                            .foregroundColor(.white)
//                    }
                }
                .padding()
                // Add additional styling to the DisclosureGroup if needed
            }
        }
    }
}
