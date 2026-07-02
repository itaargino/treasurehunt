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
                    
                    Text("Um rio violento e caudaloso bloqueia sua passagem. Não há pontes à vista. Você pode escolher explorar um pouco mais a ilha para encontrar outra rota, ou entrar na caverna sombria que fica logo acima nas rochas.")
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
                
                // Block 2: Pop to root action
                VStack(spacing: 14) {
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
    
    // TODO: Bloco 2 - Explorar mais a ilha deveria resetar a pilha (Pop to root) voltando para a praia inicial.
    // Hack: Zere a variável 'path'.
    private func explorarMais() {
        // Implementar reset da rota aqui
    }
}

#Preview {
    NavigationStack {
        RioView(path: .constant(NavigationPath()))
    }
}
