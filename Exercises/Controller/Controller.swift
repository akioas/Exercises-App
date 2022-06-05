import Foundation

func dates(for date: Date) -> (start: Date, end: Date){
    let startDate = Calendar.current.startOfDay(for: date)
    var components = DateComponents()
    components.day = 1
    components.second = -1
    let endDate = Calendar.current.date(byAdding: components, to: startDate)!
    return (startDate, endDate)
}

