//
//
//import Foundation
//
//enum VarType {
//    case slack
//    case artificial
//    case regular
//}
//
//class FractionNum {
//    var type: VarType
//    var value: Double // Використовуємо Double для представлення дробів
//    var name: String
//
//    init(type: VarType, value: Double, name: String = "") {
//        self.type = type
//        self.value = value
//        self.name = name
//    }
//}
//
//class VarNum {
//    var type: VarType
//    var value: Double
//    var name: String
//
//    init(type: VarType, value: Double, name: String = "") {
//        self.type = type
//        self.value = value
//        self.name = name
//    }
//}
//
//import Foundation
//
//class SimplexTable {
//    var c: [FractionNum]
//    var A: [[Double]]
//    var b: [Double]
//    var delta: [Double]
//    var basis: [FractionNum]
//
//    init(c: [FractionNum], A: [[Double]], b: [Double], basis: [FractionNum]) {
//        self.c = c
//        self.A = A
//        self.b = b
//        self.delta = Array(repeating: 0.0, count: c.count)
//        self.basis = basis
//    }
//
//    func solve(pivotColumnMin: Bool = false) -> SimplexTable {
//        let pivotColumn = getPivotColumn(min: pivotColumnMin)
//        let pivotRow = getPivotRow(pivotColumn: pivotColumn)
//        return pivot(pivotRow: pivotRow, pivotColumn: pivotColumn)
//    }
//
//    private func getPivotColumn(min: Bool) -> Int {
//        delta = getDelta()
//        let max = min ? delta.min() ?? 0.0 : delta.max() ?? 0.0
//        return delta.firstIndex(of: max) ?? -1
//    }
//
//    private func getPivotRow(pivotColumn: Int) -> Int {
//        let ratios = A.enumerated().map { (i, row) -> Double in
//            let value = row[pivotColumn]
//            return value > 0 ? b[i] / value : Double.greatestFiniteMagnitude
//        }
//        let min = ratios.min() ?? Double.greatestFiniteMagnitude
//        return ratios.firstIndex(of: min) ?? -1
//    }
//
//    func getDelta() -> [Double] {
//        return (0..<delta.count).map { i -> Double in
//            let sum = A.enumerated().reduce(0.0) { (result, element) -> Double in
//                let (j, row) = element
//                return result + basis[j].value * row[i]
//            }
//            return sum - c[i].value
//        }
//    }
//
//    func pivot(pivotRow: Int, pivotColumn: Int) -> SimplexTable {
//        var newA = [[Double]]()
//        var newB = [Double]()
//        for i in 0..<A.count {
//            if i == pivotRow {
//                newA.append(A[i].map { $0 / A[pivotRow][pivotColumn] })
//                newB.append(b[pivotRow] / A[pivotRow][pivotColumn])
//            } else {
//                newA.append(A[i].enumerated().map { (j, val) in
//                    val - (A[i][pivotColumn] * A[pivotRow][j] / A[pivotRow][pivotColumn])
//                })
//                newB.append(b[i] - (A[i][pivotColumn] * b[pivotRow] / A[pivotRow][pivotColumn]))
//            }
//        }
//        basis[pivotRow] = c[pivotColumn]
//        return SimplexTable(c: c, A: newA, b: newB, basis: basis)
//    }
//}
//
//
//import Foundation
//
//class SimplexMethod {
//    private var cVec: [FractionNum]
//    private var aMatrix: [[Double]]
//    private var bVec: [Double]
//    private var logMode: LogMode
//    private var table: SimplexTable
//    private var constraintTypes: [String]
//    private var numVars: Int
//    private var numConstraints: Int
//    private var basis: [FractionNum] = []
//    private var tables: [SimplexTable] = []
//
//    init(funcVec: [Double], conditionsMatrix: [[Double]], constraintsVec: [Double], constraintTypes: [String], logMode: LogMode = .logOff) {
//        // ВЕКТОР ФУНКЦІЇ
//        self.cVec = funcVec.enumerated().map { index in
//            FractionNum(type: .regular, value: index, name: "x\(index + 1)")
//        }
//        // МАТРИЦЯ УМОВ
//        self.aMatrix = conditionsMatrix
//        // ВЕКТОР УМОВ
//        self.bVec = constraintsVec
//        // ЗНАК УМОВ
//        self.constraintTypes = constraintTypes
//
//        self.logMode = logMode
//
//        self.numVars = cVec.count
//        self.numConstraints = aMatrix.count
//        self.table = SimplexTable(c: cVec, A: aMatrix, b: bVec, basis: [])
//        self.initializeSimplexTable()
//    }
//
//    private func initializeSimplexTable() {
//        // Add slack and artificial variables
//        for i in 0..<numConstraints {
//            var slack = Array(repeating: 0.0, count: numConstraints)
//            slack[i] = 1.0
//
//            if constraintTypes[i] == "<=" {
//                aMatrix = aMatrix.map { $0 + slack }
//                cVec.append(FractionNum(type: .slack, value: 0.0, name: "s\(i + 1)"))
//                basis.append(FractionNum(type: .slack, value: 0.0, name: "s\(i + 1)"))
//            } else if constraintTypes[i] == ">=" {
//                aMatrix = aMatrix.map { $0 + slack.map { -$0 } }
//                var artificial = Array(repeating: 0.0, count: numConstraints)
//                artificial[i] = 1.0
//                aMatrix = aMatrix.map { $0 + artificial }
//                cVec.append(FractionNum(type: .slack, value: 0.0, name: "s\(i + 1)"))
//                cVec.append(FractionNum(type: .artificial, value: 1.0, name: "a\(i + 1)"))
//                basis.append(FractionNum(type: .artificial, value: 1.0, name: "a\(i + 1)"))
//            }
//        }
//        table = SimplexTable(c: cVec, A: aMatrix, b: bVec, basis: basis)
//    }
//
//    func solve() -> [SimplexTable]? {
//        phaseOne()
//
//        if checkArtificialVarsOut() {
//            phaseTwo()
//            if !checkIfResultIsInteger() {
//                phaseThree()
//            }
//            return tables
//        } else {
//            print("No feasible solution.")
//            return nil
//        }
//    }
//
//    private func phaseOne() {
//        var artificialObj = table.c.map { $0.type != .artificial ? FractionNum(type: $0.type, value: 0.0, name: $0.name) : $0 }
//        table.c = artificialObj
//
//        while !checkArtificialVarsOut() {
//            tables.append(table.solve())
//        }
//    }
//
//    private func checkArtificialVarsOut() -> Bool {
//        return !table.basis.contains { $0.type == .artificial }
//    }
//
//    private func phaseTwo() {
//        table.c = cVec
//
//        for i in 0..<table.c.count {
//            if table.c[i].type == .artificial {
//                table.c.remove(at: i)
//                table.A = table.A.map { row in
//                    var newRow = row
//                    newRow.remove(at: i)
//                    return newRow
//                }
//                table.delta.remove(at: i)
//            }
//        }
//
//        while !isOptimal() {
//            tables.append(table.solve(pivotColumnMin: true))
//        }
//
//        getSolution()
//    }
//
//    private func phaseThree() {
//        var constraint: [Double] = []
//        var index = 0
//        for (i, basisVar) in table.basis.enumerated() {
//            if basisVar.type == .regular && !isInteger(number: table.b[i]) {
//                index = i
//                break
//            }
//        }
//
//        constraint = table.A[index].map { val in
//            let frac = val - floor(val)
//            return frac * -1.0
//        }
//
//        let numOfSlack = table.basis.filter { $0.type == .slack }.count
//        let newSlack = FractionNum(type: .slack, value: 1.0, name: "s\(numOfSlack + 1)")
//
//        var basis = table.b[index] - floor(table.b[index])
//        basis *= -1.0
//        table.b.append(basis)
//        table.basis.append(newSlack)
//        table.A.append(constraint)
//
//        table.c.append(FractionNum(type: .slack, value: 0.0, name: "s\(numOfSlack + 1)"))
//
//        while !isOptimal() {
//            tables.append(table.solve(pivotColumnMin: true))
//        }
//
//        getSolution()
//    }
//
//    private func isOptimal() -> Bool {
//        return table.getDelta().allSatisfy { $0 >= 0 }
//    }
//
//    private func getSolution() {
//        let vars = cVec.count - table.basis.filter { $0.type == .slack }.count
//        for i in 0..<vars {
//            let index = table.basis.firstIndex { $0.name == cVec[i].name }
//            cVec[i].value = index == nil ? 0 : table.b[index!]
//        }
//    }
//
//    private func isInteger(number: Double) -> Bool {
//        return floor(number) == number
//    }
//}
//
//enum LogMode {
//    case logOff
//    case logOn
//}
//
//
