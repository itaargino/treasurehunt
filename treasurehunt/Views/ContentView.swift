import SwiftUI

struct ContentView: View {
    
    // BLOCO 1: adicionar @State private var path aqui
    
    var body: some View {
        
        // BLOCO 1: envolver em NavigationStack(path: $path)
        
        ZStack {
            Color.praia.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Cabeçalho
                VStack(spacing: 12) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    Text("Náufragos &\nExploradores")
                        .font(.system(size: 36, weight: .black, design: .serif))
                        .multilineTextAlignment(.center)
                    
                    Text("Edição SwiftUI Navigation Stack")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                DiarioCard(
                    title: "Regra da Ilha:",
                    text: "Cada ilha/etapa possui um erro de navegação intencional. Seu dever como desenvolvedor-explorador é resolver os TODOs no código para liberar o caminho até o baú!"
                )
                
                Spacer()
                
                // BLOCO 1: trocar por NavigationLink(value: "ilha")
                Button {
                    // sem ação
                } label: {
                    BotaoAventura(text: "Iniciar Jornada", icon: "arrow.right", iconTrailing: true)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                // BLOCO 4: adicionar .navigationDestination(for: String.self)
                // BLOCO 4: adicionar .navigationDestination(for: Baú.self)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
