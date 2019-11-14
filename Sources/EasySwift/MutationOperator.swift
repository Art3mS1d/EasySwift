//
//  MutationOperator.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

/**
 Mutation operator.
 Examples:

 ```
 let label = UILabel() ~ {
    $0.textColor = .green
    $0.text = "Some text"
 }
 
 view.frame = label.frame ~ { $0.size.height += 100 }

 ```
 - parameter objectOrValue: Object that we want to modify.
 - parameter configure: Closure in witch it will be modified.
 - returns: Modified object or if it is value-typed it will return reconfigurated copy.
 */
@discardableResult
func ~ <T>(objectOrValue: T, configure: (inout T) throws -> Void) rethrows -> T {
    var objectOrCopy = objectOrValue
    try configure(&objectOrCopy)
    return objectOrCopy
}
infix operator ~ : AssignmentPrecedence
