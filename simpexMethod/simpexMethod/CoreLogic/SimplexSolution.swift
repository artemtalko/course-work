import Foundation


class SimplexSolution {
    var tableau: SimplexTableau
    var iterations: [SimplexTableau] = []
    
    init(tableau: SimplexTableau) {
        self.tableau = tableau
    }
    
    
    //MARK: solveWithIterations
    func solveWithIterations() -> (iterations: [SimplexTableau], solutionString: String) {
        var iteration = 0
        iterations.append(tableau.copy())
        
        while !isOptimal() && iteration < 100 {
            print("Iteration \(iteration):")
            tableau.printTableau()
            
            iteration += 1
            guard let pivot = findPivot() else { break }
            performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
            iterations.append(tableau.copy())
        }
        
        while hasFractionalSolution() && iteration < 20 {
            print("Before Gomory Cut:")
            tableau.printTableau()
            
            addGomoryCuts()
            
            print("After Gomory Cut:")
            tableau.printTableau()
            
            iteration += 1
            while !isOptimal() && iteration < 10 {
                iteration += 1
                guard let pivot = findPivot() else { break }
                performPivoting(pivotRow: pivot.row, pivotCol: pivot.col)
                iterations.append(tableau.copy())
            }
        }
        
        let solutionString = solutionAsString()
        return (iterations, solutionString)
    }
    
    
    private func isOptimal() -> Bool {
        let optimal = !tableau.deltaRow.contains { $0 < Fraction(0, 1) }
        print("Is optimal: \(optimal)")
        return optimal
    }
    
    
    //MARK: findPivot
    private func findPivot() -> (row: Int, col: Int)? {
        guard let pivotCol = tableau.deltaRow.enumerated().min(by: { $0.element < $1.element })?.offset else { return nil }
        
        var pivotRow: Int?
        var minRatio = Fraction(Int.max, 1)
        
        for i in 0..<tableau.matrix.count {
            let rhs = tableau.rhs[i]
            let element = tableau.matrix[i][pivotCol]
            if element > Fraction(0, 1) {
                let ratio = rhs / element
                if ratio < minRatio {
                    minRatio = ratio
                    pivotRow = i
                }
            }
        }
        
        guard let row = pivotRow else { return nil }
        print("Pivot found at row: \(row), col: \(pivotCol)")
        return (row, pivotCol)
    }
    
    //MARK: performPivoting
    private func performPivoting(pivotRow: Int, pivotCol: Int) {
        let pivotElement = tableau.matrix[pivotRow][pivotCol]
        print("Performing pivoting on row: \(pivotRow), col: \(pivotCol), pivotElement: \(pivotElement)")
        
        // Normalize the pivot row
        for j in 0..<tableau.matrix[pivotRow].count {
            tableau.matrix[pivotRow][j] = tableau.matrix[pivotRow][j] / pivotElement
        }
        tableau.rhs[pivotRow] = tableau.rhs[pivotRow] / pivotElement
        
        // Eliminate the pivot column entries in other rows
        for i in 0..<tableau.matrix.count {
            if i != pivotRow {
                let factor = tableau.matrix[i][pivotCol]
                for j in 0..<tableau.matrix[i].count {
                    tableau.matrix[i][j] = tableau.matrix[i][j] - factor * tableau.matrix[pivotRow][j]
                }
                tableau.rhs[i] = tableau.rhs[i] - factor * tableau.rhs[pivotRow]
            }
        }
        
        // Update the basis
        //MARK: Тут крашиться додаток, тому що виходить за межі масиву, але я не розумію чому і як це виправити
        //q: how to fix this?
        
        tableau.basis[pivotRow] = pivotCol
        
        tableau.updateBasisObjectiveCoefficients()
        
        let deltaFactor = tableau.deltaRow[pivotCol]
        for j in 0..<tableau.deltaRow.count {
            tableau.deltaRow[j] = tableau.deltaRow[j] - deltaFactor * tableau.matrix[pivotRow][j]
        }
    }
    
    //MARK: hasFractionalSolution
    private func hasFractionalSolution() -> Bool {
        for rhs in tableau.rhs {
            if rhs.numerator % rhs.denominator != 0 {
                return true
            }
        }
        print("Has fractional solution: \(String(describing: hasFractionalSolution))")
        return false
    }
    
    
    //MARK: addGomoryCuts
    private func addGomoryCuts() {
        for i in 0..<tableau.basisObjectiveCoefficients.count {
            if tableau.basisObjectiveCoefficients[i] != Fraction(0, 1) {
                print("->" + String(i))
                
                let rhs = tableau.rhs[i]
                
                let fractionalPart = rhs - Fraction(rhs.numerator / rhs.denominator, 1)
                
                if fractionalPart.numerator != 0 {
                    
                    // Add a new constraint
                    var newRow = tableau.matrix[i].map { element -> Fraction in
                        let fractionalPart = element - Fraction(element.numerator / element.denominator, 1)
                        return fractionalPart.numerator < 0 ? fractionalPart + Fraction(1, 1) : fractionalPart
                    }
                    
                    // Add the fractional part to the new row
                    if fractionalPart.numerator > 0 {
                        newRow.append(fractionalPart)
                    } else {
                        newRow.append(-fractionalPart)
                    }
                    
                    
                    // Add the new row to the tableau
                    newRow = newRow.map { $0 * Fraction(-1, 1) }
                    
                    // Add the new row to the tableau
                    tableau.matrix.append(newRow)
                    
                    
                    tableau.rhs.append(fractionalPart * Fraction(-1, 1))
                    
                    tableau.numberOfConstraints += 1
                    
                    for j in 0..<tableau.matrix.count {
                        if j != tableau.matrix.count - 1 {
                            tableau.matrix[j].append(Fraction(0, 1))
                        } else {
                            tableau.matrix[j].append(Fraction(1, 1))
                        }
                    }
                    
               //     tableau.updateBasisObjectiveCoefficients()
                    
                    let minIndex = findMinGamoryElement(tableau.matrix.last!)
                    
                    performPivoting(pivotRow: tableau.matrix.count - 1, pivotCol: minIndex)
                    //                    performPivoting(pivotRow: tableau.matrix.count - 1, pivotCol: minIndex)
                    iterations.append(tableau.copy())
                }
            }
        }
    }
    
    
    //MARK: findMinGamoryElement
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
        
        print("Min Gamory Element found at index: \(index)")
        return index
    }
    
    private func solutionAsString() -> String {
        var result = ""
        for i in 0..<tableau.matrix.count {
            result += tableau.matrix[i].map { $0.description }.joined(separator: "\t") + "\t|\t" + tableau.rhs[i].description + "\n"
        }
        result += "c: " + tableau.objectiveCoefficients.map { $0.description }.joined(separator: "\t") + "\n"
        result += "delta: " + tableau.deltaRow.map { $0.description }.joined(separator: "\t") + "\n"
        return result
    }
}
