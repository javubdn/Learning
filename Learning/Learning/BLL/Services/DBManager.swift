//
//  DBManager.swift
//  Learning
//
//  Created by Javi Castillo Risco on 10/01/2021.
//

import Foundation
import SQLite3

class DBManager {

    let documentsDirectory: String
    let databaseFilename: String
    private var db: OpaquePointer?

    init(with dataBaseFilename: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        documentsDirectory = paths[0]
        databaseFilename = dataBaseFilename
        copyDatabaseIntoDocumentsDirectory()
        db = openDatabase(documentsDirectory + "/" + databaseFilename)
    }

    private func copyDatabaseIntoDocumentsDirectory() {
        let destinationPath = documentsDirectory + "/" + databaseFilename
        if !FileManager.default.fileExists(atPath: destinationPath),
           let resourcePath = Bundle.main.resourcePath {
            let sourcePath = resourcePath + "/" + databaseFilename
            do {
                try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
            } catch let error {
                print(error)
            }
        }
    }

    func query(_ queryStatementString: String) -> [Any]? {
        var queryStatement: OpaquePointer?
        var dataList: [Any]?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var columnNames = [String]()
            dataList = []
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var currentRow = [String]()
                let numberColumns = sqlite3_column_count(queryStatement)
                for columnIndex in 0..<numberColumns {
                    if let queryResultColumn = sqlite3_column_text(queryStatement, columnIndex)  {
                        currentRow.append(String(cString: queryResultColumn))
                    }

                    if columnNames.count != numberColumns {
                        if let dbDataAsChars = sqlite3_column_name(queryStatement, columnIndex) {
                            columnNames.append(String(utf8String: dbDataAsChars)!)
                        }
                    }
                }
                if currentRow.count > 0 {
                    dataList?.append(currentRow)
                }
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return dataList
    }

    func execute(_ executeStatementString: String) {
        var executeStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, executeStatementString, -1, &executeStatement, nil) == SQLITE_OK {
            if sqlite3_step(executeStatement) == SQLITE_DONE {
                print("\nStatement successfully executed.")
            } else {
                print("\nCould not exectue the statement.")
            }
        } else {
            print("\nStatement could not be prepared.")
        }
        sqlite3_finalize(executeStatement)
    }

    private func openDatabase(_ databasePath: String) -> OpaquePointer? {
        var db: OpaquePointer?
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            return db
        }
        return nil
    }

}
