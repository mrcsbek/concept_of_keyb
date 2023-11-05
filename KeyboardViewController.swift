//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by mrcsbek on 28/10/23.
//


import UIKit
import SwiftUI

struct ContentView: View {
    
    @State private var inputText: String = ""
    @State private var isCapsLocked = false
    @State private var isLanguageChange = false
    
    var onChangeText: ((String) -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "а", characters: ["б", "в", "г", "1"], secondaryCharacters: ["Б", "В", "Г", "1"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "д", characters: ["е", "ё", "ж", "2"], secondaryCharacters: ["Е", "Ё", "Ж", "2"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "з", characters: ["и", "й", "к", "3"], secondaryCharacters: ["И", "Й", "К", "3"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                Button(action: {
                    if !inputText.isEmpty {
                        inputText.removeLast()
                    }
                }) {
                    Text("⌫")
                        .frame(width: 100, height: 60)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .onTapGesture {
                    if !inputText.isEmpty {
                        inputText.removeLast()
                    }
                }
            }
            HStack {
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "л", characters: ["м", "н", "о", "4"], secondaryCharacters: ["М", "Н", "О", "4"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "п", characters: ["р", "с", "т", "5"], secondaryCharacters: ["Р", "С", "Т", "5"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "у", characters: ["ф", "х", "ц", "6"], secondaryCharacters: ["Ф", "Х", "Ц", "6"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                Button(action: {
                    isCapsLocked.toggle()
                }) {
                    Text(isCapsLocked ? "⬆" : "⇧")
                        .frame(width: 100, height: 60)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .onTapGesture {
                    isCapsLocked.toggle()
                }
            }
            HStack {
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "ч", characters: ["ш", "щ", "ъ", "7"], secondaryCharacters: ["Ш", "Щ", "Ъ", "7"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "ы", characters: ["ь", "э", "ю", "8"], secondaryCharacters: ["Ь", "Э", "Ю", "8"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                MultiSymbolKeyView(inputText: $inputText, primaryCharacter: "я", characters: ["?", "!", "@", "9"], secondaryCharacters: ["?", "!", "@", "9"], gestures: [.tap, .upSwipe, .rightSwipe, .downSwipe, .leftSwipe])
                Button(action: {
                    isLanguageChange.toggle()
                }) {
                    Text(isLanguageChange ? "ENG" : "RUS")
                        .frame(width: 100, height: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .onTapGesture {
                    isLanguageChange.toggle()
                }
            }
        }
        .onChange(of: inputText) { oldValue, newValue in
            onChangeText?(newValue)
        }
        .padding()
    }
}

struct MultiSymbolKeyView: View {
    @Binding var inputText: String
    let primaryCharacter: String
    let characters: [String]
    let secondaryCharacters: [String]
    let gestures: [KeyGesture]
    @State private var isSwiped = false
    @State private var activeIndex = -1
    
    var body: some View {
        ZStack {
            Text(primaryCharacter)
                .font(.system(size: 30))
                .frame(width: 100, height: 60)
                .background(isSwiped ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let xOffset = value.translation.width
                            let yOffset = value.translation.height
                            if gestures.contains(.upSwipe) {
                                if yOffset < -abs(xOffset) {
                                    isSwiped = true
                                    activeIndex = 0
                                }
                            }
                            if gestures.contains(.rightSwipe) {
                                if xOffset > abs(yOffset) {
                                    isSwiped = true
                                    activeIndex = 1
                                }
                            }
                            if gestures.contains(.downSwipe) {
                                if yOffset > abs(xOffset) {
                                    isSwiped = true
                                    activeIndex = 2
                                }
                            }
                            if gestures.contains(.leftSwipe) {
                                if xOffset < -abs(yOffset) {
                                    isSwiped = true
                                    activeIndex = 3
                                }
                            }
                        }
                        .onEnded { value in
                            if isSwiped {
                                inputText = (characters[activeIndex])
                            } else {
                                inputText = (primaryCharacter)
                            }
                            isSwiped = false
                            activeIndex = -1
                        }
                )
            ForEach(0..<4) { index in
                Text(characters[index])
                    .font(.system(size: 20))
                    .offset(onGetOffset(for: activeIndex, atIndex: index))
                    .opacity(isSwiped && activeIndex == index ? 1 : 0.5)
            }
            ForEach(0..<4) { index in
                Text(secondaryCharacters[index])
                    .font(.system(size: 15))
                    .offset(onGetSecondaryOffset(for: index, atIndex: activeIndex))
                    .opacity(isSwiped ? 1 : 0)
            }
        }
    }
    
    func onGetOffset(for index: Int, atIndex: Int) -> CGSize {
        switch index {
        case 0:
            return CGSize(width: 0, height: -20)
        case 1:
            return CGSize(width: 20, height: 0)
        case 2:
            return CGSize(width: 0, height: 20)
        case 3:
            return CGSize(width: -20, height: 0)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func onGetSecondaryOffset(for index: Int, atIndex: Int) -> CGSize {
        switch index {
        case 0:
            return CGSize(width: 0, height: -40)
        case 1:
            return CGSize(width: 40, height: 0)
        case 2:
            return CGSize(width: 0, height: 40)
        case 3:
            return CGSize(width: -40, height: 0)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}

enum KeyGesture {
    case tap
    case upSwipe
    case downSwipe
    case leftSwipe
    case rightSwipe
}

class KeyboardViewController: UIInputViewController {
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = UIHostingController(rootView: ContentView(onChangeText: {[weak self] text in
            self?.textDocumentProxy.insertText(text)
        }))
        
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(child.view)
        addChild(child)
    }
}








