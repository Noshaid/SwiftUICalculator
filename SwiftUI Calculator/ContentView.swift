//
//  ContentView.swift
//  SwiftUI Calculator
//
//  Created by Noshaid Ali on 20/03/2020.
//  Copyright © 2020 Noshaid Ali. All rights reserved.
//

import SwiftUI

enum CalculatorButton: String {
    
    case zero, one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent, dot
    
    var title: String {
        switch self {
        case .dot: return "."
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "x"
        case .divide: return "÷"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .equals: return "="
        default: return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .dot, .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return Color(.darkGray)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        default:
            return .orange
        }
    }
}

//Enviornment Object
//You can treat this as the Global Application State
class GlobalEnvironment: ObservableObject {
    
    @Published var display = GlobalEnvironment.defaultDisplay
    static let defaultDisplay = "0"
    var firstExpression = ""
    var secondExpression = ""
    var pressedOperator = ""
    
    func receiveInput(calculatorButton: CalculatorButton) {
        
        if calculatorButton == .ac {
            display = GlobalEnvironment.defaultDisplay
            firstExpression = ""
            secondExpression = ""
            pressedOperator = ""
            return
        }
        
        if calculatorButton == .plus || calculatorButton == .minus || calculatorButton == .multiply || calculatorButton == .divide {
            pressedOperator = calculatorButton.title
            
            if !firstExpression.isEmpty && !secondExpression.isEmpty {
                let first = Int(firstExpression) ?? 0
                let second = Int(display) ?? 0
                
                if pressedOperator == "+" {
                    display = "\(first + second)"
                } else if pressedOperator == "-" {
                    display = "\(first - second)"
                } else if pressedOperator == "x" {
                    display = "\(first * second)"
                } else if pressedOperator == "÷" {
                    display = "\(first / second)"
                }
            }
            return
        }
        
        if calculatorButton == .equals {
            let first = Int(firstExpression) ?? 0
            let second = Int(display) ?? 0
            
            if pressedOperator == "+" {
                display = "\(first + second)"
            } else if pressedOperator == "-" {
                display = "\(first - second)"
            } else if pressedOperator == "x" {
                display = "\(first * second)"
            } else if pressedOperator == "÷" {
                display = "\(first / second)"
            }
            firstExpression = display
            //secondExpression = ""
            //pressedOperator = ""
            return
        }
        
        if pressedOperator.isEmpty {
            if display == GlobalEnvironment.defaultDisplay {
                display = calculatorButton.title
            } else {
                display += calculatorButton.title
            }
            firstExpression = display
        } else {
            if secondExpression.isEmpty {
                display = calculatorButton.title
            } else {
                display += calculatorButton.title
            }
            secondExpression = display
        }
        
    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equals]
    ]
    
    var body: some View {
        //use ZStack when deal with safe area layout guide
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Text(env.display)
                    .foregroundColor(.white)
                    .font(.system(size: 64))
                }.padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) {
                            button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }.padding(.bottom)
        }
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        Button(action: {
            self.env.receiveInput(calculatorButton: self.button)
        }) {
            Text(button.title)
            .font(.system(size: 32))
                .frame(width: self.buttonWidth(button: button), height: (UIScreen.main.bounds.width - 5*12)/4)
            .foregroundColor(.white)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button)) //.cornerRadius(self.buttonWidth()/2)
        }
    }
    
    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return ((UIScreen.main.bounds.width - 5*12)/4)*2
        }
        return (UIScreen.main.bounds.width - 5*12)/4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
