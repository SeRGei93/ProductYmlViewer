//
//  XMLParser.swift
//  ProductYmlViewer
//
//  Created by Сергей Бушкевич on 1.08.21.
//

import Foundation

struct ShopFile:Codable{
    var name: String
    var company: String
    var url: String
    var currencies: Currency
    var categories: [Category]
}
struct Currency:Codable{
    var id: String
    var rate: Int
}
struct Category:Codable{
    var id: String
    var name: String
    var parentId: String?
    var childs: [Category]?
}
struct Offer: Codable{
    var id: Int
    var available: Bool
    var url: String
    var price: Int
    var currencyId: String
    var categoryId: Int?
    var pictireUrl: String?
    var vendor: String
    var model: String
}

class YmlFeedParser: NSObject, XMLParserDelegate{

    struct Constants{
        static let feedURL: String = "https://ledeme.by/bitrix/catalog_export/test.xml"
    }
    
    private var categories: [Category] = []
    private var currentElement = ""
    private var currentId: String = ""{
        didSet {
            currentId = currentId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentName: String = ""{
        didSet {
            currentName = currentName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentParentId: String = ""{
        didSet {
            currentParentId = currentParentId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([Category]) -> Void)?
    
    func parseFeed(url: String, completitionHandler: (([Category]) -> Void)?)
    {
        self.parserCompletionHandler = completitionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            
            // parse xml data
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }
        
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "category" {
            
            currentName = ""
            
            if let idValue = attributeDict["id"] {
                currentId = idValue
            }
            
            if let idParentValue = attributeDict["parentId"] {
                currentParentId = idParentValue
            }
        }
        
    }
    

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentName += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "category" {
                let categoryItem = Category(id: currentId, name: currentName, parentId: currentParentId)
                self.categories.append(categoryItem)
                
                
                if let index = self.categories.firstIndex(where: { $0.id == currentParentId }) {
                    print("Для \(categoryItem.name) нашли родителя это \(self.categories[index].name)")
                    //self.categories[index].childs?.append(categoryItem)
                }
                
            }
        
        }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(categories)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    

}




