import SwiftUI

struct RioView: View {
    
    // BLOCO 2: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                TelaHeader(icon: "drop.fill", title: "Rio das Almas")
                
                DiarioCard(
                    title: "Diário de Bordo:",
                    text: "Um rio violento e caudaloso bloqueia sua passagem. Não há pontes à vista. Você pode escolher explorar mais a ilha, ou entrar na caverna sombria que fica logo acima nas rochas."
                )
                
                Spacer()
                
                VStack(spacing: 12) {
                    
                    // BLOCO 2: adicionar path.append("ilha") — PUSH PROGRAMÁTICO
                    Button {
                        // sem ação
                    } label: {
                        BotaoAventura(text: "Explorar mais a ilha", icon: "compass.fill", color: .cyan)
                    }
                    
                    // BLOCO 2: trocar por NavigationLink(value: "criatura")
                    Button {
                        // sem ação
                    } label: {
                        BotaoAventura(text: "Entrar na Caverna Sombria", icon: "mountain.2.fill", iconTrailing: true, color: .blue)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("O Rio")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RioView()
    }
}
