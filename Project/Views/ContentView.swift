//
//  ContentView.swift
//  Project
//
//  Created by Jason Jordan on 11/8/24.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var store = CocktailStore()
    @State private var query = ""
    @State private var searched = false
    @State private var navigateToRandomCocktail = false
    @State private var editHistoryMode = false
  
  
    @State private var selectedTab: String = "" // Keep track of the selected tab
  
  
    // Not being used I give up.
    @State private var searchTimeout = false
    @State private var searchedString = "" // Keep track of last called search drink

  
  func toggleEditHistoryMode(){
    self.editHistoryMode = !self.editHistoryMode
  }

    var body: some View {
        TabView {
          
          // Search Tab
          NavigationStack {
              VStack {
                
                  TextField("Search for a cocktail by name...", text: $query, onCommit: {
                      Task {
                          await store.getCocktailsByName(for: query)
                          searched = true
                      }
                  })
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  //.padding()
                  .onChange(of: query) { textValue in
                      if textValue.isEmpty {
                          searched = false
                          store.cocktails = []
                      }
                  }
                // Refactoring my search field so I can add a time out
//                TextField("Search for a cocktail by name...", text: $query)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .onChange(of: query) { textValue in
//                      Task {
//                        //if (searchTimeout == false){
//                          if textValue.isEmpty {
//                            searched = false
//                            store.cocktails = []
//                          } else {
//                            await store.getCocktailsByName(for: textValue)
//                            searchedString = textValue
//                            searched = true
//                            searchTimeout = true
//
//                            // From prof
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                if (textValue != searchedString){
//                                }
//                            searchTimeout = false
//                            }
//                          }
//                        //}
//                        }
//                    }
                  
                  if !store.cocktails.isEmpty {
                      List(store.cocktails, id: \.strDrink) { cocktail in
                        NavigationLink(
                            destination: SingleCockTailView(
                                store: store, // Pass shared store instance
                                cocktail: cocktail
                            )
                            .onAppear {
                                Task {
                                  if (store.incognitomode == false){
                                    store.addCocktailtoHistory(cocktail: cocktail)
                                  }
                                }
                            }
                        ) {
                          HStack {
                            Text(cocktail.strDrink)
                            Spacer()
                            
                            // Favorite Star here
                            
                            Button(action: {
                                store.toggleFavorite(for: cocktail)
                            }) {
                                Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
                                    .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
                            }.buttonStyle(BorderlessButtonStyle())

                          }
                        }
                      }.listStyle(PlainListStyle())
                  } else if !query.isEmpty && searched {
                      Text("Nothing Found")
                  }
                  Spacer()
              }
              .padding()
              .navigationTitle("Search")
          }
          .tabItem {
              Label("Search", systemImage: "magnifyingglass")
          }
          
          // Random Tab //
          NavigationStack {
              VStack {
                  SingleRandomCocktailView(
                      store: store, // Pass shared store instance
                      cocktail: store.randcocktail,
                      testingMode: false
                  )
              }
              .padding()

              .onAppear {
                  Task {
                      await store.getCocktailsByRandom()
                  }
              }
          }
          .tabItem {
              Label("Random", systemImage: "dice")
          }
          .tag("Random")
          
          // Ingredient Tab
          NavigationStack {
              VStack {
                  TextField("Search for a Ingredient by name...", text: $query, onCommit: {
                      Task {
                          await store.getIngredientbyName(for: query)
                        //searched = true
                      }
                  })
                  .textFieldStyle(RoundedBorderTextFieldStyle())
//                  .padding()
                  .onChange(of: query) { textValue in
                      if textValue.isEmpty {
                        // empty view
                      }
                  }
                  
//                if (store.currentIngredient != nil) {
//                  CurrentIngredientView(ingredient: store.currentIngredient)
//                }
                
                if let ingredient = store.currentIngredient {
                    CurrentIngredientView(store: store,
                                          ingredient: ingredient)
                }
                
                  Spacer()
              }
              .padding()
              .navigationTitle("Ingredient Search")
          }
          .tabItem {
              Label("Ingredient", systemImage: "drop")
          }

          // History Tab
          NavigationStack {
            HStack{
              Spacer()
              Toggle(isOn: $store.incognitomode) {
                Text("Incognito Mode")
                  .font(.headline)
                // https://stackoverflow.com/questions/73327827/remove-space-between-toggle-button-and-text
                  .frame(maxWidth: .infinity, alignment: .trailing)
              }.padding()
            }
            // The normal view
            if (!editHistoryMode){
              VStack {
                if !store.history.isEmpty {
                  List(store.history.reversed(), id: \.strDrink) { cocktail in
                    NavigationLink(destination: SingleCockTailView(
                      store: store, // Pass shared store instance
                      cocktail: cocktail)) {
                        HStack {
                          Text(cocktail.strDrink)
                          Spacer()
                          // Favorite Star here
                          Button(action: {
                              store.toggleFavorite(for: cocktail)
                          }) {
                              Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
                                  .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
                          }.buttonStyle(BorderlessButtonStyle())

//                          Button(action: {
//                            //toggleFavorite(for: cocktail)
//                          }) {
//                            // I got a bug if I didn't use where: { $0.}
//                            
//                            Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
//                              .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
//                          }
                        }
                      }
                  }.listStyle(PlainListStyle())
                }
                else {
                  Spacer()
                }

                
                // Add a button here with the text clear all history
                Button(action: {
                  Task {
                    toggleEditHistoryMode()
                    //await store.clearHistory()
                  }
                }) {
                  Text("Edit History")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                  //.padding(.horizontal)
                }
              // Vstack End is here
              }.padding()
                .navigationTitle("History")
            } else {
              // The Edit View
              VStack {
                if !store.history.isEmpty {
                  List(store.history.reversed(), id: \.strDrink) { cocktail in
                    HStack {
                        
                        Button(action: {
                            store.removeCocktailtoHistory(cocktail: cocktail)
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                      // I need to add this buttonStyle to avoid trigger both button on actions
                      // https://stackoverflow.com/questions/58514891/two-buttons-inside-hstack-taking-action-of-each-other
                      
                        Text(cocktail.strDrink)
                        Spacer()

                        Button(action: {
                            store.toggleFavorite(for: cocktail)
                        }) {
                            Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
                                .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
                        }.buttonStyle(BorderlessButtonStyle())

                    }
                  }.listStyle(PlainListStyle())
                }
                else {
                  Spacer()
                }
                // Add a button that clears all history
                Button(action: {
                  Task {
                    await store.clearHistory()
                  }
                }) {
                  Text("Clear All History")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                  //.padding(.horizontal)
                }
                // Add a button here to toggle a edit mode
                Button(action: {
                  Task {
                    toggleEditHistoryMode()
                  }
                }) {
                  Text("History Edit Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                  //.padding(.horizontal)
                }
              // Vstack End is here
              }.padding()
                .navigationTitle("History")
            }

          }
          .tabItem {
              Label("History", systemImage: "clock.arrow.circlepath")
          }

          // Favorites Tab
          NavigationStack {
            VStack {
//              Toggle("Incognito Mode")
//                  .padding()
//                  .toggleStyle(SwitchToggleStyle(tint: .blue))
              
              
                if !store.favorites.isEmpty {
                  List(store.favorites.reversed(), id: \.strDrink) { cocktail in
                    NavigationLink(
                      destination: SingleCockTailView(                      
                        store: store, // Pass shared store instance
                        cocktail: cocktail)) {
                        HStack {
                          Text(cocktail.strDrink)
                          Spacer()
                          
                          // Favorite Star here
                          
                          Button(action: {
                              store.toggleFavorite(for: cocktail)
                          }) {
                              Image(systemName: store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? "star.fill" : "star")
                                  .foregroundColor(store.favorites.contains(where: { $0.strDrink == cocktail.strDrink }) ? .yellow : .gray)
                          }.buttonStyle(BorderlessButtonStyle())

                        }
                    }
                  }.listStyle(PlainListStyle())
                }
                Spacer()
            }
              .padding()
              .navigationTitle("Favorites")
          }
          .tabItem {
              Label("Favorites", systemImage: "heart")
          }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}



//// Random Tab
//NavigationStack {
//    VStack {
//      // button moved to Randomcocktailview
////                    Button(action: {
////                        Task {
////                            await store.getCocktailsByRandom()
////                            navigateToRandomCocktail = true // Set this after fetching the random cocktail
////                          // This is to make the app wait for the api call
////                        }
////                    }) {
////                        Text("Random")
////                            .frame(width: 80, height: 80)
////                            .foregroundColor(Color.black)
////                            .background(Color.cyan)
////                            .clipShape(Circle())
////                    }
//      SingleRandomCocktailView(store: CocktailStore(), cocktail:store.randcocktail,
//        testingMode: false
//        )
////                    .navigationDestination(isPresented: $navigateToRandomCocktail) {
////                        SingleCockTailView(cocktail: store.randcocktail)
////                    }
//        //Spacer()
//    }
//    .padding()
//    .onAppear {
//        Task {
//            await store.getCocktailsByRandom()
//            navigateToRandomCocktail = true
//          // This is to make the app wait for the api call
//        }
//    }
