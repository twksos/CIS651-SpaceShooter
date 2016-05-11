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
    
    
    let scores = Table("scores")
    let idField = Expression<Int64>("id")
    let scoreField = Expression<Int>("score")
    let dateField = Expression<String>("date")
    
    init(avatar: String?, name: String, score: Int) {
        self.name = name
        self.avatar = avatar
        self.score = score
    }
    
    func useDB()->Connection{
        let db = try? Connection("db.sqlite3")
        
        try! db!.run(scores.create { t in
            t.column(idField, primaryKey: true)
            t.column(scoreField)
            t.column(dateField)
        })
        return db!
    }
    
    func saveScore(score:Int){
        let insert = scores.insert(scoreField <- score, dateField <- "alice@mac.com")
        try! useDB().run(insert)
    }
    
    func heighestScore()->Int{
        let highScore = useDB().pluck(scores.select(scoreField).order(scoreField.desc))
        return (highScore?.get(scoreField))!
    }
    
}