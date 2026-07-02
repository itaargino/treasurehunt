//
//  ContentView.swift
//  treasurehunt
//

import SwiftUI

struct ContentView: View {
    // A pilha genérica que gerencia o fluxo de telas no jogo
    @State private var path = NavigationPath()
    
    var body: some View {
        // TODO: Bloco 1 - Sem isso, nenhum NavigationLink funciona e o app não navega.
        // Dica: Envolva a VStack principal em um 'NavigationStack(path: $path)'
        VStack {
            ZStack {
                // Background: Solid light cyan (Ciano bem claro)
                Color(red: 0.9, green: 0.97, blue: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title and Icon
                    VStack(spacing: 12) {
                        Image(systemName: "map.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.cyan)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .symbolEffect(.bounce, options: .repeating)
                        
                        Text("Náufragos &\nExploradores")
                            .font(.system(size: 36, weight: .black, design: .serif))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                        
                        Text("Edição SwiftUI Navigation Stack")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Welcome & Rules card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Regra da Ilha:")
                            .font(.headline)
                            .foregroundStyle(.cyan)
                        
                        Text("Cada ilha/etapa possui um erro de navegação intencional. Seu dever como desenvolvedor-explorador é resolver os TODOs no código para liberar o caminho até o baú!")
                            .font(.subheadline)
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
                    
                    // Start Button / Navigation Link
                    // TODO: Bloco 2 - O botão abaixo existe mas não faz nada.
                    // Substitua por um NavigationLink que envie o valor "ilha" para empilhar a IlhaView.
                    Button(action: {
                        // Este botão não navega!
                    }) {
                        HStack {
                            Text("Iniciar Jornada")
                                .fontWeight(.black)
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .shadow(color: .cyan.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding()
            }
        }
        // Registro de rotas baseadas em Strings
        .navigationDestination(for: String.self) { rota in
            switch rota {
            case "ilha":
                IlhaView(path: $path)
            case "floresta":
                FlorestaView(path: $path)
            case "rio":
                RioView(path: $path)
            case "criatura":
                CriaturaView(path: $path)
            case "bau":
                // Mostra o baú genérico sem chave no início do workshop (para compilar antes do Bloco 4)
                BauView(baú: Baú(id: UUID(), temChave: false), path: $path)
            // TODO: Bloco 4 - Adicione a rota "premiacao" para abrir a PremiacaoView()
            default:
                EmptyView()
            }
        }
        // TODO: Bloco 4 - Falta registrar o destino de navegação para a struct Baú.
        // Sem isso, empilhar um Baú no NavigationPath causará erro ou não mostrará nada.
        // Habilite o modificador .navigationDestination(for: Baú.self) aqui:
        // .navigationDestination(for: Baú.self) { baú in
        //     BauView(baú: baú, path: $path)
        // }
    }
}

#Preview {
    ContentView()
}
