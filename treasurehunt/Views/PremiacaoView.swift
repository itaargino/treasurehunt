import SwiftUI

struct PremiacaoView: View {
    
    // BLOCO 4: adicionar @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.premiacao.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                VStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.orange)
                        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("Parabéns, Capitão!")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    Text("Você encontrou a Coroa de Ouro dos Navegantes e superou todos os perigos do arquipélago!")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Text("Você agora domina o poder do NavigationStack, NavigationPath e do Data-Driven Navigation no SwiftUI.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // BLOCO 4: adicionar path = NavigationPath() — POP TO ROOT
                Button {
                    // sem ação
                } label: {
                    BotaoAventura(text: "Comemorar e Fechar", color: .orange)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

#Preview {
    PremiacaoView()
}
