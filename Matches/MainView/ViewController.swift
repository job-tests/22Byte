//
//  ViewController.swift
//  Matches
//
//  Created by Kirill Drozdov on 26.12.2021.
//

import UIKit
import SnapKit
import CoreData

var noteList = [Note]()

class ViewController: UIViewController
{
    var firstLoad = true
    private let cellIdentifire = "cellID"
    
    
    func nonDeletedNotes() ->[Note]
    {
        var noDeletedNoteList = [Note]()
        for note in noteList
        {
            if note.deletedDate == nil
            {
                noDeletedNoteList.append(note)
            }
        }
        return noDeletedNoteList
    }
    
   
    override func viewDidAppear(_ animated: Bool)
    {
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellWithMatches", bundle: nil), forCellReuseIdentifier: cellIdentifire)
        setupView()
        setupContraints()
        
        view.backgroundColor = .white
        navigationItem.title = "Matches"
        _ = navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(transtionVC))
        
        if firstLoad
        {
            firstLoad = false
            let appDelegate                         =           UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext     =           appDelegate.persistentContainer.viewContext
            let request                             =           NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do
            {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    @objc func transtionVC()
    {
        let rootVc = CreateViewController()
        rootVc.navigationItem.titleView?.backgroundColor        =               .white
        rootVc.navigationItem.titleView?.tintColor              =               .white
        
        let navVC = UINavigationController(rootViewController: rootVc)
        navVC.modalPresentationStyle        =        .fullScreen
        present(navVC, animated: true, completion: nil)
        
    }
    
    @objc private func dismis()
    {
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
    
    private func setupView()
    {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupContraints()
    {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview().inset(0)
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        nonDeletedNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let thisNote: Note!
        let noteCell                    =       tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! CellWithMatches
        thisNote                        =       nonDeletedNotes()[indexPath.row]
        noteCell.TeamOne.text           =       thisNote.teamOne
        noteCell.TeamTwo.text           =       thisNote.teamTwo
        noteCell.ResultMatches.text     =       thisNote.teamWin
        
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var textInfo:String?
        let thisNote: Note!
        
        thisNote                        =       nonDeletedNotes()[indexPath.row]
        textInfo                        =       thisNote.descriptionMatches

        guard let textInfo = textInfo else {return}

        let alert = UIAlertController(title: "Ифнформация",
                                      message: "\(textInfo)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return .delete
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            _ = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            let recordToDeleted = noteList[indexPath.row]
            noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            context.delete(recordToDeleted)
            do
            {
                try context.save()
                tableView.reloadData()
            }
            catch
            {
                print("Errror")
            }
        }
    }
}


