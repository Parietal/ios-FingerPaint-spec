//
//  FingerPaintTests.swift
//  FingerPaintTests
//
//  Created by Howard Yeh on 2014-09-15.
//  Copyright (c) 2014 Howard Yeh. All rights reserved.
//

import UIKit
import XCTest

class SpecTests: XCTestCase {

    var vc : ViewController!

    override func setUp() {
        super.setUp()
        let board = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = board.instantiateInitialViewController() as ViewController!
        // trigger the view to load by accessing the view property ...
        vc.view.subviews
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCanvasViewProperty() {
        if let canvasView = vc.canvasView {
            XCTAssert(canvasView.isKindOfClass(UIView.self),"canvasView should be a subclass of UIView")
            XCTAssert(canvasView.isMemberOfClass(CanvasView.self),"canvasView should be a CanvasView")
            XCTAssert(canvasView.frame == vc.view.frame,"canvasView should fill up the root view")
            XCTAssert(canvasView.superview == vc.view,"canvasView should be added to the root view")
        } else {
            XCTFail("ViewController should initialize the canvasView property")
        }
    }
}
