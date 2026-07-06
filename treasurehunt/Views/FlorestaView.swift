// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  FlorestaView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 2 (continuação): Mais um PUSH na Pilha
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela:
//
//   ┌────────────────┐
//   │  FlorestaView  │  ← TOPO (você está aqui)
//   ├────────────────┤
//   │   IlhaView     │
//   ├────────────────┤
//   │  ContentView   │  ← BASE
//   └────────────────┘
//   path = ["ilha", "floresta"]
//
//  Note como a pilha vai CRESCENDO a cada NavigationLink.
//  Cada valor empilhado corresponde a uma tela.
//  O path agora tem 2 itens: "ilha" e "floresta".
//
//  📖 O BOTÃO "< VOLTAR" NATIVO
//
//  Percebeu a seta "< A Praia" no topo da tela?
//  O SwiftUI gera esse botão AUTOMATICAMENTE quando há mais de
//  1 tela na pilha. Ao tocar, ele faz path.removeLast() internamente.
//
//  O texto "A Praia" vem do .navigationTitle("A Praia") da IlhaView
//  (a tela ANTERIOR). O botão sempre mostra o título de quem está abaixo.
//
//  Esse botão pode ser OCULTADO — veremos isso na CriaturaView.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct FlorestaView: View {
    
    // Mesmo padrão: @Binding para ter acesso ao path da ContentView.
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // ── Cabeçalho ──
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
                
                // ── Card de Descrição ──
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
                
                // ═════════════════════════════════════════════════════════════
                //  📖 MAIS UM NavigationLink(value:) — EMPILHANDO O RIO
                // ═════════════════════════════════════════════════════════════
                //
                //  ✅ BLOCO 2 CORRIGIDO
                //
                //  Mesmo mecanismo: o toque empilha "rio" no path.
                //
                //  Estado da pilha DEPOIS do toque:
                //   ┌────────────────┐
                //   │    RioView     │  ← TOPO
                //   ├────────────────┤
                //   │  FlorestaView  │
                //   ├────────────────┤
                //   │   IlhaView     │
                //   ├────────────────┤
                //   │  ContentView   │  ← BASE
                //   └────────────────┘
                //   path = ["ilha", "floresta", "rio"]
                //
                //  A pilha agora tem 3 itens. O botão nativo de voltar
                //  na RioView mostrará "< A Floresta" (nosso título).
                //
                // ═════════════════════════════════════════════════════════════
                
                NavigationLink(value: "rio") {
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
