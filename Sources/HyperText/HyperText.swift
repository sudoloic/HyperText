//
//  HyperText.swift
//  HyperText
//
//  Created by Loïc Salanon on 22/09/2024.
//
import SwiftUI

@MainActor
public struct HyperText: View {
    let html: String
    
    @State private var htmlAttributedString: NSAttributedString? = nil
    
    public init(_ html: String) {
        self.html = html
    }
    
    public var body: some View {
        VStack{
            if let attributedString = htmlAttributedString {
                let atstr = AttributedString(attributedString)
                Text(atstr)
                    .font(.body)
            }
            else {
                EmptyView()
            }
        }
        .task{
            htmlAttributedString = NSAttributedString(html: html)
        }
    }
}

#Preview{
    HyperText("""
<p>Lorem ipsum dolor sit amet, qui eu scripta liberavisse. Ei est case fastidii apeirian, an possim regione expetenda sed.</p>
<p>Est at alii solum. Per unum elit ad. At mel everti habemus. Munere philosophia id mea, omnes postea reprimique ne eum.</p>
<p>Euismod inimicus sea ne, pri tota senserit ut.</p>
<p>Hello <a href=\"#\">world !</a></p>
<br>
<p>hello</p>
<table><tr><td>1</td></tr></table>
""").textSelection(.enabled)
}
