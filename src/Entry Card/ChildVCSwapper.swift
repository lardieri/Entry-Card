//
//  ChildVCSwapper.swift
//  Entry Card
//

import UIKit

protocol HasStoryboardID: UIViewController {

    static var storyboardID: String { get }

}


extension UIViewController {

    private static let fadeTime = 0.5

    func show<New, Old> (new storedNew: inout New?, replacing storedOld: inout Old?) where New: HasStoryboardID, Old: UIViewController {
        assert(storedNew == nil, "Existing view controller found while starting transition to same view controller.")

        let new = (storyboard!.instantiateViewController(withIdentifier: New.storyboardID) as! New)
        addChild(new)
        new.view.frame = view.bounds

        if let old = storedOld {
            old.willMove(toParent: nil)
            transition(from: old, to: new, duration: Self.fadeTime, options: .transitionCrossDissolve, animations: nil) { finished in
                old.removeFromParent()
                new.didMove(toParent: self)
            }
        } else {
            self.view.addSubview(new.view)
            new.didMove(toParent: self)
        }

        storedNew = new
        storedOld = nil
    }

}
