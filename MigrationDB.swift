//
//  MigrationDB.swift
//  miadParizadian
//  Created by miadParizadian on 6/12/19.
//  Copyright © 2019 miadParizadian. All rights reserved.
//

import UIKit
import SQLite

class MigrationDB {
    init( db : Connection,tableName:String, query : String) {
            var asAnArray:[String] = []
            do {
                let columnInDB = try db.prepare("PRAGMA table_info(" + tableName + ")" )
                
                for row in columnInDB { asAnArray.append(row[1]! as! String) }
            }
            catch { print("some woe in findColumns for \(tableName) \(error)") }
            let querySplite = query.components(separatedBy: "(")[1]
            var queryToArray = querySplite.components(separatedBy: ",")
            var typeArray = [String]()
            for i in 0 ..< queryToArray.count{
                var  queryToArraySplite = queryToArray[i].components(separatedBy: "\"")
                queryToArray[i] = queryToArraySplite[1]
                typeArray.append(queryToArraySplite[2].trim())
                if !asAnArray.contains(queryToArray[i]){
                    do {
                        try db.run("ALTER TABLE " + tableName + " ADD COLUMN " + queryToArray[i] + " " + typeArray[i] + ";")
                    }catch let err{
                        print(err)
                    }
                }
            }
        
    }

}
