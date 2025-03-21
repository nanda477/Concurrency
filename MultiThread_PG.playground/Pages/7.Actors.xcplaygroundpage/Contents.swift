import Foundation

class UnsafeCounter {
    var count = 0

    func increment() {
        count += 1
    }

    func getCount() -> Int {
        return count
    }
}

func runUnsafeCounter() {
    let counter = UnsafeCounter()
    let queue = DispatchQueue(label: "unsafe", attributes: .concurrent)

    for _ in 0..<1000 {
        queue.async {
            counter.increment()
        }
    }

    queue.sync(flags: .barrier) {} // Wait for all increments

    print("Unsafe Counter Value: \(counter.getCount())")
}

runUnsafeCounter()

//problem

//Understanding the Problem: Data Races
//1. Concurrent Access:
//    * The DispatchQueue(label: "unsafe", attributes: .concurrent) creates a queue that allows multiple tasks to run concurrently (at the same time).
//    * The queue.async { counter.increment() } dispatches 1000 tasks to this concurrent queue.
//2. Shared Mutable State:
//    * The UnsafeCounter class has a shared mutable state: the count variable.
//    * Multiple concurrent tasks are trying to modify this count variable simultaneously.
//3. Lack of Synchronization:
//    * The increment() method simply increments count without any synchronization mechanism (like locks or actors).
//    * This means that when multiple tasks try to execute count += 1 at the same time, the following can happen:
//        * Read-Modify-Write: The steps involved in count += 1 are:
//            1. Read the current value of count.
//            2. Add 1 to the value.
//            3. Write the new value back to count.
//        * Interleaving: These steps can interleave between different tasks. For example:
//            1. Task 1 reads count (e.g., count is 5).
//            2. Task 2 reads count (also 5).
//            3. Task 1 adds 1 (6) and writes it back.
//            4. Task 2 adds 1 (6) and writes it back.
//        * Lost Updates: In this scenario, one of the updates is lost. Both tasks incremented, but count only increased by 1, not 2.


actor SafeCounter {
    var count = 0

    func increment() {
        count += 1
    }

    func getCount() -> Int {
        return count
    }
}

func runSafeCounter() async {
    let counter = SafeCounter()

    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<1000 {
            group.addTask {
                await counter.increment()
            }
        }
    }

    print("Safe Counter Value: \(await counter.getCount())")
}

Task {
    await runSafeCounter()
}
