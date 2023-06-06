//
//  ViewController.swift
//  AppList
//
//  Created by iOS on 13/01/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var feed:Feed?
    
    var arrApps:[Entry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionViewUI()
        
        NetworkManager.shared.getAppDlist(for: AppList.self, completion: { result in
            print("result",result)
            
            switch result {
            case .success(let success):
                self.feed = success.feed
                self.arrApps = success.feed?.entry ?? []
            case .failure(let failure):
                print("error:\(failure.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }

    func setupCollectionViewUI(){
        
        let layout = PinterestLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: CustomCollectionCell.identifire, bundle: nil), forCellWithReuseIdentifier: CustomCollectionCell.identifire)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.identifire, for: indexPath) as! CustomCollectionCell
        let obj = self.arrApps[indexPath.row]

        if let imgDetails = obj.imImage?.last,let strImgUrl = imgDetails.label {
            
            let strAppname = obj.imName?.label ?? ""
            if let imgUrl = URL(string: strImgUrl) {
                FileCaching.shared.loadFileAsync(url: imgUrl, fileDirectoryPath: "LocalImages/\(strAppname)", filename: imgUrl.lastPathComponent) { isSucess, localFilePath in
                    
                    DispatchQueue.main.async {
                        if let url = localFilePath {
                            if let imageData = try? Data(contentsOf: url) {
                                if let loadedImage = UIImage(data: imageData) {
                                    cell.imgView.image = loadedImage
                                }
                            }
                        }
                    }
                }
            }
        }
        
        cell.setupCelldata(feed: obj)
        return cell
        
    }
    
}



extension ViewController : PinterestLayoutDelegate {
   
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        
        let obj = self.arrApps[indexPath.row]
        let imgHeight = calculateImageHeight(sourceImage: obj.imImage , scaledToWidth: cellWidth)
        
        let textHeight = requiredHeight(text: obj.title?.label ?? "", cellWidth: (cellWidth - 10))

        let cellHeight = (imgHeight + textHeight)
        return cellHeight
        
    }
    
    func calculateImageHeight (sourceImage:[IMImage]?, scaledToWidth: CGFloat) -> CGFloat {
        if let imgDetails = sourceImage?.last {
            let height: Float = Float(imgDetails.attributes?.height ?? "") ?? 0
            let scaleFactor = scaledToWidth / CGFloat(height)
            let newHeight = CGFloat(height) * scaleFactor
            return newHeight
        } else {
            return 10
        }
       
    }
    
    func requiredHeight(text:String , cellWidth : CGFloat) -> CGFloat {

        let font = UIFont(name: "Helvetica", size: 16.0)
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height

    }
}
