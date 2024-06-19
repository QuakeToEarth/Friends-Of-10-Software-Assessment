import SwiftUI

struct ShopPage: View {
    @ObservedObject var sharedData = SharedData.shared
    @State private var showPurchaseAlert: Bool = false
    @State private var selectedItemIndex: Int? = nil
    @State private var showInsufficientPointsMessage: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
//All styling and background images
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("title.png")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 390, height: 70)
                }
                .offset(y: -320)
                
                Image("Border")
                    .resizable()
                    .frame(width: 350, height: 400)
                    .offset(y: -20)
                
//Shows user points avaliable
                HStack {
                    Image("PointTotal")
                        .resizable()
                        .frame(width: 270, height: 60)
                        .offset(x: -20)
                        
                    Text("\(sharedData.PointTotal)")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .offset(x: -20, y: 3)
                }
                .offset(y: -260)
                
                
//For every item in the shared data file, it creates a button
                ScrollView(.vertical) {
                    VStack {
                        ForEach(sharedData.items.indices, id: \.self) { index in
                            Button(action: {
                                itemButtonTapped(index: index)
                            }) {
                                Image(sharedData.items[index].imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .background(sharedData.items[index].isPurchased ? (sharedData.items[index].isSelected ? Color.green : Color.gray) : Color.gray)
                                    .cornerRadius(10)
                            }
                            .padding(3)
                        }
                    }
                }
                .offset(x: -80, y: 170)
                .alert(isPresented: $showPurchaseAlert) {
                    Alert(
                        title: Text("Purchase Item"),
                        message: Text("Do you want to buy this item for \(sharedData.items[selectedItemIndex!].pointValue) points?"),
                        primaryButton: .default(Text("Yes")) {
                            purchaseItem()
                        },
                        secondaryButton: .cancel()
                    )
                }
//Shows Item Point Value
                VStack {
                    ForEach(sharedData.items.indices, id: \.self) { index in
                        Text("\(sharedData.items[index].pointValue) Points")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding(35)
                        .offset(x:60,y:-15)
                    }
                }
//Appears if User doesn't own enough points
                if showInsufficientPointsMessage {
                    Image("ErrorPoint")
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                
//Appears when user purchases and selects the items, saves data in the shared data file
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
        }
    }

    private func itemButtonTapped(index: Int) {
        if sharedData.items[index].isPurchased {
            sharedData.items[index].isSelected.toggle()
        } else {
            selectedItemIndex = index
            if sharedData.PointTotal >= sharedData.items[index].pointValue {
                showPurchaseAlert = true
            } else {
                showInsufficientPointsMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showInsufficientPointsMessage = false
                }
            }
        }
    }

    private func purchaseItem() {
        if let index = selectedItemIndex {
            if sharedData.PointTotal >= sharedData.items[index].pointValue {
                sharedData.PointTotal -= sharedData.items[index].pointValue
                sharedData.items[index].isPurchased = true
                sharedData.items[index].isSelected = true
                selectedItemIndex = nil
            }
        }
    }
}

#Preview {
    ShopPage()
}
