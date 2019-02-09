//
//  ViewController.swift
//  LaunchNativeAppURL
//
//  Created by Uğuralp ÖNBAŞLI on 29.12.2018.
//  Copyright © 2018 Uğuralp ÖNBAŞLI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchTypeLabelOutlet: UILabel!
    
    var searchSitesArray = ["YouTube", "Twitter", "Google", "Amazon", "Vimeo", "Dailymotion"]
    var slideAll = [SearchboxSlideView](), firstTimeSlideViewSetup = true,
    myTableView:UITableView!, firstTimeRunningTV:Bool = true,
    button:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollViewOutlet.delegate = self
        let slides = createSlide()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
        createButton()
        
        self.scrollViewOutlet.setNeedsLayout()
        
    }
    
    func createSlide() ->[SearchboxSlideView]{
        if firstTimeSlideViewSetup == true{
            firstTimeSlideViewSetup = false
            for i in 0..<searchSitesArray.count{
                slideAll.append(Bundle.main.loadNibNamed("slideView", owner: self, options: nil)?.first as! SearchboxSlideView)
                
                slideAll[i].searchboxNameLabel.text = searchSitesArray[i]
            }
        }else{
            for i in 0..<searchSitesArray.count{
                slideAll[i].searchboxNameLabel.text = searchSitesArray[i]
            }
        }
        
        return slideAll
        
    }

    func setupSlideScrollView(slides:[SearchboxSlideView]){
        scrollViewOutlet.frame = CGRect(x: 0, y: 0, width: stackView.frame.width, height: stackView.frame.height)
        scrollViewOutlet.contentSize = CGSize(width: stackView.frame.width * CGFloat(slides.count), height: stackView.frame.height)
        scrollViewOutlet.isPagingEnabled = true
        
        for i in 0..<slides.count{
            slides[i].frame = CGRect(x: stackView.frame.width * CGFloat(i), y: 0, width: stackView.frame.width, height: stackView.frame.height)
            scrollViewOutlet.addSubview(slides[i])
            slideAll[0].backgroundColor = .red
            slideAll[0].searchboxNameLabel.textColor = .white
        }
    }
    
    @IBAction func addSearchValueAction(_ sender: UIBarButtonItem) {
        if firstTimeRunningTV == true{
            firstTimeRunningTV = false
            //create the table
            let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            let displayWidth: CGFloat = self.view.frame.width
            let displayHeight: CGFloat = self.view.frame.height
            
            myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
            myTableView.backgroundColor = .black
            myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            myTableView.dataSource = self
            myTableView.delegate = self
            self.view.addSubview(myTableView)
        }else{
            if myTableView.isHidden == true{
                myTableView.isHidden = false
            }else{
                myTableView.isHidden = true
            }
        }
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/stackView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }*/
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x/stackView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        searchTypeLabelOutlet.text = searchSitesArray[pageControl.currentPage]
    }
    
    func createButton(){
        button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle("YouTube", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button
    }

    @objc func clickOnButton(button: UIButton) {
        
        if firstTimeRunningTV == true{
            firstTimeRunningTV = false
            //create the table
            let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            let displayWidth: CGFloat = self.view.frame.width
            let displayHeight: CGFloat = self.view.frame.height
            
            myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
            myTableView.backgroundColor = .black
            myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
            myTableView.dataSource = self
            myTableView.delegate = self
            self.view.addSubview(myTableView)
        }else{
            if myTableView.isHidden == true{
                myTableView.isHidden = false
            }else{
                myTableView.isHidden = true
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Num: \(indexPath.row)")
        let searchType  = searchSitesArray[indexPath.row]
        button.setTitle(searchType, for: .normal)
        
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "AddSearch") as! AddSearchValueViewController
        nextPage.value = searchType
        self.navigationController?.pushViewController(nextPage, animated: true)
        
        myTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSitesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel!.text = "\(searchSitesArray[indexPath.row])"
        return cell
    }

    @IBAction func buttonAction(_ sender: Any) {
        let pageIndex = round(scrollViewOutlet.contentOffset.x/stackView.frame.width)
        launchApp(decodedURL: "https://www.youtube.com/results?search_query=battle+of+naboo")
        print(searchSitesArray[Int(pageIndex)])
    }
    
    func launchApp(decodedURL: String) {
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
}

