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

    func testPathDrawing() {
        let canvas = vc.canvasView
        let points = [(10,10),(20,20),(30,30),(40,40)].map { (x,y) in CGPoint(x: x,y:y) }
        XCTAssertEqual(canvas.paths.count, 0, "There should initially be no paths")
        touchPath(canvas, points: points)
        XCTAssertEqual(canvas.paths.count, 1, "Touch events should create a new path.")
        let path = canvas.paths[0]
        XCTAssertEqual(path.color, canvas.currentColor, "The path should be drawn with the canvas' current color")
        XCTAssertEqual(path.points, points, "The path should contain all touch points.")
    }

    func testClearCanvas() {
        let canvas = vc.canvasView
        let points = [(10,10),(20,20),(30,30),(40,40)].map { (x,y) in CGPoint(x: x,y:y) }
        touchPath(canvas, points: points)
        XCTAssertEqual(canvas.paths.count, 1, "Touch events should create a new path.")
        self.vc.clearButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        XCTAssertEqual(canvas.paths.count, 0, "Canvas should be cleared.")
    }

    class MockTouch: UITouch {
        let point: CGPoint
        init(point: CGPoint) {
            self.point = point
        }

        override func locationInView(view: UIView!) -> CGPoint {
            return self.point
        }
    }

    typealias TouchPath = [CGPoint]
    private func touchPath(view: UIView, points: TouchPath) {
        assert(points.count >= 3, "A touch path must have at least 3 points")
        for i in 0..<points.count {
            let touch = MockTouch(point: points[i])
            let touches = NSSet(object: touch)
            if i == 0 {
                view.touchesBegan(touches, withEvent: nil)
            } else if i == points.count-1 {
                view.touchesEnded(touches, withEvent: nil)
            } else {
                view.touchesMoved(touches, withEvent: nil)
            }
        }
    }

    private func colorPickers() -> [UIButton] {
        let pickers = vc.view.subviews.filter { view in
            if let picker = view as? UIButton {
                return picker != self.vc.clearButton
            } else {
                return false
            }
        }
        return pickers.map { $0 as UIButton }
    }
}
