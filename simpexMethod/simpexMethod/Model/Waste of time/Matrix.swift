////
////  Matrix.swift
////  simpexMethod
////
////  Created by Artem Talko on 04.06.2024.
////
//
//import Foundation
//
//
//struct Matrix<T> {
//    var rows: Int
//    var columns: Int
//    var grid: [T]
//
//    init(rows: Int, columns: Int, initialValue: T) {
//        self.rows = rows
//        self.columns = columns
//        self.grid = Array(repeating: initialValue, count: rows * columns)
//    }
//
//    init(rows: Int, columns: Int, grid: [T]) {
//        self.rows = rows
//        self.columns = columns
//        self.grid = grid
//    }
//
//    init(_ data: [[T]]) {
//        self.rows = data.count
//        self.columns = data[0].count
//        self.grid = data.flatMap { $0 }
//    }
//
//    subscript(row: Int, column: Int) -> T {
//        get {
//            return grid[(row * columns) + column]
//        }
//        set {
//            grid[(row * columns) + column] = newValue
//        }
//    }
//
//    static func identity(size: Int) -> Matrix<Double> where T == Double {
//        var grid = [Double](repeating: 0.0, count: size * size)
//        for i in 0..<size {
//            grid[i * size + i] = 1.0
//        }
//        return Matrix<Double>(rows: size, columns: size, grid: grid)
//    }
//
//    func concatenatingHorizontally(_ matrix: Matrix<Double>) -> Matrix<Double> where T == Double {
//        var newGrid = [Double]()
//        for i in 0..<rows {
//            newGrid.append(contentsOf: grid[(i * columns)..<(i * columns + columns)])
//            newGrid.append(contentsOf: matrix.grid[(i * matrix.columns)..<(i * matrix.columns + matrix.columns)])
//        }
//        return Matrix<Double>(rows: rows, columns: columns + matrix.columns, grid: newGrid)
//    }
//
//    func dropColumns(numericRange: Range<Int>) -> Matrix<Double> where T == Double {
//        var newGrid = [Double]()
//        for i in 0..<rows {
//            for j in 0..<columns {
//                if !numericRange.contains(j) {
//                    newGrid.append(grid[i * columns + j])
//                }
//            }
//        }
//        return Matrix<Double>(rows: rows, columns: columns - numericRange.count, grid: newGrid)
//    }
//
//    func dropRows(_ rowIndices: [Int]) -> Matrix<Double> where T == Double {
//        var newGrid = [Double]()
//        for i in 0..<rows {
//            if !rowIndices.contains(i) {
//                newGrid.append(contentsOf: grid[(i * columns)..<(i * columns + columns)])
//            }
//        }
//        return Matrix<Double>(rows: rows - rowIndices.count, columns: columns, grid: newGrid)
//    }
//}
