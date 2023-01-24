//
//  Third Party Credits.swift
//  Entry Card
//

import SwiftUI

struct ThirdPartyCredits: View {
    var body: some View {
        VStack {
            ThirdParty_BrightnessToggle()
            ThirdParty_UIViewBorders()
            ThirdParty_UIBarButtonItem()
        }
    }
}

struct ThirdPartyCredits_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPartyCredits()
    }
}
