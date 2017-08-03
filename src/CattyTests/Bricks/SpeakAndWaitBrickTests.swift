/**
 *  Copyright (C) 2010-2017 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

@testable import Pocket_Code

final class SpeakAndWaitBrickTests: XCTestCase {
    
    var spriteObject : SpriteObject!
    var spriteNode : CBSpriteNode!
    var script : Script!
    var logger : CBLogger!
    
    override func setUp() {
        super.setUp()
        
        logger = CBLogger(name: "Logger");
        
        spriteObject = SpriteObject();
        spriteNode = CBSpriteNode();
        spriteNode.name = "SpriteNode";
        spriteNode.spriteObject = spriteObject;
        spriteObject.spriteNode = spriteNode;
        
        script = Script();
        script.object = spriteObject;
    }
    
    func testSpeakAndWaitDuration() {
        let exp = self.expectationWithDescription("Speech Expectation")
        let speakAndWaitBrick = SpeakAndWaitBrick()
        speakAndWaitBrick.formula = Formula(double: 1010101.0)
        speakAndWaitBrick.script = self.script;
        
        let executionTime = self.measureExecutionTime(speakAndWaitBrick.instruction())
        
        if (executionTime > 1) {
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
     }
    
    func testTitleSingular() {
        let speakBrick = SpeakAndWaitBrick()
        
        let speakFormula = Formula()
        let formulaElement = FormulaElement()
        formulaElement.type = .STRING
        formulaElement.value = "I am a speek and wait brick and I am being tested."
        speakFormula.formulaTree = formulaElement
        
        speakBrick.formula = speakFormula
        
        XCTAssertEqual(kLocalizedSpeak + "%@" + kLocalizedAndWait, speakBrick.brickTitle, "Wrong brick title")
    }

    
    func measureExecutionTime(instruction: CBInstruction) -> Double {
        var start = NSDate()
        switch instruction {
        case let .WaitExecClosure(closure):
            start = NSDate()
            closure(context: CBScriptContext(script: self.script, spriteNode: self.spriteNode), scheduler: CBScheduler(logger: self.logger, broadcastHandler: CBBroadcastHandler(logger: self.logger)))
        default: break
        }
        
        let timeIntervalInSeconds: Double = NSDate().timeIntervalSinceDate(start)
        return timeIntervalInSeconds
    }
}
