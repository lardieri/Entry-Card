//
//  SettingsViewController.swift
//  Entry Card
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var brightnessSwitch: UISwitch!

    private let borderViewTag = 314159
    private let borderColor = UIColor(named: Colors.tableViewBorder)

    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSwitch.setOn(AppSettings.useMaximumBrightness, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard view.viewWithTag(borderViewTag) == nil else { return }

        let borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.tag = borderViewTag
        borderView.backgroundColor = borderColor

        let borderThickness = (traitCollection.userInterfaceStyle == .light ? (1.0  / tableView.window!.screen.scale ) : 1.0)

        view.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: borderThickness),
        ])
    }

    @IBAction func brightnessChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        if AppSettings.useMaximumBrightness != sender.isOn {
            AppSettings.useMaximumBrightness = sender.isOn
        }
    }

}
