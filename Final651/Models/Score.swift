//
//  Score.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/9/16.
//  Copyright © 2016 Guangcheng Wei. All rights reserved.
//

import Foundation
import SQLite

class Score:NSObject {
    var avatar: String?
    var name: String = "Loading Name..."
    var score: Int = 0
    
    
    static let scores = Table("scores")
    static let idField = Expression<Int64>("id")
    static let scoreField = Expression<Int>("score")
    static let dateField = Expression<String>("date")
    
    init(avatar: String?, name: String, score: Int) {
        self.name = name
        self.avatar = avatar
        self.score = score
    }
    
    static func useDB()->Connection{
        
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        let docsDir = dirPaths[0]
        let destPath = (docsDir as NSString).stringByAppendingPathComponent("/db.sqlite3")
        
        let db = try? Connection(destPath)
        return db!
    }
    
    static func saveScore(score:Int){
        let insert = scores.insert(scoreField <- score, dateField <- "alice@mac.com")
        try! useDB().run(insert)
    }
    
    static func heighestScore()->Int{
        let highScore = useDB().pluck(scores.select(scoreField).order(scoreField.desc))
        return (highScore?.get(scoreField))!
    }
    
}