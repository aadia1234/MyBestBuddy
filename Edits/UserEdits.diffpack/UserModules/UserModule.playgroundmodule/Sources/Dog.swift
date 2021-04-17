
import SwiftUI

public struct Dog {
    
    enum Size {
        case small, medium, large
    }
    
    enum Trait {
        case protective, friendly
    }
    
    
    let name: String?
    let image: UIImage?
    let relativeSize: Size
    let doesShed: Bool
    let personality: Trait
    
    init(_ name: String?, _ image: UIImage?, _ relativeSize: Size, doesShed: Bool, _ personality: Trait) {
        self.name = name
        self.image = image
        self.relativeSize = relativeSize
        self.doesShed = doesShed
        self.personality = personality
    }
    
    init(_ relativeSize: Any, _ doesShed: Any, _ personality: Any) {
        self.init(nil, nil, relativeSize as! Size, doesShed: doesShed as! Bool, personality as! Trait)
    }
    
    public static func compareDogs(_ dog1: Dog, _ dog2: Dog) -> Bool {
        return (dog1.relativeSize == dog2.relativeSize && dog1.doesShed == dog2.doesShed && dog1.personality == dog2.personality) ? true : false
    }
    
}
