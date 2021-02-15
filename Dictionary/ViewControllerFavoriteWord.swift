//
//  ViewControllerFavoriteWord.swift
//  Dictionary
//
//  Created by Laurentia Audrey on 15/02/21.
//  Copyright © 2021 Laurentia Audrey. All rights reserved.
//

import UIKit
import CoreData

var favWord = ""
class ViewControllerFavoriteWord: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrFavWord = [FavoriteWord]()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvFavWord: UITableView!
    @IBAction func unwind(_ sender:UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromCoreData()
        tvFavWord.dataSource = self
        tvFavWord.delegate = self
        tvFavWord.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataFromCoreData()
    }
    func getDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<FavoriteWord>(entityName: "FavoriteWord")
        do {
            arrFavWord = try context.fetch(fetchReq)
        }
        catch let error {
            print(error.localizedDescription)
        }
        tvFavWord.reloadData()
        if(!arrFavWord.isEmpty) {
            lblTitle.text = "Favorite Words"
        }
        else {
            lblTitle.text = "No Data!"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favWord = arrFavWord[indexPath.row].wordName!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let idx = arrFavWord[indexPath.row]
            do {
                context.delete(idx)
                try context.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
            getDataFromCoreData()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavWord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favWordCell")
        cell?.textLabel?.text = arrFavWord[indexPath.row].wordName
        return cell!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
