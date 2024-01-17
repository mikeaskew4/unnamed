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
                    items[index].title,
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
                }
                .padding()
            }
        }
    }
}
