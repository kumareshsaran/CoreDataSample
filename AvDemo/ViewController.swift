//
//  ViewController.swift
//  AvDemo
//
//  Created by CSS on 21/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import CoreData

class ViewController: UIViewController {

    @IBOutlet var audioTableView: UITableView!
    
    @IBOutlet var progressBar: UIProgressView!
    
    
    var entity : NSEntityDescription!
    var newData : NSManagedObject!
    //var context : NSManagedObjectContext!
    
    var videocalss = [Videos]()
    
    var videoObj : Videos?
    
    var context:NSManagedObjectContext = {
        return AppDelegate.shared.persistentContainer.viewContext
    }()
 //   let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // context = appdelegate.persistentContainer.viewContext
        self.progressBar.progress = 0.0
       //createEntity()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func createEntity(){
        entity = NSEntityDescription.entity(forEntityName: "Videos", in: context)
        newData = NSManagedObject(entity: entity, insertInto: context)
    }
    
    func fetchvalue(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Videos")
        request.returnsObjectsAsFaults = false
        do {
            let resultdata = try context.fetch(request)
            print("coredata response : \(resultdata)")
        }catch {
            
        }
    }
    
    func downloadImage() {
        
        
        Alamofire.request("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4").downloadProgress(closure: {(process) in
            
            
            
        }).responseData { (response) in
            
        }
        Alamofire.request("https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4").downloadProgress(closure: { (progress) in
            print(progress.fractionCompleted)
            
            
            self.progressBar.progress = Float(progress.fractionCompleted)
            
        }).responseData { (response) in
            print(response.result)
            print(response.result.value)
            
            if let data = response.result.value {
                
                
                if self.videoObj == nil {
                    
                    self.videoObj = NSEntityDescription.insertNewObject(forEntityName: "Videos", into: self.context) as? Videos
                    self.videoObj?.url = data as NSData
                }
               self.save()
                
                self.getValue()
               // self.imgView.image = UIImage(data: data)
            }
            
            
            
        }
        
        
        
    }
    
    func save(){
        do {
            try self.context.save()
        }catch{
            print("failed")
        }
    }
    
    func getValue(){
        let fetchVideoValue = Videos.fetch()
        fetchVideoValue.returnsObjectsAsFaults = false
        
        do {
            self.videocalss = try context.fetch(fetchVideoValue)
            
            print("final value: \(videocalss.count)")
        }catch{
            
        }
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        
        downloadImage()
    }
    
    
    
}



class AudioCell: UITableViewCell {
    
    @IBOutlet var progressBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
