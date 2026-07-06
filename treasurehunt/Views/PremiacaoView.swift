// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  PremiacaoView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 4 (final): Pop to Root para Encerrar a Jornada
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela (a mais alta do jogo!):
//
//   ┌───────────────────┐
//   │  PremiacaoView    │  ← TOPO 🎉 (você está aqui — VENCEU!)
//   ├───────────────────┤
//   │    BauView        │
//   ├───────────────────┤
//   │  CriaturaView     │
//   ├───────────────────┤
//   │    RioView        │
//   ├───────────────────┤
//   │  FlorestaView     │
//   ├───────────────────┤
//   │   IlhaView        │
//   ├───────────────────┤
//   │  ContentView      │  ← BASE
//   └───────────────────┘
//   path = ["ilha", "floresta", "rio", "criatura", Baú(...), "premiacao"]
//   path.count = 6
//
//  Esta é a tela de VITÓRIA.
//  O botão "Comemorar e Fechar" faz POP TO ROOT → volta direto ao início.
//
//  ─── RESUMO DE TODOS OS CONCEITOS USADOS NO JOGO ───
//
//  📦 NavigationStack(path: $path)
//     → O contêiner que gerencia a pilha de telas.
//     → Só existe 1, na ContentView (raiz).
//
//  🗺️ NavigationPath
//     → O "array mágico" que guarda os valores empilhados.
//     → Aceita tipos mistos (String, Baú, Int — qualquer Hashable).
//     → @State na raiz, @Binding nas filhas.
//
//  🔗 NavigationLink(value:)
//     → Link declarativo. Empilha o valor ao ser tocado.
//     → O NavigationStack faz path.append() internamente.
//     → Lazy: a View destino só é criada quando necessário.
//
//  🗃️ .navigationDestination(for: Tipo.self)
//     → O "mapa de rotas". Associa um tipo Hashable a uma View.
//     → Pode ter vários, um por tipo (String.self, Baú.self, etc).
//
//  ➕ path.append(valor)
//     → Push programático. Empilha via código (dentro de Button, etc).
//
//  ➖ path.removeLast()
//     → Pop simples. Volta 1 tela.
//
//  🏠 path = NavigationPath()
//     → Pop to root. Esvazia a pilha, volta ao início.
//
//  🔒 .navigationBarBackButtonHidden(true)
//     → Oculta o botão nativo "< Voltar".
//
//  #️⃣ Hashable
//     → Protocolo necessário para empilhar structs no NavigationPath.
//     → Tipos básicos (String, Int, UUID) já são Hashable.
//     → Structs customizadas precisam de `: Hashable` explícito.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct PremiacaoView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 0.99, green: 0.96, blue: 0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // ── Ícone de Celebração ──
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
                
                // ── Texto de Conquista ──
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
                
                // ═════════════════════════════════════════════════════════════
                //  📖 POP TO ROOT FINAL — Voltando ao Início
                // ═════════════════════════════════════════════════════════════
                //
                //  path = NavigationPath() cria um path NOVO e VAZIO.
                //  Todas as 6 telas empilhadas são removidas de uma vez.
                //  O usuário volta direto para a ContentView.
                //
                //  ANTES (6 telas na pilha):
                //   ┌───────────────────┐
                //   │  PremiacaoView    │  ← Removida
                //   ├───────────────────┤
                //   │    BauView        │  ← Removida
                //   ├───────────────────┤
                //   │  CriaturaView     │  ← Removida
                //   ├───────────────────┤
                //   │    RioView        │  ← Removida
                //   ├───────────────────┤
                //   │  FlorestaView     │  ← Removida
                //   ├───────────────────┤
                //   │   IlhaView        │  ← Removida
                //   ├───────────────────┤
                //   │  ContentView      │  ← Sobra esta
                //   └───────────────────┘
                //
                //  DEPOIS (pilha limpa):
                //   ┌────────────────┐
                //   │  ContentView   │  ← Única tela (raiz)
                //   └────────────────┘
                //   path = [] (vazio) → Pronto para jogar de novo!
                //
                // ═════════════════════════════════════════════════════════════
                
                Button(action: {
                    path = NavigationPath()
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
    PremiacaoView(path: .constant(NavigationPath()))
}
