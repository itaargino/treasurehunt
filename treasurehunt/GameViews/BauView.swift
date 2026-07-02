//
//  BauView.swift
//  treasurehunt
//

import SwiftUI

// TODO: Bloco 4 - Sem conformar a Hashable, o compilador vai reclamar ao tentar empilhar o Baú no NavigationPath.
// Dica: Adicione ': Hashable' a declaração da struct.
struct Baú: Hashable {
    let id: UUID
    let temChave: Bool
}

struct BauView: View {
    let baú: Baú
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Background: Solid light cyan (Ciano bem claro)
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Icon
                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Text("Baú do Tesouro")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.black)
                }
                
                // Description Card
                VStack(spacing: 16) {
                    Text("Baú Trancado:")
                        .font(.headline)
                        .foregroundStyle(.cyan)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Você encontrou o baú de ouro maciço! Ele está trancado com um cadeado antigo enferrujado. Se você tiver a chave, agora é a hora de usá-la.")
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
                
                // Block 4: Reward Navigation
                VStack(spacing: 12) {
                    // TODO: Bloco 4 - Esse botão devia ser um NavigationLink para a tela de premiação (enviando o valor "premiacao").
                    // A navegação só deve funcionar se o baú tiver a chave (temChave: true). Use .disabled(!baú.temChave) para controlar isso.
                    NavigationLink(value: "premiacao") {
                        HStack {
                            Image(systemName: "key.fill")
                            Text("Usar Chave & Abrir")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(baú.temChave ? Color.cyan : Color.gray)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .cyan.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .disabled(!baú.temChave)
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
        // Para testes rápidos
        BauView(baú: Baú(id: UUID(), temChave: true), path: .constant(NavigationPath()))
    }
}
