// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  IlhaView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 2: NavigationLink com Valor (Value-Based)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  ESTADO DA PILHA ao chegar nesta tela:
//
//   ┌─────────────┐
//   │   IlhaView   │  ← TOPO (você está aqui)
//   ├─────────────┤
//   │ ContentView  │  ← BASE
//   └─────────────┘
//   path = ["ilha"]
//
//  O usuário tocou "Iniciar Jornada" na ContentView.
//  O NavigationLink(value: "ilha") fez path.append("ilha").
//  O .navigationDestination(for: String.self) reconheceu "ilha"
//  e devolveu esta IlhaView.
//
//  Agora, esta tela tem um NavigationLink(value: "floresta")
//  que vai empilhar a FlorestaView POR CIMA desta.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct IlhaView: View {
    
    // ═════════════════════════════════════════════════════════════════════════
    //  📖 @Binding — Referência de "mão dupla" ao NavigationPath
    // ═════════════════════════════════════════════════════════════════════════
    //
    //  @Binding cria uma REFERÊNCIA ao @State de outra View.
    //  Aqui, `path` NÃO é uma cópia — é um PONTEIRO para o
    //  `@State private var path` que vive lá na ContentView.
    //
    //  Quando esta View modifica `path`, a ContentView SENTE a mudança,
    //  e o NavigationStack reage (empilhando ou desempilhando telas).
    //
    //  ─── POR QUE @Binding E NÃO @State? ───
    //
    //  ❌ @State var path = NavigationPath()
    //     → Criaria um path NOVO, independente do da ContentView.
    //     → Modificar este path não teria efeito algum na navegação.
    //     → Cada View teria "seu próprio path" desconectado.
    //
    //  ✅ @Binding var path: NavigationPath
    //     → Aponta para o MESMO path da ContentView.
    //     → Qualquer mudança aqui reflete lá, e vice-versa.
    //
    //  ─── COMO O BINDING CHEGA AQUI? ───
    //
    //  Na ContentView, ao criar IlhaView(path: $path),
    //  o `$path` gera um Binding<NavigationPath> a partir do @State.
    //  O `$` é o "projetor de binding" — ele transforma @State em @Binding.
    //
    //  ─── ALTERNATIVA: @Environment(\.dismiss) ───
    //
    //  Para apenas VOLTAR 1 tela (pop simples), existe uma opção
    //  que NÃO precisa do @Binding:
    //
    //     @Environment(\.dismiss) private var dismiss
    //
    //     Button("Voltar") { dismiss() }
    //
    //  → Simples para pop de 1 tela.
    //  → MAS não permite pop to root, nem push programático.
    //  → Por isso, no workshop usamos @Binding para ter controle total.
    //
    // ═════════════════════════════════════════════════════════════════════════
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // ── Cabeçalho ──
                VStack(spacing: 8) {
                    Image(systemName: "palmtree.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Text("Ilha Misteriosa")
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
                    
                    Text("Você desembarcou na praia de areia preta. O vento uiva entre as palmeiras e um caminho escuro leva direto para o interior da floresta fechada.")
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
                //  📖 NavigationLink(value: "floresta") — PUSH DECLARATIVO
                // ═════════════════════════════════════════════════════════════
                //
                //  ✅ BLOCO 2 CORRIGIDO
                //
                //  Ao tocar, o SwiftUI faz path.append("floresta") internamente.
                //
                //  Estado da pilha DEPOIS do toque:
                //   ┌────────────────┐
                //   │  FlorestaView  │  ← TOPO (nova tela visível)
                //   ├────────────────┤
                //   │   IlhaView     │  ← Escondida por baixo
                //   ├────────────────┤
                //   │  ContentView   │  ← BASE
                //   └────────────────┘
                //   path = ["ilha", "floresta"]
                //
                //  ─── DIFERENÇA ENTRE Button E NavigationLink ───
                //
                //  ❌ Button + path.append (funciona, mas é antipadrão para links simples):
                //     Button("Entrar na Floresta") {
                //         path.append("floresta")
                //     }
                //     → Funciona! Mas o SwiftUI NÃO aplica o estilo visual
                //       de "link de navegação" (a seta > na direita).
                //     → Use Button + append quando a navegação é CONDICIONAL
                //       (ex: só navega se um formulário estiver válido).
                //
                //  ✅ NavigationLink(value:) (para navegação direta):
                //     NavigationLink(value: "floresta") {
                //         Text("Entrar na Floresta")
                //     }
                //     → O jeito idiomático quando o toque SEMPRE navega.
                //     → O SwiftUI adiciona a seta automaticamente (se label simples).
                //     → Lazy: a View de destino só é criada quando necessário.
                //
                // ═════════════════════════════════════════════════════════════
                
                NavigationLink(value: "floresta") {
                    HStack {
                        Text("Entrar na Floresta")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.circle.fill")
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
        
        // ═════════════════════════════════════════════════════════════════════
        //  📖 .navigationTitle e .navigationBarTitleDisplayMode
        // ═════════════════════════════════════════════════════════════════════
        //
        //  .navigationTitle("A Praia")
        //  → Define o título que aparece na barra de navegação.
        //  → Este texto também é usado pelo botão "< Voltar" na próxima tela.
        //    (o botão mostra o título da tela ANTERIOR por padrão)
        //
        //  .navigationBarTitleDisplayMode(.inline)
        //  → O título fica PEQUENO e centralizado na barra.
        //
        //  Opções:
        //  • .large   → Título grande, estilo iOS (padrão). Bom para telas de lista.
        //  • .inline  → Título pequeno centralizado. Bom para telas internas.
        //  • .automatic → O sistema decide (geralmente .large na raiz, .inline depois).
        //
        // ═════════════════════════════════════════════════════════════════════
        
        .navigationTitle("A Praia")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // ─── PREVIEWS COM NavigationStack ───
    //
    // No Preview, precisamos envolver em NavigationStack
    // senão .navigationTitle e NavigationLink não funcionam.
    //
    // .constant(NavigationPath()) cria um Binding "falso"
    // que nunca muda — perfeito para Previews estáticos.
    
    NavigationStack {
        IlhaView(path: .constant(NavigationPath()))
    }
}
