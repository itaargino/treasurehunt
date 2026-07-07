import SwiftUI

struct FlorestaView: View {
    
    // BLOCO 2: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.praia.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                TelaHeader(icon: "leaf.fill", title: "Floresta Fechada")
                
                DiarioCard(
                    title: "Diário de Bordo:",
                    text: "As árvores gigantes bloqueiam a luz do sol. Você ouve barulhos estranhos de animais selvagens. Seguindo o som de água corrente, você sente que o rio está próximo."
                )
                
                Spacer()
                
                // BLOCO 2: trocar por NavigationLink(value: "rio")
                Button {
                    // sem ação
                } label: {
                    BotaoAventura(text: "Seguir para o Rio", icon: "drop.fill", iconTrailing: true)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("A Floresta")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FlorestaView()
    }
}
