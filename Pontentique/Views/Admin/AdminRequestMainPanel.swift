//
//  AdminRequestMainPanel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 17/01/24.
//

import SwiftUI

//MARK: REQUEST STRUCT
struct AdminRequest: Identifiable {
    var id = UUID()
    var name: String
    var details: String
    var time: String
    var reason: String
}

struct AdminRequestMainPanel: View {
//MARK: REQUEST DUMMY DATA
    @State private var requests = [

        AdminRequest(name: "Renan Poersch", details: "18/12 12:31 → 18/12 13:00", time: "Bati ponto errado ao voltar do almoço", reason: ""),
        AdminRequest(name: "Daniel Didone", details: "18/12 13:00 → Médico", time: "Tenho consulta à tarde", reason: ""),
        AdminRequest(name: "Daniel Didone", details: "18/12 13:00 → Médico", time: "Tenho consulta à tarde", reason: ""),
        AdminRequest(name: "Daniel Didone", details: "18/12 13:00 → Médico", time: "Tenho consulta à tarde", reason: ""),
        AdminRequest(name: "Daniel Didone", details: "18/12 13:00 → Médico", time: "Tenho consulta à tarde", reason: "")
        
    ]
    
    
    var body: some View {
        
        VStack {
            Text("Solicitações")
                .font(.system(size: 28))
                .frame(maxWidth: .infinity, alignment: .center)
            //MARK: REQUEST RECIVER
            List{
                ForEach(requests) { request in
                    VStack(alignment: .leading) {
                        Text(request.name).font(.headline)
                        Text(request.details).font(.subheadline)
                        Text(request.time).font(.caption)
                        
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            //Botão aceita
                        } label: {
                            Text("Aceitar")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                denyRequest(request)
                                //Botão negar
                            }
                        } label: {
                            Text("Negar")
                        }
                        .tint(.red)
                    }
                }
            }
        }
    }
    
//MARK: FUNC TO DELETE THE REQUEST (DUMMY DATA)
    private func denyRequest(_ request: AdminRequest) {
        if let index = requests.firstIndex(where: { $0.id == request.id }) {
            requests.remove(at: index)
        }
    }
}





//MARK: PREVIEW
#Preview {
    AdminRequestMainPanel()
}
