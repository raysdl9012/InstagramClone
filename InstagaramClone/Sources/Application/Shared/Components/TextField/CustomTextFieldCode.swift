//
//  CustomTextField
//
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import SwiftUI

struct CustomTextFieldCode: View {
    
    @Binding var code: [String]
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Spacer()
            ForEach(0..<5, id: \.self) { index in
                TextField("", text: $code[index])
                    .font(.title)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 55, height:75)
                    .background(.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedIndex == index ? Color.blue : .cyan, lineWidth: 2)
                    )
                    .focused($focusedIndex, equals: index)
                    .onChange(of: code[index]) { newValue in
                        handleInput(newValue, at: index)
                    }
            }
            .padding(.vertical, 20)
            Spacer()
        }
        .onAppear {
            focusedIndex = 0
        }
    }
}

extension CustomTextFieldCode {
    private var isComplete: Bool {
        code.allSatisfy { !$0.isEmpty }
    }
    
    private func handleInput(_ value: String, at index: Int) {
        // permitir solo 1 carácter
        if value.count > 1 {
            code[index] = String(value.prefix(1))
        }
        // mover el foco al siguiente campo
        if !value.isEmpty && index < 4 {
            focusedIndex = index + 1
        }
        // si se borra, retroceder
        if value.isEmpty && index > 0 {
            focusedIndex = index - 1
        }
    }
}

#Preview {
    CustomTextFieldCode(code: .constant(Array(repeating: "", count: 5))).padding(10)
}
