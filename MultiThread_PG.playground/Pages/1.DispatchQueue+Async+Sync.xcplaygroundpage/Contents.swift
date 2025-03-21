import Foundation

let dispatchQueue = DispatchQueue(label: "com.example.DispatchGroup", attributes: .concurrent)
/*
dispatchQueue.async() {
    print("Choose Product")
}

dispatchQueue.async() {
    print("Add to cart")
}

dispatchQueue.async() {
    print("Pay Money")
}

dispatchQueue.async() {
    print("Place Order")
}
*/

//MARK: =========================== Concurrent =================
/*
let dispatchGroup = DispatchGroup()//0

dispatchGroup.enter()
dispatchQueue.async() {
    sleep(3)
    print("Choose Product")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.async() {
    sleep(1)
    print("Add to cart")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.async() {
    sleep(2)
    print("Pay Money")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.async() {
    sleep(1)
    print("Place Order")
    dispatchGroup.leave()
}

//dispatchGroup.notify(queue: .main) { //UI update
//    print("Product Delivered")
//}
 
 dispatchGroup.wait()

 DispatchQueue.main.async { // UI update
     print("Product Delivered")
 }
*/
//=======
//let qGroup = DispatchGroup()
//
//let q1 = DispatchQueue(label: "com.q1.ios")
//q1.async(group: qGroup) {
//    sleep(1)
//    print("q1 completed..!")
//}
//
//let q2 = DispatchQueue(label: "com.q2.ios")
//q2.async(group: qGroup) {
//    sleep(1)
//    print("q2 completed..!")
//}
//
//qGroup.notify(queue: .main) {
//    print("All Task completed")
//}


//MARK: =============================== Serial ==========================
/*
let dispatchGroup = DispatchGroup()

dispatchGroup.enter()
dispatchQueue.sync {
    sleep(3)
    print("Choose Product")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.sync {
    sleep(1)
    print("Add to cart")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.sync {
    sleep(2)
    print("Pay Money")
    dispatchGroup.leave()
}

dispatchGroup.enter()
dispatchQueue.sync {
    sleep(1)
    print("Place Order")
   dispatchGroup.leave()
}

dispatchGroup.notify(queue: .main) {
    print("Product Delivered")
}
*/

//MARK: =============================== OTHER (Combinations) ==========================

// MARK: - Concurrent Queue Example

func concurrentQueueExample() {
    let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: .concurrent)
    print("Concurrent Queue")

    // Asynchronous (Concurrent) Tasks
//    for i in 1...5 {
//        concurrentQueue.async {
//            print("Concurrent Task \(i) started")
//            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5)) // Simulate work
//            print("Concurrent Task \(i) finished")
//        }
//    }

    // Synchronous (Forced Serial) Tasks - NOT RECOMMENDED for typical concurrent tasks.
    for i in 6...10 {
        concurrentQueue.sync {
            print("Forced Serial Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5)) // Simulate work
            print("Forced Serial Task \(i) finished")
        }
    }

    // Wait for all async tasks to finish (not needed for sync, as they block)
    //concurrentQueue.async(flags: .barrier) {} //barrier to wait for all the previous async tasks to finish.
  
    concurrentQueue.async {
        print("Concurrent queue finished")
    }
}

// MARK: - Concurrent Queue Example with DispatchGroup

func concurrentQueueWithDispatchGroupExample() {
    let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: .concurrent)
    let dispatchGroup = DispatchGroup()
    print("Concurrent Queue Example:")

    // Asynchronous (Concurrent) Tasks
    for i in 1...5 {
        dispatchGroup.enter()
        concurrentQueue.async {
            print("Concurrent Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5)) // Simulate work
            print("Concurrent Task \(i) finished")
            dispatchGroup.leave()
        }
    }

    // Synchronous (Forced Serial) Tasks - NOT RECOMMENDED for typical concurrent tasks.
    for i in 6...10 {
        dispatchGroup.enter()
        concurrentQueue.sync {
            print("Forced Serial Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5)) // Simulate work
            print("Forced Serial Task \(i) finished")
            dispatchGroup.leave()
        }
    }

    // Wait for all async tasks to finish and gets called, no UI block
    dispatchGroup.notify(queue: .main) {
        print("Concurrent queue example finished")
    }
}

// MARK: - Serial Queue Example

func serialQueueExample() {
    let serialQueue = DispatchQueue(label: "com.example.serial")

    print("\nSerial Queue Example:")
    
//    for i in 1...5 {
//        serialQueue.sync {
//            print("Serial Task \(i) started")
//            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5)) // Simulate work
//            print("Serial Task \(i) finished")
//        }
//    }

    // Serial (Ordered) Tasks
    for i in 1...5 {
        serialQueue.async {
            print("Forced Concurrent Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 1...3)) // Simulate work
            print("Forced Concurrent Task \(i) finished")
        }
    }

    serialQueue.async {
        print("Concurrent queue example finished")
    }
}

// MARK: - Multiple Serial Queues Example (Simulating Concurrency)

func multipleSerialQueuesExample() {
    print("\nMultiple Serial Queues Example:")

    let queue1 = DispatchQueue(label: "com.example.serial1")
    let queue2 = DispatchQueue(label: "com.example.serial2")
    let queue3 = DispatchQueue(label: "com.example.serial3")

//    for i in 1...3 {
//        queue1.async {
//            print("Queue 1, Task \(i) started")
//            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
//            print("Queue 1, Task \(i) finished")
//        }
//
//        queue2.async {
//            print("Queue 2, Task \(i) started")
//            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
//            print("Queue 2, Task \(i) finished")
//        }
//
//        queue3.async {
//            print("Queue 3, Task \(i) started")
//            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
//            print("Queue 3, Task \(i) finished")
//        }
//    }
    
    for i in 1...3 {
        queue1.sync {
            print("Queue 1, Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
            print("Queue 1, Task \(i) finished")
        }

        queue2.sync {
            print("Queue 2, Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
            print("Queue 2, Task \(i) finished")
        }

        queue3.sync {
            print("Queue 3, Task \(i) started")
            Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.5))
            print("Queue 3, Task \(i) finished")
        }
    }
    
    queue1.async(flags: .barrier) {}
    queue2.async(flags: .barrier) {}
    queue3.async(flags: .barrier) {}
    queue3.async {
        print("Multiple serial queues example finished")
    }
}

// MARK: - Usage

//concurrentQueueExample()
//concurrentQueueWithDispatchGroupExample()

//serialQueueExample()

//multipleSerialQueuesExample()
