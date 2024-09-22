//
//  HyperText.swift
//  HyperText
//
//  Created by Loïc Salanon on 22/09/2024.
//
import SwiftUI

struct HyperText: View {
    let html: String
    
    var body: some View {
        if let attributedString = NSAttributedString(html: html) {
            let atstr = AttributedString(attributedString)
            Text(atstr)
                .font(.body)
        }
        else {
            Text("Erreur")
        }
    }
}

#Preview{
    
    HyperText(html: """
<p>Lorem ipsum dolor sit amet, qui eu scripta liberavisse. Ei est case fastidii apeirian, an possim regione expetenda sed.</p>
<p>Est at alii solum. Per unum elit ad. At mel everti habemus. Munere philosophia id mea, omnes postea reprimique ne eum.</p>
<p>Euismod inimicus sea ne, pri tota senserit ut.</p>
<p>Hello <a href=\"#\">world !</a></p>
<br>
<p>hello</p>
<table><tr><td>1</td></tr></table>
""")
}

