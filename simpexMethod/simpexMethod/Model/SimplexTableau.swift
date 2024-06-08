//
//  SimplexTableau.swift
//  simpexMethod
//
//  Created by Artem Talko on 02.06.2024.
//

import Foundation

struct SimplexTableau {
    var tableau: [[Fraction]]
    var numberOfConstraints: Int
    var numberOfVariables: Int
    
    init(c: [Fraction], A: [[Fraction]], b: [Fraction]) {
        let numberOfConstraints = A.count
        let numberOfVariables = c.count
        
        var tableau = A
        
        // Add slack variables
        for i in 0..<numberOfConstraints {
            for j in 0..<numberOfConstraints {
                tableau[i].append(Fraction(i == j ? 1 : 0, 1, .slack))
            }
            tableau[i].append(b[i])
        }
        
        // Add objective function row
        var objectiveFunctionRow = c.map { Fraction(-$0.numerator, $0.denominator, $0.varType) }
        for _ in 0..<numberOfConstraints {
            objectiveFunctionRow.append(Fraction(0, 1, .slack))
        }
        objectiveFunctionRow.append(Fraction(0, 1, .regular))
        tableau.append(objectiveFunctionRow)
        
        self.tableau = tableau
        self.numberOfConstraints = numberOfConstraints
        self.numberOfVariables = numberOfVariables
    }
}
