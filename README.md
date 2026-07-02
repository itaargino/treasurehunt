# Workshop SwiftUI Navigation Stack: Náufragos & Exploradores 🏴‍☠️

Bem-vindo ao workshop prático de **SwiftUI Navigation Stack**!

Neste desafio, você assumirá o papel de um explorador náufrago em um arquipélago misterioso. Para encontrar o tesouro lendário, você precisará consertar a navegação do aplicativo, ilha por ilha.

---

## 🏴‍☠️ A Regra de Ouro
**Nada funciona sozinho.** Cada parte do aplicativo tem um `// TODO` ou uma linha intencionalmente incorreta. Seu objetivo é "hackear" o código para liberar a próxima ilha e continuar a jornada.

---

## 🗺️ Mapa da Jornada & Timing

| Bloco | Tempo | Desafio Central | Conceito SwiftUI |
|---|---|---|---|
| **Parte 1** | 10 min | Teoria Relâmpago | Vocabulário Geral |
| **🏝️ Bloco 1** | 5 min | Botão "Iniciar" não faz nada | `NavigationStack` inicial |
| **🗺️ Bloco 2** | 12 min | Ilha → Floresta → Rio | `NavigationLink` & Push programático |
| **🐻 Bloco 3** | 18 min | Fuga do Urso & Caminho Alternativo | `NavigationPath` programático, Pop simples, Pop to root (Poção) & Back Button Oculto |
| **🔑 Bloco 4** | 10 min | Baú trancado & Tela de Premiação | `Hashable` + `navigationDestination` + `NavigationLink` |
| **Fechamento**| 5 min | Dúvidas & Feedback | Revisão geral |

---

## 🛠️ Detalhes dos Blocos

### 🏝️ Bloco 1 — Zarpar (5 min)
*   **Sintoma:** O botão "Iniciar Jornada" na tela inicial não faz nada.
*   **Seu objetivo:** Fazer com que o botão e os links subsequentes funcionem.
*   **Onde mexer:** [ContentView.swift](treasurehunt/ContentView.swift) (`// TODO: Bloco 1`)
*   **Dica:** Falta envelopar a tela inicial em um container de navegação.

### 🗺️ Bloco 2 — Ilha → Floresta → Rio (12 min)
*   **Sintoma:** Os botões para "Entrar na ilha", "Entrar na floresta" e "Seguir para o rio" existem, mas não mudam de tela.
*   **Seu objetivo:** Substituir botões estáticos por links de navegação. Além disso, ao chegar ao Rio, a opção de "Explorar mais a ilha" deve adicionar uma nova ilha à rota programaticamente.
*   **Onde mexer:**
    *   `ContentView.swift`
    *   [IlhaView.swift](treasurehunt/GameViews/IlhaView.swift) (`// TODO: Bloco 2`)
    *   [FlorestaView.swift](treasurehunt/GameViews/FlorestaView.swift) (`// TODO: Bloco 2`)
    *   [RioView.swift](treasurehunt/GameViews/RioView.swift) (`// TODO: Bloco 2`)
*   **Dica:** Troque `Button` por `NavigationLink`. Para avançar programaticamente, dê append na lista de navegação (`path`).

### 🐻 Bloco 3 — Urso e volta na ilha (18 min)
*   **Sintoma:** Fugir do urso ou tentar usar a poção para voltar ao início não faz nada. Além disso, o botão de retorno nativo da barra superior sumiu!
*   **Seu objetivo:**
    1.  Fazer com que "Fugir Correndo" retorne exatamente 1 tela no histórico de navegação.
    2.  Fazer com que "Usar Poção (Fugir ao Início)" zere a lista de navegação programaticamente (Pop to root).
*   **Onde mexer:** [CriaturaView.swift](treasurehunt/GameViews/CriaturaView.swift) (`// TODO: Bloco 3`)
*   **Dica:** Manipule a variável `path` que controla a pilha de navegação. Use `.removeLast()` para voltar e zere o `path` para retornar ao barco inicial. O botão de retorno foi ocultado com `.navigationBarBackButtonHidden(true)`.

### 🔑 Bloco 4 — Baú e premiação (10 min)
*   **Sintoma:** O baú não abre com a chave (erro de compilação ou o destino não responde).
*   **Seu objetivo:**
    1.  Fazer com que a estrutura `Baú` possa ser passada na rota de navegação (resolvendo o erro ao descomentar a chamada em `CriaturaView`).
    2.  Registrar o destino correto de tela para quando o dado do tipo `Baú` for empilhado.
    3.  Navegar para a premiação empilhando a tela usando um `NavigationLink` na tela do baú.
    4.  A tela de premiação deve voltar ao início (Pop to root) quando o usuário clicar em "Comemorar e Fechar".
*   **Onde mexer:**
    *   [BauView.swift](treasurehunt/GameViews/BauView.swift) (`// TODO: Bloco 4`)
    *   [PremiacaoView.swift](treasurehunt/GameViews/PremiacaoView.swift) (`// TODO: Bloco 4`)
    *   `ContentView.swift` (`// TODO: Bloco 4`)
*   **Dica:** structs passadas no NavigationPath precisam conformar a `Hashable`. Use `.navigationDestination(for: ...)` para definir o destino e `NavigationLink` para abrir a premiação.

---

Boa sorte, marujo! 🏴‍☠️
