
import Foundation
import PlaygroundSupport

// MARK: - BlockOperation
/*
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 2// Serial execution
//.defaultMaxConcurrentOperationCount
operationQueue.qualityOfService = .userInitiated

let operationA = BlockOperation {
    print("Operation A started")
    sleep(10)
    print("Operation A finished")
}

let operationB = BlockOperation {
    print("Operation B started")
    sleep(1)
    print("Operation B finished")
}

let operationC = BlockOperation {
    print("Operation C started")
    sleep(1)
    print("Operation C finished")
}

// Add Dependency
operationB.addDependency(operationA)
operationC.addDependency(operationB)

//operationB.cancel()
//operationC.cancel()

operationQueue.addOperation(operationA)
operationQueue.addOperation(operationB)
operationQueue.addOperation(operationC)

operationA.cancel()

//print("All operations added to queue")







//MARK: Get Each BLOCK OPERATION completion callback
/*
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 5 // Serial execution
operationQueue.qualityOfService = .userInitiated

let operationA = BlockOperation {
    print("Operation A started")
    sleep(1)
}

operationA.completionBlock = {
    print("Operation A finished")
}


let operationB = BlockOperation {
    print("Operation B started")
    sleep(1)
}
operationB.completionBlock = {
    print("Operation B finished")
}


let operationC = BlockOperation {
    print("Operation C started")
    sleep(1)
}
operationC.completionBlock = {
    print("Operation C finished")
}

// Add Dependency
//operationB.addDependency(operationA)
//operationC.addDependency(operationB)
//operationA.cancel()
//operationB.cancel()
//operationC.cancel()

operationQueue.addOperation(operationA)
operationQueue.addOperation(operationB)
operationQueue.addOperation(operationC)

print("All operations added to queue")

*/



//MARK: Get Entire Operation(operationQueue) completion callback : Approach 1(wait for all operations to complete)

//let operationQueue = OperationQueue()
//operationQueue.maxConcurrentOperationCount = 5
//operationQueue.qualityOfService = .userInitiated
//
//let operationA = BlockOperation {
//    print("Operation A started")
//    sleep(1)
//}
//
//operationA.completionBlock = {
//    print("Operation A finished")
//}
//
//
//let operationB = BlockOperation {
//    print("Operation B started")
//    sleep(1)
//}
//operationB.completionBlock = {
//    print("Operation B finished")
//}
//
//
//let operationC = BlockOperation {
//    print("Operation C started")
//    sleep(1)
//}
//operationC.completionBlock = {
//    print("Operation C finished")
//}
//
//operationQueue.addOperation(operationA)
//operationQueue.addOperation(operationB)
//operationQueue.addOperation(operationC)
//
////Approach1
//operationQueue.waitUntilAllOperationsAreFinished() // Blocks UI
//
//print("All operations added to queue")
//



//MARK: Get Entire Operation(operationQueue) completion callback : Approach 2(Completion Block on the Last Operation (with Dependencies):)

let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 5
operationQueue.qualityOfService = .userInitiated

let operationA = BlockOperation {
    print("Operation A started")
    sleep(1)
}

operationA.completionBlock = {
    print("Operation A finished")
}


let operationB = BlockOperation {
    print("Operation B started")
    sleep(1)
}
operationB.completionBlock = {
    print("Operation B finished")
}


let operationC = BlockOperation {
    print("Operation C started")
    sleep(1)
}
operationC.completionBlock = {
    print("Operation C finished")
}

let completionOperation = BlockOperation {
    DispatchQueue.main.async{
        print("All operations finished via completion block.")
        //Perform UI updates here
    }
}

completionOperation.addDependency(operationA)
completionOperation.addDependency(operationB)
completionOperation.addDependency(operationC)

operationQueue.addOperation(operationA)
operationQueue.addOperation(operationB)
operationQueue.addOperation(operationC)
operationQueue.addOperation(completionOperation)

print("All operations added to queue")



//MARK: Get Entire Operation(operationQueue) completion callback : Approach 3(KVO Approach)

class OperationQueueObserver: NSObject { // Inherit from NSObject
    let operationQueue = OperationQueue()

    override init() {
        super.init()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = .userInitiated

        let operationA = BlockOperation {
            print("Operation A started")
            sleep(1)
        }

        operationA.completionBlock = {
            print("Operation A finished")
        }

        let operationB = BlockOperation {
            print("Operation B started")
            sleep(1)
        }
        operationB.completionBlock = {
            print("Operation B finished")
        }

        let operationC = BlockOperation {
            print("Operation C started")
            sleep(1)
        }
        operationC.completionBlock = {
            print("Operation C finished")
        }

        operationQueue.addOperation(operationA)
        operationQueue.addOperation(operationB)
        operationQueue.addOperation(operationC)

        // Non-blocking KVO approach:
        operationQueue.addObserver(self, forKeyPath: #keyPath(OperationQueue.operationCount), options: [.new], context: nil)
    }

    deinit {
        operationQueue.removeObserver(self, forKeyPath: #keyPath(OperationQueue.operationCount))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(OperationQueue.operationCount), let newValue = change?[.newKey] as? Int {
            if newValue == 0 {
                operationQueue.removeObserver(self, forKeyPath: #keyPath(OperationQueue.operationCount))
                // Perform post-completion actions here (on main thread if needed)
                DispatchQueue.main.async {
                    print("UI updates or other post processing here")
                    PlaygroundPage.current.finishExecution() // to stop the playground execution.
                }
            }
        } else {
            // No super needed since observeValue is not being overridden, but defined in the class.
            print("other key path changed")
        }
    }
}

// Create an instance of the class
let observer = OperationQueueObserver()

// Allow playground to run asynchronously.
PlaygroundPage.current.needsIndefiniteExecution = true

