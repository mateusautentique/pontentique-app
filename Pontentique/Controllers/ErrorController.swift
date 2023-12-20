//
//  ErrorController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 20/12/23.
//

import Foundation

// ERROR HANDLING

func createError(from json: [String: Any], with statusCode: Int) -> NSError {
    var errorMessage: String?
    var userInfo = [String: Any]()
    
    if statusCode == 401 {
        errorMessage = json["error"] as? String
    } else if statusCode == 422 {
        errorMessage = json["message"] as? String
        if let errorsDict = json["errors"] as? [String: Any] {
            for (field, fieldError) in errorsDict {
                if let fieldError = fieldError as? [String] {
                    userInfo[field] = fieldError.joined(separator: ", ")
                }
            }
        }
    } else {
        errorMessage = json["message"] as? String
    }
    
    userInfo[NSLocalizedDescriptionKey] = errorMessage
    return NSError(domain: "", code: statusCode, userInfo: userInfo)
}
