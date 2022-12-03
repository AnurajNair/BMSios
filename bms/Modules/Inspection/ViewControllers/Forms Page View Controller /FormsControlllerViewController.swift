//
//  FormsControlllerViewController.swift
//  bms
//
//  Created by Naveed on 30/10/22.
//

import UIKit



class FormsControlllerViewController: UIViewController {

    //private var pageController: UIPageViewController?
  



    @IBOutlet weak var cutentView: UIView!
    var inspectionSections :[sections]? = [sections(section_name: "General", isSubSectionPresent: "false", subSections: [], questions: [question_ans(question: "Bridge Name", type: "text"),question_ans(question: "River Name", type: "text"),question_ans(question: "Name ofHighway", type: "text"),question_ans(question: "Highway No.", type: "text"),question_ans(question: "Bridge Location", type: "text")]),sections(section_name: "Approach", isSubSectionPresent: "false", subSections: [], questions: [question_ans(question: "Bridge Name", type: "text"),question_ans(question: "Bridge Name", type: "text"),question_ans(question: "Bridge Name", type: "option"),])]
    
    
    
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var progressSection: UICollectionView!
    
    let progressData = [1,2,3,4,5,6,7,8]
    
    var currentViewControllerIndex = 0
    
    var bridgeData:InspectionBridgeListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Data",bridgeData)

        self.view.backgroundColor = .lightGray
        
        self.setupPageController()
        self.setupProgressCollection()
    }
    
    private func setupPageController() {
        
        guard let pageController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else{
            return
        }
        //        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        //        self.pageController?.dataSource = self
        //        self.pageController?.delegate = self
        //        self.pageController?.view.backgroundColor = .clear
        //        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        //        self.addChild(self.pageController!)
        //        self.view.addSubview(self.pageController!.view)
        //
        //        let initialVC = BridgeDetailFormViewController(with: pages[0])
        //
        //        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        //
        
        
        //        self.pageController?.didMove(toParent: self)
        pageController.delegate = self
        pageController.dataSource = self
        
        addChild(pageController)
        pageController.didMove(toParent: self)
        pageController.view.translatesAutoresizingMaskIntoConstraints = true
        cutentView.addSubview(pageController.view)
        
        guard let startingView = detailViewControllerAt(index: currentViewControllerIndex) else{
            return
        }
        
        pageController.setViewControllers([startingView], direction: .forward, animated: true )
        
    }
    
    func setupProgressCollection(){
        self.progressSection.delegate = self
        self.progressSection.dataSource = self
        self.progressSection.registerNib(ProgressCollectionViewCell.identifier)
       // self.progressSection.registerNibs(["ProgressCollectionViewCell"])
       
    }
    
    func detailViewControllerAt(index:Int)-> UIViewController?{
        
//        if index >= self.pages.count || self.pages.count == 0{
//            return nil
//        }
//
//        guard let detailView = NavigationRoute.onboardingStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
//            return nil
//        }
//
//        detailView.index = index
        
        print(index)
       
        let viewController = NavigationRoute.inspectionsStoryboard().instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        let section = inspectionSections![index]
        viewController.formDetails = section
        return viewController
    }
    
    
    @IBAction func onPreviousBtnClick(_ sender: Any) {
    }
    
    @IBAction func onNextBtnClick(_ sender: Any) {
    }
    
    
    
}

extension FormsControlllerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
 
        guard let currentVC = viewController as? FormViewController else {
            return nil
        }
        
        var index = inspectionSections?.firstIndex(where: { section in
            section.section_name == currentVC.formDetails?.section_name
        })
        
        print("section",index)
//
        if index == 0 {
            return nil
        }

        index! -= 1
        self.currentViewControllerIndex = index!

        return self.detailViewControllerAt(index: self.currentViewControllerIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        

        
//        let cur = self.identifiers.index(of: viewController.restorationIdentifier)
//        print(viewController.restorationIdentifier)
//                // if you prefer to NOT scroll circularly, simply add here:
//                 if cur == (pages.count - 1) { return nil }
//
//        let nxt = cur &+ 1
//        print(nxt)
//        self.currentViewControllerIndex = nxt
        
        guard let currentVC = viewController as? FormViewController else {
            return nil
        }
        
        var index = inspectionSections?.firstIndex(where: { section in
            section.section_name == currentVC.formDetails?.section_name
        })
        
        if index! >= self.inspectionSections!.count - 1 {
            return nil
        }
        
        index! += 1
        self.currentViewControllerIndex = index!
        return self.detailViewControllerAt(index: self.currentViewControllerIndex)

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.inspectionSections?.count ?? 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentViewControllerIndex
    }
    
    
    
}


extension FormsControlllerViewController:UICollectionViewDelegate{
    
    
}

extension FormsControlllerViewController:UICollectionViewDataSource{


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inspectionSections!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else{
            return UICollectionViewCell()
        }
        
//        let section = self.inspectionSections![indexPath.section]
        
//        cell.progressLabel.text =  "ok"
        
        return cell
    }
    
    
}


