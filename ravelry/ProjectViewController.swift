//
//  ProjectViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 1/29/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

//
//  PatternView.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/29/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class ProjectViewController: BaseRavelryTableViewController, OAuthServiceResultsDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ControllerResultsDelegate, UITextFieldDelegate, UITextViewDelegate, PhotoSetLoaderDelegate {

    var projectId: Int = 0
    
    var project: Project? {
        return ravelryUser!.projects[projectId]
    }

    var segueAction: String = ""
    var selectedNeedle: Needle?
    var selectedPack: Pack?
    
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var percentageTicker: UILabel!

    @IBOutlet weak var progressBar: UISlider!
    
    @IBOutlet weak var photoCollection: MipmapCollectionView!

    @IBOutlet weak var needleCollection: NeedleSizeCollectionView!
    @IBOutlet weak var yarnCollection: YarnPackCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menuButtons: [UIBarButtonItem] = [
            addBarButtonItem("circle-save-menu", action: .SaveProject),
            addBarButtonItem("circle-x-mark", action: .DestroyProject)
        ]

        nameField.text = project!.name
        nameField.backgroundColor = Color.champagne.uiColor
        nameField.textColor = UIColor.blackColor()
        var attributedPlaceholder = NSMutableAttributedString(string: "NAME")

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 15
        paragraphStyle.headIndent = 15
        

        attributedPlaceholder.setAttributes(
            [
                NSFontAttributeName: UIFont(name: "BebasNeueBook", size: 18)!,
                NSForegroundColorAttributeName: Color.silver.uiColor,
                NSParagraphStyleAttributeName: paragraphStyle
            ],
            range: NSRange(location: 0, length: attributedPlaceholder.length)
        )

        nameField.defaultTextAttributes = [
            NSFontAttributeName: UIFont(name: "BebasNeueBook", size: 16)!,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        nameField.attributedPlaceholder = attributedPlaceholder
        
        navigationItem.setRightBarButtonItems(menuButtons, animated: true)
        
        photoCollection.delegate = self
        photoCollection.dataSource = self

        //Set Up Yarn Pack
        yarnCollection.delegate = self
        yarnCollection.dataSource = self
        //Set Up Needle Sizes
        needleCollection.delegate = self
        needleCollection.dataSource = self

        percentageTicker.text = String(format: "%d%%", project!.progress)
        progressBar.value = Float(project!.progress) / 100.0
    }
    
    //TextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        project!.name = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange: NSRange, replacementText: NSString!) {
        project!.notes = textView.text
        if(replacementText == "\n") {
            textView.resignFirstResponder()
        }
    }
    
    //Collection View Methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let yarnView = collectionView as? YarnPackCollectionView {
            if indexPath.row < project!.packs.count {
                let pack = project!.packs[indexPath.row]
                var form = buildYarnWeightForm("Update Pack", pack: pack)
                
                form.addAction(UIImage(named: "circle-save-menu")!) {

                    mOAuthService.updatePack(
                        pack.id,
                        data: form.getValues(),
                        delegate: self,
                        action: "UpdatePack"
                    )
                }
                
                form.addAction(UIImage(named: "circle-x-mark")!) {
                    let dialogue = DialogueController(title: "Delete Pack", message: "Are you sure you want to do this?")
                    
                    dialogue.addAction("Yes") { (action) in
                        mOAuthService.deletePack(pack.id, delegate: self)
                        self.project!.packs.removeAtIndex(indexPath.row)
                        self.dismissViewControllerAnimated(true, nil)
                        self.yarnCollection!.reloadData()
                    }
                    
                    dialogue.addAction("No") { (action) in
                    }
                    
                    dialogue.present()
                    
                }
                
                form.present(context: self) {
                    self.dismissViewControllerAnimated(true, nil)
                }
            }
        } else if let needleView = collectionView as? NeedleSizeCollectionView {
            if indexPath.row < project!.needles.count {
                let needle = project!.needles[indexPath.row]
                var form = buildNeedleSizeForm("Update Needle Size", needle: needle)
                
                form.addAction(UIImage(named: "circle-save-menu")!) {
                    var size: NeedleSize = NeedleSize(rawValue: form.getPickerAtIndex(0)!)!
                    self.project!.needles[indexPath.row].size = size
                    self.needleCollection!.reloadData()
                }
                
                form.addAction(UIImage(named: "circle-x-mark")!) {
                    let dialogue = DialogueController(title: "Delete Needle Size", message: "Are you sure you want to do this?")
                    
                    dialogue.addAction("Yes") { (action) in
                        self.project!.needles.removeAtIndex(indexPath.row)
                        self.dismissViewControllerAnimated(true, nil)
                        self.needleCollection!.reloadData()
                    }
                    
                    dialogue.addAction("No") { (action) in
                        self.dismissViewControllerAnimated(true, nil)
                    }
                    
                    dialogue.present()
                    
                }
                
                form.present(context: self)
                
            }
        } else {
            //self.presentViewController(modal!, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let yarnView = collectionView as? YarnPackCollectionView {
            return project!.packs.count + 1
        } else if let needleView = collectionView as? NeedleSizeCollectionView {
            return project!.needles.count + 1
        } else {
            return project!.photos.count + 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let yarnView = collectionView as? YarnPackCollectionView {
            var index = indexPath.row
            if index < project!.packs.count {
                var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                    "yarn",
                    forIndexPath: indexPath
                    ) as YarnCell
                
                if let yarn = project!.packs[index].yarn {
                    cell.yarnLabel.text = yarn.name
                }
                
                cell.yarnImage.image = UIImage(named: "skein")
                return cell
            } else {
                var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                    "addYarn",
                    forIndexPath: indexPath
                ) as AddYarnCell
                
                cell.button.addTarget(
                    self,
                    action: Selector("addYarn:"),
                    forControlEvents: .TouchUpInside
                )
                
                cell.imageView.image = UIImage(named: "skein")
                
                return cell
            }
            
            
        } else if let needleView = collectionView as? NeedleSizeCollectionView {
            var index = indexPath.row
            if index < project!.needles.count {
                
                var cell = needleView.dequeueReusableCellWithReuseIdentifier(
                    "needle",
                    forIndexPath: indexPath
                ) as NeedleSizeCell

                let needle = project!.needles[index]
            
                if let craft = needle.craft {
                    cell.needleImage.image = craft.icon
                } else {
                    cell.needleImage.image = UIImage(named: "needles")
                }
                
                cell.sizeLabel.text = needle.name

                return cell
            } else {
                var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                    "addNeedle",
                    forIndexPath: indexPath
                    ) as AddNeedleCell
                
                cell.button.addTarget(
                    self,
                    action: Selector("addNeedle:"),
                    forControlEvents: .TouchUpInside
                )
                
                cell.imageView.image = UIImage(named: "needles")
                
                return cell
            }
        } else {

            println("Photo Count for Collection View \(project!.photos.count)")

            var index = indexPath.row
            if index < project!.photos.count {
                var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                    "mipmapCell",
                    forIndexPath: indexPath
                ) as MipmapCell
                
                cell.setPhotoSet(project!.photos[index])
                
                return cell
            } else {
                var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                    "addMipmap",
                    forIndexPath: indexPath
                ) as AddMipmapCell
            
                return cell
            }
        }
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ProjectCameraController {
            controller.controllerResultsDelegate = self
        }
    }
    
    //Delegation Methods
    func resultsHaveBeenFetched(data: NSData!, action: ActionResponse) {
        switch action {
            case .ProjectSaved:
                onProjectSaved(data)
            case .ProjectDestroyed:
                onProjectDestroyed(data)
            case .PackCreated:
                var parser = PackParser<NSDictionary>().loadData(data) as PackParser
                project!.packs.append(parser.pack!)
                self.dismissViewControllerAnimated(true, nil)
            case .ProjectPhotoCreated:
                println("New Photo has been added")
            case .PackUpdated:
                self.dismissViewControllerAnimated(true, nil)
            case .PackDestroyed:
                self.dismissViewControllerAnimated(true, nil)
                println("Deleting Pack")
            default:
                println("Not a Valid Action.")
        }
    }
    
    func didCompleteAction(results: AnyObject, action: String) {
        println("Photo Selected \(action)")
        
        switch action {
            case "SelectedPhoto":
                if let image = results as? UIImage {
                    println("Creating Project Photo")
                    mOAuthService.createProjectPhoto(project!, filepath: image, delegate: self)
                    project!.photos.append(PhotoSet(photo: image, size: .Medium, delegate: self))
                    
                    tableView.reloadData()
                }
            default:
                println("Not an acceptable action")
        }
    }
    
    
    
    
    //Actions
    @IBAction func onProjectSaved(results: AnyObject) {
        println("Project has been saved")
    }

    @IBAction func onProjectDestroyed(results: AnyObject) {
        println("Project has been destroyed")
    }

    @IBAction func addMipmap(sender: UIButton) {
        segueAction = "capturePhoto"
        performSegueWithIdentifier("showCamera", sender: self)
    }
    
    @IBAction func updateSlider(sender: UISlider) {
        percentageTicker.text = String(format: "%.00f%%", sender.value * 100.0);
        project!.progress = Int(sender.value * 100.0)
    }
    
    @IBAction func addYarn(sender: UIButton) {
        
        var form = buildYarnWeightForm("Add Pack to Project")
        
        form.addAction(UIImage(named: "circle-save-menu")!) {
            
            mOAuthService.createPack(
                self.project!,
                data: form.getValues(),
                delegate: self
            )
        }
        
        form.present(context: self)
    }
    
    @IBAction func saveProject(sender: AnyObject) {
        mOAuthService.saveProject(project!, delegate: self)
    }
    
    @IBAction func destroyProject(sender: AnyObject) {
        println("Destroy Project")
        DialogueController(title: "Delete Project", message: "Are you sure you want to do this?")
        .addCancelAction()
        .addAction("OK") { action in
            mOAuthService.destroyProject(self.project!.id, delegate: self)
        }.present()
    }
    
    @IBAction func showPattern(sender: AnyObject) {
        println("Show Pattern")
    }
    
    @IBAction func addNeedle(sender: UIButton) {
        
        let form = buildNeedleSizeForm("Add Needle Size to Project")
        
        form.addAction(UIImage(named: "circle-save-menu")!) {
            var size: NeedleSize = NeedleSize(rawValue: form.getPickerAtIndex(0)!)!
            self.project!.needles.append(Needle(id: size.id))
        }
        
        form.present(context: self)
    }
    
    func imageHasLoaded(remaining: Int, _ total: Int) {
        photoCollection.reloadData()
    }
    
    private
    
    func buildNeedleSizeForm(title: String, needle: Needle? = nil) -> FormController {
        selectedNeedle = needle
        var needleSizeId = 0

        if let n = needle {
            if let nsize = n.size {
                needleSizeId = nsize.id
            }
        }
        
        let form = FormController(title)
        form.addPicker("needle_size_id", label: "Needle Size", descriptions: NeedleSize.descriptions, data: NeedleSize.ids, selection: needleSizeId)
        return form
    }
    
    func buildYarnWeightForm(title: String, pack: Pack? = nil) -> FormController {
        selectedPack = pack
        let form = FormController(title)
        var colorway = ""
        var name = ""
        var family = 0
        var weight = 0
        var dye = ""
        var skeins = 0
        var yards: Float = 0
        
        if let p = pack {
            name = p.name
            colorway = p.colorway
            
            if let f = p.colorFamily {
                family = f.id
            }

            if let w = p.getYarnWeight() {
                weight = w.id
            }
            dye = p.dyeLot
            skeins = p.skeins
            yards = p.yards
        }
        
        form.addTextField("personal_name", placeholder: "Name", text: name)
        form.addTextField("colorway", placeholder: "Colorway", text: colorway)
        form.addPicker("color_family_id", label: "Color Family", descriptions: ColorFamily.descriptions, data: ColorFamily.ids, selection: family)
        form.addTextField("dye_lot", placeholder: "Dye Lot", text: dye)
        form.addTextField("skeins", placeholder: "Skeins", text: skeins)
        form.addTextField("skein_length", placeholder: "Yards Per Skein", text: yards)
        form.addPicker("personal_yarn_weight_id", label: "Yarn Weight", descriptions: YarnWeight.descriptions, data: YarnWeight.ids, selection: weight)
        
        return form
    }
    
    
    
    
    
    
}