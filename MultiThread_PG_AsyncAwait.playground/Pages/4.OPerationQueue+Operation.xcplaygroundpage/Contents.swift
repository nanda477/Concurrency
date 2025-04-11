import Foundation


//MARK: Operation
// Example using a custom Operation subclass
/*
class CustomOperationOne: Operation {
    override func main() {
        print("Custom Operation 1 started")
        sleep(3)
        print("Custom Operation 1 finished")
    }
}

class CustomOperationTwo: Operation {
    override func main() {
        print("Custom Operation 2 started")
        sleep(3)
        print("Custom Operation 2 finished")
    }
}

class CustomOperationThree: Operation {
    override func main() {
        print("Custom Operation 3 started")
        sleep(3)
        print("Custom Operation 3 finished")
    }
}


let customOperation1 = CustomOperationOne()
let customOperation2 = CustomOperationTwo()
let customOperation3 = CustomOperationThree()

let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 3

customOperation3.addDependency(customOperation2)
customOperation1.addDependency(customOperation2)

operationQueue.addOperation(customOperation1)
operationQueue.addOperation(customOperation2)
operationQueue.addOperation(customOperation3)
*/


//MARK:  BlockOperation + Operation
// Example using BlockOperation
let blockOperation1 = BlockOperation {
    print("Block Operation 1 started")
    sleep(2)
    print("Block Operation 1 finished")
}

let blockOperation2 = BlockOperation {
    print("Block Operation 2 started")
    sleep(1)
    print("Block Operation 2 finished")
}


// Example using a custom Operation subclass
class CustomOperation: Operation {
    override func main() {
        print("Custom Operation started")
        sleep(3)
        print("Custom Operation finished")
    }
}


let customOperation = CustomOperation()

// Create an OperationQueue
let operationQueue = OperationQueue()

// Add dependencies
blockOperation2.addDependency(blockOperation1)

// Set max concurrent operations
operationQueue.maxConcurrentOperationCount = 2
//operationQueue.maxConcurrentOperationCount = .defaultMaxConcurrentOperationCount

// Add operations to the queue
operationQueue.addOperation(blockOperation1)
operationQueue.addOperation(blockOperation2)
operationQueue.addOperation(customOperation)


//
//// Example with cancellation
//let cancellableOperation = BlockOperation {
//    for i in 0...5 {
//        if OperationQueue.current?.isCancelled ?? false {
//            print("Cancellable operation cancelled at \(i)")
//            return
//        }
//        print("Cancellable operation: \(i)")
//        sleep(1) // Simulate work
//    }
//    print("Cancellable operation finished")
//}
//
//operationQueue.addOperation(cancellableOperation)
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//    cancellableOperation.cancel()
//    print("Cancellable operation cancellation requested")
//}


//MARK: - Example with multiple blocks within a BlockOperation
//let operationQueue = OperationQueue()
//let multiBlockOperation = BlockOperation()
//
//multiBlockOperation.addExecutionBlock {
//    print("Multi-block operation: Block 1 started")
//    sleep(1)
//    print("Multi-block operation: Block 1 finished")
//}
//
//multiBlockOperation.addExecutionBlock {
//    print("Multi-block operation: Block 2 started")
//    sleep(1)
//    print("Multi-block operation: Block 2 finished")
//}
//
//operationQueue.addOperation(multiBlockOperation)
