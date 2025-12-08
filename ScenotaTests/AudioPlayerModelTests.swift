import XCTest
@testable import Scenota



final class AudioPlayerModelTests: XCTestCase {
    
    
    var audioModel: AudioPlayerModel! = nil
    
    // Setup the audio player model
    override func setUpWithError() throws {
        
        guard let testURL = Bundle.main.url(forResource: "tambourine", withExtension: "wav") else { return }
        audioModel = AudioPlayerModel(audioFileURL: testURL)
       
        
    }

    override func tearDownWithError() throws {
           audioModel = nil
       
    }
    
   
    
    
    func testInvalidURLHandled() {
    
        let url = Bundle.main.url(forResource: "zizaza", withExtension: "wav")
        
        audioModel = AudioPlayerModel(audioFileURL: url)
        audioModel.setupAudio()
        
        XCTAssertNotNil(audioModel.errorMessage, "The model should have set an error for an invalid URL")
        XCTAssertTrue(audioModel.showError, "showError should be true for an invalid URL")
    }
    
    func testPlayPauseFlags() throws {
       
        audioModel.playAudio()
        XCTAssertTrue(audioModel.isPlaying)
        
        audioModel.pauseAudio()
        XCTAssertFalse(audioModel.isPlaying)
        XCTAssertFalse(audioModel.isCountingDown)
    }
    
    func testCountdownStart() {
        audioModel.delay = 10
        audioModel.startCountdown()
        
        XCTAssertTrue(audioModel.isCountingDown)
        XCTAssertEqual(audioModel.countdownRemaining, 10)
    }

}

