//
//  CocktailStore.swift
//  Project
//
//  Created by Jason Jordan on 11/8/24.
//

import Foundation
import SwiftUI

class CocktailStore: ObservableObject {
    @Published var cocktails: [Cocktail] = []
  @Published var randcocktail: Cocktail = Cocktail.pinaC

    // for Ingredient
    @Published var currentIngredient: Ingredient? = nil
    // I spent like 30 mins once only to find out I wrote "CocktailsMini" instead of CocktailMini here.
    @Published var relatedDrinks: [CocktailMini]? = nil
    @Published var singleDrinkForIngredient: Cocktail? = nil

//    @Published var favorites: [Cocktail] = []
//    @Published var history: [Cocktail] = []
    @AppStorage("history") private var historyData: Data = Data()
    @AppStorage("favorites") private var favoritesData: Data = Data()
  
    // Prob should be in a seperate store file
    @AppStorage("incognito") public var incognitomode: Bool = false
  
    var history: [Cocktail] {
        get {
            decodeCocktails(from: historyData)
        }
        set {
            historyData = encodeCocktails(newValue)
        }
    }
    
    var favorites: [Cocktail] {
        get {
            decodeCocktails(from: favoritesData)
        }
        set {
            favoritesData = encodeCocktails(newValue)
        }
    }
  
    private let service = CocktailService()
    //@Published var objects: [Object] = []
    private let maxIndex: Int
    
    init(maxIndex: Int = 30) {
        self.maxIndex = maxIndex
    }
    
    func getCocktailsByName(for queryTerm: String) async {
      print("getting by name")
      cocktails = []
        do {
            if let fetchedCocktails = try await service.getCocktailsByName(from: queryTerm) {
                await MainActor.run {
                    self.cocktails = Array(fetchedCocktails.prefix(maxIndex))
                }
            }
        } catch {
            print("Failed to fetch cocktails: \(error)")
        }
    }
  
  func getCocktailsByRandom() async {
//    cocktails = []
    print("running random")
      do {
          if let fetchedCocktail = try await service.getCocktailsByRandom() {
              await MainActor.run {
                  self.randcocktail = fetchedCocktail
                  if (self.incognitomode == false){
                    self.history.append(fetchedCocktail)
                  }
              }
          }
      } catch {
          print("Failed to fetch cocktails: \(error)")
      }
  }
  
  func clearHistory() async{
    
    self.history = []
  }
  
  
    func toggleFavorite(for cocktail: Cocktail) {
        if let index = favorites.firstIndex(of: cocktail) {
            favorites.remove(at: index) // Remove from favorites if already favorited
        } else {
            favorites.append(cocktail) // Add to favorites if not favorited
        }
    }
  
  func addCocktailtoHistory(cocktail: Cocktail){
    //if (!self.incognitomode){
      if self.history.contains(where: { $0.strDrink == cocktail.strDrink }) {
        // does nothing
      }else {
        self.history.append(cocktail)
      }
    //}
    
  }
  
  // Found the remove method from
  //https://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift
  func removeCocktailtoHistory(cocktail: Cocktail){
      // if let index = self.history.firstIndex(of: cocktail.strDrink) {
      if let index = self.history.firstIndex(of: cocktail){
        self.history.remove(at: index)
      }else {
        // does nothing
      }
    
  }
  
  func getIngredientbyName(for queryTerm: String) async {
    print("getting Ingredient")
    var success = false
    
    
    do {
        if let fetchedIngredient = try await service.getIngredient(from: queryTerm) {
          print("fetched Ingredient succuess path")
          if (fetchedIngredient.strIngredient != "Nothing found"){
            success = true // will run the 2nd api call for related drinks
          }
          await MainActor.run {
              self.currentIngredient = fetchedIngredient
          }
        }
    } catch {
      self.relatedDrinks = []
      print("Failed to fetch ingredient: \(error)")
    }
    self.relatedDrinks = []
    if (success){ // This is for the related drinks from ingredient
      print("getting related drinks list")
      do {
      if let fetchedDrinks = try await service.getDrinksRelated(from: queryTerm) {
        await MainActor.run {
          self.relatedDrinks = Array(fetchedDrinks.prefix(maxIndex))
        }
      }
      } catch {
        self.relatedDrinks = []
        print("Failed to fetch related ingredients: \(error)")
      }
    } else {
      self.relatedDrinks = []
    }
  }
  
//  func getCocktailById(for id: String) async {
//    print("getting cocktail though ingre")
//    do {
//      if let fetchedDrink = try await service.getCocktailById(id){
//        self.singleDrinkForIngredient = fetchedDrink
//      }
//    } catch {
//      print ("Failed to fetch related drink from ingredients: \(error)")
//    }
//  }
  
  // I need to change this to return
  func getCocktailById(for id: String) async throws -> Cocktail? {
      print("Getting cocktail through ingredient")
      do {
          if let fetchedDrink = try await service.getCocktailById(id) {
              await MainActor.run {
                  self.singleDrinkForIngredient = fetchedDrink
              }
              return fetchedDrink // Ensure the fetched drink is returned
          } else {
              return nil // Return nil if no drink was fetched
          }
      } catch {
          print("Failed to fetch related drink from ingredients: \(error)")
          return nil // Return nil in case of an error
      }
  }
  
  // Encoders and Decoders
  private func encodeCocktails(_ cocktails: [Cocktail]) -> Data {
      do {
          return try JSONEncoder().encode(cocktails)
      } catch {
          print("Failed to encode cocktails: \(error)")
          return Data()
      }
  }
  
  private func decodeCocktails(from data: Data) -> [Cocktail] {
      do {
          return try JSONDecoder().decode([Cocktail].self, from: data)
      } catch {
          print("Failed to decode cocktails: \(error)")
          return []
      }
  }
  
}





//  func fetchObjects(for queryTerm: String) async throws {
//    if let objectIDs = try await service.getObjectIDs(from: queryTerm) {  // 1
//      for (index, objectID) in objectIDs.objectIDs.enumerated()  // 2
//      where index < maxIndex {
//        if let object = try await service.getObject(from: objectID) {
//          await MainActor.run {
//            objects.append(object)
//          }
//        }
//      }
//    }
//  }

