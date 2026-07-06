// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  ContentView.swift
//  treasurehunt
//
//  📚 WORKSHOP — BLOCO 1, 2 e 4: O Coração da Navegação
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  Esta é a View RAIZ do app. Tudo começa aqui.
//  Aqui vivem os 3 pilares da navegação moderna no SwiftUI:
//
//  1️⃣  NavigationStack    → O contêiner que cria e gerencia a PILHA de telas.
//  2️⃣  NavigationPath     → O "array mágico" que controla QUAIS telas estão empilhadas.
//  3️⃣  navigationDestination(for:) → O "mapa" que associa um TIPO de dado a uma View.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  🧠 ENTENDENDO A PILHA (STACK) DE NAVEGAÇÃO — CONCEITO FUNDAMENTAL
//
//  Imagine uma PILHA DE PRATOS:
//
//   ┌─────────────┐
//   │  Tela Nova   │  ← TOPO (tela visível — a última empilhada)
//   ├─────────────┤
//   │  Floresta    │  ← Tela do meio (escondida por baixo)
//   ├─────────────┤
//   │  Ilha        │  ← Segunda tela
//   ├─────────────┤
//   │  ContentView │  ← BASE (root — a tela inicial, nunca sai da pilha)
//   └─────────────┘
//
//  • PUSH (empilhar) = colocar um prato novo NO TOPO.
//    → O usuário vê a tela nova. As anteriores ficam "embaixo".
//    → Feito com NavigationLink(value:) ou path.append().
//
//  • POP (desempilhar) = tirar o prato do TOPO.
//    → O usuário volta pra tela anterior.
//    → Feito com path.removeLast() ou botão "<" nativo.
//
//  • POP TO ROOT = tirar TODOS os pratos, deixando só a base.
//    → O usuário volta direto pra tela inicial.
//    → Feito com path = NavigationPath() ou path.removeLast(path.count).
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  📖 NavigationStack vs NavigationView (HISTÓRICO)
//
//  Antes do iOS 16, usávamos `NavigationView`. Ele foi DEPRECADO.
//
//  ❌ DEPRECADO (iOS 13–15):
//     NavigationView {
//         NavigationLink("Ir", destination: OutraView())
//     }
//     → Problemas: não tinha controle programático da pilha,
//       comportamento inconsistente entre iPhone e iPad,
//       impossível fazer pop to root sem hacks feios.
//
//  ✅ MODERNO (iOS 16+):
//     NavigationStack(path: $path) {
//         // conteúdo
//         .navigationDestination(for: String.self) { valor in
//             // View baseada no valor
//         }
//     }
//     → Controle TOTAL: push, pop, pop to root, deep linking.
//
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct ContentView: View {
    
    // ═════════════════════════════════════════════════════════════════════════
    //  📖 NavigationPath — O "GPS" da Navegação
    // ═════════════════════════════════════════════════════════════════════════
    //
    //  `NavigationPath` é um tipo especial que funciona como um ARRAY HETEROGÊNEO.
    //  Ele guarda a lista ordenada de valores que representam cada tela empilhada.
    //
    //  Por que não usar um [String] simples?
    //  Porque com NavigationPath você pode empilhar TIPOS DIFERENTES:
    //  → path.append("ilha")            // String
    //  → path.append(Baú(id: ..., temChave: true))  // Struct customizada
    //  → path.append(42)                // Int
    //  Tudo no MESMO path! Ele aceita qualquer tipo que conforme `Hashable`.
    //
    //  ─── ALTERNATIVA: Array Tipado ───
    //
    //  Se todas as suas rotas fossem do MESMO tipo (ex: só Strings), você
    //  poderia usar um array simples em vez de NavigationPath:
    //
    //  ❌ Limitado (só aceita String):
    //     @State private var path: [String] = []
    //     NavigationStack(path: $path) { ... }
    //     → Funciona, mas não aceita tipos mistos (String + Baú + Int).
    //
    //  ✅ Flexível (aceita qualquer Hashable):
    //     @State private var path = NavigationPath()
    //     NavigationStack(path: $path) { ... }
    //     → Aceita path.append("texto") E path.append(meuObjeto).
    //
    //  ─── POR QUE @State? ───
    //
    //  @State marca que esta variável é uma FONTE DE VERDADE local.
    //  Quando `path` muda (ex: append, removeLast), o SwiftUI REDESENHA
    //  a tela automaticamente, mostrando a view correta no topo da pilha.
    //
    //  `private` porque nenhuma View pai precisa acessar diretamente.
    //  As Views filhas recebem acesso via @Binding (veremos em IlhaView, etc).
    //
    //  ─── O QUE ACONTECE POR BAIXO DOS PANOS? ───
    //
    //  Quando você faz path.append("ilha"):
    //  1. O SwiftUI detecta que @State mudou.
    //  2. Ele procura um .navigationDestination(for: String.self) registrado.
    //  3. Encontra! Executa o closure passando "ilha" como parâmetro.
    //  4. O closure retorna IlhaView → SwiftUI empilha ela com animação.
    //
    //  Se NÃO houver .navigationDestination registrado para o tipo,
    //  nada acontece silenciosamente (sem crash, mas sem navegação).
    //
    // ═════════════════════════════════════════════════════════════════════════
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        // ═════════════════════════════════════════════════════════════════════
        //  📖 NavigationStack(path: $path) — O Contêiner de Navegação
        // ═════════════════════════════════════════════════════════════════════
        //
        //  NavigationStack é o CONTÊINER. Sem ele, NADA de navegação funciona:
        //  → NavigationLink não empilha.
        //  → .navigationTitle não aparece.
        //  → .navigationDestination não é registrado.
        //
        //  O parâmetro `path: $path` conecta o NavigationStack ao nosso
        //  NavigationPath via BINDING ($).
        //  → O $ cria uma ligação bidirecional: se a UI mudar o path
        //    (ex: usuário toca "voltar"), o @State atualiza, e vice-versa.
        //
        //  ─── DUAS FORMAS DE USAR NavigationStack ───
        //
        //  FORMA 1 — SEM path (navegação simples, sem controle programático):
        //
        //     NavigationStack {
        //         NavigationLink("Ir", destination: OutraView())
        //     }
        //     → Funciona para navegação básica onde você NÃO precisa
        //       fazer pop programático ou pop to root.
        //     → Não tem como saber quantas telas estão empilhadas.
        //     → Não tem como voltar ao início por código.
        //
        //  FORMA 2 — COM path (controle total — a que usamos):
        //
        //     NavigationStack(path: $path) {
        //         // ...
        //         .navigationDestination(for: Tipo.self) { valor in
        //             ViewDestino(valor)
        //         }
        //     }
        //     → Controle total: push, pop, pop to root, deep linking.
        //     → Você sabe exatamente o que está na pilha a qualquer momento.
        //     → Pode salvar/restaurar o estado de navegação.
        //
        //  ⚠️ REGRA IMPORTANTE:
        //  Só pode existir UM NavigationStack por hierarquia de navegação.
        //  Se uma View filha TAMBÉM colocar NavigationStack, você terá
        //  DOIS stacks aninhados — o que causa barra de navegação duplicada
        //  e comportamentos estranhos.
        //
        //  ❌ ERRADO:
        //     NavigationStack {          // ← Stack PAI
        //         NavigationLink(...) {
        //             NavigationStack {  // ← Stack FILHO duplicado!
        //                 Text("Bug!")
        //             }
        //         }
        //     }
        //
        //  ✅ CERTO:
        //     NavigationStack {          // ← Único Stack, aqui na raiz
        //         NavigationLink(...) {
        //             Text("Sem stack extra!")  // ← Views filhas NÃO criam stack
        //         }
        //     }
        //
        // ═════════════════════════════════════════════════════════════════════
        
        NavigationStack(path: $path) {
            
            VStack {
                ZStack {
                    Color(red: 0.9, green: 0.97, blue: 0.98)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        
                        // ── Cabeçalho ──
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
                        
                        // ── Card de Regras ──
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
                        
                        // ═════════════════════════════════════════════════════
                        //  📖 NavigationLink(value:) — Empilhando com VALOR
                        // ═════════════════════════════════════════════════════
                        //
                        //  NavigationLink tem DUAS formas principais:
                        //
                        //  ─── FORMA ANTIGA (destination — iOS 13+) ───
                        //
                        //     NavigationLink(destination: IlhaView()) {
                        //         Text("Ir para Ilha")
                        //     }
                        //     → A View de destino é criada INLINE.
                        //     → Problema: a IlhaView é instanciada IMEDIATAMENTE
                        //       (mesmo antes do toque!), desperdiçando memória.
                        //     → Não interage com NavigationPath.
                        //     → Impossível fazer pop to root.
                        //     → Acoplamento forte: o link SABE qual View mostrar.
                        //
                        //  ─── FORMA MODERNA (value — iOS 16+) ───
                        //
                        //     NavigationLink(value: "ilha") {
                        //         Text("Ir para Ilha")
                        //     }
                        //     → O link envia um VALOR (aqui a String "ilha").
                        //     → O NavigationStack recebe esse valor.
                        //     → Procura um .navigationDestination(for: String.self)
                        //       e executa o closure associado.
                        //     → A View é criada SOMENTE quando necessário (lazy).
                        //     → O valor é adicionado ao path automaticamente.
                        //     → Desacoplado: o link não sabe qual View vai abrir!
                        //
                        //  ⚠️ O QUE EMPILHA?
                        //
                        //  Quando o usuário toca no NavigationLink(value: "ilha"):
                        //  1. O SwiftUI faz path.append("ilha") internamente.
                        //  2. O NavigationStack percebe que path mudou.
                        //  3. Busca .navigationDestination(for: String.self).
                        //  4. Executa o switch, cai no case "ilha".
                        //  5. Retorna IlhaView → empilha com animação slide-in.
                        //
                        //  Estado da pilha após o toque:
                        //   ┌─────────────┐
                        //   │   IlhaView   │  ← TOPO (visível)
                        //   ├─────────────┤
                        //   │ ContentView  │  ← BASE (escondida)
                        //   └─────────────┘
                        //   path = ["ilha"]
                        //
                        // ═════════════════════════════════════════════════════
                        
                        NavigationLink(value: "ilha") {
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
            
            // ═════════════════════════════════════════════════════════════════
            //  📖 .navigationDestination(for:) — O MAPA DE ROTAS
            // ═════════════════════════════════════════════════════════════════
            //
            //  Este modificador é o "roteador" do app.
            //  Ele diz ao NavigationStack:
            //  "Quando alguém empilhar um valor do tipo X, mostre esta View."
            //
            //  Funciona assim:
            //
            //  .navigationDestination(for: TIPO.self) { valorRecebido in
            //      // retorna a View que deve ser exibida
            //  }
            //
            //  ─── POR QUE `String.self`? ───
            //
            //  `String.self` é o METATIPO — se refere ao tipo String em si,
            //  não a uma instância. É como dizer "para qualquer String".
            //  Quando fazemos path.append("ilha"), o valor "ilha" é uma String,
            //  então cai neste .navigationDestination(for: String.self).
            //
            //  ─── REGRA: UM DESTINO POR TIPO ───
            //
            //  Você pode ter VÁRIOS .navigationDestination no mesmo
            //  NavigationStack, MAS cada um para um TIPO diferente:
            //
            //  ✅ CERTO:
            //     .navigationDestination(for: String.self) { ... }   // Strings
            //     .navigationDestination(for: Baú.self) { ... }      // Structs Baú
            //     .navigationDestination(for: Int.self) { ... }       // Inteiros
            //
            //  ❌ ERRADO (dois destinos para o mesmo tipo):
            //     .navigationDestination(for: String.self) { ... }
            //     .navigationDestination(for: String.self) { ... }  // ← Ignorado!
            //     → O segundo é silenciosamente ignorado. Apenas o primeiro vale.
            //
            //  ─── ONDE COLOCAR? ───
            //
            //  O .navigationDestination deve ser colocado como modificador
            //  de uma View que esteja DENTRO do NavigationStack.
            //  Normalmente, colocamos na View RAIZ do stack (a que aparece
            //  no body do NavigationStack, que é esta VStack aqui).
            //
            //  ✅ CERTO: Dentro do NavigationStack, na View raiz
            //  ❌ ERRADO: Fora do NavigationStack (não será encontrado)
            //  ❌ ERRADO: Dentro de uma View filha que nem sempre está na tela
            //
            // ═════════════════════════════════════════════════════════════════
            
            .navigationDestination(for: String.self) { rota in
                
                // ─── O PADRÃO SWITCH PARA ROTEAMENTO ───
                //
                // Usamos um switch para decidir qual View mostrar
                // baseado no valor da String empilhada.
                //
                // Fluxo: path.append("floresta")
                //        → rota recebe "floresta"
                //        → switch cai no case "floresta"
                //        → retorna FlorestaView
                //
                // ⚠️ PRÓS E CONTRAS DO ROTEAMENTO POR STRING:
                //
                // ✅ Simples, rápido de implementar, fácil de ler.
                // ❌ Frágil: se você errar a digitação ("ilah" em vez de "ilha"),
                //    cai no default (EmptyView) e nada acontece, sem erro.
                // ❌ Não carrega dados — "bau" não diz se tem chave ou não.
                //
                // 💡 ALTERNATIVA MELHOR para apps grandes:
                //    Usar um enum Hashable como rota:
                //
                //    enum Rota: Hashable {
                //        case ilha
                //        case floresta
                //        case rio
                //        case criatura
                //        case bau(temChave: Bool)  // ← leva dados junto!
                //        case premiacao
                //    }
                //
                //    .navigationDestination(for: Rota.self) { rota in
                //        switch rota {
                //        case .ilha: IlhaView(path: $path)
                //        case .bau(let temChave): BauView(temChave: temChave)
                //        // ...
                //        }
                //    }
                //
                //    → O compilador GARANTE que você não erre o nome.
                //    → Pode associar dados à rota.
                //    → Mas para o workshop, String é mais didático.
                
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
                    // Rota genérica por String → baú SEM chave (fallback)
                    BauView(baú: Baú(id: UUID(), temChave: false), path: $path)
                case "premiacao":
                    // ✅ BLOCO 4 CORRIGIDO: Rota para a tela de premiação
                    PremiacaoView(path: $path)
                default:
                    // Se empilhar uma String que não existe nos cases acima,
                    // mostra uma tela vazia. Nenhum crash, mas nenhuma tela.
                    EmptyView()
                }
            }
            
            // ═════════════════════════════════════════════════════════════════
            //  📖 SEGUNDO .navigationDestination — Para o tipo Baú
            // ═════════════════════════════════════════════════════════════════
            //
            //  ✅ BLOCO 4 CORRIGIDO
            //
            //  Aqui registramos um destino para o tipo `Baú`.
            //  Quando fazemos path.append(meuBau) na CriaturaView,
            //  onde meuBau é do tipo Baú, o NavigationStack procura
            //  um .navigationDestination(for: Baú.self) — e encontra este!
            //
            //  O closure recebe a instância exata do Baú que foi empilhada,
            //  com todos os seus dados (id, temChave), e passa para a BauView.
            //
            //  ─── POR QUE DOIS .navigationDestination? ───
            //
            //  Porque temos DOIS tipos diferentes de valores no path:
            //  • String → para rotas simples ("ilha", "floresta", "premiacao")
            //  • Baú    → para rotas que carregam dados (temChave: true/false)
            //
            //  Cada tipo precisa do seu próprio .navigationDestination.
            //  O NavigationStack verifica o TIPO do valor empilhado e
            //  despacha para o closure correto automaticamente.
            //
            //  Fluxo quando path.append(Baú(id: ..., temChave: true)):
            //  1. O valor é do tipo Baú (não String).
            //  2. O Stack IGNORA o .navigationDestination(for: String.self).
            //  3. O Stack ENCONTRA .navigationDestination(for: Baú.self).
            //  4. Executa o closure, passando o Baú recebido.
            //  5. Retorna BauView com o baú correto (temChave: true).
            //
            // ═════════════════════════════════════════════════════════════════
            
            .navigationDestination(for: Baú.self) { baú in
                BauView(baú: baú, path: $path)
            }
        }
    }
}

#Preview {
    ContentView()
}
