//
//  DetailedViewController.swift
//  Lab 4 Again
//
//  Created by Justin Stares on 10/17/18.
//  Copyright © 2018 Justin Stares. All rights reserved.
//

import UIKit
import SQLite3

class DetailedViewController: UIViewController {
    var image: UIImage!
    var imageName: String!
    var releaseDate: String!
    var overView: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: 80, width: image.size.width, height: image.size.height)
        
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        let theTextFrame = CGRect(x: 0, y: image.size.height + 80, width: view.frame.width, height: 30  )
        let textView = UILabel(frame: theTextFrame)
        textView.text = imageName
        textView.textAlignment = .center
        
        let theReleaseFrame = CGRect(x: 0, y: image.size.height + 110, width: view.frame.width, height: 30  )
        let releaseView = UILabel(frame: theReleaseFrame)
        releaseView.text = releaseDate
        releaseView.textAlignment = .center
        
        let theOverviewFrame = CGRect(x: 0, y: image.size.height + 140, width: view.frame.width, height: 100  )
        let overviewView = UITextView(frame: theOverviewFrame)
        overviewView.isEditable = false
        overviewView.text = overView
        overviewView.textAlignment = .center
        //overviewView.numberOfLines = 8
        
        
//        let theButtonFrame = CGRect(x: 0, y: image.size.height + 170, width: view.frame.width, height: 30  )
//        let buttonView = UIButton(frame: theButtonFrame)
//        buttonView.backgroundColor = UIColor.gray
//        buttonView.setTitle("add", for: [])
//        buttonView.setTitleColor(UIColor.cyan, for: [])
//        buttonView.addTarget(self, action: Selector(("Action:")), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(buttonView)
        
        
        //got this from stack and made little edits
        //https://stackoverflow.com/questions/24030348/how-to-create-a-button-programmatically/40139569
        let theButtonFrame = CGRect(x: 0, y: image.size.height + 240, width: view.frame.width, height: 30  )
        let buttonView = UIButton(frame: theButtonFrame)
        buttonView.backgroundColor = UIColor.gray
        buttonView.setTitle("Add to Favorites", for: .normal)
        buttonView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(buttonView)
        
        
        
        view.addSubview(overviewView)
        view.addSubview(releaseView)
        view.addSubview(textView)
        view.addSubview(imageView)
        // Do any additional setup after loading the view.
        
        
        //database stuff
//        let thepath = Bundle.main.path(forResource: "movies", ofType: "db")
//        let contactDB = FMDatabase(path: thepath)
        
        
    }
    
    //got this from stack
    //https://stackoverflow.com/questions/24030348/how-to-create-a-button-programmatically/40139569
    @objc func buttonAction(sender: UIButton!) {
        loadDatabase()
        //found this on stack
        let ac = UIAlertController(title: "Added!", message: "This movie has been added to your favorites." , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
        present(ac, animated:true, completion:nil)

//        let favVC = FavoritesViewController()
//        self.navigationController?.pushViewController(favVC, animated: true)
//        favVC.Mtitle = imageName

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDatabase() {
        print("Detailed load Database")
        let thepath = Bundle.main.path(forResource: "movies", ofType: "db")
        let contactDB = FMDatabase(path: thepath)

        
        if !(contactDB.open()) {
            print("Unable to open database")
            return
        } else {
            do{
            
//            let insertSQL = "INSERT INTO favorite (title) VALUES ('\(imageName!)')"
//            let results = contactDB.executeUpdate(insertSQL, withArgumentsIn: [""])
                try contactDB.executeUpdate("create table if not exists test(title text)", values: nil)
                try contactDB.executeUpdate("insert into test (title) values (?)", values: ["\(imageName!)"])
                print("detail made it here")
                

            } catch let error as NSError {
                print("failed \(error)")
            }
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
