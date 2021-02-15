//
//  ViewControllerSearch.swift
//  Dictionary
//
//  Created by Laurentia Audrey on 14/02/21.
//  Copyright © 2021 Laurentia Audrey. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerSearch: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrRandomWord = ["apple", "pint pot", "gold", "yolk", "universe", "owl", "tiger", "novel", "minion", "straw"]
    var arrDefinitionList: [DictionaryWord] = []
    let BASE_URL = "https://owlbot.info/"
    @IBOutlet weak var txtInput: UITextField!
    
    @IBAction func btnSearch(_ sender: UIButton) {
        let input = txtInput.text!
        if(input.count < 3) {
            alertMe(message: "Please type at least 3 characters.")
        }
        else {
            let wordQuery = input.replacingOccurrences(of: " ", with: "%20")
            requestData(word: wordQuery)
        }
    }
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var lblWord: UILabel!
    @IBAction func btnAddFavorite(_ sender: UIButton) {
        addToFavorite()
    }
    @IBOutlet weak var tvWordDetail: UITableView!
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        generateRandomWord()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomWord()
        tvWordDetail.dataSource = self
        tvWordDetail.delegate = self
        tvWordDetail.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func alertMe(message:String) -> Void {
        let alertOn = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertOn.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertOn, animated: true, completion: nil)
    }
    
    func addToFavorite() {
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let favWord = FavoriteWord(context: context)
        favWord.wordName = arrDefinitionList[0].wordName
        do {
            context.insert(favWord)
            try context.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    func generateRandomWord() {
        let chosen = arrRandomWord.randomElement()
        lblWord.text = chosen!
        print(chosen!)
        let wordQuery = chosen?.replacingOccurrences(of: " ", with: "%20")
        requestData(word: wordQuery!)
    }
    
    func requestData(word: String) {
        arrDefinitionList.removeAll()
        let urlString = "\(BASE_URL)api/v4/dictionary/\(word)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Token aa356066e62d5f18ee86d0eb4e3a2eb19a96532f"
, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(data, response, error) in
            if(error != nil) {
                print("Something wrong! \(String(describing: error?.localizedDescription))")
                return
            }
            do {
                if let responseObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                    let wordName = responseObj["word"] as! String
                    let wordDefinitionArray = responseObj["definitions"] as! [[String:Any]]
                    var wordType = ""
                    var wordDefinition = ""
                    var wordImageURL = ""
                    var wordImage:UIImage? = nil
                    for result in wordDefinitionArray {
                        wordType = result["type"] as! String
                        wordDefinition = result["definition"] as! String
                        wordImageURL = result["image_url"] as? String ?? ""
                        if let imgURL = URL(string: wordImageURL) {
                            do {
                                let data = try Data(contentsOf: imgURL)
                                wordImage = UIImage(data: data)
                            }
                            catch let error {
                                print(error.localizedDescription)
                            }
                        }
                        self.arrDefinitionList.append(DictionaryWord(wordName: wordName, wordType: wordType, wordDesc: wordDefinition, wordImgURL: wordImageURL, wordImg: wordImage))
                    }
                    DispatchQueue.main.async {
                        self.lblWord.text = wordName
                        self.tvWordDetail.reloadData()
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        self.alertMe(message: "No definition :(")
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDefinitionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvWordDetail.dequeueReusableCell(withIdentifier: "cell") as! WordTableViewCell
        cell.dcType.text = "\(arrDefinitionList[indexPath.row].wordType)"
        cell.dcDesc.text = "\(arrDefinitionList[indexPath.row].wordDesc)"
        if let img = arrDefinitionList[indexPath.row].wordImg {
            cell.dcImage.image = img
        }
        else {
            cell.dcImage.image = UIImage(named: "image.png")
        }
        return cell
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
