//
//  ShoppingGroupView.swift
//  ShoppingSorted
//
//  Created by Quinn on 16/06/2023.
//

import SwiftUI

struct ShoppingGroupView: View {
    
    let group: GroupedIngredients
    let vm: ShoppingListViewModel
    @State var isMarkedForDeletion = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 10) {
                CircleButton(isSelected: $isMarkedForDeletion, group: group, vm: vm)
                
                
                VStack {
                    HStack {
                        Text(group.name)
                            .lineLimit(4)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        HStack(spacing: 5) {
                            Group {
                                Text(group.quantityString)
                                Text(group.unit)
                                    .foregroundColor(.gray)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        }
                        .frame(width: 90)
                    }
                    if group.items.count == 1 && group.items[0].mealTagForShoppingList != nil {
                        HStack {
                            Text("For '\(group.items[0].mealTagForShoppingList!)'")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .italic()
                            Spacer()
                        }
                        
                    }
                }
                
                
                
            
                
                
                if group.items.count == 1 {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22, alignment: .center)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            vm.selectedIngredientToEdit = group.items[0]
                        }
                }
                else if group.items.count > 1 {
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22, alignment: .center)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            vm.path = [group]
                        }
                }
            }
        }
    }
}


struct ShoppingGroupView_Preview: PreviewProvider {
    static var previews: some View {
        ShoppingGroupView(group: GroupedIngredients(id: UUID(), name: "Test", unit: "kg", quantity: 0, items: []), vm: ShoppingListViewModel())
    }
}


fileprivate struct CircleButton: View {
    
    @Binding var isSelected: Bool
    let group: GroupedIngredients
    let vm: ShoppingListViewModel
    
    var body: some View {
        
        Button {
            isSelected.toggle()
            vm.purchaseGroupedItems(group: group, toPurchase: isSelected)
 
        } label: {
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.green : Color.gray, lineWidth: 1)
                    .foregroundColor(.clear)
                    .frame(width: 24)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 18)
                }
            }
        }

        
//        .onTapGesture {
//       }
    }
}

