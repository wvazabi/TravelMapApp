//
//  TravelListViewController.swift
//  TravelBook
//
//  Created by Enes Kaya on 16.07.2022.
//

import UIKit
import CoreData

class TravelListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var titlerArray = [String]()
    var idArray = [UUID]()
    var choosenTitle = ""
    var choosenTitleId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
        
    }
    
   @objc func getData() {
     
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        do {
        let results = try context.fetch(request)
           if (results.count > 0) {
               
               self.titlerArray.removeAll(keepingCapacity: false)
               self.idArray.removeAll(keepingCapacity: false)
            for result in results as! [NSManagedObject] {
                if let title = (result.value(forKey: "title") as? String){
                    self.titlerArray.append(title)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                
                tableView.reloadData()
                
            }
            }
        }catch{
            print("fail")
        }
        
    }
    
    @objc func addButtonClicked(){
        choosenTitle = ""
        performSegue(withIdentifier: "toDetailPlace", sender: nil)
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titlerArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenTitle = titlerArray[indexPath.row]
        choosenTitleId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailPlace", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPlace" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.selectedTitleID = choosenTitleId
        }
    }

}
