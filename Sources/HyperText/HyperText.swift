//
//  HyperText.swift
//  HyperText
//
//  Created by Loïc Salanon on 22/09/2024.
//
import SwiftUI

public struct HyperText: View {
    let html: String
    
    public init(_ html: String) {
        self.html = html
    }
    
    public var body: some View {
        if let attributedString = NSAttributedString(html: html) {
            let atstr = AttributedString(attributedString)
            Text(atstr)
                .font(.body)
        }
        else {
            EmptyView()
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
""")
}
