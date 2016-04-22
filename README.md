# SVEJSONObject

[![CI Status](http://img.shields.io/travis/SergioEstevao/SVEJSONObject.svg?style=flat)](https://travis-ci.org/SergioEstevao/SVEJSONObject)
[![Version](https://img.shields.io/cocoapods/v/SVEJSONObject.svg?style=flat)](http://cocoapods.org/pods/SVEJSONObject)
[![License](https://img.shields.io/cocoapods/l/SVEJSONObject.svg?style=flat)](http://cocoapods.org/pods/SVEJSONObject)
[![Platform](https://img.shields.io/cocoapods/p/SVEJSONObject.svg?style=flat)](http://cocoapods.org/pods/SVEJSONObject)


JSONObject is a simple JSON deserializer using Swift. 

The implementation is minimal but very expressive easily extendable. 
One of the main features is the handling and trackdown of errors in the json objects. 

## Usage

To read a json file like this

```json
[
  {
    "id": 1,
    "name": "Sergio",
    "weight": 70.5,
    "photos": []
  },
  {
    "id": 2,
    "name": "Miguel",
    "weight": 65.5,
    "photos": [{
             "url": "http://fake.com/miguel.jpeg",
             "width": 100,
             "height": 200
             }]
  }
]

```

You simple need to do this

```swift
    guard let url = NSBundle.mainBundle().URLForResource("sample", withExtension: "json") else {
        print("Sample.json not found")
        return
    }

    do {
        let users = try JSONObject(url: url)
        for user in users {
            let id = try user["id"].int()
            let name = try user["name"].string()
            let weight = try user["weight"].double()
            print("\(id) : \(name)'s weight is \(weight)")
        }
    } catch {
        print(error)
        return
    }
```

### Initialization

JSONObject can be initialized with an instance of AnyObject?, NSData? or NSURL

```swift
let jsonFromAnyObject = try JSONObject(json:object) // where object is an instance of AnyObject?
let jsonFromNSData = try JSONObject(data:data) // where data is an instance of NSData
let jsonFromNSURL = try JSONObject(url: url) // where url is an instance of NSURL

```

### Accessing JSON values

You can access JSON values by using subscripts.

#### Using subscript

Use a subscript with an integer or a string key depending on whether the JSON is an array or a dictionary.

```swift
let user = try users[0]
let name = try user["name"]
```
#### Chaining subscript calls

Each subscript call returns an instance of JSONObject to allow chaining.

```swift
let name = try users[0]["name"]
```

#### Iterating over a JSON array

If the underlying JSON object is an array, you can iterate over it.

```swift
for user in users {
    let name = try user["name"]
}
```

#### Acessing JSON values

After you interate to the right location you can use any of these functions to get the final object

 * dictionary()
 * array()
 * string()
 * int()
 * float()
 * double()
 * bool()
 * null()

JSONObject also provides an helper method to covert to NSDate
 
 * dateWithFormater(formmatter) 

#### Error handling

It any of the keys doesn't exist, an index is out of bounds or the type is incorrect JSONObject will trown a JSONValidationError
that shows the type of error and where it happened

```swift
do {
  let name = try users[0]["fullname"] // that's fine too
} catch {
  print(error)//Prints Root[0]: Missing "fullname" element in dictionary.
}
```

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

 * iOS 8 and above

## Installation

SVEJSONObject is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SVEJSONObject"
```

## Author

Sérgio Estêvão, sergio.estevao@gmail.com

## License

SVEJSONObject is available under the MIT license. See the LICENSE file for more info.
