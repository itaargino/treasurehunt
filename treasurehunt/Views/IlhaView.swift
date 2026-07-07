import SwiftUI

struct IlhaView: View {
    
    // BLOCO 2: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.praia.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                TelaHeader(icon: "palmtree.fill", title: "Ilha Misteriosa")
                
                DiarioCard(
                    title: "Diário de Bordo:",
                    text: "Você desembarcou na praia de areia preta. O vento uiva entre as palmeiras e um caminho escuro leva direto para o interior da floresta fechada."
                )
                
                Spacer()
                
                // BLOCO 2: trocar por NavigationLink(value: "floresta")
                Button {
                    // sem ação
                } label: {
                    BotaoAventura(text: "Entrar na Floresta", icon: "arrow.right.circle.fill", iconTrailing: true)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("A Praia")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        IlhaView()
    }
}
