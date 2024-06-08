//
//  Fraction.swift
//  simpexMethod
//
//  Created by Artem Talko on 05.06.2024.
//

import Foundation

struct Fraction: CustomStringConvertible, Comparable {
    var numerator: Int
    var denominator: Int
    var varType: VariableType?

    init(_ numerator: Int, _ denominator: Int, _ varType: VariableType? = nil) {
        let gcd = Fraction.gcd(abs(numerator), abs(denominator))
        self.numerator = numerator / gcd
        self.denominator = denominator / gcd
        self.varType = varType
        
        if self.denominator < 0 {
            self.numerator = -self.numerator
            self.denominator = -self.denominator
        }
    }

    static func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }

    var description: String {
        return "\(numerator)/\(denominator)"
    }

    static func + (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator, lhs.denominator * rhs.denominator)
    }

    static func - (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator, lhs.denominator * rhs.denominator)
    }

    static func * (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.numerator, lhs.denominator * rhs.denominator)
    }

    static func / (lhs: Fraction, rhs: Fraction) -> Fraction {
        return Fraction(lhs.numerator * rhs.denominator, lhs.denominator * rhs.numerator)
    }

    static prefix func - (fraction: Fraction) -> Fraction {
        return Fraction(-fraction.numerator, fraction.denominator)
    }

    static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
    }

    static func == (lhs: Fraction, rhs: Fraction) -> Bool {
        return lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
    }
}
