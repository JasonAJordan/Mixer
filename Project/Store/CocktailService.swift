//
//  CocktailService.swift
//  Project
//
//  Created by Jason Jordan on 11/8/24.
//

import Foundation

struct CocktailService {
    let baseURLString = "https://www.thecocktaildb.com/api/json/v1/1/"
    // www.thecocktaildb.com/api/json/v1/1/random.php

    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func getCocktailsByName(from queryTerm: String) async throws -> [Cocktail]? {
        guard let url = URL(string: baseURLString + "search.php?s=" + queryTerm) else { return nil }
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            print(">>> search response outside of bounds")
            return nil
        }
        
        do {
            let cocktailsResponse = try decoder.decode(Cocktails.self, from: data)
            return cocktailsResponse.drinks
        } catch {
            print(error)
            return nil
        }
    }
  
  func getCocktailsByRandom() async throws -> Cocktail? {
      guard let url = URL(string: baseURLString + "random.php") else { return nil }
      let request = URLRequest(url: url)
      
      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print(">>> search response outside of bounds")
          return nil
      }

      do {
          let cocktailsResponse = try decoder.decode(Cocktails.self, from: data)
          if let firstCocktail = cocktailsResponse.drinks.first {
            return firstCocktail
          } else {
            print("No drinks found in response.")
            return nil
          }
      } catch {
        print("Decoding error in getCocktailsByRandom: \(error)")
        return nil
    }
  }
  
  func getIngredient(from name: String) async throws -> Ingredient? {
      guard let url = URL(string: baseURLString + "search.php?i=" + name) else { return nil }
      let request = URLRequest(url: url)

      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print(">>> ingredient response outside of bounds")
          return nil
      }

      do {
          let ingredientResponse = try decoder.decode(Ingredients.self, from: data)
          return ingredientResponse.ingredients.first 
      } catch {
          print("Decoding error in getIngredient: \(error)")
        
          return Ingredient.nothingFound
          //return nil
      }
  }
  
  func getDrinksRelated(from name: String) async throws -> [CocktailMini]? {
      guard let url = URL(string: baseURLString + "filter.php?i=" + name) else { return nil }
      let request = URLRequest(url: url)

      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print(">>> related drinks response outside of bounds")
          return nil
      }

      do {
          let cocktailsMiniResponse = try decoder.decode(CocktailsMini.self, from: data)
          return cocktailsMiniResponse.drinks // Return the list of related drinks
      } catch {
          print("Decoding error in getDrinksRelated: \(error)")
          return nil
      }
  }
  
  
  func getCocktailById(_ id: String) async throws -> Cocktail? {
      guard let url = URL(string: baseURLString + "lookup.php?i=" + id) else { return nil }
      let request = URLRequest(url: url)

      let (data, response) = try await session.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
          print(">>> cocktail by ID response outside of bounds")
          return nil
      }

      do {
          let cocktailResponse = try decoder.decode(Cocktails.self, from: data)
          return cocktailResponse.drinks.first
      } catch {
          print("Decoding error in getCocktailById: \(error)")
          return nil
      }
  }
  

}

  
//
//  func getObjectIDs(from queryTerm: String) async throws -> ObjectIDs? {
//    let objectIDs: ObjectIDs?  // 1
//
//    guard var urlComponents = URLComponents(string: baseURLString + "search") else {  // 2
//      return nil
//    }
////    let baseParams = ["hasImages": "true"]
////    urlComponents.setQueryItems(with: baseParams)
//    // swiftlint:disable:next force_unwrapping
//    urlComponents.queryItems! += [URLQueryItem(name: "q", value: queryTerm)]
//    guard let queryURL = urlComponents.url else { return nil }
//    let request = URLRequest(url: queryURL)
//
//    let (data, response) = try await session.data(for: request)  // 1
//    guard
//      let response = response as? HTTPURLResponse,
//      (200..<300).contains(response.statusCode)
//    else {
//      print(">>> getObjectIDs response outside bounds")
//      return nil
//    }
//
//    do {  // 2
//      objectIDs = try decoder.decode(ObjectIDs.self, from: data)
//    } catch {
//      print(error)
//      return nil
//    }
//    return objectIDs  // 3
//  }
//
//  func getObject(from objectID: Int) async throws -> Object? {
//    let object: Object?  // 1
//
//    let objectURLString = baseURLString + "\(objectID)"  // 2
//    guard let objectURL = URL(string: objectURLString) else { return nil }
//    let objectRequest = URLRequest(url: objectURL)
//
//    let (data, response) = try await session.data(for: objectRequest)  // 3
//    if let response = response as? HTTPURLResponse {
//      let statusCode = response.statusCode
//      if !(200..<300).contains(statusCode) {
//        print(">>> getObject response \(statusCode) outside bounds")
//        print(">>> \(objectURLString)")
//        return nil
//      }
//    }
//
//    do {  // 4
//      object = try decoder.decode(Object.self, from: data)
////      print(object)
//    } catch {
//      print(error)
//      return nil
//    }
//
//    return object  // 5
//  }
//}
