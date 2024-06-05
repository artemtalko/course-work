////
////  LinearModel.swift
////  simpexMethod
////
////  Created by Artem Talko on 04.06.2024.
////
//import Foundation
//
//
//class LinearModel {
//    var A: Matrix<Double>
//    var b: Vector<Double>
//    var c: Vector<Double>
//    var x: [Double]
//    var minmax: String
//    var printIter: Bool
//    var optimalValue: Double?
//    var transform: Bool
//    var feasible: Bool
//    var bounded: Bool
//
//    init(A: Matrix<Double> = Matrix<Double>(rows: 0, columns: 0, initialValue: 0.0), b: Vector<Double> = Vector<Double>([]), c: Vector<Double> = Vector<Double>([]), minmax: String = "MAX") {
//        self.A = A
//        self.b = b
//        self.c = c
//        self.x = Array(repeating: 0.0, count: c.count)
//        self.minmax = minmax
//        self.printIter = true
//        self.optimalValue = nil
//        self.transform = false
//        self.feasible = true
//        self.bounded = false
//    }
//
//    func addA(_ A: Matrix<Double>) {
//        self.A = A
//    }
//
//    func addB(_ b: Vector<Double>) {
//        self.b = b
//    }
//
//    func addC(_ c: Vector<Double>) {
//        self.c = c
//        self.transform = false
//    }
//
//    func setObj(_ minmax: String) {
//        if minmax == "MIN" || minmax == "MAX" {
//            self.minmax = minmax
//        } else {
//            print("Invalid objective.")
//        }
//        self.transform = false
//    }
//
//    func setPrintIter(_ printIter: Bool) {
//        self.printIter = printIter
//    }
//
//    func printSoln() {
//        if feasible {
//            if bounded {
//                print("Coefficients: ")
//                print(x)
//                print("Optimal value: ")
//                print(optimalValue ?? 0)
//            } else {
//                print("Problem Unbounded; No Solution")
//            }
//        } else {
//            print("Problem Infeasible; No Solution")
//        }
//    }
//
//    func printTableau(_ tableau: Matrix<Double>) {
//        print("ind \t\t", terminator: "")
//        for j in 0..<c.count {
//            print("x_\(j)", terminator: "\t")
//        }
//        for j in 0..<(tableau.columns - c.count - 2) {
//            print("s_\(j)", terminator: "\t")
//        }
//
//        print()
//        for j in 0..<tableau.rows {
//            for i in 0..<tableau.columns {
//                if !tableau[j, i].isNaN {
//                    if i == 0 {
//                        print(Int(tableau[j, i]), terminator: "\t")
//                    } else {
//                        print(String(format: "%.2f", tableau[j, i]), terminator: "\t")
//                    }
//                } else {
//                    print(terminator: "\t")
//                }
//            }
//            print()
//        }
//    }
//
//    func getTableauPhase1() -> Matrix<Double> {
//        let numVar = c.count
//        let numArtificial = A.rows
//
//        let t1 = Vector<Double>([Double.nan, 0.0] + Array(repeating: 0.0, count: numVar + numArtificial))
//
//        var basis = Array(repeating: 0, count: numArtificial)
//        for i in 0..<basis.count {
//            basis[i] = numVar + i
//        }
//
//        var A = self.A
//        if A.columns != numVar + numArtificial {
//            let B = Matrix<Double>.identity(size: numArtificial)
//            A = A.concatenatingHorizontally(B)
//        }
//
//        let t2 = Matrix<Double>(rows: basis.count, columns: A.columns + 1, grid: basis.map { Double($0) } + A.grid)
//
//        var tableau = Matrix<Double>(rows: t1.count + 1, columns: t2.columns, grid: [Double](repeating: 0.0, count: (t1.count + 1) * t2.columns))
//        tableau.grid.replaceSubrange(0..<t1.count, with: t1.elements)
//        tableau.grid.replaceSubrange(t1.count..<tableau.grid.count, with: t2.grid)
//
//        for i in 1..<tableau.columns - numArtificial {
//            for j in 1..<tableau.rows {
//                if minmax == "MIN" {
//                    tableau[0, i] -= tableau[j, i]
//                } else {
//                    tableau[0, i] += tableau[j, i]
//                }
//            }
//        }
//
//        return tableau
//    }
//
//    func driveOutAV(_ tableau: Matrix<Double>) -> Matrix<Double> {
//        var tableau = tableau  // Change tableau to var
//        var avPresent = false
//        var avInd: [(Int, Bool)] = []
//
//        for i in 0..<tableau.columns {
//            if tableau[0, i] == 0.0 {
//                avPresent = true
//                var avInCol = false
//                for j in 1..<tableau.rows {
//                    if tableau[j, i] == 1.0 {
//                        avInCol = true
//                        break
//                    }
//                }
//                avInd.append((i, avInCol))
//            }
//        }
//
//        if avPresent {
//            avInd = avInd.filter { $0.1 }
//            if !avInd.isEmpty {
//                let columnsToDrop = avInd.map { $0.0 }
//                return tableau.dropColumns(numericRange: columnsToDrop[0]..<(columnsToDrop[0] + columnsToDrop.count))
//            }
//        }
//        return tableau
//    }
//
//    func getTableauPhase2(_ tableau: Matrix<Double>) -> Matrix<Double> {
//        var tableau = tableau  // Change tableau to var
//        let numVar = c.count
//
//        var t1 = Vector<Double>([Double.nan, 0.0] + c.elements)
//        var basis = [Int]()
//        for j in 1..<tableau.rows {
//            basis.append(Int(tableau[j, 0]))
//        }
//
//        for j in 1..<basis.count {
//            if basis[j - 1] < numVar {
//                t1[basis[j - 1] + 2] = b[j - 1]
//            }
//        }
//
//        for j in 1..<tableau.rows {
//            if basis[j - 1] >= numVar {
//                for i in 1..<t1.count {
//                    if minmax == "MIN" {
//                        t1[i - 1] -= tableau[0, Int(tableau[j, 0]) + 2] * tableau[j, i]
//                    } else {
//                        t1[i - 1] += tableau[0, Int(tableau[j, 0]) + 2] * tableau[j, i]
//                    }
//                }
//            }
//        }
//
//        for i in 1..<t1.count {
//            tableau[0, i] = t1[i - 1]
//        }
//
//        return tableau
//    }
//
//    func pivot(_ tableau: Matrix<Double>, _ row: Int, _ col: Int) -> Matrix<Double> {
//        var tableau = tableau  // Change tableau to var
//        let pivot = tableau[row, col]
//
//        for i in 0..<tableau.columns {
//            tableau[row, i] /= pivot
//        }
//
//        for i in 0..<tableau.rows {
//            if i != row {
//                let mult = tableau[i, col]
//                for j in 0..<tableau.columns {
//                    tableau[i, j] -= mult * tableau[row, j]
//                }
//            }
//        }
//
//        return tableau
//    }
//}
//
//// Example Usage
//
//let matrix = Matrix<Double>(rows: 3, columns: 3, initialValue: 1.0)
//let vector = Vector<Double>([1.0, 2.0, 3.0])
//let model = LinearModel(A: matrix, b: vector, c: vector, minmax: "MAX")
//
