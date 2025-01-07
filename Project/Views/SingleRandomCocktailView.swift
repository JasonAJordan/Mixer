//
//  SingleRandomCocktailView.swift
//  Project
//
//  Created by Jason Jordan on 11/16/24.
//

import SwiftUI


struct SingleRandomCocktailView: View {
    @ObservedObject var store: CocktailStore
    let cocktail: Cocktail
    let testingMode: Bool
    @Environment(\.dismiss) var dismiss
  
    
    @State private var rotation: Double = 360 // Tracks rotation state

  
  @State private var navigateToIngredient: Bool = false // Controls navigation to ingredient
  @State private var selectedIngredient: String? = nil // Tracks the selected ingredient

  
    @State private var showStar: Bool = false // Controls visibility of the star

//  @State private var animateNewBtn: Bool = false // for adding a animatio to the new button
  
  @State private var isTapped: Bool = false // for adding a animatio to the new button

//  HStack{
//    
//    Text(cocktail.strDrink)
//      .font(.largeTitle)
//      .padding(.bottom, 10)
//  }
    var body: some View {
      ScrollView { // Allows content to scroll if it overflows the screen I found this from chat gpt, I googled first and couldn't find a good answer
        if (cocktail.strDrink != "Pina_Colada"){
          VStack(spacing: 10) {
            HStack{
              
              Text(cocktail.strDrink)
                .font(.largeTitle)
                .padding(.bottom, 10)
            }
            
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
            Spacer()
          }
        }
        // I followed a youtube guide, then added more to it https://www.youtube.com/watch?v=TQGBPtoWcPk
        else {
          
          VStack {
            // I got this spinner idea from here. https://www.youtube.com/watch?v=TQGBPtoWcPk
              Text("Loading...")
                  .font(.largeTitle)
                  .padding(.bottom, 10)
              Circle()
                  .trim(from: 1/2, to: 1) // Creates a partial circle
                  .stroke(lineWidth: 10) // Sets the stroke width
                  .frame(width: 200, height: 150) // Sets the frame size
                  .rotationEffect(.degrees(rotation)) // Applies rotation effect
                  .onAppear {
                      startwithAnimation()
                  }
                  .foregroundColor(.cyan)
                  
          }
          
        }
      }
        //.padding()
        //.navigationTitle("Page Details")
      
      // TOOL BAR CODE STARTS HERE
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              HStack{
                // New Button
                Button(action: {
                  Task {
                    await store.getCocktailsByRandom()
                    //navigateToRandomCocktail = true // Set this after fetching the random cocktail
                    // This is to make the app wait for the api call
                  }
                }) {
                  Text("New")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.black)
                    //.background(Color.cyan)
                    .background(isTapped ? Color.orange : Color.cyan) // Color changes on tap

                    .clipShape(Capsule())
                  
                    //.scaleEffect(animateNewBtn ? 1.0 : 0.7)
                } //.resizable()
                  //.scaledToFit()
                  //.scaleEffect(animateNewBtn ? 1.0 : 0.9) // Shrinks or expands the image
                  .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) { // Smooth color transition
                        isTapped.toggle() // Toggle the color
                    }


                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isTapped = false
                        }
                    }
                  }
                
                Spacer()
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
        }
      
      // Background for navigation
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
  
  // rotates the spiner with "withAnimation"
  private func startwithAnimation() {
      withAnimation(Animation.linear(duration: 2)) {
          rotation += 360
      }

      // Schedule the next rotation
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        startwithAnimation() }
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
          .animation(.interpolatingSpring(stiffness:170, damping:15), value: showStar)
          .animation(.easeInOut(duration: 1), value: showStar)
  }
}

struct SingleRandomCocktailView_Previews: PreviewProvider {
    static var previews: some View {
        SingleRandomCocktailView(
            store: CocktailStore(),
            cocktail: Cocktail.pinaC,
            testingMode: true
        )
    }
}


//  let placeholder = Cocktail(
//    strDrink: "Pina Colada",
//    strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/upgsue1668419912.jpg",
//    strIngredient1: "Light Rum",
//    strIngredient2: "Coconut Juice",
//    strIngredient3: "Pineapple"
//  )
