import UIKit
import SVEJSONObject

class ViewController: UITableViewController {

    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        loadJSONObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadJSONClassic() {
        do {
            guard let url = NSBundle.mainBundle().URLForResource("sample", withExtension: "json"),
                let JSONData = NSData(contentsOfURL: url),
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions()) as? Array<AnyObject> else
            {
                print("Sample.json not found")
                return
            }

            for item in json  {
                guard let user = item as? [String: AnyObject],
                    let id = user["id"] as? Int,
                    let name = user["name"] as? String,
                    let weight = user["weight"] as? Double else {
                        print("Unable to read json object")
                        return
                }
                print("\(id) : \(name)'s weight is \(weight)")
                data.append("\(id) : \(name)'s weight is \(weight)")
            }
        } catch {
            print(error)
            return
        }

    }

    func loadJSONObject() {

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
                print("\(id) : \(name)'s weight is \(weight).")
                data.append("\(id) : \(name)'s weight is \(weight)")
            }
        } catch {
            print(error)
            return
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}

