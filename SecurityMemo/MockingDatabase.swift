//
//  MockingDatabase.swift
//  SecurityMemo
//
//  Created by Frank on 11/15/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import Foundation
class MockDatabase {
    
    
    
    public static var database: [String: [Incident]] = [:] {
        didSet{
            print(database)
        }
    }
}
