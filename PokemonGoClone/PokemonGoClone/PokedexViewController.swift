//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Quang Kha Tran on 27/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemon: [Pokemon] = []
    var uncaughtPokemon: [Pokemon] = []
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caughtPokemon = getPokemon(caught: true)
        uncaughtPokemon = getPokemon(caught: false)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return uncaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = uncaughtPokemon[indexPath.row]
        }
        cell.textLabel?.text = pokemon.name
        if let imageName = pokemon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        return cell
    }


}
