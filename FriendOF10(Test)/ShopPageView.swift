import SwiftUI

struct ShopPageView: View {
    @ObservedObject var sharedData = SharedData.shared
    @State private var items: [Item] = [
        Item(id: 1, imageName: "1", pointValue: 20, offset: CGSize(width: -60, height: 350)),
        Item(id: 2, imageName: "2", pointValue: 5, offset: CGSize(width: -120, height: 330)),
        Item(id: 3, imageName: "3", pointValue: 10, offset: CGSize(width: 60, height: 330))
    ]
    @State private var purchasedItems: [Item] = []
    @State private var showPurchaseAlert: Bool = false
    @State private var selectedItemIndex: Int? = nil
    @State private var showInsufficientPointsMessage: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("title.png")
                        .resizable()
                        .scaledToFit()
                        .frame(width:390, height:70)
                }
                .offset(y: -320)
                
                HStack{
                    Image("PointTotal")
                        .resizable()
                        .frame(width: 270, height: 60)
                        .offset(x:-20)
                        
                    Text("\(sharedData.PointTotal)")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .offset(x:-20, y:3)
                }
                .offset(y:-260)
                
                Image("Border")
                    .resizable()
                    .frame(width: 350, height: 400)
                    .offset(y: -20)
                ScrollView(.vertical) {
                    VStack {
                        ForEach(items.indices, id: \.self) { index in
                            Button(action: {
                                itemButtonTapped(index: index)
                            }) {
                                Image(items[index].imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .background(items[index].isPurchased ? (items[index].isSelected ? Color.green : Color.gray) : Color.gray)
                                    .cornerRadius(10)
                                
                            }
                            .padding(3)
                        }
                    }
                }
                .offset(x:-80,y:170)
                .alert(isPresented: $showPurchaseAlert) {
                    Alert(
                        title: Text("Purchase Item"),
                        message: Text("Do you want to buy this item for \(items[selectedItemIndex!].pointValue) points?"),
                        primaryButton: .default(Text("Yes")) {
                            purchaseItem()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                VStack {
                    ForEach(sharedData.items.indices, id: \.self) { index in
                        Text("\(sharedData.items[index].pointValue) Points")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding(35)
                        .offset(x:60,y:-15)
                    }
                }

                if showInsufficientPointsMessage {
                    Image("ErrorPoint")
                        .foregroundColor(.red)
                        .transition(.opacity)
                       
                }

            
                    ZStack {
                        ForEach(purchasedItems) { item in
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
        if items[index].isPurchased {
            items[index].isSelected.toggle()
            if items[index].isSelected {
                addToPurchasedItems(item: items[index])
            } else {
                removeFromPurchasedItems(item: items[index])
            }
        } else {
            selectedItemIndex = index
            if sharedData.PointTotal >= items[index].pointValue {
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
            if sharedData.PointTotal >= items[index].pointValue {
                sharedData.PointTotal -= items[index].pointValue
                items[index].isPurchased = true
                items[index].isSelected = true
                addToPurchasedItems(item: items[index])
                selectedItemIndex = nil
            }
        }
    }

    private func addToPurchasedItems(item: Item) {
        if !purchasedItems.contains(where: { $0.id == item.id }) {
            purchasedItems.append(item)
        }
    }

    private func removeFromPurchasedItems(item: Item) {
        purchasedItems.removeAll(where: { $0.id == item.id })
    }
}

struct Item: Identifiable {
    let id: Int
    let imageName: String
    let pointValue: Int
    let offset: CGSize
    var isPurchased: Bool = false
    var isSelected: Bool = false
}

#Preview {
    ShopPageView()
    }

