//
//  Settings.swift
//  Entry Card
//

import SwiftUI

// From UIKit's readable layout guide. No official equivalent in SwiftUI.
fileprivate let maxReadableWidth: CGFloat = 672.0

fileprivate struct Icon: Identifiable {
    let imageName: String
    let assetName: String?
    var id: String? { assetName }
}

fileprivate let appIcons: [Icon] = [
    Icon(imageName: "Icon - default", assetName: nil),
    Icon(imageName: "Icon - gray", assetName: "AppIcon-VelvetRopeGray"),
    Icon(imageName: "Icon - vax", assetName: "AppIcon-VaxCard"),
    Icon(imageName: "Icon - vip", assetName: "AppIcon-VIP"),
]

struct SettingsTab: View {
    @EnvironmentObject var settings: Settings
    @State private var iconAssetName = appIcons.last!.assetName

    var body: some View {
        List {
            Section("Screen") {
                Toggle("Use maximum brightness", isOn: $settings.useMaximumBrightness)
            }
            .listSectionSeparator(.hidden)

            Section("Privacy") {
                Toggle("Require unlock", isOn: $settings.requireUnlock)
            }
            .listSectionSeparator(.hidden)

            Section("App icon") {
                Picker(selection: $iconAssetName, label: EmptyView()) {
                    ForEach(appIcons) { icon in
                        Image(icon.imageName)
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .pickerStyle(.segmented)
                .frame(height: 100)
            }
            .listSectionSeparator(.hidden)
        }
        .listStyle(.inset)
        .frame(maxWidth: maxReadableWidth, alignment: .center)
    }
}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
    }
}
