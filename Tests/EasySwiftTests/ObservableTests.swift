import XCTest
@testable import EasySwift

final class ObservableTests: XCTestCase {
    
    var observation: Observation?
    
    @Observable
    var text = "hello"
    
    func testObservable() {
        XCTAssertEqual(text, "hello")
        XCTAssertNil(observation)
        XCTAssertEqual($text.descriptors.count, 0)

        let _ = $text { [weak self] text in
            XCTAssertEqual(text, "hello")
            XCTAssertNil(self?.observation)
        }
        XCTAssertEqual($text.descriptors.count, 0)

        var initial = true
        var secondInvoke = false
        
        $text { [weak self] text in
            if initial {
                XCTAssertEqual(text, "hello")
                XCTAssertNil(self?.observation)
                initial = false
            } else {
                XCTAssertEqual(text, "goodbye")
                XCTAssertNotNil(self?.observation)
                secondInvoke = true
            }
        }.dispose(in: &observation)
        
        XCTAssertNotNil(observation)
        XCTAssertEqual($text.descriptors.count, 1)
        
        XCTAssertFalse(secondInvoke)
        text = "goodbye"
        XCTAssertTrue(secondInvoke)
        
        $text { text in
        }.dispose(in: &observation)
        
        XCTAssertEqual($text.descriptors.count, 1)
        observation = nil
        XCTAssertEqual($text.descriptors.count, 0)
    }
    
    func testSimpleObserver() {
        let simpleObserver = Observer<Bool>()

        var invoked = false
        simpleObserver { value in
            invoked = value
        }.dispose(in: &observation)
        
        XCTAssertFalse(invoked)
        simpleObserver(true)
        XCTAssertTrue(invoked)
    }
    
    
    let changeObserver = Observer<(Int, Int)>()
    
    var state = 1 {
        didSet {
            guard oldValue != state else { return }
            changeObserver((oldValue, state))
        }
    }
    
    func testStateObserver() {
        var prev = 0
        changeObserver { (old, new) in
            XCTAssertNotEqual(old, new)
            prev = old
        }.dispose(in: &observation)
        state = 3
        state = 3
        XCTAssertEqual(prev, 1)
        state = 5
        XCTAssertEqual(prev, 3)
    }

    func testVoidObserver() {
        let emptyObserver = Observer<Void>()

        var invoked = false
        emptyObserver {
            invoked = true
        }.dispose(in: &observation)
        
        XCTAssertFalse(invoked)
        emptyObserver()
        XCTAssertTrue(invoked)
    }


    static var allTests = [
        ("testObservable", testObservable),
        ("testSimpleObserver", testSimpleObserver),
        ("testStateObserver", testStateObserver),
        ("testVoidObserver", testVoidObserver),
    ]
}
