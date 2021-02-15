//
//  FavoriteWord+CoreDataProperties.swift
//  Dictionary
//
//  Created by Laurentia Audrey on 15/02/21.
//  Copyright © 2021 Laurentia Audrey. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteWord> {
        return NSFetchRequest<FavoriteWord>(entityName: "FavoriteWord")
    }
 
    @NSManaged public var wordName: String?

}
