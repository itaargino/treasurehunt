import SwiftUI

// BLOCO 4: adicionar : Hashable
struct Baú {
    let id: UUID
    let temChave: Bool
}

struct BauView: View {
    
    // BLOCO 4: adicionar let baú: Baú
    // BLOCO 4: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.praia.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                TelaHeader(icon: "lock.fill", title: "Baú do Tesouro")
                
                DiarioCard(
                    title: "Baú Trancado:",
                    text: "Você encontrou o baú de ouro maciço! Ele está trancado com um cadeado antigo enferrujado. Se você tiver a chave, agora é a hora de usá-la."
                )
                
                Spacer()
                
                // BLOCO 4: trocar por NavigationLink(value: "premiacao") + .disabled(!baú.temChave)
                Button {
                    // sem ação
                } label: {
                    BotaoAventura(text: "Usar Chave & Abrir", icon: "key.fill")
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("O Tesouro")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BauView()
    }
}
