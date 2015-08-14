//
//  BehtarinTests.swift
//  BehtarinTests
//
//  Created by Max Vitruk on 28.07.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import UIKit
import XCTest
import Behtarin

class BehtarinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewController(){
        let vc = ViewController() as ViewController
        vc.viewDidLoad()
        vc.viewWillAppear(true)
        testAsynchronousURLConnection(vc.makeURLWithParameters())
    }
    
    func testAsynchronousURLConnection(url : String) {
        let URL = NSURL(string: url)!
        let expectation = expectationWithDescription("GET \(URL)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(URL) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? NSHTTPURLResponse,
                responseURL = HTTPResponse.URL,
                MIMEType = HTTPResponse.MIMEType
            {
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(MIMEType, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(task.originalRequest.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
}
