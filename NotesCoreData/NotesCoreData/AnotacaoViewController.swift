//
//  ViewController.swift
//  NotesCoreData
//
//  Created by Rafael Oliveira on 25/06/18.
//  Copyright © 2018 Rafael Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    
    @IBOutlet weak var texto: UITextView!
    var gerenciadorObjeto: NSManagedObjectContext!
    var anotacao: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //coreData Config
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        gerenciadorObjeto = appDelegate.persistentContainer.viewContext
        
        //open keyboard & reset text
        self.texto.becomeFirstResponder()
        
        if anotacao != nil {
            
            self.texto.text = anotacao.value(forKey: "texto") as? String
            
        } else {
            self.texto.text = ""
            
        }
        
    }
    
    @IBAction func salvarAnotacao(_ sender: Any) {
        
        if anotacao != nil {
            
            self.atualizar()
            
        } else {
            self.save()
        }
        
        //back to home
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func save(){
        // create a new entity
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: gerenciadorObjeto)
        
        //anotation config
        novaAnotacao.setValue(self.texto.text, forKey: "texto")
        novaAnotacao.setValue(NSDate(), forKey: "data")
        
        //save
        do {
            try gerenciadorObjeto.save()
            print("sucesso ao salvar")
        } catch let erro as NSError {
            print("erro ao salvar anotacao"+erro.description)
        }
    }
    
    func atualizar(){
        anotacao.setValue(self.texto.text, forKey: "texto")
        anotacao.setValue(NSDate(), forKey: "data")
        
        //Update & save
        do {
            try gerenciadorObjeto.save()
            print("sucesso ao atualizar")
        } catch let erro as NSError {
            print("erro ao salvar atualizar. Erro:"+erro.description)
        }
    }
}

