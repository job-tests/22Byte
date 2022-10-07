//
//  CreateViewController.swift
//  Matches
//
//  Created by Kirill Drozdov on 26.12.2021.
//

import UIKit
import SnapKit
import CoreData

class CreateViewController: UIViewController
{
    
    private let items = [">", "=", "<"]
    private var selectedNote: Note? = nil
    
    //MARK: - Переменные
    var textFieldFirstTeam      :    UITextField!
    var textFieldSecondTeam     :    UITextField!
    var winSegmented            :    UISegmentedControl!
    var infoAboutMatches        :    UITextView!
    var saveDataAboutMatches    :    UIButton!
    // -------------------------------- \\
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    
        //MARK: - FirstTextField
        textFieldFirstTeam = UITextField()
        textFieldFirstTeam.placeholder = "Первая команда"
        textFieldFirstTeam.textAlignment = .center
        textFieldFirstTeam.borderStyle = .line
        textFieldFirstTeam.clipsToBounds = true
        textFieldFirstTeam.layer.borderWidth = 2
        textFieldFirstTeam.layer.cornerRadius = 15
        
        view.addSubview(textFieldFirstTeam)
        textFieldFirstTeam.snp.makeConstraints { make in
            make.top.equalTo(view.bounds.minY + 100)
            make.left.equalToSuperview().inset(5)
            make.width.equalTo(view.bounds.width / 2 - 7) // дела првоерку на то как прыгает тф
        }
        
        
        //MARK: - SecondTextField
        textFieldSecondTeam = UITextField()
        textFieldSecondTeam.placeholder = "Вторая команда"
        textFieldSecondTeam.textAlignment = .center
        textFieldSecondTeam.borderStyle = .line
        
        textFieldSecondTeam.clipsToBounds = true
        textFieldSecondTeam.layer.borderWidth = 2
        textFieldSecondTeam.layer.cornerRadius = 15
        
        view.addSubview(textFieldSecondTeam)
        textFieldSecondTeam.snp.makeConstraints { make in
            make.top.equalTo(view.bounds.minY + 100)
            make.right.equalToSuperview().inset(5)
            make.width.equalTo(view.bounds.width / 2 - 7) // дела првоерку на то как прыгает тф
        }
        
        
        //MARK: - SegmentedController
        winSegmented = UISegmentedControl(items: items)
        winSegmented.selectedSegmentIndex = 0
        winSegmented.tintColor = UIColor.black
        
        view.addSubview(winSegmented)
        winSegmented.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(50)
            make.height.equalTo(50) // возможно пофиксить
            make.width.equalTo(view.bounds.width - 25)
            make.centerX.equalToSuperview()
            make.top.equalTo(textFieldFirstTeam.snp_bottomMargin).offset(20)
        }
        
        
        //MARK: - TextView
        infoAboutMatches = UITextView()
        infoAboutMatches.contentInsetAdjustmentBehavior = .automatic
        infoAboutMatches.textAlignment = .justified
        infoAboutMatches.textColor = .blue
        infoAboutMatches.backgroundColor = UIColor.lightGray
        infoAboutMatches.font = UIFont.systemFont(ofSize: 20)
        infoAboutMatches.layer.cornerRadius = 15
        
        view.addSubview(infoAboutMatches)
        infoAboutMatches.snp.makeConstraints { make in
            make.top.equalTo(winSegmented.snp_bottomMargin).offset(40)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.left.equalTo(50) // Странно, привязал в коде только к левому краю, а на деле к правому тоже привязалось
        }
        
        
        //MARK: - Button
        saveDataAboutMatches = UIButton()
        saveDataAboutMatches.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        saveDataAboutMatches.backgroundColor = .black
        saveDataAboutMatches.setTitle("СОХРАНИТЬ", for: .normal)
        saveDataAboutMatches.layer.cornerRadius = 15
        
        view.addSubview(saveDataAboutMatches)
        saveDataAboutMatches.snp.makeConstraints { make in
            make.top.equalTo(infoAboutMatches.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
    }
    
    @objc private func buttonTapped(){
        let appDeleagate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDeleagate.persistentContainer.viewContext
        
        if selectedNote == nil
        {
            let enity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: enity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.teamOne = textFieldFirstTeam.text
            newNote.teamTwo = textFieldSecondTeam.text
            newNote.teamWin = winSegmented.titleForSegment(at: winSegmented.selectedSegmentIndex)
            newNote.descriptionMatches = infoAboutMatches.text
            
            do
            {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print( "save error")
            }
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            do
            {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let note = result as! Note
                    if note == selectedNote{
                        note.teamOne = textFieldFirstTeam.text
                        note.teamTwo = textFieldSecondTeam.text
                        note.teamWin = winSegmented.titleForSegment(at: winSegmented.selectedSegmentIndex)
                        note.descriptionMatches = infoAboutMatches.text
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
}







