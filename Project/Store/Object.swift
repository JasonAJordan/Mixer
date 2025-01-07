//
//  Object.swift
//  Project
//
//  Created by Jason Jordan on 11/8/24.
//


import Foundation

// Don't need from text book
struct Object: Codable, Hashable {
  let objectID: Int
  let title: String
  let creditLine: String
  let objectURL: String
  let isPublicDomain: Bool
  let primaryImageSmall: String
}

// Don't need from textbook
struct ObjectIDs: Codable {
  let total: Int
  let objectIDs: [Int]
}


struct Cocktail: Codable , Equatable {
  let strDrink: String
  let strDrinkThumb: String
  let strIngredient1: String?
  let strIngredient2: String?
  let strIngredient3: String?
  let strIngredient4: String?
  let strIngredient5: String?
  let strInstructions: String?
  let strMeasure1: String?
  let strMeasure2: String?
  let strMeasure3: String?
  let strMeasure4: String?
  let strMeasure5: String?

  // This is or removing and adding to history or favorites
  static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
    return lhs.strDrink == rhs.strDrink
  }
  
  // I wish I figured this out 3 weeks ago
  static let pinaC = Cocktail(
    strDrink: "Pina_Colada",
    strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/upgsue1668419912.jpg",
    strIngredient1: "Light Rum",
    strIngredient2: "Coconut Juice",
    strIngredient3: "Pineapple",
    strIngredient4: nil,
    strIngredient5: nil,
    strInstructions: "Mix with crushed ice in blender until smooth. Pour into chilled glass, garnish and serve.",
    strMeasure1: "3 oz ",
    strMeasure2: "3 tblsp ",
    strMeasure3: "3 tblsp ",
    strMeasure4: nil,
    strMeasure5: nil
  )
  
  static let blank = Cocktail(
    strDrink: "Loading...",
    strDrinkThumb: "Loading...",
    strIngredient1: nil,
    strIngredient2: nil,
    strIngredient3: nil,
    strIngredient4: nil,
    strIngredient5: nil,
    strInstructions: nil,
    strMeasure1: nil,
    strMeasure2: nil,
    strMeasure3: nil,
    strMeasure4: nil,
    strMeasure5: nil
    )
}

struct Cocktails: Codable{
  let drinks: [Cocktail]
}

struct CocktailMini: Codable {
  let strDrink: String
  let strDrinkThumb: String
  let idDrink: String // don't need
}

struct CocktailsMini:Codable {
  let drinks: [CocktailMini]
}

// Ingredient
struct Ingredient: Codable {
    let idIngredient: String
    let strIngredient: String
    let strDescription: String?
    let strType: String?
    let strAlcohol: String?
    let strABV: String?
  
  
  // nothing found respone
  static let nothingFound = Ingredient(
      idIngredient: "",
      strIngredient: "Nothing found",
      strDescription: "Sorry you must type in correct ingredient names.",
      strType: nil,
      strAlcohol: nil,
      strABV: nil
  )
}

struct Ingredients: Codable {
    let ingredients: [Ingredient]
}
