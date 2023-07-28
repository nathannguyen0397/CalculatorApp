//
//  CalculatorVer2View.swift
//  Calculator
//
//  Created by Ngoc Nguyen on 6/14/23.
//


import SwiftUI

struct CalculatorVer2View: View {
    let buttonList = [
            ["C", "+/-", "%", "/"],
            ["7", "8", "9", "x"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "00", "="]
        ]
    @StateObject var calViewModel = Calculator2ViewModel()
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        //Background
        ZStack {
            //Color.black.ignoresSafeArea(.all)
            VStack{
                //Day-Night mode
                HStack{
                    Image(systemName: "sun.max")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .imageScale(.large)
                    Image(systemName: "moon.stars")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .imageScale(.large)
                }
                .frame(width: 100, height: 50)
                .background(Color(hex: "b6e8fb"))
                .cornerRadius(20)

                Spacer()
                
                //Sequences, equal sign, result
                HStack{
                    //Operators, equal sign
                    VStack{
                        Text(calViewModel.operation)
                            .font(.system(size: 32))
                            .padding(10)
                            .frame(width: 50)
                        Text("=")
                            .font(.system(size: 32))
                            .padding(10)
                    }
                    .frame(width: 50)
                    VStack{
                        //Input1
                        Text(calViewModel.input1)
                            .onTapGesture {
                                calViewModel.selectedInput = 1
                            }
                            .font(.system(size: 30))
                            .frame(width: screenWidth - 120, alignment: .trailing)
                            .background(calViewModel.selectedInput == 1 ? Color(hex: "b6e8fb") : Color.clear)
                            .cornerRadius(15)
                                                
                        //input2
                        Spacer()
                        Text(calViewModel.input2)
                            .onTapGesture {
                                calViewModel.selectedInput = 2
                            }
                            .font(.system(size: 30))
                            .frame(width: screenWidth - 120, alignment: .trailing)
                            .background(calViewModel.selectedInput == 2 ? Color(hex: "b6e8fb") : Color.clear)
                            .cornerRadius(10)
                        
                        //Result
                        Spacer()
                        Text(calViewModel.result)
                            .font(.system(size: 30))
                            .frame(width: screenWidth - 120, alignment: .trailing)
                        
                    }
                    .padding(20)
                }
                .background(Color(hex: "9EE0FA"))
                .cornerRadius(20)
                .padding(20)
                .shadow(color: Color(hex: "#065979"), radius: 5, x: 0, y: 10)

                //grid of buttons
                VStack{
                    ForEach(0..<buttonList.count){row in
                        HStack{
                            ForEach(0..<buttonList[row].count, id: \.self){col in
                                Button(action: {
                                    //Handle button tap
                                    calViewModel.receiveInput(button: buttonList[row][col])
                                }){
                                    Text(buttonList[row][col])
                                        .font(.system(size: 28))
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(buttonList[row][col].allSatisfy { "0123456789.00".contains($0) } ? Color.black : Color.white)
                                        .background(buttonList[row][col].allSatisfy { "0123456789.00".contains($0)} ? Color.white.opacity(0.5) : Color(hex: "33ccff").opacity(0.75))
                                }

                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                                .padding(5)
                            }
                        }
                    }
                }
//                .border(Color.red)
                .frame(maxWidth: .infinity, maxHeight: 500)
                .padding(.top, 20)
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "55ccfa"), Color(hex: "#9de0fa").opacity(0.5)]), startPoint: .topTrailing, endPoint: .bottomLeading))
            .foregroundColor(Color(hex: "004477"))
        }
    }
}

class Calculator2ViewModel: ObservableObject {
    @Published var result: String = "0"
    @Published var operation: String = "+"
    @Published var selectedInput: Int = 1
    @Published var input1: String = "0"
    @Published var input2: String = "0"
    
    func receiveInput(button: String) {
        switch button {
        case "C":
            clear()
        case "+/-":
            changeSign()
        case "+", "-", "x", "/", "%":
            operation = button
        case "=":
            equal()
        default:
            if(selectedInput == 1){
                if(input1 == "0" || input1 == "00"){
                    input1 = ""
                }
                input1 += button
            }
            else{
                if(input2 == "0" || input2 == "00"){
                    input2 = ""
                }
                input2 += button
            }
            
        }
    }
    
    func clear(){
        result = "0"
        if(selectedInput == 1){
            input1 = "0"
        }
        else{
            input2 = "0"
        }
        selectedInput = 0

    }
    
    func changeSign(){
        if selectedInput == 1 {
                if let num = Int(input1) {
                    input1 = String(-num)
                }
            } else {
                if let num = Int(input2) {
                    input2 = String(-num)
                }
            }
    }
    
    func equal(){
        guard let num1 = Int(input1), let num2 = Int(input2) else {
                result = "Error"
                return
            }
            switch operation {
            case "+":
                result = String(num1 + num2)
            case "-":
                result = String(num1 - num2)
            case "x":
                result = String(num1 * num2)
            case "/":
                if num2 == 0 {
                    result = "Error"  // Handle division by zero
                } else {
                    result = String(num1 / num2)
                }
            case "%":
                if num2 == 0 {
                    result = "Error"  // Handle division by zero
                } else {
                    result = String(num1 % num2)
                }
            default:
                result = "Error"
            }
        selectedInput = 0
        }
    
    
    
}

struct Calculator2View_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorVer2View()
    }
}









