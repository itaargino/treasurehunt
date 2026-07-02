//
//  PremiacaoView.swift
//  treasurehunt
//

import SwiftUI

struct PremiacaoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background: Solid almost yellow (Quase um amarelo)
            Color(red: 0.99, green: 0.96, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Celebration Icon
                VStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.orange)
                        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("Parabéns, Capitão!")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
                
                // Achievement Text
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
                
                // Action to Dismiss
                Button(action: {
                    dismiss()
                }) {
                    Text("Comemorar e Fechar")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .orange.opacity(0.2), radius: 10, x: 0, y: 5)
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
