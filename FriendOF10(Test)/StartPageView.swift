//
//  StartPageView.swift
//  FriendOF10(Test)
//
//  Created by Alicia J on 23/5/2024.
//

import SwiftUI
import Foundation

struct StartPageView: View {
    @ObservedObject var sharedData = SharedData.shared
    @State var ErrorMessage1 : String = ""
    @State var ErrorMessageInteger : String = ""
    
    @State var Move : Bool = false
    

    
    @State private var inputValue: String = ""
    @State private var isValidNumber: Bool = true
    @State private var AgeAppropraite: Bool = false

    
    //To check is Input is filled
    func checkinputfilled(){
        if inputValue.isEmpty ||  sharedData.Name.isEmpty{
            ErrorMessage1 = "ErrorFill"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                ErrorMessage1 = ""
            }
        }
        else
        {
            //Displays if Valid or not
            if isValidNumber == false{
                ErrorMessageInteger = "ErrorNumber"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    ErrorMessageInteger = ""
                }
            }
            else{
                ErrorMessage1 = ""
                print("Success!!")
                Move = true
               
            }
        }
        
        
    }
   
    
    var body: some View {
        NavigationStack{
            
            ZStack{
           
                //Title
                VStack{
                    Image("Title1.png")
                        .resizable()
                        .frame(width:500, height:350)
                        .padding(.leading)
                        .offset(y:-210)
                    
                    
                }
                //INPUT Name, this goes into Shared Data
                ZStack{
                    TextField("Enter Your Name Here", text: $sharedData.Name)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .frame(width:250, height:60)
                        .keyboardType(.alphabet)
                }
                .offset(y: 20)
                
                //INPUT Age
                ZStack {
                    TextField("Enter your Age", text: $inputValue)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green)
                        .frame(width:250, height:50)
                        .keyboardType(.numberPad)
                        .onChange(of: inputValue) { newValue in
                            validateInput(newValue)
                        }
                        .offset(y:30)
                    
                   
                    
                }
                .offset(y: 100)
                
                Image(ErrorMessage1)
                    .offset(y: 70)
                Image(ErrorMessageInteger)
                    .offset(y:70)
                
            
                //Enter Button
                VStack{
                    Button(action: {
                        checkinputfilled()
                    }, label: {
                        Image("Enter")
                            .resizable()
                            .frame(width:250, height:130)
                    })
                    
                }
                .offset(y:250)
                
                //Move button appears
                if Move == true{
                    if AgeAppropraite == true{
                     
                        ZStack{
                            NavigationLink(destination: HomePageView()) {
                                Image("Go")
                                    .resizable()
                                    .frame(width:350, height:200)
                            }
                            .isDetailLink(false)
                        }
                        .offset(y:60)
                        
                        Color.white
                        .frame(width:350, height:400)
                        .offset(y:300)
                        
                    }
                    else{
                        ZStack{
                            Color.white
                            .frame(width:350, height:400)
                            .offset(y:300)
                            Image("Recommendation")
                                .resizable()
                                .frame(width:350, height:400)
                                .offset(y: 80)
                            NavigationLink(destination: HomePageView()) {
                                Image("Continue")
                                    .resizable()
                                    .frame(width:250, height:140)
                            }
                            .isDetailLink(false)
                            .offset(y: 310)
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func validateInput(_ value: String) {
        if let intValue = Int(value) {
            if intValue  >= 0{
                isValidNumber = true
            } else {
                isValidNumber = false
            }
        } else {
            isValidNumber = false
        }
    }
    
    func checkAge(_ value: String) {
        if let intValue = Int(value) {
            if intValue  > 8 {
                AgeAppropraite = false
            } else{
                AgeAppropraite = true
            }
        }
    }
    
  
}
#Preview {
    StartPageView()
}
