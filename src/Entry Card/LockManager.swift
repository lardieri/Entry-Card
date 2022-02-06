//
//  LockManager.swift
//  Entry Card
//

import UIKit
import LocalAuthentication

class LockManager {

    enum UnlockResult {
        case succeeded
        case failed
    }

    public static let shared = LockManager()

    func requestUnlock(completion: @escaping (UnlockResult) -> Void) {
        let queue = OperationQueue.current!

        guard context.canEvaluatePolicy(policy, error: nil) else {
            queue.addOperation {
                completion(.failed)
            }

            return
        }

        context.evaluatePolicy(policy, localizedReason: Self.reason) {
            success, authenticationError in

            queue.addOperation {
                if success {
                    completion(.succeeded)
                } else {
                    completion(.failed)
                }
            }
        }
    }

    var available: Bool {
        return context.canEvaluatePolicy(policy, error: nil)
    }

    // Yes, crash if we can't find it. That way we know if we're missing the FaceID string, even when we test on a TouchID device.
    private static let reason = Bundle.main.object(forInfoDictionaryKey: "NSFaceIDUsageDescription") as! String

    private let policy = LAPolicy.deviceOwnerAuthentication
    private var context = LAContext()

}


