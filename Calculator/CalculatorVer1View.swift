//
//  ContentView.swift
//  Calculator
//
//  Created by Ngoc Nguyen on 6/13/23.
//

import SwiftUI

struct CalculatorVer1View: View {
    let buttonList = [
            ["AC", "+/-", "%", "/"],
            ["7", "8", "9", "x"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "00", "="]
        ]
    @StateObject var calViewModel = Calculator1ViewModel()
    
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
                        .frame(width: 40, height: 40)
                        .imageScale(.large)
                    //.foregroundColor(.white)
                    Image(systemName: "moon.stars")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .imageScale(.large)
                    //.foregroundColor(.white)
                    
                }
                Spacer()
                //Sequences, equal sign, result
                HStack{
                    Spacer()
                    Text(calViewModel.textView)
                        .font(.system(size: 40))
                        .padding(20)
                        .border(Color.red)
                }
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
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
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
        }
    }
}

class Calculator1ViewModel: ObservableObject {
    @Published var textView: String = "0"
    var operation: String = ""
    var currentNumber: String = "0"
    var storedCurrentNumber: String = ""
    var resetForNextNumber = true
    
    func receiveInput(button: String) {
        switch button {
        case "AC":
            clear()
        case "+/-":
            changeSign()
        case "+", "-", "x", "/", "%":
            if operation == "" {
                operation = button
                addSubMulDiv()
            }
            else{
                addSubMulDiv()
                operation = button
            }
        case "=":
            equal()
        default:
            if(resetForNextNumber || currentNumber == "0" || currentNumber == "00"){
                currentNumber = ""
            }
            currentNumber += button
            resetForNextNumber = false
            textView = currentNumber
        }
    }
        
        
    func addSubMulDiv(){
        //consecutive op
        if(resetForNextNumber && storedCurrentNumber == ""){
            return
        }
        equal()
        storedCurrentNumber = textView
        resetForNextNumber = true

    }

    
    func equal(){
        if let currentNum = Int(currentNumber), let storedNum = Int(storedCurrentNumber) {
            var result = 0
            switch operation {
            case "+":
                result = storedNum + currentNum
            case "-":
                result = storedNum - currentNum
            case "x":
                result = storedNum * currentNum
            case "/":
                if currentNum == 0 {
                    textView = "Error"
                    return
                } else {
                    result = storedNum / currentNum
                }
            case "%":
                if currentNum == 0 {
                    textView = "Error"
                } else {
                    result = storedNum % currentNum
                }
            default:
                break
            }
            textView = String(result)
        }
        resetForNextNumber = true
    }
    
    func changeSign() {
        // Perform sign change
        if let currentNum = Int(currentNumber){
            currentNumber = String(0 - currentNum)
            textView = currentNumber
        }
    }
    
    // Clear the input and operation
    private func clear() {
        textView = "0"
        operation = ""
        currentNumber = "0"
        storedCurrentNumber = ""
        resetForNextNumber = true
    }
}

struct CalculatorVer1View_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorVer1View()
    }
}


//Helper for Hexa color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(1)
        )
    }
}







