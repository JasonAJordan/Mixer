//
//  currentIngredientView.swift
//  Project
//
//  Created by Jason Jordan on 11/24/24.
//

import SwiftUI

struct CurrentIngredientView: View {
  @ObservedObject var store: CocktailStore
  let ingredient: Ingredient // Pass the ingredient to the view
  // I might not need this now Im passing the store down
  
  
  // I had some trouble figuring this part out
  @State private var selectedCocktail: Cocktail? = nil // don't need now
  @State private var navigateToCocktail: Bool = false
  
  // can't do this
//  @State private var cocktailHelp: Cocktail = store.singleDrinkForIngredient ?? Cocktail.blank
  
    
  var body: some View {
    ScrollView {
//      if (!navigateToCocktail){
        VStack(alignment: .leading, spacing: 10) {
          Text(ingredient.strIngredient)
            .font(.title2)
            .bold()
          
          if let type = ingredient.strType {
            Text("Type: \(type)")
          }
          
          if let alcohol = ingredient.strAlcohol {
            Text("Alcohol: \(alcohol)")
          }
          
          if let abv = ingredient.strABV {
            Text("ABV: \(abv)%")
          }
          
          if let description = ingredient.strDescription {
            Text("Description:")
              .font(.headline)
            Text(description)
              .multilineTextAlignment(.leading)
              .padding(.bottom, 10)
          } else {
            Text("No description available.")
              .foregroundColor(.gray)
          }
          
          
          // Value of optional type '[CocktailMini]?' must be unwrapped to refer to member 'isEmpty' of wrapped base type '[CocktailMini]'
          //          if !store.relatedDrinks.isEmpty {
          //            List(store.relatedDrinks, id: \.strDrink) { cocktail in
          //              Text("Title ", cocktail.strDrink)
          //            }}
          
          // Related Drinks
          if let relatedDrinks = store.relatedDrinks, !relatedDrinks.isEmpty {
            Text("Drinks that use \(ingredient.strIngredient):")
              .font(.headline)
              .padding(.top, 10)
            
            ForEach(relatedDrinks, id: \.strDrink) { cocktail in
              Button(action: {
                Task {
                  if let fullCocktail = try? await store.getCocktailById(for: cocktail.idDrink) {
                    //selectedCocktail = fullCocktail
                    navigateToCocktail = true
                  }
                }
              }) {
                HStack {
                  Text(cocktail.strDrink)
                  Spacer()
                  if let url = URL(string: cocktail.strDrinkThumb) {
                    AsyncImage(url: url) { image in
                      image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(5)
                    } placeholder: {
                      ProgressView()
                    }
                  }
                }
                .padding(.vertical, 5) // Add spacing between items
              }
            }
          } else {
            Text("No related drinks found.")
              .foregroundColor(.gray)
              .padding(.top, 10)
          }
          
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        //.background(Color(red: 0.7, green: 0.8, blue: 1.0))
        .cornerRadius(10)
        .padding(.top, 20)
      
//      else {
//        // This code was copy and pasted then fixed from content view
//        // I needed this helper
//        var helperCocktail: Cocktail = store.singleDrinkForIngredient ?? Cocktail.blank
//          SingleCockTailView(
//            store: store, // Pass shared store instance
//            cocktail: helperCocktail)
//        
//      }
    } //.navigationTitle(ingredient.strIngredient)//asdf
      .background(
      NavigationLink(
          destination: SingleCockTailView(
              store: store,
              cocktail: store.singleDrinkForIngredient ?? Cocktail.blank
          ).onAppear {
            if let ingredientCocktail = store.singleDrinkForIngredient {
                Task {
                  if (store.incognitomode == false){
                    store.addCocktailtoHistory(cocktail: ingredientCocktail)
                  }
                }
            }
        },
          isActive: $navigateToCocktail
      ) {
          EmptyView()
      }
  )
}
}

#Preview {
    CurrentIngredientView(
      store: CocktailStore(),
        ingredient: Ingredient(
            idIngredient: "359",
            strIngredient: "Orange",
            strDescription: "The orange is the fruit of the citrus species Citrus × sinensis in the family Rutaceae. It is also called sweet orange...",
            strType: "Fruit",
            strAlcohol: "No",
            strABV: nil
        )
    )
}
