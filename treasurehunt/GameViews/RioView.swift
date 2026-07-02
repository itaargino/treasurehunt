//
//  RioView.swift
//  treasurehunt
//

import SwiftUI

struct RioView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Background: Solid light cyan (Ciano bem claro)
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Icon
                VStack(spacing: 8) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Text("Rio das Almas")
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
                    
                    Text("Um rio violento e caudaloso bloqueia sua passagem. Não há pontes à vista. Você pode escolher explorar mais a ilha, ou entrar na caverna sombria que fica logo acima nas rochas.")
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
                
                // Block 2: Programmatic Push
                VStack(spacing: 12) {
                    // TODO: Bloco 2 - Explorar mais a ilha deveria empilhar a praia (IlhaView) programaticamente de novo.
                    // Hack: Dê um append do valor "ilha" na variável 'path'.
                    Button(action: {
                        explorarMais()
                    }) {
                        HStack {
                            Image(systemName: "compass.fill")
                            Text("Explorar mais a ilha")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .cyan.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    
                    // Link to the Creature Cave (next destination)
                    NavigationLink(value: "criatura") {
                        HStack {
                            Text("Entrar na Caverna Sombria")
                                .fontWeight(.bold)
                            Image(systemName: "mountain.2.fill")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
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
    
    private func explorarMais() {
        // Implementar avanço programático
    }
}

#Preview {
    NavigationStack {
        RioView(path: .constant(NavigationPath()))
    }
}
