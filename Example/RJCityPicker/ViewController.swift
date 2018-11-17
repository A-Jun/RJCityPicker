//
//  ViewController.swift
//  RJCityPicker
//
//  Created by A-Jun on 11/17/2018.
//  Copyright (c) 2018 A-Jun. All rights reserved.
//

import UIKit
import RJCityPicker
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = RJCityPickerViewController()
        vc.city { (city) in
            print(city)
        }
        self.present(vc, animated: true, completion: nil)
    }
}

