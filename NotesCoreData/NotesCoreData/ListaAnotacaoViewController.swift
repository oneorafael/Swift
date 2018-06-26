//
//  ListaAnotacaoViewController.swift
//  NotesCoreData
//
//  Created by Rafael Oliveira on 25/06/18.
//  Copyright © 2018 Rafael Oliveira. All rights reserved.
//

import UIKit
import CoreData
class ListaAnotacaoViewController: UITableViewController {
    
    var gerenciadorObjeto: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //coreData Config
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        gerenciadorObjeto = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarAnotacoes()
    }
    
    //config tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        let anotacao = self.anotacoes[indexPath.row]
        celula.textLabel?.text = anotacao.value(forKey: "texto") as! String
        let data = anotacao.value(forKey: "data")
        //date format
        let formatacaoData = DateFormatter()
        formatacaoData.dateFormat = "dd/MM/yy hh:mm"
        
        let novaData = formatacaoData.string(from: data as! Date)
        
        celula.detailTextLabel?.text = novaData
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let anotacao = anotacoes[indexPath.row]
        self.performSegue(withIdentifier: "verAnotacao", sender: anotacao)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verAnotacao"{
            let viewControllerDestino = segue.destination as! AnotacaoViewController
            viewControllerDestino.anotacao = sender as? NSManagedObject
        }
    }
    
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            self.gerenciadorObjeto.delete(anotacao)
            self.anotacoes.remove(at: indice )
            
            do{
                try gerenciadorObjeto.save()
                self.tableView.deleteRows(at: [indexPath], with: .automatic )
            }catch let erro{
                print("erro ao remover. Erro"+erro.localizedDescription)
            }

        }
    }
    
    //resume from coreData
    func recuperarAnotacoes(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName:"Anotacao")
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenacao]
        do {
            let anotacoesRecuperadas = try gerenciadorObjeto.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro as NSError {
            print("erro ao listar anotacoes "+erro.description)
        }
        
    }
    
    
}
