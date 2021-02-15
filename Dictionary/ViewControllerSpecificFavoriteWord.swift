//
//  ViewControllerSpecificFavoriteWord.swift
//  Dictionary
//
//  Created by Laurentia Audrey on 15/02/21.
//  Copyright © 2021 Laurentia Audrey. All rights reserved.
//

import UIKit

class ViewControllerSpecificFavoriteWord: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrFavDefinitionList:[DictionaryWord] = []
    
    
    @IBOutlet weak var lblWord: UILabel!
    
    @IBOutlet weak var tvWordDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvWordDetail.dataSource = self
        tvWordDetail.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print(favWord)
        lblWord.text = favWord
        requestData(word: favWord.replacingOccurrences(of: " ", with: "%20"))
    }
    
    func requestData(word: String) {
        arrFavDefinitionList.removeAll()
        let BASE_URL = "https://owlbot.info/"
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
                let responseObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                let wordName = responseObj?["word"] as! String
                let wordDefinitionArray = responseObj?["definitions"] as! [[String:Any]]
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
                    self.arrFavDefinitionList.append(DictionaryWord(wordName: wordName, wordType: wordType, wordDesc: wordDefinition, wordImgURL: wordImageURL, wordImg: wordImage))
                }
                DispatchQueue.main.async {
                    self.lblWord.text = wordName
                    self.tvWordDetail.reloadData()
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
        return arrFavDefinitionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvWordDetail.dequeueReusableCell(withIdentifier: "cell") as! WordTableViewCell
        cell.dcType.text = "\(arrFavDefinitionList[indexPath.row].wordType)"
        cell.dcDesc.text = "\(arrFavDefinitionList[indexPath.row].wordDesc)"
        if let img = arrFavDefinitionList[indexPath.row].wordImg {
            cell.dcImage.image = img
        }
        else {
            cell.dcImage.image = UIImage(named: "image.png")
        }
        return cell    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
