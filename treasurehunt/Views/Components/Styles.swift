import SwiftUI

// MARK: - Cores

extension Color {
    static let praia = Color(red: 0.9, green: 0.97, blue: 0.98)
    static let caverna = Color(red: 0.08, green: 0.09, blue: 0.12)
    static let premiacao = Color(red: 0.99, green: 0.96, blue: 0.8)
}

// MARK: - Cabeçalho de Tela

struct TelaHeader: View {
    let icon: String
    let title: String
    var tint: Color = .cyan
    var titleColor: Color = .black
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 72))
                .foregroundStyle(tint)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            
            Text(title)
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(titleColor)
        }
    }
}

// MARK: - Card do Diário

struct DiarioCard: View {
    let title: String
    let text: String
    var estilo: EstiloCard = .claro
    
    enum EstiloCard {
        case claro, escuro
        
        var corTitulo: Color { self == .claro ? .cyan : .orange }
        var corTexto: Color { self == .claro ? .black.opacity(0.8) : .white.opacity(0.9) }
        var corFundo: Color { self == .claro ? .black.opacity(0.04) : .white.opacity(0.08) }
        var corBorda: Color { self == .claro ? .black.opacity(0.1) : .white.opacity(0.15) }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundStyle(estilo.corTitulo)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(text)
                .font(.body)
                .foregroundStyle(estilo.corTexto)
                .lineSpacing(4)
        }
        .padding(20)
        .background(estilo.corFundo)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(estilo.corBorda, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Botão de Aventura (label reutilizável)

struct BotaoAventura: View {
    let text: String
    var icon: String? = nil
    var iconTrailing: Bool = false
    var color: Color = .cyan
    var textColor: Color = .white
    
    var body: some View {
        HStack {
            if let icon, !iconTrailing {
                Image(systemName: icon)
            }
            Text(text)
                .fontWeight(.bold)
            if let icon, iconTrailing {
                Image(systemName: icon)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .foregroundStyle(textColor)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}
