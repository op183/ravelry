//
//  FormController.swift
//  ravelry
//
//  Created by Kellan Cummings on 2/1/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

import UIKit

typealias ButtonAction = () -> ()

class FormController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
 
    var headlineText: String = ""
    var defaultRowHeight = CGFloat(40);
    var rowHeights = [CGFloat]()
    
    var buttons = [UIBarButtonItem]()
    var labels = [UILabel]()
    var actions = [ButtonAction]()
    var fields = [UIView]()
    var keys = [String]()
    
    let defaultWidth: Float = 250
    let defaultPickerHeight: CGFloat = 216
    let basalFont = UIFont(name: "BebasNeueBook", size: 15)
    let headlineFont = UIFont(name: "BebasNeueBold", size: 25)

    var data = [Int:[Int]]()
    var dataDescriptions = [Int:[String]]()
    var selectedValues = [Int:Int]()
    var endAction: ButtonAction?
    var defaultFieldFrame = CGRectMake(0, 0, 0, 0)
    
    var selectedTextField: UITextField?
    var context: UIViewController?

    init(_ text: String) {
        super.init(nibName: nil, bundle: nil)
        setupView(text)
    }
    
    required init(coder aDecoder: NSCoder) {
        println("Init Coder")
        super.init(coder: aDecoder)
        setupView()
    }
 
    private func setupView(_ text: String = "") {
        headlineText = text
        //addKeyboardHideObserver("keyboardWillHide:")
        //addKeyboardShowObserver("keyboardWillShow:")
        
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func present(#context: UIViewController, endAction: ButtonAction? = nil) {
        self.endAction = endAction
        self.context = context
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
        self.addBackButton()

        self.context!.navigationController!.pushViewController(self, animated: true)
    }
    
    func getValues() -> [String:AnyObject] {
        var values = [String:AnyObject]()
        
        for (i, field) in enumerate(fields) {
            if field is UIPickerView {
                if let value = getPickerAtIndex(i) {
                    if value != 0 {
                        values[keys[i]] = value
                    }
                }
            } else {
                if getStringAtIndex(i) != "" {
                    values[keys[i]] = getStringAtIndex(i)
                }
            }

        }
        
        return values
    }
    
    func setLabel(text: String) {
        var label = UILabel()
        
        label.textAlignment = .Left
        label.text = text
        label.font = basalFont
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        labels.append(label)
    }

    //Main Form Table
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Set Up Headline
        var view = UIView()
        
        var headline = UILabel()
        headline.text = headlineText
        headline.font = self.headlineFont
        headline.textAlignment = .Center
        headline.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(headline)
        view.subviewToCenter(headline)
        
        return view
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        var field = fields[indexPath.row]
        var label = labels[indexPath.row]
 
        field.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(field)
        cell.clipsToBounds = true

        
        cell.subviewToFill(cell.contentView)
        
        cell.contentView.subviewToLeft(label, 10)
        cell.contentView.subviewToTop(label, 0)
        cell.contentView.subviewToBottom(label, 0)
        
        cell.contentView.subviewToRight(field, 10)
        cell.contentView.subviewToTop(field, 0)
        cell.contentView.subviewToBottom(field, 0)
        cell.contentView.subviewWidth(label, 100)
        cell.contentView.subviewRelationshipX(label, field, 10)

        return cell
    }
    
    //Text Fields
    func getStringAtIndex(index: Int) -> String {
        if let field = fields[index] as? UITextField {
            return field.text
        } else {
            println("Not a text field at index \(index)!")
            abort()
        }
    }

    func getIntAtIndex(index: Int) -> Int {
        var s = getStringAtIndex(index)
        if let number = s.toInt() {
            return number
        }
        return 0
    }

    func getFloatAtIndex(index: Int) -> Float {
        var s = getStringAtIndex(index)
        return (s as NSString).floatValue
    }
    
    func addTextField(key: String, placeholder: String, text: AnyObject = "") {
        var textField = UITextField(frame: defaultFieldFrame)
        //textField.layer.borderColor = COLORS["lightBlue"]!.CGColor

        textField.text = "\(text)"
        textField.delegate = self
        textField.backgroundColor = Color.champagne.uiColor
        textField.font = basalFont!
        
        setLabel(placeholder)
        keys.append(key)
        fields.append(textField)
        rowHeights.append(defaultRowHeight)
    }

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        println("TextField Selected")
        selectedTextField = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    //Pickers
    func addPicker(key: String, label: String, descriptions: [String], data: [Int], selection: Int? = nil) {
        var picker: UIPickerView = UIPickerView(frame: defaultFieldFrame);
        self.dataDescriptions[fields.count] = descriptions
        self.data[fields.count] = data
        keys.append(key)
        
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = Color.champagne.uiColor
        

        setLabel(label)
        fields.append(picker)
        rowHeights.append(100)
    
        if let selectedValue = selection {
            println("Selected Value: \(selectedValue)")
            self.selectedValues[fields.count - 1] = selectedValue
            if let index = find(data, selectedValue) {
                picker.selectRow(index, inComponent: 0, animated: false)
            } else {
                println("Could Not Locate index at \(selectedValue)")
            }
        } else {
            self.selectedValues[fields.count - 1] = self.data[fields.count - 1]![0]
            picker.selectRow(0, inComponent: 0, animated: true)
        }

    }
    
    func getPickerAtIndex(index: Int) -> Int? {
        if let field = fields[index] as? UIPickerView {
            return selectedValues[index]
        } else {
            return nil
        }
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 15
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let index = find(fields, pickerView) {
            return data[index]!.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var i = 0
        for field in fields {
            if pickerView == field {
                selectedValues[i] = data[i]![row]
                break
            }
            ++i
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var index = find(fields, pickerView)!
        var label = UILabel()
        
        label.font = self.basalFont
        label.textColor = UIColor.blackColor()
        label.text = dataDescriptions[index]![row]
        label.textAlignment = .Center
        
        
        return label
    }
    
    func addAction(image: UIImage, action: ButtonAction) {
        var button = UIBarButtonItem(
            image: image.doScaling(25, 25),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("doAction:")
        )

        actions.append(action)
        buttons.append(button)
    }
    
    @IBAction func keyboardWillShow(notification: NSNotification) {
        println("Keyboard is showing")
        
        if let userInfo = notification.userInfo {
            println(userInfo)
            var keyboardFrame: CGRect? = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            println(keyboardFrame)
            
            var keyboardSize = keyboardFrame!.size
            println(keyboardSize)
            var contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
            
            var rect = self.view.frame
            rect.size.height -= keyboardSize.height
            
            if let textField = selectedTextField {
                if !CGRectContainsPoint(rect, textField.frame.origin) {
                    var scrollPoint: CGPoint = CGPointMake(0.0, textField.frame.origin.y - (keyboardSize.height - textField.frame.size.height))
                    tableView.setContentOffset(scrollPoint, animated: true)
                    println(scrollPoint)
                }
            }
        }
        
    }

    @IBAction func keyboardWillHide(sender: AnyObject) {
        println("Keyboard is hiding")
    }
    
    func doAction(sender: UIBarButtonItem) {
        if let index = find(buttons, sender) {
            actions[index]()
        }
    }
}