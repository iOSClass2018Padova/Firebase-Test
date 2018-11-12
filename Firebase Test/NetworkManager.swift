//
//  NetworkManager.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CodableFirebase

class NetworkManager {
    
    private static var db: Firestore?
    private static var storageRef : StorageReference?
    
    private static var listeners: [String : ListenerRegistration] = [:]
    
    
    static func initFirebase() {
        
        FirebaseApp.configure()
        
        db = Firestore.firestore()
        storageRef = Storage.storage().reference()
    }
    
    static func login(email: String, password: String, completion: @escaping (Bool) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error?.localizedDescription, closeAction: {
                    completion(false)
                }), animated: true, completion: nil)
                
                
                return
                
            }
            
            debugPrint(user)
            completion(true)
        }
        
    }
    
    static func checkLoggeduser(completion: @escaping (Bool) -> ()) {
        
        if let user = Auth.auth().currentUser {
            user.reload(completion: { (error) in
                if error != nil {
                    UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error?.localizedDescription, closeAction: {
                        completion(false)
                    }), animated: true, completion: nil)
                } else {
                    completion(true)
                }
            })
        } else {
            completion(false)
        }
    }
    
    static func logout(completion: @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            removeAllListener()
            completion(true)
        } catch let error as NSError {
            print ("Error signing out: %@", error)
            
            UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: {
                completion(false)
            }), animated: true, completion: nil)
            
            
        }
    }
    
    private static func removeAllListener() {
    
        listeners.forEach { (key, listener) in
            listener.remove()
        }
        
    }
    
    static func signup(email: String, password: String, completion: @escaping (Bool) -> ()) {
    
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            guard let user = authResult?.user else {
                
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error?.localizedDescription, closeAction: {
                    completion(false)
                }), animated: true, completion: nil)
                
                return
                
            }
            debugPrint(user)
            completion(true)
        }
        
    }
    
    static func uploadUserInfo(name: String = "", surname: String = "", imageURL: String = "", age: Int = -1, gender: Int = -1, email : String, completion: @escaping (Bool) -> ()) {
        
        guard let db = db, let user = Auth.auth().currentUser else { completion(false); return }
        
        db.collection("users").document(user.uid).setData([
            "id": user.uid,
            "name": name,
            "surname": surname,
            "email": email,
            "imageURL": imageURL,
            "age": age,
            "gender": gender
        ], merge: true) { error in
            if let error = error {
                
                print("Error writing document: \(error)")
                
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: {
                    completion(false)
                }), animated: true, completion: nil)
                
            } else {
                print("Document successfully written!")
                completion(true)
            }
        }
        
    }
    
    static func getUser(completion: @escaping (Bool) -> ()) {
        
        guard let db = db, let user = Auth.auth().currentUser else { completion(false); return }
        
        
        let docRef = db.collection("users").document(user.uid)
        
        listeners["users"] = docRef.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists, let dataDocument = document.data() {
                
                do {
                    
                    try FirebaseDecoder().decode(User.self, from: dataDocument).save()
                    completion(true)
                    
                } catch let error {
                    
                    UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: {
                        completion(false)
                    }), animated: true, completion: nil)
                    
                    
                }
                
            } else {
                print("Error getting documents: \(String(describing: error))")
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: R.string.localizable.kErorr(), message: error?.localizedDescription, closeAction: {
                    completion(false)
                }), animated: true, completion: nil)
            }
        }
        
    }
    
    
    static func uploadImageProfile(withData data: Data, forUserID id: String, completion: @escaping (String?) -> ()) {
        
        guard let storageRef = storageRef else { completion(nil); return }
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("profileImages/\(id).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                completion(nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            debugPrint(size)
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completion(nil)
                    return
                }
                
                debugPrint(downloadURL)
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    static func dowloadImageProfile(withURL url: String, completion: @escaping (UIImage?) -> ()) {
        
        // Create a reference from an HTTPS URL
        // Note that in the URL, characters are URL escaped!
        let httpsReference = Storage.storage().reference(forURL: url)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                debugPrint(error)
                completion(nil)
            } else {
                // Data for "images/island.jpg" is returned
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
        }
        
    }

}

