// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  treasurehuntApp.swift
//  treasurehunt
//
//  📚 WORKSHOP — NavigationStack: Ponto de Entrada do App
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  🔑 CONCEITO: O que é o @main e por que ele existe?
//
//  Em Swift, `@main` marca a struct que será o PONTO DE ENTRADA do aplicativo.
//  Pense nele como a "porta da frente" — é por aqui que o iOS começa a executar.
//
//  Antes do SwiftUI (no UIKit), usávamos um arquivo AppDelegate.swift com
//  `@UIApplicationMain`. O SwiftUI simplificou tudo: basta uma struct com `@main`.
//
//  ⚠️ REGRA: Só pode existir UM @main em todo o projeto. Se houver dois,
//  o compilador dá erro: "multiple entry points".
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

// ─────────────────────────────────────────────────────────────────────────────
//  📖 POR QUE `struct` E NÃO `class`?
//
//  No SwiftUI, quase tudo é struct (valor), não class (referência).
//  Structs são mais leves, não têm herança, e o SwiftUI depende de comparação
//  de valores para saber o que redesenhar na tela.
//
//  ❌ ERRADO: class treasurehuntApp: App { ... }
//     → Compila, mas quebra o modelo reativo do SwiftUI.
//
//  ✅ CERTO: struct treasurehuntApp: App { ... }
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
//  📖 O PROTOCOLO `App`
//
//  Toda struct marcada com @main precisa conformar ao protocolo `App`.
//  Esse protocolo exige UMA propriedade obrigatória:
//
//      var body: some Scene { ... }
//
//  `Scene` é o "palco" onde suas Views vão atuar.
//  No iOS, o Scene mais comum é o `WindowGroup`.
//
//  📖 CONVENÇÃO DE NOMENCLATURA:
//  Por convenção da Apple, o nome da struct do App segue o padrão:
//  NomeDoProjetoApp (ex: TreasureHuntApp, MeuAppApp).
//  O Xcode gera automaticamente assim. Aqui está em minúscula (treasurehuntApp)
//  porque o projeto foi criado assim — funciona, mas o ideal é PascalCase:
//
//  ❌ Funciona mas fora da convenção: treasurehuntApp
//  ✅ Convenção Apple:               TreasureHuntApp
// ─────────────────────────────────────────────────────────────────────────────

@main
struct TreasureHuntApp: App {
    
    // ─────────────────────────────────────────────────────────────────────────
    //  📖 `body` retorna `some Scene`
    //
    //  `some` é uma "opaque return type" — significa:
    //  "Eu sei o tipo exato, mas não preciso declarar. O compilador descobre."
    //
    //  Na prática, `some Scene` aqui sempre retorna um `WindowGroup`.
    //  Poderíamos escrever `var body: WindowGroup<ContentView>` mas fica
    //  verboso e frágil. `some Scene` é a convenção.
    // ─────────────────────────────────────────────────────────────────────────
    
    var body: some Scene {
        
        // ─────────────────────────────────────────────────────────────────────
        //  📖 O QUE É `WindowGroup`?
        //
        //  `WindowGroup` cria e gerencia uma janela para o app.
        //  • No iPhone: é a tela inteira (só existe 1 janela).
        //  • No iPad:   pode ter múltiplas janelas (multitasking).
        //  • No Mac:    cada janela é independente.
        //
        //  Dentro do WindowGroup, colocamos a View RAIZ — a primeira tela
        //  que o usuário vê ao abrir o app.
        //
        //  ⚠️ ATENÇÃO WORKSHOP — ONDE COLOCAR O NavigationStack?
        //
        //  O NavigationStack NÃO deve ficar aqui no App.
        //  Ele fica DENTRO da ContentView (ou da View raiz).
        //
        //  ❌ ERRADO (funciona mas é antipadrão):
        //     WindowGroup {
        //         NavigationStack {
        //             ContentView()
        //         }
        //     }
        //     → O App não deve conhecer detalhes de navegação.
        //       Isso acopla a camada de "ciclo de vida" com a de "UI".
        //
        //  ✅ CERTO:
        //     WindowGroup {
        //         ContentView()  // ← A ContentView gerencia sua navegação
        //     }
        //     → Cada View cuida do seu próprio NavigationStack.
        //       Limpo, testável, reutilizável.
        // ─────────────────────────────────────────────────────────────────────
        
        WindowGroup {
            ContentView()
        }
    }
}
