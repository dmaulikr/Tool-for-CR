//
//  ViewController.swift
//  CRHelper
//
//  Created by Fan Wu on 5/14/16.
//  Copyright © 2016 8184. All rights reserved.
//

import UIKit

class ChestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var previousChestsView: PreviousChestsView!
    @IBOutlet weak var previousChestsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var possibleChestsTableView: UITableView!
    @IBOutlet weak var possibleChestsTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var rareChestsPicker: UIPickerView!
    
    //use this property to determine the button view should slide out or off
    private var slideout = true
    private var chests = Chests()
    private var previousChests: [String]
    {
        get { return NSUserDefaults.standardUserDefaults().objectForKey("chests.previousChests") as? [String] ?? []}
        set { NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "chests.previousChests") }
    }
    
    private var possibleChests = [[(position: Int, chest: String)]]()
    private var previousRareChests: [(left: String, right: String)]
    {
        return [(left: Chests.ChestsPopulation.Unknown.rawValue, right: Chests.ChestsPopulation.Unknown.rawValue),
                (left: Chests.ChestsPopulation.Unknown.rawValue, right: Chests.ChestsPopulation.Magic.rawValue),
                (left: Chests.ChestsPopulation.Unknown.rawValue, right: Chests.ChestsPopulation.Giant.rawValue),
                (left: Chests.ChestsPopulation.Magic.rawValue, right: Chests.ChestsPopulation.Magic.rawValue),
                (left: Chests.ChestsPopulation.Giant.rawValue, right: Chests.ChestsPopulation.Giant.rawValue),
                (left: Chests.ChestsPopulation.Magic.rawValue, right: Chests.ChestsPopulation.Giant.rawValue),
                (left: Chests.ChestsPopulation.Giant.rawValue, right: Chests.ChestsPopulation.Magic.rawValue)]
    }
    
    //datasource of range picker view
    private var pickerRange = [(start: Int, end: Int)]()
    //store the selected rare chests option
    private var selectedPreviousRareChestsOption = (left: "", right: "")
    
    //populate Picker Options in picker view
    private var pickerOptions: [[(left: String, right: String)]]
    {
        var range = [(left: Chests.ChestsPopulation.Unknown.rawValue, right: Chests.ChestsPopulation.Unknown.rawValue)]
        
        for item in pickerRange
        {
            range.append((left: String(item.start), right: String(item.end)))
        }
        
        return [previousRareChests, range]
    }
    
    @IBAction func enterPreviousChests(sender: UIButton)
    {
        //make sure previousChests array is not go over the maximum number of previous chests view
        if previousChests.count < PreviousChestsView.Constants.numberOfPreviousChests
        {
            previousChests.append(sender.currentTitle!)
            updateUI()
        }
        else
        {
            previousChests.removeAtIndex(0)
            previousChests.append(sender.currentTitle!)
            updateUI()
        }
    }
    
    @IBAction func delete()
    {
        if !previousChests.isEmpty
        {
            previousChests.removeLast()
        }
        
        updateUI()
    }

    @IBAction func scrollButtonView()
    {
        scroll(slideout)
    }
    
    @IBAction func panButtonView(sender: UIPanGestureRecognizer)
    {
        let translation = sender.translationInView(buttonView)
        
        if translation.y < 0
        {
            if slideout
            {
                scroll(slideout)
            }
        }
        else if translation.y > 0
        {
            if !slideout
            {
               scroll(slideout)
            }
        }
    }
    
    private func scroll (slideState: Bool)
    {
        if slideState
        {
            UIView.animateWithDuration(1)
            {
                self.buttonView.center.y = self.buttonView.center.y - self.buttonViewHeight.constant + self.scrollButtonHeight.constant
                self.possibleChestsTableView.center.y = self.possibleChestsTableView.center.y - self.buttonViewHeight.constant + self.scrollButtonHeight.constant
            }
            
            slideout = false
        }
        else
        {
            UIView.animateWithDuration(1)
            {
                self.buttonView.center.y = self.buttonView.center.y + self.buttonViewHeight.constant - self.scrollButtonHeight.constant
                self.possibleChestsTableView.center.y = self.possibleChestsTableView.center.y + self.buttonViewHeight.constant - self.scrollButtonHeight.constant
            }
            
            slideout = true
        }
    }
    
    //set up the pickerRange
    private func setPickerRange (newPickerRange: [(start: Int, end: Int)])
    {
        var validInput = true
        
        //if there is one part not valid, then the whole is not valid
        for item in newPickerRange
        {
            if item.start < 0 || item.start >= chests.chestsArray.count || item.end < 0 || item.end >= chests.chestsArray.count
            {
                validInput = false
                break
            }
        }
        
        if validInput
        {
            pickerRange = newPickerRange
        }
        else
        {
            pickerRange = chests.populateRange
        }
    }
    
    func showNextPossibleChests()
    {
        possibleChests = chests.showComingChests(previousChests)
        possibleChestsTableView.reloadData()
    }
    
    func updateUI()
    {
        previousChestsView.removeChests()
        
        for item in previousChests
        {
            previousChestsView.addChests(item)
        }
        
        showNextPossibleChests()
    }
    
    // MARK: Chests View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        rareChestsPicker.dataSource = self
        rareChestsPicker.delegate = self
        setPickerRange(chests.populateRange)
        updateUI()
        
        previousChestsViewHeight.constant = previousChestsView.chestsSize.height * 2
        buttonViewHeight.constant = previousChestsView.chestsSize.height * 3
        scrollButtonHeight.constant = previousChestsView.chestsSize.height * 0.2
        possibleChestsTableView.rowHeight = previousChestsView.chestsSize.height
        possibleChestsTableViewBottom.constant = -buttonViewHeight.constant + previousChestsView.chestsSize.height * 0.25
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        //when this view is loaded, always set the slideout is true first
        slideout = true
        scrollButtonView()
    }
    
    // MARK: Chests Picker View Datasouce
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions[component].count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return pickerOptions.count
    }
    
    // MARK: Chests Picker View Delegate
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        func setupLabelProperty(label: UILabel)
        {
            label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.88)
            label.font = UIFont(name: "Supercell-Magic", size: 11)
            label.textAlignment = NSTextAlignment.Center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
        }
        
        let prototypeView = UIView()
        
        var ChestsSize: CGSize
        {
            let size = pickerView.rowSizeForComponent(component).height
            return CGSize(width: size, height: size)
        }
        
        let centerOfPickerComponent = pickerView.rowSizeForComponent(component).width / 2
        
        let leftRareChestOrigin = CGPoint(x: centerOfPickerComponent - 1.5 * ChestsSize.width, y: 0)
        let leftRareChestFrame = CGRect(origin: leftRareChestOrigin, size: ChestsSize)
        let leftRareChest = UIImageView(frame: leftRareChestFrame)
        leftRareChest.image = UIImage(named: pickerOptions[component][row].left)
        
        let pickerLabelOrigin = CGPoint(x: centerOfPickerComponent - 0.5 * ChestsSize.width, y: 0)
        let pickerLableFrame = CGRect(origin: pickerLabelOrigin, size: ChestsSize)
        let pickerLabel = UILabel(frame: pickerLableFrame)
        setupLabelProperty(pickerLabel)
        
        
        let rightRareChestOrigin = CGPoint(x: centerOfPickerComponent + 0.5 * ChestsSize.width, y: 0)
        let rightRareChestFrame = CGRect(origin: rightRareChestOrigin, size: ChestsSize)
        let rightRareChest = UIImageView(frame: rightRareChestFrame)
        rightRareChest.image = UIImage(named: pickerOptions[component][row].right)
        
        prototypeView.addSubview(leftRareChest)
        prototypeView.addSubview(rightRareChest)
        
        if component == 0
        {
            leftRareChest.image = UIImage(named: pickerOptions[component][row].left)
            pickerLabel.text = "~"
            rightRareChest.image = UIImage(named: pickerOptions[component][row].right)
        }
        
        if component == 1
        {
            if row == 0
            {
                leftRareChest.image = UIImage(named: pickerOptions[component][row].left)
                rightRareChest.image = UIImage(named: pickerOptions[component][row].right)
            }
            else
            {
                let leftRangeChest = chests.chestsArray[Int(pickerOptions[component][row].left)!]
                let rightRangeChest = chests.chestsArray[Int(pickerOptions[component][row].right)!]
                leftRareChest.image = UIImage(named: leftRangeChest)
                rightRareChest.image = UIImage(named: rightRangeChest)
                
                let leftPickerLabelOrigin = CGPoint(x: pickerLabelOrigin.x - 2 * ChestsSize.width, y: 0)
                let leftPickerLableFrame = CGRect(origin: leftPickerLabelOrigin, size: ChestsSize)
                let leftPickerLabel = UILabel(frame: leftPickerLableFrame)
                let rightPickerLabelOrigin = CGPoint(x: pickerLabelOrigin.x + 2 * ChestsSize.width, y: 0)
                let rightPickerLableFrame = CGRect(origin: rightPickerLabelOrigin, size: ChestsSize)
                let rightPickerLabel = UILabel(frame: rightPickerLableFrame)
                setupLabelProperty(leftPickerLabel)
                setupLabelProperty(rightPickerLabel)
                leftPickerLabel.textAlignment = NSTextAlignment.Right
                rightPickerLabel.textAlignment = NSTextAlignment.Left
                leftPickerLabel.text = pickerOptions[component][row].left
                rightPickerLabel.text = pickerOptions[component][row].right
                prototypeView.addSubview(leftPickerLabel)
                prototypeView.addSubview(rightPickerLabel)
            }
            
            pickerLabel.text = "to"
        }
        
        prototypeView.addSubview(leftRareChest)
        prototypeView.addSubview(pickerLabel)
        prototypeView.addSubview(rightRareChest)
        
        return prototypeView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //according to the previous rare chests picker, reset the range picker
        if component == 0
        {
            selectedPreviousRareChestsOption = pickerOptions[component][row]
            setPickerRange(chests.filter(selectedPreviousRareChestsOption))
            rareChestsPicker.reloadComponent(1)
            rareChestsPicker.selectRow(0, inComponent: 1, animated: true)
        }
        
        if component == 1
        {
            if row > 0
            {
                chests.selectRange([pickerRange[row - 1]])
            }
            else
            {
                chests.filter(selectedPreviousRareChestsOption)
            }
        }
        
        updateUI()
    }
    
    //The height of picker's row should be less than 0.5 because the row's images (component 1 has 5 subviews)
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return CGFloat(previousChestsView.chestsSize.height * 0.4)
    }
    
    // MARK: Chests Table View Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return possibleChests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = possibleChestsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PossibleChestsTableViewCell
        
        if !possibleChests.isEmpty
        {
            cell.nextPossibleChests = possibleChests[indexPath.row]
        }
        
        return cell
    }
}

