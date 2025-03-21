
/*
 Thread Safety
    * NSLocks
    * Semaphore
 */
import Foundation

//Both NSLock and DispatchSemaphore are synchronization primitives used to manage concurrent access to shared resources, but they have distinct characteristics and use cases.

//NSLock:
/*
Purpose:
    Primarily designed for mutual exclusion, ensuring that only one thread can access a critical section at a time.
Mechanism:
    A basic lock with lock() and unlock() methods. If a thread attempts to lock() an already locked NSLock, it will block until the lock is released.
Behavior:
* It's a mutex (mutual exclusion) lock.
* It's thread-based; the same thread that acquires the lock must release it.
* If a different thread attempts to unlock it, it will cause undefined behavior.

Use Cases:
* Protecting critical sections of code where only one thread should execute at a time.
* Simple synchronization within a single process.
* When you need a basic lock for mutual exclusion.
*/


//MARK: - Data Race Problem (Unsafe Counter)
/*
class UnsafeCounter {
    private var counter = 0

    func increment() {
        counter += 1
        print("Unsafe increment: \(counter)")
    }
    
    func decrement() {
        counter -= 1
        print("Unsafe Decrement: \(counter)")
    }

    func value() -> Int {
        return counter
    }
}

func runUnsafeCounter() {
    let unsafeCounter = UnsafeCounter()
    let queue = DispatchQueue(label: "unsafe", attributes: .concurrent)

    for _ in 0..<100 {
        queue.async {
            unsafeCounter.increment()
        }
    }
    
    for _ in 0..<50 {
        queue.async {
            unsafeCounter.decrement()
        }
    }

    queue.sync(flags: .barrier) {} // Wait for all increments

    print("Unsafe Final Value: \(unsafeCounter.value())")
}

runUnsafeCounter()
*/


//MARK: -  Solution with NSLock
/*
class SafeCounterNSLock {
    private var counter = 0
    private let lock = NSLock()

    func increment() {
        lock.lock()
        counter += 1
        print("NSLock increment counter: \(counter)")
        lock.unlock()
    }
    
    func decrement() {
        lock.lock()
        counter -= 1
        print("NSLock  decrement counter: \(counter)")
        lock.unlock()
    }

    func value() -> Int {
        lock.lock()
        let value = counter
        lock.unlock()
        return value
    }
}

func runSafeCounterNSLock() {
    let safeCounter = SafeCounterNSLock()
    let queue = DispatchQueue(label: "safeNSLock", attributes: .concurrent)

    for _ in 0..<100 {
        queue.async {
            safeCounter.increment()
        }
    }
    
    for _ in 0..<50 {
        queue.async {
            safeCounter.decrement()
        }
    }

    queue.sync(flags: .barrier) {}

    print("NSLock Final Value: \(safeCounter.value())")
}

runSafeCounterNSLock()

*/

/*
DispatchSemaphore:

Purpose:
    More versatile, used for both mutual exclusion and controlling access to a limited number of resources.
Mechanism:
    Maintains a counter and provides wait() (decrement) and signal() (increment) operations. If the counter is 0, wait() blocks until signal() increases it.
Behavior:
* Can act as a mutex (binary semaphore) or a counting semaphore.
* Not tied to a specific thread; any thread can call signal() to release the semaphore.
* Can be used to limit the amount of concurrent work being performed.

Use Cases:
* Controlling access to a pool of limited resources (e.g., database connections, network connections).
* Implementing producer-consumer patterns.
* Synchronizing asynchronous operations.
* Coordinating work across different queues.
 
*/

//MARK: -  Solution with DispatchSemaphore
/*class SafeCounterSemaphore {
    private var counter = 0
    private let semaphore = DispatchSemaphore(value: 1)

    func increment() {
        semaphore.wait()
        counter += 1
        print("Semaphore increment counter: \(counter)")
        semaphore.signal()
    }
    
    func decrement() {
        semaphore.wait()
        counter -= 1
        print("Semaphore decrement counter: \(counter)")
        semaphore.signal()
    }

    func value() -> Int {
        semaphore.wait()
        let value = counter
        semaphore.signal()
        return value
    }
}

func runSafeCounterSemaphore() {
    let safeCounter = SafeCounterSemaphore()
    let queue = DispatchQueue(label: "safeSemaphore", attributes: .concurrent)

    for _ in 0..<100 {
        queue.async {
            safeCounter.increment()
        }
    }
    
    for _ in 0..<50 {
        queue.async {
            safeCounter.decrement()
        }
    }

    queue.sync(flags: .barrier) {}

    print("Semaphore Final Value: \(safeCounter.value())")
}

runSafeCounterSemaphore()
*/
