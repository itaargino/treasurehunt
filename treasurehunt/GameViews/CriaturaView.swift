//
//  CriaturaView.swift
//  treasurehunt
//

import SwiftUI

struct CriaturaView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Background: Solid very dark slate/gray (Exceto na caverna que deve ser escuro)
            Color(red: 0.08, green: 0.09, blue: 0.12)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header Icon
                VStack(spacing: 8) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.orange)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    
                    Text("Urso Gigante")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                }
                
                // Description Card
                VStack(spacing: 16) {
                    Text("Perigo Iminente:")
                        .font(.headline)
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Um urso gigante e faminto está guardando a entrada de uma câmara secreta onde fica o baú antigo. Você precisa decidir rápido o que fazer!")
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineSpacing(4)
                }
                .padding(20)
                .background(Color.white.opacity(0.08))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    // Action 1: Flee / Run (Pop 1 screen)
                    Button(action: {
                        fugir()
                    }) {
                        HStack {
                            Image(systemName: "figure.run")
                            Text("Fugir Correndo (Voltar 1 tela)")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                    

                    // Action 3: Use teleport potion to go back to start (Pop to root)
                    Button(action: {
                        usarPocao()
                    }) {
                        HStack {
                            Image(systemName: "flask.fill")
                            Text("Usar Poção (Fugir ao Início)")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                    
                    // Action 4: Confront the Bear to find the chest (Pushes chest)
                    Button(action: {
                        // TODO: Bloco 4 - Para passar o baú com a chave (temChave: true), você precisa:
                        // 1. Comentar a linha abaixo (navegação genérica por String)
                        // 2. Descomentar a linha com a struct Baú
                        // 3. Fazer a struct Baú conformar a Hashable em BauView.swift para o compilador aceitar
                        path.append("bau")
                        
                        // let meuBau = Baú(id: UUID(), temChave: true)
                        // path.append(meuBau)
                    }) {
                        HStack {
                            Image(systemName: "shield.fill")
                            Text("Enfrentar o Urso (Achar Baú)")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(12)
                        .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("Caverna")
        .navigationBarTitleDisplayMode(.inline)
        // Oculta o botão de retorno da navigation bar para forçar o uso dos botões de ação
        .navigationBarBackButtonHidden(true)
    }
    
    // TODO: Bloco 3 - Fugir deveria voltar apenas 1 tela no histórico de navegação.
    // Hack: Remova o último item do 'path'.
    private func fugir() {
        // Implementar pop de 1 tela
    }

    
    // TODO: Bloco 3 - A poção mágica deveria resetar a pilha (Pop to root) voltando para a tela inicial.
    // Hack: Zere a variável 'path'.
    private func usarPocao() {
        // Implementar pop to root
    }
}

#Preview {
    NavigationStack {
        CriaturaView(path: .constant(NavigationPath()))
    }
}
