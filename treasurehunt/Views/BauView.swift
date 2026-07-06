// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  BauView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 4: Hashable + navigationDestination para Structs
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela (com struct Baú):
//
//   ┌─────────────────┐
//   │    BauView      │  ← TOPO (baú com temChave: true)
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
//   path = ["ilha", "floresta", "rio", "criatura", Baú(id: ..., temChave: true)]
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

// ═════════════════════════════════════════════════════════════════════════════
//  📖 A STRUCT Baú — POR QUE PRECISA SER Hashable?
// ═════════════════════════════════════════════════════════════════════════════
//
//  ✅ BLOCO 4 CORRIGIDO: Adicionado `: Hashable`
//
//  O NavigationPath só aceita valores que conformem ao protocolo `Hashable`.
//  Se a struct NÃO for Hashable, o compilador dá ERRO ao tentar:
//  path.append(meuBau)  // ❌ "Type 'Baú' does not conform to protocol 'Hashable'"
//
//  ─── MAS O QUE É Hashable? ───
//
//  Hashable é um protocolo que exige que o tipo possa ser convertido
//  em um valor numérico inteiro chamado "hash value".
//
//  Pense assim: cada Baú precisa de uma "impressão digital" única.
//  O NavigationPath usa esse hash para IDENTIFICAR e COMPARAR
//  valores na pilha — saber se dois valores são iguais ou diferentes.
//
//  Exemplo:
//  Baú(id: ABC, temChave: true).hashValue  → 483920174
//  Baú(id: XYZ, temChave: false).hashValue → 192837465
//  → Hashes diferentes = objetos diferentes na pilha.
//
//  ─── QUEM JÁ É Hashable AUTOMATICAMENTE? ───
//
//  Tipos básicos do Swift já são Hashable:
//  ✅ String, Int, Double, Bool, UUID, Date, URL
//
//  Por isso path.append("ilha") funciona sem configuração:
//  String já é Hashable nativamente.
//
//  Structs CUSTOMIZADAS (como Baú) NÃO são Hashable por padrão.
//  Precisamos declarar explicitamente: `struct Baú: Hashable`
//
//  ─── COMO O SWIFT GERA O HASH? ───
//
//  Quando TODAS as propriedades da struct já são Hashable
//  (UUID e Bool são), o Swift SINTETIZA o Hashable automaticamente.
//  Você não precisa implementar nada manualmente.
//
//  O Swift gera internamente algo como:
//
//     func hash(into hasher: inout Hasher) {
//         hasher.combine(id)        // UUID é Hashable
//         hasher.combine(temChave)  // Bool é Hashable
//     }
//
//  ─── E SE UMA PROPRIEDADE NÃO FOSSE Hashable? ───
//
//  Se Baú tivesse uma propriedade de tipo que NÃO é Hashable
//  (ex: uma UIImage), o Swift NÃO conseguiria sintetizar.
//  Aí você teria que implementar hash(into:) manualmente,
//  ou marcar a propriedade como não participante do hash.
//
//  ─── HASHABLE vs EQUATABLE vs IDENTIFIABLE ───
//
//  • Equatable: Permite comparar (==). "Esses dois são iguais?"
//  • Hashable:  Estende Equatable + gera hash. Necessário para
//               NavigationPath, Set, e chaves de Dictionary.
//  • Identifiable: Tem um `id` único. Necessário para List/ForEach.
//
//  Hashable INCLUI Equatable (quem é Hashable é automaticamente Equatable).
//  Identifiable é separado — ter um `id` não implica ser Hashable.
//
//  Para NavigationPath, o que importa é Hashable.
//
//  ─── FORMAS DE DECLARAR ───
//
//  ✅ CERTO (síntese automática — todas propriedades são Hashable):
//     struct Baú: Hashable {
//         let id: UUID
//         let temChave: Bool
//     }
//
//  ✅ CERTO (implementação manual — para controle fino):
//     struct Baú: Hashable {
//         let id: UUID
//         let temChave: Bool
//
//         func hash(into hasher: inout Hasher) {
//             hasher.combine(id) // Só usa id para o hash
//         }
//
//         static func == (lhs: Baú, rhs: Baú) -> Bool {
//             lhs.id == rhs.id // Igualdade só pelo id
//         }
//     }
//
//  ❌ ERRADO (esqueceu o Hashable):
//     struct Baú {
//         let id: UUID
//         let temChave: Bool
//     }
//     → path.append(Baú(...)) // ❌ ERRO de compilação!
//
// ═════════════════════════════════════════════════════════════════════════════

struct Baú: Hashable {
    let id: UUID
    let temChave: Bool
}

struct BauView: View {
    
    // O Baú que foi empilhado no path.
    // Recebido via .navigationDestination(for: Baú.self) na ContentView.
    // Contém os dados: id e temChave.
    let baú: Baú
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // ── Cabeçalho ──
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
                
                // ── Card de Descrição ──
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
                
                // ═════════════════════════════════════════════════════════════
                //  📖 NavigationLink(value: "premiacao") — PUSH FINAL
                // ═════════════════════════════════════════════════════════════
                //
                //  ✅ BLOCO 4 CORRIGIDO
                //
                //  Substituímos o Button (que não fazia nada) por um
                //  NavigationLink que empilha a rota "premiacao".
                //
                //  O .navigationDestination(for: String.self) na ContentView
                //  reconhece "premiacao" e retorna PremiacaoView.
                //
                //  ─── .disabled(!baú.temChave) ───
                //
                //  O modificador .disabled() desabilita interação.
                //  Se temChave é false → o link fica cinza e não clicável.
                //  Se temChave é true  → o link fica ativo e navegável.
                //
                //  Isso demonstra NAVEGAÇÃO CONDICIONAL:
                //  O NavigationLink existe na tela, mas só funciona
                //  se a condição for atendida.
                //
                //  ─── ALTERNATIVA COM Button CONDICIONAL ───
                //
                //  Poderíamos usar Button + path.append com if:
                //
                //     Button("Abrir") {
                //         if baú.temChave {
                //             path.append("premiacao")
                //         }
                //     }
                //
                //  → Funciona, mas o usuário não tem feedback visual.
                //  → Com .disabled(), o link fica visualmente "apagado",
                //    comunicando que a ação não está disponível.
                //
                //  Estado da pilha DEPOIS (se temChave: true):
                //   ┌───────────────────┐
                //   │  PremiacaoView    │  ← TOPO 🎉
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
                //   path = ["ilha","floresta","rio","criatura", Baú(...),"premiacao"]
                //   path.count = 6 (a pilha mais alta do jogo!)
                //
                // ═════════════════════════════════════════════════════════════
                
                VStack(spacing: 12) {
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
        BauView(baú: Baú(id: UUID(), temChave: true), path: .constant(NavigationPath()))
    }
}
