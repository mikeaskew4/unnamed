//
//  unnamedApp.swift
//  unnamed
//
//  Created by Mike Askew on 12/12/23.
//

import SwiftUI

@main
struct unnamedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .customFont(size: 16)
                .environment(\.colorScheme, .dark) // Forces dark mode

                .onAppear {
//                    for family in UIFont.familyNames.sorted() {
//                        let names = UIFont.fontNames(forFamilyName: family)
//                        print("Family: \(family) Font names: \(names)")
//                    }
                }

        }
    }
}

struct CustomFontModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content.font(.custom("EncodeSans-CondensedThin_Regular", size: size))
    }
}

extension View {
    func customFont(size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
}
