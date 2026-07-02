//
//  FlorestaView.swift
//  treasurehunt
//

import SwiftUI

struct FlorestaView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Background: Solid light cyan (Ciano bem claro)
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Icon
                VStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Text("Floresta Fechada")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.black)
                }
                
                // Description Card
                VStack(spacing: 16) {
                    Text("Diário de Bordo:")
                        .font(.headline)
                        .foregroundStyle(.cyan)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("As árvores gigantes bloqueiam a luz do sol. Você ouve barulhos estranhos de animais selvagens. Seguindo o som de água corrente, você sente que o rio está próximo.")
                        .font(.body)
                        .foregroundStyle(.black.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(20)
                .background(Color.black.opacity(0.04))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Navigation Action
                // TODO: Bloco 2 - Trocar o Button comum por um NavigationLink para empilhar o RioView.
                // O destino deve ser o valor "rio".
                Button(action: {
                    // Este botão comum não faz nada! Corrija para um NavigationLink
                }) {
                    HStack {
                        Text("Seguir para o Rio")
                            .fontWeight(.bold)
                        Image(systemName: "drop.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .shadow(color: .cyan.opacity(0.2), radius: 10, x: 0, y: 5)
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
        FlorestaView(path: .constant(NavigationPath()))
    }
}
