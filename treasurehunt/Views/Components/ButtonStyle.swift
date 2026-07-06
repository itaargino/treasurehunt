// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  ButtonStyle.swift
//  treasurehunt
//
//  📚 WORKSHOP — BÔNUS: Estilos customizados de botão (opcional)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  Este arquivo está vazio no workshop original.
//  Se quiser reduzir repetição de código nos botões, pode criar
//  um ButtonStyle customizado e aplicá-lo com .buttonStyle():
//
//  Exemplo de uso:
//
//     struct AdventureButtonStyle: ButtonStyle {
//         var color: Color = .cyan
//
//         func makeBody(configuration: Configuration) -> some View {
//             configuration.label
//                 .fontWeight(.bold)
//                 .padding()
//                 .frame(maxWidth: .infinity)
//                 .background(color.opacity(configuration.isPressed ? 0.7 : 1.0))
//                 .foregroundStyle(.white)
//                 .cornerRadius(12)
//                 .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
//                 .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
//         }
//     }
//
//  E nas Views:
//
//     Button("Entrar na Floresta") { ... }
//         .buttonStyle(AdventureButtonStyle(color: .green))
//
//  Isso NÃO afeta a navegação — é apenas organização visual.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
