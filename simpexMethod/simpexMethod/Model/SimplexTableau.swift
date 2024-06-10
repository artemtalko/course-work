//
//  SimplexTableau.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import Foundation


class SimplexTableau {
    var objectiveCoefficients: [Fraction]
    var basis: [Int]
    var matrix: [[Fraction]]
    var rhs: [Fraction]
    var deltaRow: [Fraction]
    var basisObjectiveCoefficients: [Fraction]
    var pivotSearchingString: [String]?
    
    var numberOfConstraints: Int
    var numberOfVariables: Int
    
    init(c: [Fraction], A: [[Fraction]], b: [Fraction], deltaRow: [Fraction], pivotSearchingString: [String]? = nil) {
        self.numberOfConstraints = A.count
        self.numberOfVariables = c.count
        
        self.pivotSearchingString = pivotSearchingString
        self.objectiveCoefficients = c
        self.basis = Array(numberOfVariables..<(numberOfVariables + numberOfConstraints))
        self.matrix = A
        self.rhs = b
        self.deltaRow = deltaRow
        self.basisObjectiveCoefficients = Array(repeating: Fraction(0, 1), count: numberOfConstraints) // Ініціалізація
        
        updateBasisObjectiveCoefficients()
    }
    
    func updateBasisObjectiveCoefficients() {
        for i in 0..<basis.count {
            let basisIndex = basis[i]
            if basisIndex < objectiveCoefficients.count {
                basisObjectiveCoefficients[i] = objectiveCoefficients[basisIndex]
            } else {
                basisObjectiveCoefficients[i] = Fraction(0, 1)
            }
        }
    }

    

    func copy() -> SimplexTableau {
        let c = objectiveCoefficients.map { $0 }
        let A = matrix.map { $0.map { $0 } }
        let b = rhs.map { $0 }
        let deltaRow = self.deltaRow.map { $0 }
        let basisObjectiveCoefficients = self.basisObjectiveCoefficients.map { $0 }
        let pivotSearchingString = self.pivotSearchingString.map { $0 }
        
        let copyTableau = SimplexTableau(c: c, A: A, b: b, deltaRow: deltaRow, pivotSearchingString: pivotSearchingString)
        copyTableau.basisObjectiveCoefficients = basisObjectiveCoefficients
        
        return copyTableau
    }
    
    func printTableau() {
        
        
        print("Simplex table:")
        
        print("\nMatrix (A):")
        for i in 0..<matrix.count {
            let rowString = matrix[i].map { $0.description }.joined(separator: "\t | \t")
            print("\(rowString)\t | \t RHS: \(rhs[i].description)")
        }
        
        print("\nC coefs:")
        print(objectiveCoefficients.map { $0.description }.joined(separator: "\t | \t"))
        
        print("\nDelta row (delta):")
        print(deltaRow.map { $0.description }.joined(separator: "\t | \t"))
        
        print("\nBasis Objective Coefficients:")
        print(basisObjectiveCoefficients.map { $0.description }.joined(separator: "\t | \t"))
        
        print("\nBasis Indices:")
        print(basis.map { "\($0)" }.joined(separator: "\t | \t"))
    }

}
