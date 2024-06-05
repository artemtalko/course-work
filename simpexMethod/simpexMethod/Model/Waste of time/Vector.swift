////
////  Vector.swift
////  simpexMethod
////
////  Created by Artem Talko on 04.06.2024.
////
//
//import Foundation
//
//struct Vector<T> {
//    var elements: [T]
//
//    init(_ elements: [T]) {
//        self.elements = elements
//    }
//
//    var count: Int {
//        return elements.count
//    }
//
//    subscript(index: Int) -> T {
//        get {
//            return elements[index]
//        }
//        set {
//            elements[index] = newValue
//        }
//    }
//
//    func allSatisfy(_ predicate: (T) -> Bool) -> Bool {
//        return elements.allSatisfy(predicate)
//    }
//
//    func contains(where predicate: (T) -> Bool) -> Bool {
//        return elements.contains(where: predicate)
//    }
//
//    func enumerated() -> EnumeratedSequence<[T]> {
//        return elements.enumerated()
//    }
//}
