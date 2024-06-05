import UIKit

class SimplexSolution {
    var tableau: SimplexTableau
    var iterations: [[[Decimal]]] = []

    init(tableau: SimplexTableau) {
        self.tableau = tableau
    }

    func solveWithIterations() -> (iterations: [[[Decimal]]], solutionString: String) {
        var iteration = 0
        iterations.append(tableau.tableau)
        
        while !isOptimal() && iteration < 100 {
            iteration += 1
            guard let pivot = findPivot() else { break }
            performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
            iterations.append(tableau.tableau)
        }

        while hasFractionalSolution() && iteration < 100 {
            addGomoryCuts()
            iteration += 1
            while !isOptimal() && iteration < 100 {
                iteration += 1
                guard let pivot = findPivot() else { break }
                performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
                iterations.append(tableau.tableau)
            }
        }

        let solutionString = solutionAsString()
        print("Solution after applying Gomory cuts:")
        print(SimplexTableau.getTableu(tableau))

        return (iterations, solutionString)
    }

    private func isOptimal() -> Bool {
        let lastRow = tableau.tableau.last!
        return !lastRow.contains { $0 < 0 }
    }

    private func findPivot() -> (row: Int, col: Int)? {
        guard let pivotCol = tableau.tableau.last?.enumerated().min(by: { $0.element < $1.element })?.offset else {
            return nil
        }

        var pivotRow: Int?
        var minRatio: Decimal = Decimal.greatestFiniteMagnitude

        for i in 0..<tableau.numberOfConstraints {
            let rhs = tableau.tableau[i].last!
            let element = tableau.tableau[i][pivotCol]
            if element > 0 {
                let ratio = rhs / element
                if ratio < minRatio {
                    minRatio = ratio
                    pivotRow = i
                }
            }
        }

        guard let row = pivotRow else { return nil }
        return (row, pivotCol)
    }

    private func performPivoting(pivotRow: Int, pivotCol: Int) {
        let pivotElement = tableau.tableau[pivotRow][pivotCol]
        for j in 0..<tableau.tableau[pivotRow].count {
            tableau.tableau[pivotRow][j] /= pivotElement
        }

        for i in 0..<tableau.tableau.count {
            if i != pivotRow {
                let factor = tableau.tableau[i][pivotCol]
                for j in 0..<tableau.tableau[i].count {
                    tableau.tableau[i][j] -= factor * tableau.tableau[pivotRow][j]
                }
            }
        }
    }

    private func hasFractionalSolution() -> Bool {
        for i in 0..<tableau.numberOfConstraints {
            let rhs = tableau.tableau[i].last!
            let rhsDouble = NSDecimalNumber(decimal: rhs).doubleValue
            let fractionalPart = rhsDouble - floor(rhsDouble)
            if fractionalPart != 0 {
                return true
            }
        }
        return false
    }

    private func addGomoryCuts() {
        for i in 0..<tableau.numberOfConstraints {
            print(i)
            let rhs = tableau.tableau[i].last!
            let rhsDouble = NSDecimalNumber(decimal: rhs).doubleValue
            let fractionalPart = rhsDouble - floor(rhsDouble)

            if fractionalPart != 0 {
                var newRow = tableau.tableau[i].map { Decimal(NSDecimalNumber(decimal: $0).doubleValue - floor(NSDecimalNumber(decimal: $0).doubleValue)) }
                newRow[newRow.count - 1] = Decimal(fractionalPart)

                tableau.tableau.append(newRow + [Decimal(0)])
                tableau.numberOfConstraints += 1

                for j in 0..<tableau.tableau.count {
                    tableau.tableau[j].append(j == tableau.tableau.count - 1 ? Decimal(1) : Decimal(0))
                }

                return
            }
        }
    }

    private func solutionAsString() -> String {
        var result = ""
        for row in tableau.tableau {
            result += row.map { String(describing: $0) }.joined(separator: "\t") + "\n"
        }
        return result
    }
}
