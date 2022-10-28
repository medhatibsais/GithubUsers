//
//  URLProtocolMock.swift
//  GithubUsersTests
//
//  Created by Medhat Ibsais on 26/10/2022.
//

import Foundation

class URLProtocolMock: URLProtocol {
    
    // this is the data we're expecting to send back
    static var testURLs = [URL: Data]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // as soon as loading starts, send back our test data or an empty Data instance, then end loading
    override func startLoading() {
        if let url = request.url {
            if let data = URLProtocolMock.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
