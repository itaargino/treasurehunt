// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  CriaturaView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 3: POP, POP TO ROOT e BACK BUTTON OCULTO
//               BLOCO 4: Push de struct Hashable customizada
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela (caminho normal):
//
//   ┌─────────────────┐
//   │  CriaturaView   │  ← TOPO (você está aqui — enfrentando o urso!)
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
//   path.count = 4
//
//  Esta é a tela mais RICA em conceitos de navegação:
//
//  1. 🏃 Fugir      → POP simples (removeLast — volta 1 tela)
//  2. 🧪 Poção      → POP TO ROOT (esvazia o path — volta ao início)
//  3. 🛡️ Enfrentar  → PUSH de struct Hashable customizada (Baú)
//  4. 🔙 Back hidden → Botão nativo de voltar OCULTO
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct CriaturaView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Fundo escuro — estamos na caverna!
            Color(red: 0.08, green: 0.09, blue: 0.12)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // ── Cabeçalho ──
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
                
                // ── Card de Descrição ──
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
                    
                    // ═════════════════════════════════════════════════════════
                    //  📖 AÇÃO 1: FUGIR — POP SIMPLES (removeLast)
                    // ═════════════════════════════════════════════════════════
                    //
                    //  ✅ BLOCO 3 CORRIGIDO
                    //
                    //  Ao tocar, chama fugir() que faz path.removeLast().
                    //  Isso REMOVE o último item da pilha ("criatura"),
                    //  e o usuário volta para a RioView.
                    //
                    //  ANTES:
                    //   ┌─────────────────┐
                    //   │  CriaturaView   │  ← Este é removido
                    //   ├─────────────────┤
                    //   │    RioView      │
                    //   ├─────────────────┤
                    //   │  FlorestaView   │
                    //   ├─────────────────┤
                    //   │   IlhaView      │
                    //   ├─────────────────┤
                    //   │  ContentView    │
                    //   └─────────────────┘
                    //   path = ["ilha", "floresta", "rio", "criatura"]
                    //
                    //  DEPOIS:
                    //   ┌────────────────┐
                    //   │    RioView     │  ← TOPO (visível agora)
                    //   ├────────────────┤
                    //   │  FlorestaView  │
                    //   ├────────────────┤
                    //   │   IlhaView     │
                    //   ├────────────────┤
                    //   │  ContentView   │
                    //   └────────────────┘
                    //   path = ["ilha", "floresta", "rio"]
                    //
                    // ═════════════════════════════════════════════════════════
                    
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
                    
                    // ═════════════════════════════════════════════════════════
                    //  📖 AÇÃO 2: POÇÃO MÁGICA — POP TO ROOT
                    // ═════════════════════════════════════════════════════════
                    //
                    //  ✅ BLOCO 3 CORRIGIDO
                    //
                    //  Ao tocar, chama usarPocao() que ESVAZIA o path inteiro.
                    //  Todas as telas são desempilhadas de uma vez.
                    //  O usuário volta direto para a ContentView (raiz).
                    //
                    //  ANTES:
                    //   ┌─────────────────┐
                    //   │  CriaturaView   │  ← Removido
                    //   ├─────────────────┤
                    //   │    RioView      │  ← Removido
                    //   ├─────────────────┤
                    //   │  FlorestaView   │  ← Removido
                    //   ├─────────────────┤
                    //   │   IlhaView      │  ← Removido
                    //   ├─────────────────┤
                    //   │  ContentView    │  ← Sobra esta (raiz)
                    //   └─────────────────┘
                    //   path = ["ilha", "floresta", "rio", "criatura"]
                    //
                    //  DEPOIS:
                    //   ┌────────────────┐
                    //   │  ContentView   │  ← Única tela (raiz)
                    //   └────────────────┘
                    //   path = [] (vazio)
                    //
                    // ═════════════════════════════════════════════════════════
                    
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
                    
                    // ═════════════════════════════════════════════════════════
                    //  📖 AÇÃO 3: ENFRENTAR — PUSH DE STRUCT HASHABLE
                    // ═════════════════════════════════════════════════════════
                    //
                    //  ✅ BLOCO 4 CORRIGIDO
                    //
                    //  Aqui, em vez de empilhar uma String ("bau"),
                    //  empilhamos uma STRUCT inteira: Baú(id:, temChave:).
                    //
                    //  Isso é poderoso porque o valor carrega DADOS:
                    //  → temChave: true significa que o baú pode ser aberto.
                    //  → A BauView recebe esse Baú e decide o que mostrar.
                    //
                    //  Para isso funcionar, são necessárias 3 coisas:
                    //  1. A struct Baú DEVE conformar a `Hashable`
                    //     (senão o compilador rejeita o append).
                    //  2. Deve existir um .navigationDestination(for: Baú.self)
                    //     registrado na ContentView.
                    //  3. O path.append(meuBau) empilha o objeto Baú inteiro.
                    //
                    //  ─── POR QUE NÃO USAR STRING AQUI? ───
                    //
                    //  Com String: path.append("bau")
                    //  → O .navigationDestination recebe apenas "bau".
                    //  → Como saber se tem chave ou não? Não sabe!
                    //  → Teríamos que criar outra variável @State para isso.
                    //
                    //  Com Struct: path.append(Baú(id: ..., temChave: true))
                    //  → O .navigationDestination recebe o Baú COMPLETO.
                    //  → A BauView sabe se tem chave diretamente.
                    //  → Dados viajam JUNTO com a navegação. Limpo!
                    //
                    //  Estado da pilha DEPOIS:
                    //   ┌─────────────────┐
                    //   │    BauView      │  ← TOPO (com temChave: true)
                    //   ├─────────────────┤
                    //   │  CriaturaView   │
                    //   ├─────────────────┤
                    //   │    RioView      │
                    //   ├─────────────────┤
                    //   │  FlorestaView   │
                    //   ├─────────────────┤
                    //   │   IlhaView      │
                    //   ├─────────────────┤
                    //   │  ContentView    │  ← BASE
                    //   └─────────────────┘
                    //   path = ["ilha", "floresta", "rio", "criatura", Baú(...)]
                    //
                    //   Perceba: o path agora tem TIPOS MISTOS!
                    //   4 Strings + 1 Baú. O NavigationPath aceita isso.
                    //   Um [String] simples NÃO aceitaria. Por isso
                    //   usamos NavigationPath em vez de [String].
                    //
                    // ═════════════════════════════════════════════════════════
                    
                    Button(action: {
                        let meuBau = Baú(id: UUID(), temChave: true)
                        path.append(meuBau)
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
        
        // ═════════════════════════════════════════════════════════════════════
        //  📖 .navigationBarBackButtonHidden(true) — OCULTAR O BOTÃO VOLTAR
        // ═════════════════════════════════════════════════════════════════════
        //
        //  Por padrão, toda tela empilhada (que não é a raiz) mostra
        //  um botão "< Título Anterior" no canto superior esquerdo.
        //  Esse botão faz pop automático (volta 1 tela).
        //
        //  .navigationBarBackButtonHidden(true) ESCONDE esse botão.
        //
        //  ─── QUANDO USAR? ───
        //
        //  → Quando a tela exige uma DECISÃO do usuário antes de sair
        //    (como aqui: fugir, usar poção, ou enfrentar).
        //  → Em telas de onboarding onde você não quer que o usuário volte.
        //  → Quando você implementa um botão de voltar CUSTOMIZADO.
        //
        //  ─── BOTÃO DE VOLTAR CUSTOMIZADO ───
        //
        //  Se ocultar o botão nativo, você pode criar o seu:
        //
        //     .toolbar {
        //         ToolbarItem(placement: .navigationBarLeading) {
        //             Button(action: { path.removeLast() }) {
        //                 HStack {
        //                     Image(systemName: "chevron.left")
        //                     Text("Meu Voltar")
        //                 }
        //             }
        //         }
        //     }
        //
        //  ─── SWIPE BACK (GESTO DE ARRASTAR) ───
        //
        //  ⚠️ CUIDADO: .navigationBarBackButtonHidden(true) também
        //  DESABILITA o gesto de swipe da borda esquerda para voltar.
        //  Isso pode frustrar o usuário. Use com moderação.
        //
        //  Para manter o swipe back mesmo sem o botão:
        //  → Pesquise por "interactivePopGestureRecognizer" (UIKit hack).
        //  → No SwiftUI puro, não há forma oficial de separar os dois.
        //
        // ═════════════════════════════════════════════════════════════════════
        
        .navigationBarBackButtonHidden(true)
    }
    
    // ═════════════════════════════════════════════════════════════════════════
    //  📖 FUNÇÃO fugir() — POP SIMPLES
    // ═════════════════════════════════════════════════════════════════════════
    //
    //  path.removeLast() remove o ÚLTIMO item do path.
    //  O NavigationStack detecta a mudança e desempilha 1 tela com animação.
    //
    //  ⚠️ SEGURANÇA: Sempre cheque path.isEmpty antes de removeLast()!
    //  Se o path estiver vazio e você chamar removeLast(), dá CRASH:
    //  "Can't remove last element from an empty collection"
    //
    //  ─── FORMAS DE FAZER POP DE 1 TELA ───
    //
    //  FORMA 1 — path.removeLast() (a que usamos):
    //     if !path.isEmpty { path.removeLast() }
    //     → Controle total. Funciona de qualquer lugar com @Binding.
    //
    //  FORMA 2 — @Environment(\.dismiss):
    //     @Environment(\.dismiss) private var dismiss
    //     Button("Voltar") { dismiss() }
    //     → Mais simples. Não precisa de @Binding.
    //     → Mas NÃO permite pop to root ou pop de N telas.
    //     → Só volta 1 tela, sempre.
    //
    //  FORMA 3 — path.removeLast(N) para voltar N telas:
    //     path.removeLast(2) → Volta 2 telas de uma vez
    //     path.removeLast(3) → Volta 3 telas de uma vez
    //     → Útil para pular telas intermediárias.
    //
    // ═════════════════════════════════════════════════════════════════════════
    
    private func fugir() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // ═════════════════════════════════════════════════════════════════════════
    //  📖 FUNÇÃO usarPocao() — POP TO ROOT
    // ═════════════════════════════════════════════════════════════════════════
    //
    //  Esvazia o path INTEIRO. Todas as telas são desempilhadas.
    //  O usuário volta direto para a ContentView (raiz/root).
    //
    //  ─── FORMAS DE FAZER POP TO ROOT ───
    //
    //  FORMA 1 — Substituir por path vazio (a que usamos):
    //     path = NavigationPath()
    //     → Limpo e direto. Cria um novo NavigationPath vazio.
    //
    //  FORMA 2 — Remover todos os itens:
    //     path.removeLast(path.count)
    //     → Mesmo efeito. Remove exatamente path.count itens.
    //     → Mais explícito sobre o que está acontecendo.
    //
    //  FORMA 3 — Usando while (desnecessariamente verboso):
    //     while !path.isEmpty { path.removeLast() }
    //     ❌ Funciona, mas é ineficiente e feio. Não use.
    //
    //  ─── POR QUE POP TO ROOT ERA DIFÍCIL ANTES? ───
    //
    //  No antigo NavigationView (iOS 13–15), fazer pop to root era
    //  um PESADELO. Não existia NavigationPath. As alternativas eram:
    //  → Variáveis @State isActive em cadeia (frágil, verboso).
    //  → NotificationCenter para sinalizar a raiz (hack feio).
    //  → UIKit interop com UINavigationController.popToRootViewController.
    //
    //  Com NavigationStack + NavigationPath, basta UMA LINHA:
    //  path = NavigationPath()
    //  Essa é uma das maiores vitórias do NavigationStack.
    //
    // ═════════════════════════════════════════════════════════════════════════
    
    private func usarPocao() {
        path = NavigationPath()
    }
}

#Preview {
    NavigationStack {
        CriaturaView(path: .constant(NavigationPath()))
    }
}
