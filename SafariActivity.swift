import UIKit

public class SafariActivity: UIActivity {
    public var URL: NSURL?
    
    public override func activityType() -> String? {
        return "SafariActivity"
    }
    
    public override func activityTitle() -> String? {
        // load value from main bundle to enable overwriting title
        let frameworkBundle = NSBundle(forClass: self.dynamicType)
        let mainBundle = NSBundle.mainBundle()
        let defaultString = frameworkBundle.localizedStringForKey("Open in Safari", value: "Open in Safari", table: nil)
        return mainBundle.localizedStringForKey("Open in Safari", value: defaultString, table: nil)
    }
    
    public override func activityImage() -> UIImage? {
        let frameworkBundle = NSBundle(forClass: self.dynamicType)
        var image: UIImage? 
        
        if let path = frameworkBundle.pathForResource("safari", ofType: "png") {
            image = UIImage(contentsOfFile: path)
        }
        
        return image
    }
    
    public override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        var canPerform = false
        
        for activityItem in activityItems {
            if let URL = activityItem as? NSURL {
                if UIApplication.sharedApplication().canOpenURL(URL) {
                    canPerform = true
                    break
                }
            }
        }
        
        return canPerform
    }
    
    public override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if let URL = activityItem as? NSURL {
                self.URL = URL
                break
            }
        }
    }
    
    public override func performActivity() {
        var completed = false
        
        if let URL = URL {
            completed = UIApplication.sharedApplication().openURL(URL)
        }
        
        activityDidFinish(completed)
    }
}
