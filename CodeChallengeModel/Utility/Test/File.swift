//
//  File.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 25/12/20.
//

import Foundation

public class File {
    
    static func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: Self.self)
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
