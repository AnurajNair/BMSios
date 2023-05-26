//
//  FormsControlllerViewController.swift
//  bms
//
//  Created by Naveed on 30/10/22.
//

import UIKit



class FormsControlllerViewController: UIViewController {
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)

    @IBOutlet weak var formTitleLabel: UILabel!
    @IBOutlet weak var cutentView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progressSection: UICollectionView!
    
    var pageController: CustomPageViewController?
    var pages: [FormViewController] = []

    var currentViewControllerIndex = 0
    var questionnaireForm:InspectionQuestionnaire?
    var inspectionType: InspectionType?
    var isCurrentVcLast: Bool {
        let count = questionnaireForm?.sections.count
        guard let count = count, count > 0 else {
            return currentViewControllerIndex == count
        }
        return currentViewControllerIndex == count - 1
    }

    private lazy var router = InspctionRouterManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupView()
        setupPageController()
        setupProgressCollection()
    }

    private func setupView() {
        UILabel.style([(view: formTitleLabel, style: TextStyles.ScreenHeaderTitle)])
        formTitleLabel.text =  inspectionType == .review ? "Review Inspection Form " : "Inspection Form"
        setNextButtonTitle()
    }

    private func setupPageController() {
        guard let pageController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else{
            return
        }
        self.pageController = pageController
        pageController.delegate = self
        
        addChild(pageController)
        cutentView.addSubview(pageController.view)
        pageController.view.frame = cutentView.bounds
        pageController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageController.didMove(toParent: self)

        guard let startingView = detailViewControllerAt(index: currentViewControllerIndex) else{
            return
        }
        pageController.setViewControllers([startingView], direction: .forward, animated: true )
    }
    
    func setupProgressCollection(){
        self.progressSection.delegate = self
        self.progressSection.dataSource = self
        self.progressSection.registerNib(ProgressCollectionViewCell.identifier)
    }
    
    func detailViewControllerAt(index:Int)-> FormViewController? {
        if index < pages.count {
           return pages[index]
        }
        let viewController = NavigationRoute.inspectionsStoryboard().instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        guard index < questionnaireForm?.sections.count ?? 0 else { return viewController }
        let section = questionnaireForm?.sections[index]
        viewController.formDetails = section
        pages.append(viewController)
        return viewController
    }
    
    @IBAction func onPreviousBtnClick(_ sender: Any) {
        view.endEditing(true)
        guard currentViewControllerIndex > 0 else {
            return
        }
        currentViewControllerIndex -= 1
        movePage(direction: .reverse)
        setNextButtonTitle()
    }
    
    @IBAction func onNextBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        guard isCurrentVcLast else {
            saveData()
            return
        }
        saveData()
        currentViewControllerIndex += 1
        movePage(direction: .forward)
        setNextButtonTitle()
    }

    func setNextButtonTitle() {
        nextBtn.setTitle(isCurrentVcLast ? "Submit" : "Save & Continue", for: .normal)
    }

    func saveData() {
        if inspectionType == .inspect {
            saveInspection(status: isCurrentVcLast ? .submitted : .draft, index: currentViewControllerIndex)
        } else if inspectionType == .review {
            saveReview(status: isCurrentVcLast ? .reviewed : .submitted, index: currentViewControllerIndex)
        }
    }
    func saveInspection(status: InspectionStatus, index: Int) {
        let saveRequest = SaveInspectionRequestModel()
        saveRequest.inspectionAssignId = questionnaireForm?.id
        saveRequest.inspectionStatus = status.rawValue
        var responses: [[String: Any]] = []
        guard index < questionnaireForm?.sections.count ?? 0,
                let section = questionnaireForm?.sections[index] else {
            return
        }
        section.subSections.forEach { subSection in
            subSection.questions.forEach { question in
                let response = ["questionid" : question.questionId,
                                "response": question.response ?? "",
                                "rating" : question.rating.description,
                                "files" : []
                                ]
                responses.append(response)
            }
        }
        saveRequest.response = responses
        router.saveInspection(params: APIUtils.createAPIRequestParams(dataObject: saveRequest)) { response in
            print("response - \(response.status) - \(response.message ?? "" )")
            guard status == .submitted else { return }
            if response.status == 0 {
                self.questionnaireForm?.inspectionStatus = status.rawValue
                 _ = Utils.displayAlertController("Success", message: response.message ?? "", isSingleBtn: true) {
                    Navigate.routeUserBack(self) { /*No Action*/ }
                } cancelclickHandler: {
                    //No Action
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong")
            }
        } errorCompletionHandler: { response in
            Utils.displayAlert(title: "Error", message: response?.message ?? "Something went wrong")
        }
    }

    func saveReview(status: InspectionStatus, index: Int) {
        let saveRequest = SaveReviewRequestModel()
        saveRequest.inspectionAssignId = questionnaireForm?.id
        saveRequest.inspectionStatus = status.rawValue
        var reviews: [[String: Any]] = []
        guard index < questionnaireForm?.sections.count ?? 0,
                let section = questionnaireForm?.sections[index] else {
            return
        }
        section.subSections.forEach { subSection in
            subSection.questions.forEach { question in
                let review = ["questionid" : question.questionId,
                                "reviewerremark": question.response ?? ""]
                reviews.append(review)
            }
        }
        saveRequest.reviews = reviews
        router.saveReview(params: APIUtils.createAPIRequestParams(dataObject: saveRequest)) { response in
            print("response - \(response.status) - \(response.message ?? "" )")
            guard status == .reviewed else { return }
            if response.status == 0 {
                 _ = Utils.displayAlertController("Success", message: response.message ?? "", isSingleBtn: true) {
                    Navigate.routeUserBack(self) { /*No Action*/ }
                } cancelclickHandler: {
                    //No Action
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong")
            }
        } errorCompletionHandler: { response in
            Utils.displayAlert(title: "Error", message: response?.message ?? "Something went wrong")
        }

    }

    func movePage(direction: UIPageViewController.NavigationDirection) {
        guard let view = detailViewControllerAt(index: currentViewControllerIndex) else{
            return
        }
        pageController?.setViewControllers([view], direction: direction, animated: true )
        self.progressSection.reloadData()
    }
}

//MARK: Form Progress Collection View
extension FormsControlllerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
 
        guard let currentVC = viewController as? FormViewController else {
            return nil
        }
        let index = questionnaireForm?.sections.firstIndex(where: { section in
            section.sectionName == currentVC.formDetails?.sectionName
        })

        guard let index = index, index > 0 else {
            return nil
        }

        currentViewControllerIndex = index
        let previousViewControllerIndex = currentViewControllerIndex - 1
        return self.detailViewControllerAt(index: previousViewControllerIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? FormViewController else {
            return nil
        }
        
        let index = questionnaireForm?.sections.firstIndex(where: { section in
            section.sectionName == currentVC.formDetails?.sectionName
        })
        
        guard let index = index, index < (self.questionnaireForm?.sections.count ?? 0) - 1 else {
            return nil
        }
        
        currentViewControllerIndex = index
        let nextViewControllerIndex = currentViewControllerIndex + 1
        return self.detailViewControllerAt(index: nextViewControllerIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return questionnaireForm?.sections.count ?? 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        progressSection.reloadData()
    }
    
}

extension FormsControlllerViewController:UICollectionViewDelegate {
}

extension FormsControlllerViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionnaireForm?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let section = self.questionnaireForm?.sections[index]
        cell.configHeader(stepNo: index+1,
                          title: section?.sectionName ?? "",
                          isActive: currentViewControllerIndex == index)
        return cell
    }
}

extension FormsControlllerViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let itemsPerRow = CGFloat(questionnaireForm?.sections.count ?? 0)
         let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
         let availableWidth = self.view.frame.width - paddingSpace
             let widthPerItem = availableWidth / itemsPerRow
             
         return CGSize(width: widthPerItem, height: 70)
     }
}
