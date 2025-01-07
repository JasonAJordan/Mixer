//
//  SingleCockTailView.swift
//  Project
//
//  Created by Jason Jordan on 11/9/24.
//

import SwiftUI

struct SingleCockTailView: View {
  @ObservedObject var store: CocktailStore
  let cocktail: Cocktail
  @Environment(\.dismiss) var dismiss
  @State private var navigateToIngredient: Bool = false // Controls navigation to ingredient
  @State private var selectedIngredient: String? = nil // Tracks the selected ingredient

  
  @State private var showStar: Bool = false // Controls visibility of the star
  
//  let star = Image(systemName: store.favorites.contains(cocktail) ? "star.fill" : "star")
//    .foregroundColor(store.favorites.contains(cocktail) ? .yellow : .gray)
  
  
  var body: some View {
    ScrollView { // Allows content to scroll if it overflows the screen ty chat gpt! I googled first and couldn't find a good answer
      VStack(spacing: 10) {
        // Back button can be added here if needed
        //                Text(cocktail.strDrink)
        //                    .font(.largeTitle)
        //                    .padding(.bottom, 10)
        //                    .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
        
        ZStack {
          
          if let imageUrl = URL(string: cocktail.strDrinkThumb) {
            AsyncImage(url: imageUrl) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(10)
            } placeholder: {
              ProgressView()
            }
            .padding(.bottom, 20)
          }
          
          playAnimation(Image(systemName: "star.fill"))

        }

        
        if let strInstructions = cocktail.strInstructions {
          Text("Instructions: \(strInstructions)")
            .font(.headline)
            .multilineTextAlignment(.leading)
            .padding([.bottom, .trailing], 20)
            .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
        }
        
        Text("Ingredients:")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
        
        if let ingredient1 = cocktail.strIngredient1 {
          if let measure1 = cocktail.strMeasure1 {
            ingredientButton2(for: ingredient1, measurement:measure1)
          } else {
            ingredientButton(for: ingredient1)
          }
        }
        
        if let ingredient2 = cocktail.strIngredient2 {
          if let measure2 = cocktail.strMeasure2 {
            ingredientButton2(for: ingredient2, measurement:measure2)
          } else {
            ingredientButton(for: ingredient2)
          }
        }
        
        if let ingredient3 = cocktail.strIngredient3 {
          if let measure3 = cocktail.strMeasure3 {
            ingredientButton2(for: ingredient3, measurement:measure3)
          } else {
            ingredientButton(for: ingredient3)
          }
        }
        
        if let ingredient4 = cocktail.strIngredient4 {
          if let measure4 = cocktail.strMeasure4 {
            ingredientButton2(for: ingredient4, measurement:measure4)
          } else {
            ingredientButton(for: ingredient4)
          }
        }
        
        if let ingredient5 = cocktail.strIngredient5 {
          if let measure5 = cocktail.strMeasure5 {
            ingredientButton2(for: ingredient5, measurement:measure5)
          } else {
            ingredientButton(for: ingredient5)
          }
        }
        
//        if let ingredient1 = cocktail.strIngredient1 {
//          Text("\(ingredient1) NEEDS Ingredients linking")
//            .font(.headline)
//            .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
//        }
//        
//        if let ingredient2 = cocktail.strIngredient2 {
//          Text("\(ingredient2)")
//            .font(.headline)
//            .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
//        }
//        
//        if let ingredient3 = cocktail.strIngredient3 {
//          Text("\(ingredient3)")
//            .font(.headline)
//            .frame(maxWidth: .infinity, alignment: .topLeading) // Align text to top
//        }
        
        Spacer()
      }
      .padding()
    }
    // Toolbar and titles
    .navigationTitle(cocktail.strDrink )
    .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
              store.toggleFavorite(for: cocktail)
              
              // run playAnimation here or removes star
              if store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }){
                showStar = true
                // DispatchQueue from prof
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                  showStar = false
                }
              }

            }) {
                Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
                    .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
            }
        }
    }
    .background(
        NavigationLink(
            destination: CurrentIngredientView(
                store: store,
                ingredient: store.currentIngredient ?? Ingredient(
                    idIngredient: "",
                    strIngredient: "Loading...",
                    strDescription: nil,
                    strType: nil,
                    strAlcohol: nil,
                    strABV: nil
                )
            ),
            isActive: $navigateToIngredient
        ) { EmptyView() }
    )
  }
  
  
  // Heper functions for the linking of views/pages
  private func ingredientButton(for ingredient: String) -> some View {
      Button(action: {
          Task {
              await store.getIngredientbyName(for: ingredient)
              navigateToIngredient = true
          }
      }) {
          Text("• \(ingredient)")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .topLeading)
      }
  }
  
  private func ingredientButton2(for ingredient: String, measurement: String) -> some View {
      Button(action: {
          Task {
              await store.getIngredientbyName(for: ingredient)
              navigateToIngredient = true
          }
      }) {
          Text("• \(measurement)of \(ingredient)")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .topLeading)
      }
  }
  
  
  
  // Function to trigger the star animation
  // Where I got this from
  // https://www.youtube.com/watch?v=KL50qKi66EQ
  func playAnimation(_ image: Image) -> some View {
      image
          .resizable()
          .foregroundColor(.yellow)
          .scaledToFit()
          .frame(height: 300)
          .cornerRadius(10)
          .scaleEffect(showStar ? 1: 0)
          .opacity(showStar ? 1 : 0)
          .animation(.interpolatingSpring(stiffness:120, damping:50), value: showStar)
          .animation(.easeInOut(duration: 1), value: showStar)
  }
    
}

struct SingleCockTailView_Previews: PreviewProvider {
//  let placeholder = Cocktail(
//    strDrink: "Pina Colada",
//    strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/upgsue1668419912.jpg",
//    strIngredient1: "Light Rum",
//    strIngredient2: "Coconut Juice",
//    strIngredient3: "Pineapple"
//  )
  
    static var previews: some View {
        SingleCockTailView(
          store: CocktailStore(),
          cocktail: Cocktail.pinaC
        )
    }
}
