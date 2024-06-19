//
//  ContentView.swift
//  FriendOF10(Test)
//
//  Created by Alicia J on 21/5/2024.
//

import SwiftUI

struct HomePageView: View {
    @ObservedObject var sharedData = SharedData.shared
    @State var message = "Hello "
    @State var age = ""
    var body: some View {
        NavigationStack{
            
           
            
            ZStack {
                Image("Background")
                    .resizable()
                    .frame(width: 395, height: 855)
                    .edgesIgnoringSafeArea(.all)
                    
                
                //TITLE
                VStack{
                    Image("title.png")
                        .resizable()
                        .scaledToFit()
                        .frame(width:380, height:100)
                    
                }
                .offset(y:-350)
                .padding()
               
                VStack{
                    NavigationLink(destination: QuizPageView()) {
                        Image("Quiz")
                            .resizable()
                            .frame(width:350, height:170)
                            .buttonStyle(.borderedProminent)
                    }
                    .padding(.bottom)
                }
                .offset(y:-150)
                
                
                
        //Take User to Shop Page
                VStack{
                    NavigationLink(destination: ShopPage()) {
                        Image("Shop")
                            .resizable()
                            .frame(width:350, height:170)
                            .buttonStyle(.borderedProminent)
                    }
                }
                .offset(y:50)
                
                
                .padding(.bottom)
                //START MESSAGE
                Text("Hello "+sharedData.Name+"!")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .offset(y:170)
                Spacer()
                
                ZStack {
                    ForEach(sharedData.items.filter { $0.isSelected }) { item in
                        Image(item.imageName)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .offset(item.offset)
                    }
                }
                .padding()
                    
                
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            
            
        }
    }
    
}

#Preview {
    HomePageView()
}
