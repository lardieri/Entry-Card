//
//  Settings.swift
//  Entry Card
//

import SwiftUI

// From UIKit's readable layout guide. No official equivalent in SwiftUI.
fileprivate let maxReadableWidth: CGFloat = 672.0

struct SettingsTab: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        let requireUnlockButCheckBeforeEnabling = Binding<Bool>(
            get: {
                settings.requireUnlock
            },
            set: { userWantsToRequireUnlock in
                if userWantsToRequireUnlock {
                    LockManager.shared.requestUnlock { result in
                        if result == .succeeded {
                            settings.requireUnlock = true
                        }
                    }
                } else {
                    settings.requireUnlock = false
                }
            }
        )

        List {
            Section("Screen") {
                Toggle("Use maximum brightness", isOn: $settings.useMaximumBrightness)
            }
            .listSectionSeparator(.hidden)

            Section("Privacy") {
                Toggle("Require unlock", isOn: requireUnlockButCheckBeforeEnabling)
            }
            .listSectionSeparator(.hidden)

            Section("App icon") {
                Picker(selection: $settings.alternateIconName, label: EmptyView()) {
                    ForEach(Settings.availableIcons) { icon in
                        Image(icon.displayImageName)
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
        let settings = Settings()
        SettingsTab()
            .environmentObject(settings)
    }
}
