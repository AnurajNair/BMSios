//
//  FormsControlllerViewController.swift
//  bms
//
//  Created by Naveed on 30/10/22.
//

import UIKit
import RealmSwift



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

    var currentViewControllerIndex = 0 {
        didSet {
            setupButton()
        }
    }
    var questionnaireForm:InspectionQuestionnaire?
    private var sections: [FormSection] = []
    var inspectionType: InspectionType?
    var isCurrentVcLast: Bool {
        let count = questionnaireForm?.sections.count
        guard let count = count, count > 0 else {
            return currentViewControllerIndex == count
        }
        return currentViewControllerIndex == count - 1
    }
    private let generalDetailsSectionIndex = 0
    private lazy var router = InspctionRouterManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupSections()
        setupView()
        setupPageController()
        setupProgressCollection()
        setupButton()
    }

    private func setupSections() {
        guard let formSections = questionnaireForm?.sections else {
            return
        }
        var formSectionsArray = formSections.map { $0 } as [FormSection]
        let generalSections = getGeneralSection()
        formSectionsArray.insert(generalSections, at: 0)
        sections = formSectionsArray
    }

    private func getGeneralSection() -> FormSection {
        let generalSection = FormSection()
        generalSection.sectionIndex = 0
        generalSection.sectionName = "General Details"
        
        let subSection = FormSubSection()
        subSection.subSectionIndex = 0
        subSection.subSectionName = "Basic Details"
        
        let question1 = Question()
        question1.question = "Inspection Name"
        question1.response = questionnaireForm?.inspectionName
        question1.questionIndex = 0
        
        let question2 = Question()
        question2.question = "Bridge Name"
        question2.response = questionnaireForm?.bridgeName
        question2.questionIndex = 1
        
        let question3 = Question()
        question3.question = "BUID"
        question3.response = questionnaireForm?.buid
        question3.questionIndex = 2
        
        let question4 = Question()
        question4.question = "Next Review Date"
        question4.response = questionnaireForm?.nextReviewDateAsString
        question4.questionIndex = 3
        
        let question5 = Question()
        question5.question = "Start Date"
        question5.response = questionnaireForm?.startDateAsString
        question5.questionIndex = 4
        
        let question6 = Question()
        question6.question = "End Date"
        question6.response = questionnaireForm?.endDateAsString
        question6.questionIndex = 5
        
        let question7 = Question()
        question7.question = "Description"
        question7.response = questionnaireForm?.desc
        question7.questionIndex = 6
        
        let questions = [question1, question2, question3, question4, question5, question6, question7]
        let questionsList = List<Question>()
        questionsList.append(objectsIn: questions)
        subSection.questions = questionsList
        
        let subSections = List<FormSubSection>()
        subSections.append(subSection)

        generalSection.subSections = subSections
        
        return generalSection
    }

    private func setupView() {
        UILabel.style([(view: formTitleLabel, style: TextStyles.ScreenHeaderTitle)])
        formTitleLabel.text =  inspectionType == .review ? "Review Inspection Form " : "Inspection Form"
        setNextButtonTitle()
    }

    private func setupButton() {
        previousBtn.isHidden = currentViewControllerIndex == 0 //First vc
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
        guard index < sections.count else { return viewController }
        let section = sections[index]
        viewController.formDetails = section
        viewController.delegate = self
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
        guard isCurrentVcLast == false else {
            saveData()
            return
        }
        saveData() //should be before updating current vc index
        currentViewControllerIndex += 1
        movePage(direction: .forward)
        setNextButtonTitle()
    }

    func setNextButtonTitle() {
        let title: String
        if currentViewControllerIndex == generalDetailsSectionIndex {
            title = "Next"
        } else if isCurrentVcLast {
            title = "Submit"
        } else {
            title = "Save & Continue"

        }
        nextBtn.setTitle(title , for: .normal)
    }

    func saveData() {
        guard currentViewControllerIndex != generalDetailsSectionIndex else  {
            return
        }
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
        guard index < sections.count else {
            return
        }
        let section = sections[index]
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
        guard index < sections.count
                else {
            return
        }
        let section = sections[index]
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
        let index = sections.firstIndex(where: { section in
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
        
        let index = sections.firstIndex(where: { section in
            section.sectionName == currentVC.formDetails?.sectionName
        })
        
        guard let index = index, index < sections.count - 1 else {
            return nil
        }
        
        currentViewControllerIndex = index
        let nextViewControllerIndex = currentViewControllerIndex + 1
        return self.detailViewControllerAt(index: nextViewControllerIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return sections.count
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
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let section = sections[index]
        cell.configHeader(stepNo: index+1,
                          title: section.sectionName ?? "",
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

extension FormsControlllerViewController: formViewControllerDelegate {
    func uploadFiles(_ files: [Any], for section: Int) {
        files.forEach { file in
            guard let file = file as? UIImage, let fileData = file.pngData() else {
                return
            }
            uploadFile(fileData, section: section)
        }
    }

    func uploadFile(_ file: Data, section: Int) {
        guard let inpectionAssignId = questionnaireForm?.id else { return }
        let uploadRequest = UploadFileRequestModel()
        uploadRequest.inspectionAssignId = inpectionAssignId
        uploadRequest.fileName = getFileName(id: inpectionAssignId, section: section)
        uploadRequest.fileType = "PNG"
        Utils.showLoadingInView(self.view)
            UploadFileRouterManager() .uploadImage(params: APIUtils.createAPIRequestParams(dataObject: uploadRequest), imageData: file) { response in
                Utils.hideLoadingInView(self.view)
                print("response - \(response.status) - \(response.message ?? "" )")
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
                Utils.hideLoadingInView(self.view)
                Utils.displayAlert(title: "Error", message: response?.message ?? "Something went wrong")
            }
    }

    func getFileName(id: Int, section: Int) -> String {
//        YYYYMMDDHHMMSS_inspectionassignid_secno_3digitnonconfictingrandomnumber.extension
       return "\(currentDateAsString())_\(id)_\(section)_\(Utils.random3DigitString())"
    }

    func currentDateAsString() -> String {
        let mytime = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        return format.string(from: mytime)
    }
}
