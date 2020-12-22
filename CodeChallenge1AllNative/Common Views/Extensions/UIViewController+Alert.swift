//
//  UIViewController+Alert.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 23/12/20.
//

import UIKit

extension UIViewController {
    
    public func presentAlert(title: String?, message: String) {
      let errorAlertController = UIAlertController(title: title,
                                                   message: message,
                                                   preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default)
      errorAlertController.addAction(okAction)
      present(errorAlertController, animated: true, completion: nil)
    }
}
