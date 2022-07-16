//
//  TravelListViewController.swift
//  TravelBook
//
//  Created by Enes Kaya on 16.07.2022.
//

import UIKit

class TravelListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedPlace = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addbutton(_ sender: Any) {
        selectedPlace = ""
        performSegue(withIdentifier: "toDetailPlace", sender: nil)
    }
    
    
    

}
