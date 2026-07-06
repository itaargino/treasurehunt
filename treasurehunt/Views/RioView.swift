// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  RioView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 2 (final): PUSH PROGRAMÁTICO com path.append()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela:
//
//   ┌────────────────┐
//   │    RioView     │  ← TOPO (você está aqui)
//   ├────────────────┤
//   │  FlorestaView  │
//   ├────────────────┤
//   │   IlhaView     │
//   ├────────────────┤
//   │  ContentView   │  ← BASE
//   └────────────────┘
//   path = ["ilha", "floresta", "rio"]
//
//  Esta tela apresenta um conceito NOVO: PUSH PROGRAMÁTICO.
//  Até agora, usamos NavigationLink(value:) para empilhar.
//  Aqui, mostramos que também podemos empilhar usando
//  path.append() dentro de um Button — sem NavigationLink.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct RioView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // ── Cabeçalho ──
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
                
                // ── Card de Descrição ──
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
                
                VStack(spacing: 12) {
                    
                    // ═════════════════════════════════════════════════════════
                    //  📖 PUSH PROGRAMÁTICO — Button + path.append()
                    // ═════════════════════════════════════════════════════════
                    //
                    //  ✅ BLOCO 2 CORRIGIDO
                    //
                    //  Aqui usamos um Button NORMAL (não NavigationLink) que
                    //  chama path.append("ilha") dentro do action.
                    //
                    //  O efeito é IDÊNTICO a um NavigationLink(value: "ilha"):
                    //  a String "ilha" é empilhada no path, o NavigationStack
                    //  encontra o .navigationDestination(for: String.self),
                    //  e abre a IlhaView.
                    //
                    //  ─── QUANDO USAR Button + append vs NavigationLink? ───
                    //
                    //  Use NavigationLink(value:) quando:
                    //  → O toque SEMPRE navega, sem condição.
                    //  → Você quer que o SwiftUI gerencie o estilo (seta, etc).
                    //
                    //  Use Button + path.append() quando:
                    //  → A navegação depende de LÓGICA antes (validar, salvar, etc).
                    //  → Você quer executar CÓDIGO antes de navegar.
                    //  → A navegação é disparada por algo que não é um toque
                    //    (ex: timer, resposta de rede, etc).
                    //
                    //  Aqui "Explorar mais a ilha" empilha uma NOVA IlhaView.
                    //
                    //  Estado da pilha DEPOIS de tocar "Explorar mais":
                    //   ┌────────────────┐
                    //   │   IlhaView     │  ← NOVA cópia empilhada no topo!
                    //   ├────────────────┤
                    //   │    RioView     │
                    //   ├────────────────┤
                    //   │  FlorestaView  │
                    //   ├────────────────┤
                    //   │   IlhaView     │  ← A PRIMEIRA IlhaView (ainda lá!)
                    //   ├────────────────┤
                    //   │  ContentView   │  ← BASE
                    //   └────────────────┘
                    //   path = ["ilha", "floresta", "rio", "ilha"]
                    //
                    //  ⚠️ OBSERVE: a mesma tela (IlhaView) aparece DUAS vezes!
                    //  Isso é válido. O NavigationStack não impede duplicatas.
                    //  Cada "ilha" no path é uma entrada separada na pilha.
                    //  O usuário precisaria apertar "voltar" 4 vezes para
                    //  chegar à ContentView (ou usar pop to root).
                    //
                    // ═════════════════════════════════════════════════════════
                    
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
                    
                    // ── NavigationLink declarativo para a Caverna ──
                    // Este é o caminho "correto" da aventura.
                    // Empilha "criatura" → abre CriaturaView.
                    //
                    // Estado da pilha após tocar:
                    //   ┌─────────────────┐
                    //   │  CriaturaView   │  ← TOPO
                    //   ├─────────────────┤
                    //   │    RioView      │
                    //   ├─────────────────┤
                    //   │  FlorestaView   │
                    //   ├─────────────────┤
                    //   │   IlhaView      │
                    //   ├─────────────────┤
                    //   │  ContentView    │  ← BASE
                    //   └─────────────────┘
                    //   path = ["ilha", "floresta", "rio", "criatura"]
                    
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
    
    // ═════════════════════════════════════════════════════════════════════════
    //  📖 FUNÇÃO DE PUSH PROGRAMÁTICO
    // ═════════════════════════════════════════════════════════════════════════
    //
    //  path.append("ilha") faz EXATAMENTE a mesma coisa que
    //  NavigationLink(value: "ilha") faria ao ser tocado:
    //  adiciona "ilha" ao fim do path.
    //
    //  `private` porque esta lógica só faz sentido nesta View.
    //
    //  ─── OUTRAS COISAS QUE PODEMOS FAZER COM path ───
    //
    //  path.append("valor")      → Empilha (push) 1 tela
    //  path.removeLast()         → Desempilha (pop) 1 tela
    //  path.removeLast(2)        → Desempilha 2 telas de uma vez
    //  path.removeLast(path.count) → Pop to root (esvazia tudo)
    //  path = NavigationPath()   → Pop to root (substitui por path vazio)
    //  path.count                → Quantas telas estão empilhadas
    //  path.isEmpty              → true se só a raiz está visível
    //
    // ═════════════════════════════════════════════════════════════════════════
    
    private func explorarMais() {
        path.append("ilha")
    }
}

#Preview {
    NavigationStack {
        RioView(path: .constant(NavigationPath()))
    }
}
