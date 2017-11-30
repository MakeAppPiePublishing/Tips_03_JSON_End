//:# JSON Codable
//: An Example of JSON coding and decoding
import UIKit

//:## A JSON file
//: Here I used a string converted into a data object for the example JSON
var myJSON = """
{
    "name":"Huli Pizza Company",
    "rating": 5,
    "locations":["Hilo","Honolulu","Waimea","Lihue"],
    "best_Menu_Item":{"item":"Huli Chicken Pizza","price":14.95},
    "menuItems": [
        {"item":"Huli Chicken Pizza","price":14.95},
        {"item":"Coconut Gelato","price":5.95},
        {"item":"Kona Coffee","price":4.95}
    ]
}
""".data(using: .utf8)!


//:## Structs
//: The two structs adopting the `Codable` protocol. I nest the `MenuItem` inside the `Restaurant` struct. You must adopt `Codable` for this to work.
struct MenuItem : Codable {
    var item:String
    var price:Double
}

struct Restaurant : Codable{
    var name: String
    var rating: Int
    var locations:[String]
    var bestMenuItem:MenuItem
    var menuItems:[MenuItem]
    
    private enum CodingKeys : String, CodingKey {
        case name
        case rating
        case locations
        case bestMenuItem = "best_Menu_Item"
        case menuItems
    }
}

//:## Encoding and Decoding
//: Two functions to encode and decode the datarespectively.

func encodeJSON(restaurant:Restaurant!)-> Data! {
    var data:Data! = nil
    let encoder = JSONEncoder()
    data = try? encoder.encode(restaurant)
    return data
}

func decodeJSON(data:Data!)-> Restaurant! {
    var restaurant:Restaurant! = nil
    let decoder = JSONDecoder()
    do{
        try restaurant = decoder.decode(Restaurant.self, from: data)
    } catch let error as NSError{
        print("Error reading JSON file: \(error.localizedDescription)")
    }
    return restaurant
}


//: A function to display the information
func printRestaurant(restaurant:Restaurant!){
    if let restaurant = restaurant{
        print("------------------------- \(restaurant.name)\t")
        print("Rating: \(restaurant.rating) Slices\n")
        print("Locations:")
        for location in restaurant.locations{
            print("\t\(location)")
        }
        print("Menu Items")
        for item in restaurant.menuItems{
            print ("\t\(item.item).....$\(item.price)")
        }
        print("You should really try the \(restaurant.bestMenuItem.item)")
    } else {
        print("No restaurant found")
    }
}

//: Experimental area to run our functions

let brandi = Restaurant(name: "Pizzeria Brandi", rating: 8, locations: ["Naples"], bestMenuItem: MenuItem(item: "Pizza Margherita", price: 12.50), menuItems: [MenuItem(item: "Pizza Margherita", price: 12.50)])
let restaurant  = encodeJSON(restaurant: brandi)
printRestaurant(restaurant: decodeJSON(data: restaurant))
printRestaurant(restaurant: decodeJSON(data: myJSON))

