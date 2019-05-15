//
//  ImageViewController.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url = "https://fonpin.space/wp-content/uploads/2019/02/1693c5a9abee123ccaf3536969a8a870.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    func fetchImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: url) { (image) in
            
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchDataWithAlomofire() {
        
        request(url).responseData { (responsData) in
            
            switch responsData.result {
                
            case .success(let data):
                
                guard let image = UIImage(data: data) else { return }
                
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
