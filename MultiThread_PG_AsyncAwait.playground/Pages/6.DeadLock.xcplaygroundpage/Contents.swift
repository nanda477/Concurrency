
import Foundation

/* DEADLOCKS

* A deadlock is a situation in concurrent programming where two or more tasks or threads are blocked indefinitely, waiting for each other to complete.
* Deadlocks can significantly impact the performance and stability of an application.

* Deadlock is a situation that occurs in OS when any process enters a waiting state because another waiting process is holding the demanded resource.
* Deadlock is a common problem in multi-processing where several processes share a specific type of mutually exclusive resource known as a soft lock or software.

* Deadlock is a common issue that can occur when using threads in iOS development.
* Deadlock occurs when two or more threads are waiting for each other to release a resource, resulting in a situation where none of the threads can proceed.
 */

//MARK: - Global Main Queue
//
////Problem
//DispatchQueue.main.sync {
//    print("Before Deadlock")
//    DispatchQueue.main.sync {
//        print("Deadlock")
//    }
//}
////Solution 1
//DispatchQueue.main.async {
//    print("Before Deadlock")
//    DispatchQueue.main.async {
//        print("NO Deadlock")
//    }
//}
//
////Solution 2
//DispatchQueue.main.sync {
//    print("Before Deadlock")
//    DispatchQueue.main.async {
//        print("NO Deadlock")
//    }
//}

//Solution 3
//let otherQueue = DispatchQueue(label: "com.example.otherQueue")
//
//DispatchQueue.main.sync {
//    print("Before Deadlock")
//    otherQueue.sync {
//        print("No Deadlock")
//    }
//}
//or
//let otherQueue1 = DispatchQueue(label: "com.example.otherQueue1")
//let otherQueue2 = DispatchQueue(label: "com.example.otherQueue2")
//
//otherQueue1.sync {
//    print("Before Deadlock")
//    otherQueue2.sync {
//        print("No Deadlock")
//    }
//}

//Solution4:
//DispatchQueue.main.sync {
//    print("Before Deadlock")
//    if DispatchQueue.current != DispatchQueue.main {
//        DispatchQueue.main.sync {
//            print("No Deadlock")
//        }
//    } else {
//        DispatchQueue.main.async {
//            print("No Deadlock")
//        }
//    }
//}




//MARK: Serial Queue
//let queue = DispatchQueue(label: "com.iOS.DeadLock")
//queue.sync {
//    print("you can print me")
//    queue.sync {
//        print("YOU CANT PRINT ME")
//    }
//}
/*
//MARK: 2 Serial Queue
let dlQueue1 = DispatchQueue(label: "com.iOS.DeadLock1")
let dlQueue2 = DispatchQueue(label: "com.iOS.DeadLock2")

dlQueue1.async {
    print("Task 1 Started")
    dlQueue2.sync {//Q1 trying to execute a block on Q2 synchronously
        print("Task 1 is waiting for Task 2 to complete")
    }
    print("Task 1 Finished")
}

dlQueue2.async {
    print("Task 2 Started")
    dlQueue1.sync {//Q2 trying to execute a block on Q1 synchronously
        print("Task 2 is waiting for Task 1 to complete")
    }
    print("Task 2 Finished")
}
*/
//MARK: concurrent Queue
//let queue = DispatchQueue(label: "com.iOS.DeadLock", attributes: .concurrent)
//queue.sync {
//    print("you can print me")
//    queue.sync {
//        print("YOU CANT PRINT ME")
//    }
//}



//MARK: Circular Dependency

 /*
 In this example, two threads are created, and each thread tries to acquire the other lock before releasing its own lock, resulting in a circular dependency. This causes both threads to be blocked, waiting for the other thread to release the lock they need to proceed.
 This situation is a Deadlock.
 */

//
//let lock1 = NSLock()
//let lock2 = NSLock()
//
//DispatchQueue.global().async {
//    print("Thread-1 Entered")
//    
//    lock1.lock()
//    lock2.lock() // thread -1 is waiting for lock 2
//    
//    //Do Something
//    print("Thread-1 Completed")
//    
//    lock2.unlock()
//    lock1.unlock()
//}

//DispatchQueue.global().async {
//    print("Thread-2 Entered")
//    
//    lock2.lock()
//    lock1.lock() // thread -2 is waiting for lock 2
//    
//    //Do Something
//    print("Thread-2 Completed")
//    
//    lock1.unlock()
//    lock2.unlock()
//}


/*
 Lock Contention (Disagreement/Dispute)
 In this example, two threads created, and each thread acquires a lock on lock.
 However, each thread tried to acquire the same lock again before releasing it, resulting lock contention.
*/

//let lock = NSLock()
//
//DispatchQueue.global().async {
//    print("Thread-1 Entered")
//    lock.lock()
//    
//    DispatchQueue.global().async {
//        lock.lock()
//        //Do Something
//        print("Thread-1 Completed")
//    }
//    lock.unlock()
//}
//
//DispatchQueue.global().async {
//    print("Thread-2 Entered")
//    lock.lock()
//    
//    DispatchQueue.global().async {
//        lock.lock()
//        //Do Something
//        print("Thread-2 Completed")
//    }
//    lock.unlock()
//}


//MARK: - Resource exhaustion
/*
 Two threads are created, and each threads waits for s signal from other thread using semaphore. However, if the signal is not sent by other thread, the thread will be blocked permanently, leading to resource exhaustion. this situation also a DeadLock.
 */

let semaphore1 = DispatchSemaphore(value: 0)
let semaphore2 = DispatchSemaphore(value: 0)

DispatchQueue.global(qos: .background).async {
    print("Thread-1 Entered")
    semaphore1.wait(timeout: .now() + 2)
    sleep(2)
    print("Thread-1 Completed")
    semaphore2.signal()
    print("Thread 1 All Done")
}

DispatchQueue.global(qos: .userInitiated).async {
    print("Thread-2 Entered")
    semaphore2.wait(timeout: .now() + 1)
    sleep(1)
    print("Thread-2 Completed")
    semaphore1.signal()
    print("Thread 2 All Done")
}
