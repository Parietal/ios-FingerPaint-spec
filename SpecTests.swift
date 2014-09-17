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

    func testColorPickers() {
        let pickers = colorPickers()
        XCTAssertEqual(pickers.count, 5, "There should be 5 color pickers added to the root view")
    }

    func testColorPickerSelection() {
        for picker in colorPickers() {
            picker.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            XCTAssertEqual(picker.backgroundColor!, self.vc.canvasView.currentColor, "Picking color should change the the current color of canvas.")
        }
    }

    private func colorPickers() -> [UIButton] {
        let pickers = vc.view.subviews.filter { view in
            if let picker = view as? UIButton {
                return true
            } else {
                return false
            }
        }
        return pickers.map { $0 as UIButton }
    }
}
