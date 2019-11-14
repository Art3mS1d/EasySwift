# EasySwift

Collection of some Swift tweaks.

## Mutation Operator

Example:
```swift
static let durationFormatter = DateComponentsFormatter() ~ {
    $0.allowedUnits = .minute
    $0.calendar = .current ~ { $0.locale = preferredLocale }
    $0.unitsStyle = .full
}
``` 
Same as:
```swift
static let durationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = .minute
    var calendar = Calendar.current
    calendar.locale = preferredLocale
    formatter.calendar = calendar
    formatter.unitsStyle = .full
    return formatter
}()
``` 
## Sequence + KeyPath

Example:
```swift
let filenames = resources.flatMap(\.items).map(\.filename)
let sorted = videos.sorted(by: \.resolution)
let total = files.sum(\.size)
```
Same as:
```swift
let filenames = resources.flatMap { $0.items }.map { $0.filename }
let sorted = videos.sorted { $0.resolution < $1.resolution }
let total = files.reduce(0) { $0 + $1.size }
```


## Observable

```swift
class Model {

    @Observable
    var searchText = ""
}

// to store subscription
var searchObservation: Observation?

// to subscribe
model.$searchText { text in
    ...
}.dispose(in: &searchObservation)

// to send
model.searchText = "hi"

// to unsubscribe
searchObservation = nil
```

## CoreData

```swift
// Query objects of type File where filename are in list and sorted by size
let files = Query<File>.all(\.filename ~= filenames, by: \.size, in: context)

// Query recently created File
let recent = Query<File>.any(by: \.createdAt, descending: true, in: context)

// Delete entries where object downloaded and size above 10 MB
Query<File>.delete(\.downloaded == true && \.size > 10.MB, in: context)
```

## Basic Metrics

```swift
URLCache(memoryCapacity: 1.MB, diskCapacity: 20.MB, directory: url)
Timer.scheduledTimer(withTimeInterval: 5.minutes, repeats: true) { ...
if changeDate < Date() - 2.hours { ...
```

## UIColor + Hex

```swift
// To initialise with hex:
UIColor("#33ff55")
// or:
UIColor(0x33ff55)

// To get hex from color:
let hex = color.hexString
```

## UICollectionView + Type

```swift
collectionView.register(FontCell.self)
let cell: FontCell = collectionView.dequeue(for: indexPath)
```
