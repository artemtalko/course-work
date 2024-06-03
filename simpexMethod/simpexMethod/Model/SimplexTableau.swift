//
//  SimplexTableau.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import Foundation

struct SimplexTableau {
    var tableau: [[Decimal]]
    var numberOfVariables: Int
    var numberOfConstraints: Int
    
    init(c: [Decimal], A: [[Decimal]], b: [Decimal]) {
        self.numberOfVariables = c.count
        self.numberOfConstraints = b.count
        self.tableau = Array(repeating: Array(repeating: Decimal(0), count: numberOfVariables + numberOfConstraints + 1), count: numberOfConstraints + 1)
        
        for i in 0..<numberOfConstraints {
            for j in 0..<numberOfVariables {
                tableau[i][j] = A[i][j]
            }
            tableau[i][numberOfVariables + i] = 1
            tableau[i][numberOfVariables + numberOfConstraints] = b[i]
        }
        
        for j in 0..<numberOfVariables {
            tableau[numberOfConstraints][j] = -c[j]
        }
    }
    
    func getTableu() -> [[Decimal]] {
        for row in tableau {
            print(row.map { String(describing: $0) }.joined(separator: "\t"))
        }
        
        return tableau
    }
}
