import Foundation
import UIKit

var myCompletion: () -> Void = {}

var counter: Int = 0
 func getUserDetails(userID: String, completion: @autoclosure () -> Int) {
    
     completion()
}

func getUserDetails(userID: String, firstCompletion: @autoclosure () -> Void, secondCompletion: @autoclosure () -> Int, thirdCompletion: @autoclosure () -> Void) {
   
    
}

getUserDetails(userID: "878", firstCompletion: (counter = 1), secondCompletion: counter, thirdCompletion: (counter = 3))

