//
//  HViewController.swift
//  FBSnapshotTestCase
//
//  Created by RJ on 2018/11/16.
//

import UIKit

public class HViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
