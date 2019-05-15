//
//  CoursesTableViewController.swift
//  GetRequest
//
//  Created by Давид on 13/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    private let url = "http://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let postRequestUrl = "http://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "http://jsonplaceholder.typicode.com/posts/1"
    
    // MARK: - Methods
    
    func fetchData() {
        
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_course" // обычные данные в джейсон
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_courses" // массив словарей в джесон
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_website_description" // вло_е данные course: { словари джейсон }
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields" // пропущенные данные для полей course: { словари джейсон } чтобы избежать ошибки объявляем поля опциональными
        
        NetworkManager.fetchData(url: url) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        AlomofireNetworkRequest.sendRequest(url: url) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLesson.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        
        // работа с данными которые мы получаем из сети происходит в глобальном потоке ассинхронно
        DispatchQueue.global().async {
            
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            // обноаление интерфейса происходит в главном потоке ассинхронно
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
            
        }
    }
    
    func postRequest() {
        
        AlomofireNetworkRequest.postRequest(url: postRequestUrl) { (courses) in
            
            self.courses = courses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func putRequest() {
        
        AlomofireNetworkRequest.putRequest(url: putRequestUrl) { (courses) in
            
            self.courses = courses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    // если выбрана ячейка то передаем данные ячейки в соответствующие свойства и вызываем сегвей
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }


//     MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewController = segue.destination as? WebViewController else { return }
        webViewController.selectedCourse = courseName
        
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }

}
