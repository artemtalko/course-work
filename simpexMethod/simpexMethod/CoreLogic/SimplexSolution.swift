import UIKit

class SimplexSolution {
    
    var tableau: SimplexTableau
    var iterations: [[[Fraction]]] = []
    
    init(tableau: SimplexTableau) {
        self.tableau = tableau
    }
    
    func solveWithIterations() -> (iterations: [[[Fraction]]], solutionString: String) {
        var iteration = 0
        iterations.append(tableau.tableau)
        
        // Основний цикл симплекс-методу
        while !isOptimal() && iteration < 100 {
            iteration += 1
            guard let pivot = findPivot() else { break }
            performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
            iterations.append(tableau.tableau)
        }
        
        // Додатковий цикл для відсічення Гоморі
      //  while hasFractionalSolution() && iteration < 20 {
            print("Before Gomory Cut:")
            printTableau()
            
            addGomoryCuts()
            
            print("After Gomory Cut:")
            printTableau()
            
//            iteration += 1
//            while !isOptimal() && iteration < 10 {
//                iteration += 1
//                guard let pivot = findPivot() else { 
//                    break
//                }
//                performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
//                iterations.append(tableau.tableau)
//            }
  //      }
        
        let solutionString = solutionAsString()
        
       // print(iterations)
        return (iterations, solutionString)
    }
    
    private func isOptimal() -> Bool {
        guard let lastRow = tableau.tableau.last else { return false }
        return !lastRow.contains { $0 < Fraction(0, 1) }
    }
    
    private func findPivot() -> (row: Int, col: Int)? {
        guard let lastRow = tableau.tableau.last else { return nil }
        guard let pivotCol = lastRow.enumerated().min(by: { $0.element < $1.element })?.offset else {
            return nil
        }
        
        var pivotRow: Int?
        var minRatio = Fraction(Int.max, 1)
        
        for i in 0..<tableau.numberOfConstraints {
            let rhs = tableau.tableau[i].last!
            let element = tableau.tableau[i][pivotCol]
            if element > Fraction(0, 1) {
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
        checkRowLengths()
        
        let pivotElement = tableau.tableau[pivotRow][pivotCol]
        
        // Нормалізація опорного рядка
        for j in 0..<tableau.tableau[pivotRow].count {
            tableau.tableau[pivotRow][j] = tableau.tableau[pivotRow][j] / pivotElement
        }
        
        // Оновлення всіх інших рядків
        for i in 0..<tableau.tableau.count {
            if i != pivotRow {
                let factor = tableau.tableau[i][pivotCol]
                for j in 0..<tableau.tableau[i].count {
                    tableau.tableau[i][j] = tableau.tableau[i][j] - factor * tableau.tableau[pivotRow][j]
                }
            }
        }
    }
    
    private func hasFractionalSolution() -> Bool {
        for i in 0..<tableau.numberOfConstraints {
            let rhs = tableau.tableau[i].last!
            if rhs.numerator % rhs.denominator != 0 {
                return true
            }
        }
        return false
    }
    
    private func addGomoryCuts() {
        for i in (0..<tableau.numberOfConstraints).reversed() {
            let rhs = tableau.tableau[i].last!
            let fractionalPart = rhs - Fraction(rhs.numerator / rhs.denominator, 1)
            
            if fractionalPart.numerator != 0 {
                var newRow = tableau.tableau[i].map { element -> Fraction in
                    let fractionalPart = element - Fraction(element.numerator / element.denominator, 1)
                    return fractionalPart.numerator < 0 ? fractionalPart + Fraction(1, 1) : fractionalPart
                }
                
                if fractionalPart.numerator > 0 {
                    newRow[newRow.count - 1] = fractionalPart
                } else {
                    newRow[newRow.count - 1] = -fractionalPart
                }
                
                newRow = newRow.map { $0 * Fraction(-1, 1) }
                
                let deltaRowIndex = tableau.tableau.count - 1
                tableau.tableau.insert(newRow, at: deltaRowIndex)
                //tableau.numberOfConstraint це кількість обмежень
                tableau.numberOfConstraints += 1
                
                //tableau.tableau.count це кількість рядків
                //deltaRowIndex це індекс рядка, який ми додали
                // j це індекс рядка, який ми додаємо
                
                for j in 0..<tableau.tableau.count {
                    if j != deltaRowIndex {
                        tableau.tableau[j].append(Fraction(0, 1))
                        print(tableau.tableau[j])
                    } else {
                        tableau.tableau[j].append(Fraction(1, 1))
                        print(tableau.tableau[j])
                    }
                }
                for i in 0..<tableau.tableau.count {
                    let rowCount = tableau.tableau[i].count
                    if rowCount >= 2 {
                        let lastIndex = rowCount - 1
                        let secondLastIndex = rowCount - 2
                        (tableau.tableau[i][lastIndex], tableau.tableau[i][secondLastIndex]) = (tableau.tableau[i][secondLastIndex], tableau.tableau[i][lastIndex])
                    }
                }
                print("->")
                print(tableau.tableau[deltaRowIndex])
                
                let minIndex = findMinGamoryElement(tableau.tableau[deltaRowIndex])
              
                performPivoting(pivotRow: deltaRowIndex, pivotCol: minIndex)

                iterations.append(tableau.tableau)
                
                
                return
            }
        }
    }
    
    private func findMinGamoryElement(_ newLine: [Fraction]) -> Int {
        guard !newLine.isEmpty else { fatalError("Array is empty") }
        
        var minElement: Double = abs(Double(newLine.last!.numerator) / Double(newLine.last!.denominator))
        var index: Int = newLine.startIndex
        
        for i in stride(from: newLine.endIndex - 1, through: 0, by: -1) {
            let element = abs(Double(newLine[i].numerator) / Double(newLine[i].denominator))
            if element <= minElement && element != 0 {
                minElement = element
                index = i
            }
        }
        
        return index
    }




    private func solutionAsString() -> String {
        var result = ""
        for row in tableau.tableau {
            result += row.map { $0.description }.joined(separator: "\t") + "\n"
        }
        return result
    }
    
    private func printTableau() {
        for row in tableau.tableau {
            print(row.map { $0.description }.joined(separator: "\t"))
        }
    }
    
    private func checkRowLengths() {
        let columnCount = tableau.tableau[0].count
        for row in tableau.tableau {
            if row.count != columnCount {
                fatalError("Row length mismatch detected!")
            }
        }
    }
}
