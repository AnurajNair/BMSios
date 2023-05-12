//
//  Question.swift
//  bms
//
//  Created by Sahil Ratnani on 30/04/23.
//
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Question: RequestBody {
    @objc dynamic var inspectorId: Int = 0
    @objc dynamic var inspectorName: String?
    @objc dynamic var mandatory: String?
    @objc dynamic var question: String?
    @objc dynamic var questionId: Int = 0
    @objc dynamic var questionIndex: Int = 0
    @objc dynamic var questionType: Int = 0
    @objc dynamic var rating: Int = 0
    @objc dynamic var reviewerId: Int = 0
    @objc dynamic var reviewerName: String?
    var options = List<Option>()
    var optionsArray: [Option] {
        let options = options.map({$0}) as [Option]
        return options
    }
    var response: String?

    var questionTypeEnum: QuestionType {
        QuestionType(rawValue: questionType) ?? .text
    }
    var isMandatory: Bool {
        mandatory != "0"
    }

    enum ResponseKeys: String {
        case inspectorId = "inspectorid"
        case inspectorName = "inspectorname"
        case mandatory = "mandatory"
        case options = "options"
        case question = "question"
        case questionId = "questionid"
        case questionIndex = "questionindex"
        case questionType = "questiontype"
        case rating = "rating"
        case response = "response"
        case reviewerId = "reviewerid"
        case reviewerName = "reviewername"
    }

    override func mapping(map: ObjectMapper.Map) {
        inspectorId <- map[ResponseKeys.inspectorId.rawValue]
        inspectorName <- map[ResponseKeys.inspectorName.rawValue]
        mandatory <- map[ResponseKeys.mandatory.rawValue]
        options <- (map[ResponseKeys.options.rawValue], ListTransform<Option>())
        question <- map[ResponseKeys.question.rawValue]
        questionId <- map[ResponseKeys.questionId.rawValue]
        questionIndex <- map[ResponseKeys.questionIndex.rawValue]
        questionType <- map[ResponseKeys.questionType.rawValue]
        rating <- map[ResponseKeys.rating.rawValue]
        response <- map[ResponseKeys.response.rawValue]
        reviewerId <- map[ResponseKeys.reviewerId.rawValue]
        reviewerName <- map[ResponseKeys.reviewerName.rawValue]
    }

}
