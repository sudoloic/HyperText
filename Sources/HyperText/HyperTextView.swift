//
//  HyperTextView.swift
//  HyperText
//
//  Created by Loïc Salanon on 19/08/2025.
//

import SwiftUI

@MainActor
public struct HyperTextView: View {
    @Environment(\.layoutDirection) private var layoutDirection

    @State private var text: NSAttributedString
    @State private var calculatedHeight: CGFloat = 44
    @State private var isEmpty: Bool = false

    private var foregroundColor: UIColor = .label
    private var multilineTextAlignment: NSTextAlignment = .left
    private var font: UIFont = .preferredFont(forTextStyle: .body)
    private var isSelectable: Bool = true

    private var internalText: Binding<NSAttributedString> {
        Binding<NSAttributedString>(get: { self.text }) { attributedText, _ in
            self.text = attributedText
            self.isEmpty = attributedText.string.isEmpty
        }
    }

    public init(_ text: String) {
        self.text = NSAttributedString(html: text) ?? NSAttributedString(string: "")
        _isEmpty = State(initialValue: self.text.string.isEmpty)
    }

    public var body: some View {
        HyperTextUITextView(internalText,
                        foregroundColor: foregroundColor,
                        font: font,
                        multilineTextAlignment: multilineTextAlignment,
                        isSelectable: isSelectable,
                        calculatedHeight: $calculatedHeight)
            .frame(
                minHeight: calculatedHeight,
                maxHeight: calculatedHeight
        )
    }
}

public extension HyperTextView {

    func foregroundColor(_ color: UIColor) -> HyperTextView {
        var view = self
        view.foregroundColor = color
        return view
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> HyperTextView {
        var view = self
        switch alignment {
        case .leading:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.multilineTextAlignment = .center
        }
        return view
    }

    func font(_ font: UIFont) -> HyperTextView {
        var view = self
        view.font = font
        return view
    }

    func isSelectable(_ isSelectable: Bool) -> HyperTextView {
        var view = self
        view.isSelectable = isSelectable
        return view
    }
}

private struct HyperTextUITextView: UIViewRepresentable {

    @Binding private var text: NSAttributedString
    @Binding private var calculatedHeight: CGFloat

    private let foregroundColor: UIColor
    private let multilineTextAlignment: NSTextAlignment
    private let font: UIFont
    private let isSelectable: Bool

    init(_ text: Binding<NSAttributedString>,
         foregroundColor: UIColor,
         font: UIFont,
         multilineTextAlignment: NSTextAlignment,
         isSelectable: Bool,
         calculatedHeight: Binding<CGFloat>) {
        _text = text
        _calculatedHeight = calculatedHeight

        self.foregroundColor = foregroundColor
        self.font = font
        self.multilineTextAlignment = multilineTextAlignment
        self.isSelectable = isSelectable

        makeCoordinator()
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.backgroundColor = UIColor.clear
        view.adjustsFontForContentSizeCategory = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }

    func updateUIView(_ view: UITextView, context: Context) {
        view.attributedText = text
        view.font = font
        view.textAlignment = multilineTextAlignment
        view.textColor = foregroundColor
        view.isEditable = false
        view.isSelectable = isSelectable
        view.isScrollEnabled = false

        HyperTextUITextView.recalculateHeight(view: view, result: $calculatedHeight)
    }

    @discardableResult func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            calculatedHeight: $calculatedHeight
        )
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude))

        guard result.wrappedValue != newSize.height else { return }
        DispatchQueue.main.async { // call in next render cycle.
            result.wrappedValue = newSize.height
        }
    }

}

private extension HyperTextUITextView {

    final class Coordinator: NSObject, UITextViewDelegate {

        private var originalText: NSAttributedString = NSAttributedString(string: "")
        private var text: Binding<NSAttributedString>
        private var calculatedHeight: Binding<CGFloat>

        init(text: Binding<NSAttributedString>,
             calculatedHeight: Binding<CGFloat>) {
            self.text = text
            self.calculatedHeight = calculatedHeight
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.attributedText
            HyperTextUITextView.recalculateHeight(view: textView, result: calculatedHeight)
        }

    }

}


#Preview{
    ScrollView{
        VStack{
            HyperTextView("""
        <p>Lorem ipsum dolor sit amet, qui eu scripta liberavisse. Ei est case fastidii apeirian, an possim regione expetenda sed.</p>
        <p>Est at alii solum. Per unum elit ad. At mel everti habemus. Munere philosophia id mea, omnes postea reprimique ne eum.</p>
        <p>Euismod inimicus sea ne, pri tota senserit ut.</p>
        <p>Hello <a href=\"#\">world !</a></p>
        <br>
        <p>hello</p>
        <table><tr><td>1</td></tr></table>
        """)
            Text("Hello !!!")

            HyperTextView("""
        <p>Lorem ipsum dolor sit amet, qui eu scripta liberavisse. Ei est case fastidii apeirian, an possim regione expetenda sed.</p>
        <p>Est at alii solum. Per unum elit ad. At mel everti habemus. Munere philosophia id mea, omnes postea reprimique ne eum.</p>
        <p>Euismod inimicus sea ne, pri tota senserit ut.</p>
        <p>Hello <a href=\"#\">world !</a></p>
        <br>
        <p>hello</p>
        <table><tr><td>1</td></tr></table>
        """)

        }
    }
}


