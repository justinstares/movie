//
//  FavoritesViewController.swift
//  Lab 4 Again
//
//  Created by Justin Stares on 10/18/18.
//  Copyright © 2018 Justin Stares. All rights reserved.
//

import UIKit


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var Mtitle: String!
    var myArray: [String] = []
    @IBOutlet weak var theTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel!.text = myArray[indexPath.row]
        return myCell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print(myArray[indexPath.row])
    //how to delete from database
            let thepath = Bundle.main.path(forResource: "movies", ofType: "db")
            let contactDB = FMDatabase(path: thepath)

            if !(contactDB.open()) {
                print("Unable to open database")
                return
            } else {
                do{
                    //need to pass in title through segue
                    let query = "delete from test where title=?"
                    try contactDB.executeUpdate(query, values: [myArray[indexPath.row]])
                    print("it deleted")
                    myArray.remove(at: indexPath.row)


                } catch let error as NSError {
                    print("failed \(error)")
                }
            }
            
                theTableView.reloadData()
            }
        }    
    
    func loadDatabase1() {
        print("favorites load Database")
        let thepath = Bundle.main.path(forResource: "movies", ofType: "db")
        let contactDB = FMDatabase(path: thepath)
       
        
        if !(contactDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
                let results = try contactDB.executeQuery("select distinct * from test", values: nil)
//                let results = try contactDB.executeUpdate("select * from test", withArgumentsIn: [""])
//                print(results.next())
                print("results")
                while (results.next()) {
                    let someName = results.string(forColumn: "title")
                    print("title is \(String(describing: someName!));")
                    myArray.append(someName!)
                    theTableView.reloadData()
                    print("fav made it here")

                }
            
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myArray = []
        loadDatabase1()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.theTableView.reloadData()


        theTableView.dataSource = self
        theTableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake{
           //delete everything from database
            //clear favorites
            //everything in the editing style function
        
                //how to delete from database
                let thepath = Bundle.main.path(forResource: "movies", ofType: "db")
                let contactDB = FMDatabase(path: thepath)
                
                if !(contactDB.open()) {
                    print("Unable to open database")
                    return
                } else {
                    do{
                        //need to pass in title through segue
                        let query = "delete from test"
                        try contactDB.executeUpdate(query, values: [""])
                        print("it deleted")
                        myArray = []
                        
                        
                    } catch let error as NSError {
                        print("failed \(error)")
                    }
                }
                
                theTableView.reloadData()
            }
            
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
