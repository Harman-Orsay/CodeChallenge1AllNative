//
//  String+Date.swift
//  CodeChallenge1BL
//
//  Created by Rohan Ramsay on 9/12/20.
//

import Foundation

public extension String {
    func toDate(dateFormatter: DateFormatter? = nil) -> Date? {
        let df = dateFormatter ?? DateFormatter()
        return df.date(from: self)
    }
}

public extension Date {
    func toString(dateFormatter: DateFormatter? = nil) -> String? {
        let df = dateFormatter ?? DateFormatter()
        return df.string(from: self)
    }
}
