
import Foundation

//var callbackNew: (String) -> Void = {}

func getProjectDetails(projectID: String, callBack: @escaping (String) -> Void) {
    //callbackNew = callBack
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        callBack("Project Details")
    }
    
}
