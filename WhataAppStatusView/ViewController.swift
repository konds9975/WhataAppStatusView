

import UIKit
import AnimatedCollectionViewLayout

class SimpleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
}
class ViewController: UICollectionViewController {
    
    
    var currentIndexPath : IndexPath!
    var cureentIndex  : Int!
    var progressBarValue : Int?
    var timer : Timer!
    var currentCell : SimpleCollectionViewCell!
    @IBOutlet var dismissGesture: UISwipeGestureRecognizer!
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    let imagesArray = ["test1","test2","test3","test1","test4","test5","test6"]
    let cellIdentifier = "SimpleCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.navigationBar.isHidden = true
       
        animator = (CubeAttributesAnimator(), true, 1, 1)
        //animator = (LinearCardAttributesAnimator(), false, 1, 1)
        
        
        collectionView?.isPagingEnabled = true
        
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
        
        dismissGesture.direction = direction == .horizontal ? .down : .left
    }
   
    @IBAction func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? SimpleCollectionViewCell
        {
            cureentIndex = 0
            currentIndexPath = IndexPath(row: 1, section: 0)
            currentCell = cell
            progressBarValue = 0
            currentCell.progressBar.setProgress(0, animated: false)
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(callback), userInfo: nil, repeats: true)
            
        }
    }
   
    
    
    
   
    override var prefersStatusBarHidden: Bool { return true }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SimpleCollectionViewCell
        cell.progressBar.setProgress(0, animated: false)
        cell.titleLabel.image = UIImage(named: imagesArray[indexPath.row])
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: view.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = collectionView?.indexPathForItem(at: center)
        {
            let indexPath = IndexPath(row: ip.row, section: 0)
            if let cell = collectionView?.cellForItem(at: indexPath) as? SimpleCollectionViewCell
            {
                
                    if(indexPath.row == imagesArray.count-1)
                    {
                      cureentIndex = imagesArray.count-1
                    }
                    else
                    {
                        cureentIndex = indexPath.row
                    }
                    currentIndexPath = IndexPath(row: ip.row, section: 0)
                    progressBarValue = 0
                    currentCell = cell
                    currentCell.progressBar.setProgress(0, animated: false)
                
                
               
            }
          
        }
    }
    func callback()
    {
        
            if(currentCell.progressBar.progress == 1.0)
            {
                
                currentCell.progressBar.setProgress(1.0, animated: true)
                progressBarValue = 0
                
                if(cureentIndex<imagesArray.count)
                {
                collectionView?.scrollToItem(
                at: IndexPath(row: cureentIndex!, section: 0),at: .centeredHorizontally,
                animated: false)
                
                if let cell = collectionView?.cellForItem(at:IndexPath(row: cureentIndex!, section: 0)) as? SimpleCollectionViewCell
                {
                    cureentIndex = cureentIndex + 1
                    currentIndexPath = IndexPath(row: cureentIndex, section: 0)
                    currentCell = cell
                    progressBarValue = 0
                    
                }
                }
                
            }
            else
            {
                progressBarValue = progressBarValue! + 1
                let percentProgress = Float(Float(progressBarValue!)*0.01)
                currentCell.progressBar.setProgress(percentProgress, animated: true)
            }
        }
    
    
}


//  private let animators: [(LayoutAttributesAnimator, Bool, Int, Int)] = [(ParallaxAttributesAnimator(), true, 1, 1),
//                                                                               (ZoomInOutAttributesAnimator(), true, 1, 1),
//                                                                               (RotateInOutAttributesAnimator(), true, 1, 1),
//                                                                               (LinearCardAttributesAnimator(), false, 1, 1),
//                                                                               (CubeAttributesAnimator(), true, 1, 1),
//                                                                               (CrossFadeAttributesAnimator(), true, 1, 1),
//                                                                               (PageAttributesAnimator(), true, 1, 1),
//                                                                               (SnapInAttributesAnimator(), true, 2, 4)]

