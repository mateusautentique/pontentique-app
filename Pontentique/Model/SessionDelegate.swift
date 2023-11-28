//
//  SessionDelegate.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import Foundation

class MySessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host == "192.168.1.249" {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

//let delegate = MySessionDelegate()
//let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
