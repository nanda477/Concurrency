//: [Previous](@previous)

import Foundation

/*
 DispatchWorkItem()
 1.Encapsulation
 2.Wait/Notify
 3.Priority Level
    * .userInteractive
    * .userInitiative
    * .utility
    * .background
 4.Cancel
 5.Modify
 */



//MARK: - 1. Encapsulation
//old:
//DispatchQueue.global().async {
//    sleep(2)
//    print("This is not a Encapsulation")
//}

//New

//let workItem = DispatchWorkItem {
//    sleep(2)
//    print("This is a Encapsulation")
//}
//
//DispatchQueue.global().async(execute: workItem)
//
//
////MARK: -  2.Wait/Notify
////before Wait
//DispatchQueue.global().async {
//    sleep(2)
//    print("I have not waited for Encapsulation to complete")
//}
////workItem.wait()
//
//
////Notify
////workItem.notify(queue: .main) {
////    print("Encapsulation work is Completed")
////}
//
//DispatchQueue.global().async {
//    sleep(1)
//    print("I have waited for Encapsulation to completed")
//}
//
////MARK: - 3.Priority Level
//
//let workItem1 = DispatchWorkItem(qos: .userInteractive) {
//    sleep(2)
//    print("userInteractive is Completed")
//}
//
//let workItem2 = DispatchWorkItem(qos: .userInitiated) {
//    sleep(2)
//    print("userInitiated is Completed")
//}
//
//let workItem3 = DispatchWorkItem(qos: .utility) {
//    sleep(0)
//    print("utility is Completed")
//}
//
//let workItem4 = DispatchWorkItem(qos: .background) {
//    sleep(1)
//    print("background is Completed")
//}
//
//let wiQ = DispatchQueue(label: "com.pl.ios")
//
//wiQ.async(execute: workItem1)
//wiQ.async(execute: workItem2)
//wiQ.async(execute: workItem3)
//wiQ.async(execute: workItem4)

//MARK: -  4.Cancel

var workItem5 = DispatchWorkItem {
    sleep(4)
    print("workItem5 is completed")
}
print("workItem5 is Started")
DispatchQueue.global().async(execute: workItem5)

//workItem5.cancel()
//
//if workItem5.isCancelled {
//    print("workItem5 got cancelled")
//}


//MARK: - 5.Modify
workItem5 = DispatchWorkItem {
    // update if required
    sleep(2)
    print("workItem5 updated with new requirement")
}

DispatchQueue.global().async(execute: workItem5)
