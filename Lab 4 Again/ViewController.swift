//
//  ViewController.swift
//  Lab 4 Again
//
//  Created by Justin Stares on 10/17/18.
//  Copyright © 2018 Justin Stares. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{

    @IBOutlet weak var thePickerView: UIPickerView!
    @IBOutlet weak var theSpinner: UIActivityIndicatorView!
    @IBOutlet weak var theSearchBar: UISearchBar!
    
    //var theData:[APIResults] = []
    var theData:[Movie] = []
    var theImageCache: [UIImage] = []
    var search: String = ""
    let datasource = ["English", "Japanese", "German", "Adult Movies"]
    var rowSelected: Int = 0
    var adult: Bool = false

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowSelected = row
        adult = false
        if (rowSelected == 3){
            let confirm = UIAlertController(title: "Restricted", message: "Enter the phrase adult to continue", preferredStyle: UIAlertControllerStyle.alert)
            
            confirm.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Input here:"
            })
            let textfield = confirm.textFields?.first
            textfield?.keyboardType = .numberPad
            textfield?.delegate = self as? UITextFieldDelegate
            confirm.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (action) in
                self.adult = false
                

            }))
            confirm.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { (action) in
                
                if (textfield?.text == "adult"){
                    let ac = UIAlertController(title: "Sucess!", message: "You are a adult and have access to adult movies" , preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                    self.present(ac, animated:true, completion:nil)
                    self.adult = true;
                }
                else{

                    let ac = UIAlertController(title: "FAILURE!", message: "You are not an adult" , preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                    self.present(ac, animated:true, completion:nil)
                    self.adult = false;

                }

            }))
            
            self.present(confirm, animated: true) {
                
            }
            
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return text.characters.count <= 2018 // Your limit
    }
    
    func searchBarSearchButtonClicked(_ theSearchBar: UISearchBar) {

        search = theSearchBar.text!
        //this code is designed to handle when your string has spaces and change it to plus example "Jack Reacher" as a string needs to be Jack+Reacher for Query
        //got this from stack: https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
        search = search.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        
        theSpinner.startAnimating()
        theData = []
        theImageCache = []
        self.theCollectionView.reloadData()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForCollectionView(string: self.search)
            self.cacheImage()
        
        DispatchQueue.main.async {
            self.theCollectionView.reloadData()
            self.theSpinner.stopAnimating()
        }
    }
    }
    
    var endpoint: String!

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellOG = theCollectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        let cell = cellOG as! CustomCell

        cell.MovieTitle.text = theData[indexPath.row].title
        cell.MoviePoster.image = theImageCache[indexPath.row]
    
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.imageName = theData[indexPath.row].title
        detailedVC.releaseDate = theData[indexPath.row].release_date
        detailedVC.overView = theData[indexPath.row].overview
        detailedVC.title = theData[indexPath.row].title
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
   
    func setupCollectionView() {
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        //theCollectionView.register(UICollectionViewCell.self, forCellReuseIdentifier: "mycell")
    }
    func setupSearchBar() {
        theSearchBar.delegate = self
        theSearchBar.returnKeyType = UIReturnKeyType.done
    }
    func setupPickerView() {
        thePickerView.delegate = self
        thePickerView.dataSource = self
    }
    
   
    
    func fetchDataForCollectionView(string: String) {
        //let apiKey = "955c0447e3525b2bd10268796f919296"
        theData = []
        theImageCache = []

        if string == ""{
        return
        }
        
        let apiKey = "d9a8b63640a1656054de2afa192c6aa4"
        
        var url = URL(string: " ")
        if (rowSelected == 0){
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key="+apiKey+"&include_adult=false&query=" + string)
        }
        if (rowSelected == 1){
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key="+apiKey+"&language=ja-US&page=1&query=" + string)
        }
        if (rowSelected == 2){
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key="+apiKey+"&language=de-US&page=1&include_adult=false&query=" + string)
        }
        if (rowSelected == 3){
            if(adult == true){
            url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key="+apiKey+"&language=en-US&page=1&include_adult=true&query=" + string)
            }
            else{
            return
            }
        }

            let data = try! Data(contentsOf: url!)
            let decodeData = try! JSONDecoder().decode(APIResults.self, from: data)
//          print(decodeData.results[0])
        
            for randomMovie in decodeData.results {
                theData.append(randomMovie)
            }
        
       //print("the data is \(theData[0])")
    }
        
    
//used general idea from Piazza
        func cacheImage(){

            for item in theData{
                if item.poster_path != nil {
                    let urlImage = URL(string: "https://image.tmdb.org/t/p/w185/" + item.poster_path!)
                    do{
                        let data = try? Data(contentsOf: urlImage!)
                        let image = UIImage(data:data!) // error here
                        theImageCache.append(image!)
                        
                    }
                } else {
                    
                    theImageCache.append(#imageLiteral(resourceName: "noimage"))

                }
            }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        setupSearchBar()
        setupPickerView()
        theSpinner.hidesWhenStopped = true
        theSpinner.center = self.view.center
           //self.search
            self.fetchDataForCollectionView(string: search)
            self.cacheImage()
            self.theCollectionView.reloadData()
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var theCollectionView: UICollectionView!
    
}

