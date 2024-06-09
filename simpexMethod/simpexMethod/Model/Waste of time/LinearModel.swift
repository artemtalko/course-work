//import Foundation
//
//enum MinMaxFunction: String {
//    case min = "min"
//    case max = "max"
//}
//
//enum EqualitySign: String {
//    case equal = "="
//    case greaterThanOrEqual = ">="
//    case lessThanOrEqual = "<="
//}
//
//enum VarType: String {
//    case slack = "s"
//    case artificial = "a"
//    case regular = "x"
//}
//
//enum LogMode {
//    case logOff
//    case mediumLog
//    case fullLog
//}
//
//protocol Vector: Collection where Element: Any {}
//protocol Matrix: Collection where Element: Vector {}
//
//class FractionNum {
//    var type: VarType
//    var value: Fraction
//    var name: String
//    
//    init(type: VarType, value: Fraction, name: String = "") {
//        self.type = type
//        self.value = value
//        self.name = name
//    }
//}
//
//class SimplexTable {
//    var c: [FractionNum]
//    var A: [[Fraction]]
//    var b: [Fraction]
//    var delta: [Fraction] = []
//    var basis: [FractionNum] = []
//    
//    init(c: [FractionNum], A: [[Fraction]], b: [Fraction], basis: [FractionNum]) {
//        self.c = c
//        self.A = A
//        self.b = b
//        self.basis = basis
//        self.delta = Array(repeating: Fraction.zero, count: c.count)
//    }
//    
//    func solve(pivotColumnMin: Bool = false) -> Table {
//        let pivotColumn = getPivotColumn(min: pivotColumnMin)
//        let pivotRow = getPivotRow(pivotColumn: pivotColumn)
//        return pivot(pivotRow: pivotRow, pivotColumn: pivotColumn)
//    }
//    
//    private func getPivotColumn(min: Bool) -> Int {
//        delta = getDelta()
//        let maxVal = min ? delta.map { $0.decimalValue }.min() : delta.map { $0.decimalValue }.max()
//        return delta.firstIndex(where: { $0.decimalValue == maxVal }) ?? -1
//    }
//    
//    public func reverseSimplex() -> Table {
//        return self as! Table
//    }
//    
//    private func getPivotRow(pivotColumn: Int) -> Int {
//        let ratios = A.enumerated().map { (i, row) -> Fraction in
//            return row[pivotColumn].decimalValue > 0 ? b[i] / row[pivotColumn] : Fraction.greatestFiniteMagnitude
//        }
//        let minVal = ratios.map { $0.decimalValue }.min()
//        return ratios.firstIndex(where: { $0.decimalValue == minVal }) ?? -1
//    }
//    
//    public func getDelta() -> [Fraction] {
//        return c.indices.map { i in
//            let sum = A.enumerated().reduce(Fraction.zero) { acc, j in
//                let basis = self.basis[j.offset].value
//                let a = self.A[j.offset][i]
//                return acc + basis * a
//            }
//            return sum - c[i].value
//        }
//    }
//    
//    private func pivot(pivotRow: Int, pivotColumn: Int) -> Table {
//        var newA: [[Fraction]] = []
//        var newB: [Fraction] = []
//        
//        for i in A.indices {
//            if i == pivotRow {
//                newA.append(A[i].map { $0 / A[pivotRow][pivotColumn] })
//                newB.append(b[pivotRow] / A[pivotRow][pivotColumn])
//            } else {
//                newA.append(A[i].enumerated().map { (j, val) in
//                    val - (A[i][pivotColumn] * A[pivotRow][j]) / A[pivotRow][pivotColumn]
//                })
//                newB.append(b[i] - (A[i][pivotColumn] * b[pivotRow]) / A[pivotRow][pivotColumn])
//            }
//        }
//        
//        basis[pivotRow] = c[pivotColumn]
//        self.b = newB
//        self.A = newA
//        
//        return Table(c: c, A: newA, b: newB, delta: delta, basis: basis)
//    }
//    
//    public func getSolution(numVars: Int) {
//        print(basis)
//        print(b)
//        print(A)
//    }
//}
//
//class SimplexMethod {
//    private var cVec: [FractionNum]
//    private var aMatrix: [[Fraction]]
//    private var bVec: [Fraction]
//    private var logMode: LogMode
//    private var table: SimplexTable
//    private var constraintTypes: [String]
//    private var numVars: Int
//    private var numConstraints: Int
//    private var basis: [FractionNum] = []
//    private var tables: [Table] = []
//    
//    init(funcVec: [Any], conditionsMatrix: [[Any]], constraintsVec: [Any], constraintTypes: [String], logMode: LogMode = .logOff) {
//        self.cVec = funcVec.enumerated().map { (index, val) in
//            FractionNum(type: .regular, value: Fraction(val), name: "x\(index + 1)")
//        }
//        self.aMatrix = conditionsMatrix.map { row in
//            row.map { Fraction($0) }
//        }
//        self.bVec = constraintsVec.map { Fraction($0) }
//        self.constraintTypes = constraintTypes
//        self.logMode = logMode
//        self.numVars = cVec.count
//        self.numConstraints = aMatrix.count
//        self.table = SimplexTable(c: cVec, A: aMatrix, b: bVec, basis: [])
//        self.initializeSimplexTable()
//    }
//    
//    private func initializeSimplexTable() {
//        for i in 0..<numConstraints {
//            var slack = Array(repeating: Fraction.zero, count: numConstraints)
//            slack[i] = Fraction.one
//            
//            if constraintTypes[i] == "<=" {
//                aMatrix = aMatrix.map { $0 + [slack[$0.count]] }
//                cVec.append(FractionNum(type: .slack, value: Fraction.zero, name: "s\(i + 1)"))
//                basis.append(FractionNum(type: .slack, value: Fraction.zero, name: "s\(i + 1)"))
//            } else if constraintTypes[i] == ">=" {
//                aMatrix = aMatrix.map { $0 + [slack[$0.count] * Fraction(-1)] }
//                var artificial = Array(repeating: Fraction.zero, count: numConstraints)
//                artificial[i] = Fraction.one
//                aMatrix = aMatrix.map { $0 + [artificial[$0.count]] }
//                cVec.append(FractionNum(type: .slack, value: Fraction.zero, name: "s\(i + 1)"))
//                cVec.append(FractionNum(type: .artificial, value: Fraction.one, name: "a\(i + 1)"))
//                basis.append(FractionNum(type: .artificial, value: Fraction.one, name: "a\(i + 1)"))
//            }
//        }
//        print(aMatrix)
//        print(cVec)
//        table = SimplexTable(c: cVec, A: aMatrix, b: bVec, basis: basis)
//    }
//    
//    public func solve() -> [[Table]?] {
//        phaseOne()
//        if checkArtificialVarsOut() {
//            phaseTwo()
//            if !checkIfResultIsInteger() {
//                phaseThree()
//            }
//            return [tables]
//        } else {
//            print("No feasible solution.")
//            return [nil]
//        }
//    }
//    
//    private func phaseOne() {
//        let artificialObj = table.c.map { el -> FractionNum in
//            if el.type != .artificial {
//                return FractionNum(type: el.type, value: Fraction.zero, name: el.name)
//            } else {
//                return FractionNum(type: el.type, value: el.value, name: el.name)
//            }
//        }
//        
//        table.c = artificialObj
//        while !checkArtificialVarsOut() {
//            tables.append(table.solve())
//        }
//    }
//    
//    private func checkArtificialVarsOut() -> Bool {
//        return table.basis.first(where: { $0.type == .artificial }) == nil
//    }
//    
//    private func phaseTwo() {
//        table.c = cVec
//        for i in stride(from: table.c.count - 1, through: 0, by: -1) {
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
//        for element in table.c {
//            for j in 0..<table.basis.count {
//                if table.basis[j].name == element.name {
//                    table.basis[j] = element
//                }
//            }
//        }
//        while !isOptimal() {
//            tables.append(table.solve(pivotColumnMin: true))
//        }
//        
//        getSolution()
//    }
//    
//    private func phaseThree() {
//        var constraint: [Fraction] = []
//        var index = 0
//        for (i, basisElement) in table.basis.enumerated() {
//            if basisElement.type == .regular && !basisElement.value.isInteger {
//                index = i
//                break
//            }
//        }
//        
//        constraint.append(contentsOf: table.A[index].map { Fraction($0.value - floor($0.value)) * -1 })
//        let numOfSlack = table.basis.filter { $0.type == .slack }.count
//        let newSlack = FractionNum(type: .slack, value: Fraction.one, name: "s\(numOfSlack + 1)")
//        
//        var basis = Fraction(table.b[index].value - floor(table.b[index].value))
//        basis *= -1
//        table.b.append(basis)
//        table.basis.append(newSlack)
//        table.c.append(newSlack)
//        table.delta.append(Fraction.zero)
//        table.A.append(constraint)
//        for i in table.A.indices {
//            if i != table.A.count - 1 {
//                table.A[i].append(Fraction.zero)
//            } else {
//                table.A[i].append(Fraction.one)
//            }
//        }
//        table.reverseSimplex()
//        print(table.A)
//    }
//    
//    private func checkIfResultIsInteger() -> Bool {
//        return table.basis.allSatisfy { element in
//            element.type != .regular || element.value.isInteger
//        }
//    }
//    
//    private func isOptimal() -> Bool {
//        return table.getDelta().allSatisfy { $0.decimalValue >= 0 }
//    }
//    
//    public func getSolution() {
//        table.getSolution(numVars: numVars)
//    }
//}
//
//class Table {
//    var c: [FractionNum]
//    var A: [[Fraction]]
//    var b: [Fraction]
//    var delta: [Fraction]
//    var basis: [FractionNum]init(c: [FractionNum], A: [[Fraction]], b: [Fraction], delta: [Fraction], basis: [FractionNum]) {
//        self.c = c
//        self.A = A
//        self.b = b
//        self.delta = delta
//        self.basis = basis
//    }
//}
//
//class VarNum {
//    private var type: VarType
//    private var value: Double
//    private var name: String
//    init(type: VarType, value: Double, name: String = "") {
//        self.type = type
//        self.value = value
//        self.name = name
//    }
//    
//    var type: VarType {
//        get { return self.type }
//    }
//    
//    var value: Double {
//        get { return self.value }
//        set { self.value = newValue }
//    }
//    
//    var name: String {
//        get { return self.name }
//    }
//}
