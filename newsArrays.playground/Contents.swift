import UIKit

//let a = ["a1", "a2", "a3"]
//let b = ["b1", "b2"]
//let c = ["c1", "c2", "c3", "c4"]
//
//func merge<T>(_ arrays: [T]...) -> [T] {
//    guard let longest = arrays.max(by: { $0.count < $1.count })?.count else { return [] }
//    var result = [T]()
//    for index in 0..<longest {
//        for array in arrays {
//            guard index < array.count else { continue }
//            result.append(array[index])
//        }
//    }
//    return result
//}
//
//
//print(merge(a, b, c))  // ["a1", "b1", "c1", "a2", "b2", "c2", "a3", "c3", "c4"]

enum Dates: CaseIterable {
    case month(Int?)
    case day(Int?)
    case hour(Int?)
    case minute(Int?)
    
    var title: String {
        switch self {
        case .month(let month):
            return month != nil ?"\(month ?? 0) month ago": ""
        case .day(let month):
            return month != nil ?"\(month ?? 0) day ago": ""
        case .hour(let month):
            return month != nil ?"\(month ?? 0) hour ago": ""
        case .minute(let month):
            return month != nil ?"\(month ?? 0) minute ago": ""
        }
    }
    
}

extension Date {
    
    func differenceDate() -> String {
        let calendar = Calendar.current
        let month = Dates.month(calendar.dateComponents([.month], from: self, to: .now).month)
        let day = Dates.day(calendar.dateComponents([.day], from: self, to: .now).day)
        let hour = Dates.hour(calendar.dateComponents([.hour], from: self, to: .now).hour)
        let minute = Dates.minute(calendar.dateComponents([.minute], from: self, to: .now).minute)
        
        let result = []
        
        return ""
    }
    
}

let  b = [nil, 6, 7, 3, nil, 0]
let t = b.compactMap()
