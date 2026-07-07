import SwiftUI

struct CriaturaView: View {
    
    // BLOCO 3: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.caverna.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                TelaHeader(
                    icon: "pawprint.fill",
                    title: "Urso Gigante",
                    tint: .orange,
                    titleColor: .white
                )
                
                DiarioCard(
                    title: "Perigo Iminente:",
                    text: "Um urso gigante e faminto está guardando a entrada de uma câmara secreta onde fica o baú antigo. Você precisa decidir rápido o que fazer!",
                    estilo: .escuro
                )
                
                Spacer()
                
                VStack(spacing: 12) {
                    
                    // BLOCO 3: chamar fugir() — POP SIMPLES
                    Button {
                        // sem ação
                    } label: {
                        BotaoAventura(text: "Fugir Correndo (Voltar 1 tela)", icon: "figure.run", color: .orange)
                    }
                    
                    // BLOCO 3: chamar usarPocao() — POP TO ROOT
                    Button {
                        // sem ação
                    } label: {
                        BotaoAventura(text: "Usar Poção (Fugir ao Início)", icon: "flask.fill", color: .red)
                    }
                    
                    // BLOCO 4: path.append(Baú(id: UUID(), temChave: true)) — PUSH DE STRUCT
                    Button {
                        // sem ação
                    } label: {
                        BotaoAventura(text: "Enfrentar o Urso (Achar Baú)", icon: "shield.fill", color: .yellow, textColor: .black)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Caverna")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // BLOCO 3: back button oculto
    }
    
    // BLOCO 3: implementar aqui
    // private func fugir() { ... }
    // private func usarPocao() { ... }
}

#Preview {
    NavigationStack {
        CriaturaView()
    }
}
