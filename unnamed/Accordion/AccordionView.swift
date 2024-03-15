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
    @Binding var isInteractingWithComponent: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                                .padding(0)
                                .frame(maxWidth: .infinity)
                        }
                    } label: {
                        Text(items[index].title)
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .disclosureGroupStyle(CustomDisclosureGroupStyle(button: Text("OK")))
                }
            }
            .padding(0)
            .frame(maxWidth: .infinity)
        }
        .scrollDisabled(isInteractingWithComponent)
    }
}

struct CustomDisclosureGroupStyle<Label: View>: DisclosureGroupStyle {
    let button: Label
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Text("△")
                .fontWeight(.bold)
                .rotationEffect(.degrees(configuration.isExpanded ? 0 : 180))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                configuration.isExpanded.toggle()
            }
        }
        if configuration.isExpanded {
            configuration.content
                .disclosureGroupStyle(self)
        }
    }
}

#Preview {
    ContentView()
}
