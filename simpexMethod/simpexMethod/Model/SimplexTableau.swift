//
//  SimplexTableau.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import Foundation

struct SimplexTableau {
    var tableau: [[Fraction]]
    var numberOfVariables: Int
    var numberOfConstraints: Int

    init(c: [Fraction], A: [[Fraction]], b: [Fraction]) {
        self.numberOfVariables = c.count
        self.numberOfConstraints = b.count
        self.tableau = Array(repeating: Array(repeating: Fraction(0, 1), count: numberOfVariables + numberOfConstraints + 1), count: numberOfConstraints + 1)

        for i in 0..<numberOfConstraints {
            for j in 0..<numberOfVariables {
                tableau[i][j] = A[i][j]
            }
            tableau[i][numberOfVariables + i] = Fraction(1, 1)
            tableau[i][numberOfVariables + numberOfConstraints] = b[i]
        }

        for j in 0..<numberOfVariables {
            tableau[numberOfConstraints][j] = -c[j]
        }
    }

    func getTableau() -> [[Fraction]] {
        for row in tableau {
            print(row.map { $0.description }.joined(separator: "\t"))
        }
        return tableau
    }
}
