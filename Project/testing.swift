//
//  testing.swift
//  Project
//
//  Created by Jason Jordan on 11/16/24.
//
// Please ignore this file


import SwiftUI

struct testing: View {
    let cocktail: Cocktail
    @Environment(\.dismiss) var dismiss
  
    var body: some View {
        VStack(spacing: 10) {
//          HStack{
//            Button(action: {
//              dismiss()
//            }) {
//              HStack {
//                Image(systemName: "chevron.left")
//                Text("Back")
//              }
//              .font(.headline)
//
//            }
//            Spacer()
//          }
          
            Text(cocktail.strDrink)
                .font(.largeTitle)
                .padding(.bottom, 10)
          
          
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
          if let strInstructions = cocktail.strInstructions {
              Text("Instructions: \(strInstructions)")
              .font(.headline)
              .multilineTextAlignment(.center)
              .padding([.bottom, .trailing], 20)
          }
            Text("Ingredients:").font(.headline)
            if let ingredient = cocktail.strIngredient1 {
                Text("\(ingredient)")
                    .font(.headline)
            } else {
                Text("No main ingredient specified")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
          if let ingredient = cocktail.strIngredient2 {
              Text("\(ingredient)")
                  .font(.headline)
          }
          if let ingredient = cocktail.strIngredient3 {
              Text("\(ingredient)")
                  .font(.headline)
          }
            
            Spacer()
        }
        .padding()
        //.navigationTitle("Page Details")
    }
}

struct testing_Previews: PreviewProvider {
//  let placeholder = Cocktail(
//    strDrink: "Pina Colada",
//    strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/upgsue1668419912.jpg",
//    strIngredient1: "Light Rum",
//    strIngredient2: "Coconut Juice",
//    strIngredient3: "Pineapple"
//  )
  
    static var previews: some View {
      testing(
        cocktail: Cocktail.pinaC
        )
    }
}
