//
//  EditEventView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 21/12/23.
//

import SwiftUI

struct EditEventView: View {
    let event: ClockEvent
    
    @State var justification: String = ""
    @State var dayOff: Bool = false
    @State var doctor: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var dayAndMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: event.timestamp) {
            dateFormatter.dateFormat = "d/MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: event.timestamp) {
            dateFormatter.dateFormat = "H:mm"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("Editar registro")
                Spacer()
            }
            .padding()
            .padding(.top, 5)
            .background(ColorScheme.fieldBgColor)
            .font(.system(size: 25))
            .padding(.bottom, 10)
            
            VStack {
                HStack{
                    Text("Horário registrado")
                        .foregroundColor(ColorScheme.textColor)
                    Spacer()
                    Text("\(dayAndMonth)")
                        .foregroundColor(ColorScheme.tableTextColor)
                    Text("\(time)")
                        .padding(5)
                        .background(ColorScheme.fieldBgColor)
                        .cornerRadius(7)
                }
                .background(ColorScheme.appBackgroudColor)
                .padding(.bottom, 15)
                .font(.system(size: 18))
                
                HStack {
                    Text("Motivo da alteração")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                TextField("Motivo", text: $justification, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(ColorScheme.fieldBgColor)
                    .foregroundColor(ColorScheme.textColor)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    .lineLimit(5...10)
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Folga")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você tirou folga neste horário")
                            .foregroundColor(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle(isOn: $dayOff) {
                        Text("")
                    }
                    .padding()
                }
                Divider()
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Médico")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você está de atestado/laudo")
                            .foregroundColor(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle(isOn: $doctor) {
                        Text("")
                    }
                    .padding()
                }
                Divider()
                
                Spacer()
                
                Button(action: {
                    //salvar mudança
                }){
                    Text("Salvar")
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(ColorScheme.fieldBgColor)
                        .foregroundColor(ColorScheme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 25)
                        .font(.system(size: 20))
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.backward")
                        Text("Registros de ponto")
                    }
                }
            }
        }    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleEvent: ClockEvent
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            exampleEvent = try decoder.decode(ClockEvent.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            exampleEvent = ClockEvent(id: 0, timestamp: "", type: "", justification: nil)
        }
        return NavigationView {
            EditEventView(event: exampleEvent)
        }
    }
}
