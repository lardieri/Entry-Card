//
//  SettingsHostViewController.swift
//  Entry Card
//

import UIKit
import SwiftUI

class SettingsHostViewController: UIHostingController<SettingsHost> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsHost())
    }

}
