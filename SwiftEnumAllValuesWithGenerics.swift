protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator() {
                // withUnsafePointer: Take a pointer to a Swift managed memory 
                // withMemoryRebound: a function that will convert a pointer from a type to a different one
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(cases())
    }
}

enum Weekdays: String, EnumCollection {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

for weekday in Weekdays.cases() {
    print(weekday.rawValue)
}

print(Weekdays.allValues.map {$0.rawValue.capitalized})